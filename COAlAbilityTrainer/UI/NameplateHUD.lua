-- ============================================================
-- COAlAbilityTrainer - Nameplate HUD v4 (PvP Edition)
-- Box-free overlays on every enemy nameplate showing:
--
--  ALL nameplates:
--    · HP bar accent line (colour = health%)
--    · HP% text
--    · Quest mob indicator ❕
--    · Top loot drops
--
--  TARGET nameplate (extra PvP layer):
--    · LIVE CAST BAR + spell name
--    · Danger flash label  ⚡ INTERRUPT / DODGE / DISPEL / DEFENSIVE
--    · Class-specific counter tip + PvP advice
--    · ENEMY BUFFS row  — key PvP buffs with what-they-mean tooltip
--    · INCOMING THREATS — debuffs enemy put on YOU, how to survive
--    · OFFENSIVE TIP   — best ability to use RIGHT NOW
--    · Player vs NPC badge
--    · Target ring pulse (gold)
--    · Debuff icons (player-applied)
-- ============================================================

CoAAT_NameplateHUD = {}

local _injected   = {}
local _ticker     = 0
local _TICK       = 0.08
local _controller = nil

-- ─────────────────────────────────────────────────────────────
-- PvP BUFF DATABASE
-- Key: buff name (lowercase)
-- danger: "immune" | "burst" | "defensive" | "heal" | "cc" | "watch"
-- tip:    what it means / what to do
-- counter: what to do against it
-- ─────────────────────────────────────────────────────────────
local BUFF_DB = {
    -- IMMUNE — stop DPS immediately
    ["divine shield"]     = { danger="immune",    icon="spell_holy_divineshield",
        tip="IMMUNE — Paladin bubble! Don't waste spells.",
        counter="Save burst for after it drops (~8s). Dispel if possible." },
    ["ice block"]         = { danger="immune",    icon="spell_frost_frost",
        tip="IMMUNE — Mage Ice Block! Switch targets.",
        counter="Wait it out (~10s). Keep pressure on teammates." },
    ["deterrence"]        = { danger="immune",    icon="ability_hunter_deterrence",
        tip="IMMUNE — Hunter Deterrence! Ranged attacks bounce back.",
        counter="Go melee or swap to their pet. Ends in ~5s." },
    ["void phase"]        = { danger="immune",    icon="spell_shadow_nethercloak",
        tip="IMMUNE — Phasing! Cannot be targeted.",
        counter="Pre-position. They'll reappear at their last location." },

    -- BURST WINDOWS — defensive CDs now
    ["avenging wrath"]    = { danger="burst",     icon="spell_holy_avenginewrath",
        tip="⚡ WINGS UP — Paladin dealing 30% more damage!",
        counter="Defensive CD now. Kite or CC. Lasts ~20s." },
    ["metamorphosis"]     = { danger="burst",     icon="ability_demonhunter_metamorphasisdps",
        tip="⚡ META — Felsworn empowered! Massive damage incoming.",
        counter="Max defensives. Break LoS if possible. CC the Felsworn." },
    ["enrage"]            = { danger="burst",     icon="spell_shadow_unholyfrenzy",
        tip="⚡ ENRAGED — +attack speed & damage!",
        counter="Kite out of melee. Use slows/roots. Don't trade hits." },
    ["blade flurry"]      = { danger="burst",     icon="ability_warrior_punishingblow",
        tip="⚡ BLADE FLURRY — Cleave active! Move away from allies.",
        counter="Spread from group. Pop personal defensive." },
    ["killing spree"]     = { danger="burst",     icon="ability_rogue_murderspree",
        tip="⚡ KILLING SPREE — Rogue unstoppable burst!",
        counter="You cannot CC them during spree. Defensive CD required." },
    ["combustion"]        = { danger="burst",     icon="spell_fire_sealoffire",
        tip="⚡ COMBUSTION — Mage 100% crit chance!",
        counter="Interrupt their next Pyroblast. Move unpredictably." },
    ["icy veins"]         = { danger="burst",     icon="spell_frost_icyveins",
        tip="⚡ ICY VEINS — Mage 20% haste + no pushback!",
        counter="Interrupt their Frostbolt chain. Icy Veins = burst window." },
    ["shadow dance"]      = { danger="burst",     icon="ability_rogue_shadowdance",
        tip="⚡ SHADOW DANCE — Rogue using stealth abilities from combat!",
        counter="Face them at all times. Cheap Shot/Ambush incoming." },
    ["inquisitor's fury"] = { danger="burst",     icon="spell_holy_sealofmight",
        tip="⚡ INQUISITOR'S FURY — 30% damage increase!",
        counter="Purge it if possible. Otherwise max defensives." },
    ["berserker rage"]    = { danger="burst",     icon="spell_nature_ancestralheal",
        tip="⚡ BERSERK — CC immune during this window!",
        counter="Don't waste CC. Survive the burst, CC after." },
    ["overclock"]         = { danger="burst",     icon="spell_nature_lightning",
        tip="⚡ OVERCLOCKED — Tinker burst proc!",
        counter="Defensive CD. This is a short but intense burst window." },

    -- DEFENSIVE / ABSORB — waste of your burst
    ["pain suppression"]  = { danger="defensive", icon="spell_holy_painsupression",
        tip="PAIN SUPPRESSION — 40% damage reduction! Switch targets.",
        counter="Hard switch. Burning through Pain Suppression is inefficient." },
    ["power word: shield"] = { danger="defensive", icon="spell_holy_powerwordshield",
        tip="SHIELD — Absorb active. Burn through or dispel.",
        counter="Dispel it if you can. Otherwise burst through." },
    ["ice barrier"]       = { danger="defensive", icon="spell_ice_lament",
        tip="ICE BARRIER — Mage absorb shield active.",
        counter="Dispel or burst through. Don't CC while absorb is up." },
    ["hand of protection"]={ danger="defensive", icon="spell_holy_sealofprotection",
        tip="HAND OF PROTECTION — Physical immune!",
        counter="Switch to magic damage only, or dispel." },
    ["idan's guard"]      = { danger="defensive", icon="ability_warrior_shieldwall",
        tip="IDAN'S GUARD — Felsworn shield up!",
        counter="Switch targets or use magic damage to bypass." },
    ["bone shield"]       = { danger="defensive", icon="inv_misc_bone_09",
        tip="BONE SHIELD — DK absorbing charges of damage.",
        counter="Burn charges with rapid hits. AoE is efficient." },
    ["spirit ward"]       = { danger="defensive", icon="spell_nature_reincarnation",
        tip="SPIRIT WARD — Spiritwalker absorb active.",
        counter="Keep pressure up. Ward expires in ~8s." },

    -- HEALING — interrupt or they top off
    ["healing stream"]    = { danger="heal",      icon="spell_nature_magicimmunity",
        tip="HEALING — Interrupt or they'll top off!",
        counter="Interrupt immediately. Don't let ticks accumulate." },
    ["ancestral guidance"] = { danger="heal",     icon="spell_nature_spiritarmor",
        tip="ANCESTRAL GUIDANCE — Crits heal them!",
        counter="Stop DPS or interrupt. Your crits are healing them." },
    ["lay on hands"]      = { danger="heal",      icon="spell_holy_layonhands",
        tip="LAY ON HANDS — Full heal attempt!",
        counter="Interrupt if in range. Can't be purged." },
    ["regrowth"]          = { danger="heal",      icon="spell_nature_resistnature",
        tip="HOT — Druid HoT ticking. Dispel or outdamage it.",
        counter="Dispel the hot. Without dispel, burst harder." },
    ["death pact"]        = { danger="heal",      icon="spell_shadow_deathpact",
        tip="DEATH PACT — DK sacrificing minion for a large heal!",
        counter="Interrupt if possible. Burns their pet cooldown." },

    -- CC / DEBUFF TOOLS — react fast
    ["fear ward"]         = { danger="watch",     icon="spell_holy_excorcism",
        tip="FEAR WARD — They're immune to Fear.",
        counter="Don't open with Fear. Save CC for after Fear Ward drops." },
    ["cloak of shadows"]  = { danger="watch",     icon="spell_shadow_nethercloak",
        tip="CLOAK — Rogue dispelled all magic debuffs!",
        counter="Wait ~5s. All your DoTs got removed." },
    ["vanish"]            = { danger="watch",     icon="ability_vanish",
        tip="VANISHED — Rogue went invisible! Watch your flanks.",
        counter="Use AoE or pets to break stealth. They'll reappear." },
    ["sprint"]            = { danger="watch",     icon="ability_rogue_sprint",
        tip="SPRINT — Rogue escaping or closing gap.",
        counter="Root or snare immediately." },
    ["void empowerment"]  = { danger="burst",     icon="spell_shadow_shadowpower",
        tip="⚡ VOID EMPOWERMENT — Massive shadow damage buff!",
        counter="All defensives now. Heal through if possible." },
}

-- ─────────────────────────────────────────────────────────────
-- INCOMING DEBUFF DATABASE (debuffs on the PLAYER from target)
-- Key: debuff name (lowercase)
-- ─────────────────────────────────────────────────────────────
local INCOMING_DB = {
    ["corruption"]       = { tip="Dispel Corruption — it stacks!", survive="Cleanse or heal through. Don't let it stack past 2." },
    ["shadow word: pain"]= { tip="SW:Pain — burst healing or dispel now.", survive="Dispel it. This is the opener for Shadow burst combos." },
    ["vampiric touch"]   = { tip="Vamp Touch draining your mana!", survive="Dispel or interrupt their Mind Flay follow-up." },
    ["rend"]             = { tip="Bleed — ignores armor!", survive="Dispel bleed or heal through. It's percentage-based." },
    ["deep freeze"]      = { tip="FROZEN — break with movement ability!", survive="Trinket if low HP. Otherwise wait for Mage's follow-up cast and interrupt." },
    ["frost nova"]       = { tip="ROOTED — break free!", survive="Use charge/blink/sprint. Mage is preparing a Frostbolt." },
    ["chains of ice"]    = { tip="SNARED — movement reduced!", survive="Break snare. This is a DK's gap closer setup." },
    ["fear"]             = { tip="FEARED — trinket or wait it out!", survive="Trinket immediately if below 40% HP. Pre-trinket before feared again." },
    ["polymorph"]        = { tip="POLYMORPHED — CC'd! Break it!", survive="Trinket or wait 8s. Tell teammate to DPS break." },
    ["hex"]              = { tip="HEXED — CC'd! Break it!", survive="Trinket. Hex lasts 10s." },
    ["repentance"]       = { tip="REPENTANCE — CC'd! Any damage breaks it.", survive="Tell teammate to hit you once to break." },
    ["blind"]            = { tip="BLINDED — any damage breaks it!", survive="Tell teammate to break with DoT. Rogue is stealthing." },
    ["wound poison"]     = { tip="WOUND POISON — healing reduced 25%!", survive="Dispel or your healer's throughput is severely reduced." },
    ["mortal strike"]    = { tip="MORTAL STRIKE — healing cut 50%!", survive="CRITICAL: 50% healing debuff. Dispel or burst faster than they kill you." },
    ["sunder armor"]     = { tip="SUNDERED — armor reduced!", survive="Kite. Your physical mitigation is dropping with each stack." },
    ["voidblaze"]        = { tip="Voidblaze DoT — Felsworn targeting you!", survive="Dispel or heal through. Fuels their Felfury." },
    ["smolder"]          = { tip="Fire DoT — cleanse it!", survive="Cleanse immediately. Stacks with other fire effects." },
    ["venom spit"]       = { tip="POISONED — reduced healing!", survive="Dispel poison. Anti-venom if available." },
    ["curse of weakness"]= { tip="CURSED — attack power reduced!", survive="Mage/Druid dispel required for curses." },
    ["inquisitor's brand"]={ tip="BRANDED — AoE damage to nearby allies!", survive="MOVE AWAY from allies immediately. You are a bomb." },
    ["siphon strike"]    = { tip="LIFESTEAL DEBUFF — they heal off you!", survive="Dispel or switch to a different attack pattern." },
}

-- ─────────────────────────────────────────────────────────────
-- CAST COUNTER DATABASE (60+ spells)
-- ─────────────────────────────────────────────────────────────
local CAST_DB = {
    ["chaos bolt"]         = { danger="interrupt", tip="INTERRUPT — huge single-target nuke!", pvp="Top priority interrupt. Spell Lock or Kick immediately." },
    ["pyroblast"]          = { danger="interrupt", tip="INTERRUPT — massive fire nuke!", pvp="Don't let this land — crits for 40-60% HP in PvP." },
    ["mind blast"]         = { danger="interrupt", tip="INTERRUPT — high Shadow burst!", pvp="Interrupt or it combos into Shadow Word: Death for a kill." },
    ["shadow bolt"]        = { danger="interrupt", tip="INTERRUPT — main Shadow nuke.", pvp="Silence or interrupt. Warlocks have no melee fallback." },
    ["fireball"]           = { danger="interrupt", tip="INTERRUPT — primary fire nuke.", pvp="Close distance — fire casters stop casting in melee." },
    ["frostbolt"]          = { danger="interrupt", tip="INTERRUPT — slows and nukes!", pvp="Interrupt or you'll be perma-slowed and burst down." },
    ["heal"]               = { danger="interrupt", tip="INTERRUPT — healing the enemy!", pvp="Top priority — every tick wasted is potential death." },
    ["greater heal"]       = { danger="interrupt", tip="INTERRUPT — large heal!", pvp="If no interrupt, switch targets to drain their mana." },
    ["flash heal"]         = { danger="interrupt", tip="INTERRUPT — fast heal!", pvp="Half-second window. React instantly." },
    ["holy light"]         = { danger="interrupt", tip="INTERRUPT — Paladin burst heal!", pvp="Paladin healers are mana-starved — drain them." },
    ["chain heal"]         = { danger="interrupt", tip="INTERRUPT — heals 3 targets!", pvp="Highest value interrupt in group PvP." },
    ["resurrection"]       = { danger="interrupt", tip="INTERRUPT — reviving dead ally!", pvp="NEVER let a rez land in PvP." },
    ["soul sear"]          = { danger="interrupt", tip="INTERRUPT — high Shadow nuke!", pvp="Interrupt immediately." },
    ["inquisitor's brand"] = { danger="interrupt", tip="INTERRUPT — AoE brand!", pvp="Interrupt or use CC. Getting branded = death sentence." },
    ["reconstruct"]        = { danger="interrupt", tip="INTERRUPT — healing to full!", pvp="Interrupt or fight resets." },
    ["frost nova"]         = { danger="dodge",     tip="MOVE AWAY — incoming freeze!", pvp="Pre-move sideways. Frozen = Pyroblast follow-up." },
    ["war stomp"]          = { danger="dodge",     tip="MOVE OUT — AoE stun incoming!", pvp="Get beyond 8 yards." },
    ["fear"]               = { danger="survive",   tip="TRINKET or MOVE — fear!", pvp="Trinket immediately if below 50% HP." },
    ["chains of faith"]    = { danger="dodge",     tip="KEEP MOVING — root incoming!", pvp="Root + follow-up burst is the kill combo. Pre-move." },
    ["eviscerate"]         = { danger="survive",   tip="POP DEFENSIVE — finisher!", pvp="5cp Eviscerate at late game = your entire HP bar." },
    ["avenging wrath"]     = { danger="survive",   tip="POP DEFENSIVE — Paladin wings!", pvp="Triple damage. All defensives NOW." },
    ["void rift"]          = { danger="dodge",     tip="MOVE OUT of void zone!", pvp="Persistent damage zone — never stand in it." },
    ["flame breath"]       = { danger="dodge",     tip="SIDESTEP — frontal fire cone!", pvp="Step to his flank — cone damage kills in 1-2 ticks." },
    ["ground slam"]        = { danger="dodge",     tip="MOVE AWAY — AoE knockback!", pvp="Knockback into walls = stunned. Back against something." },
    ["shadow bolt volley"] = { danger="dodge",     tip="SPREAD OUT — AoE shadow!", pvp="Spread 8+ yards. Volley chains between clustered targets." },
    ["mind flay"]          = { danger="dispel",    tip="MOVE OUT or INTERRUPT — slows/drains.", pvp="Break LoS. Don't let it channel fully." },
    ["corruption"]         = { danger="dispel",    tip="DISPEL — stacking disease!", pvp="Corruption stacks = death spiral. Dispel immediately." },
    ["shadow word: pain"]  = { danger="dispel",    tip="DISPEL — powerful DoT!", pvp="Opener for Shadow burst combos. Remove it." },
    ["rend"]               = { danger="dispel",    tip="DISPEL — bleed DoT!", pvp="Bleeds ignore armor. Dispel or heal through." },
    ["venom spit"]         = { danger="dispel",    tip="DISPEL — poison!", pvp="Poison DoTs are strong vs low-armor classes." },
    ["curse of weakness"]  = { danger="dispel",    tip="DISPEL — attack power curse!", pvp="Requires Mage/Druid specific dispel." },
    ["hex"]                = { danger="dispel",    tip="DISPEL ally — polymorph!", pvp="Free the polymorphed player. They're a free kill." },
    ["enrage"]             = { danger="survive",   tip="POP DEFENSIVE — enemy enraging!", pvp="Enrage = burst window. Shield up, kite, or CC." },
    ["frenzy"]             = { danger="survive",   tip="POP DEFENSIVE — frenzied!", pvp="Frenzy triples attack speed. Every defensive CD NOW." },
    ["desperate stand"]    = { danger="survive",   tip="POP DEFENSIVE — 50% damage buff!", pvp="Burn all defensives." },
    ["void empowerment"]   = { danger="survive",   tip="POP DEFENSIVE — empowered!", pvp="Maximum defensives + healing CDs." },
    ["cheap shot"]         = { danger="survive",   tip="STUN — PvP opener!", pvp="Trinket if low HP. Wait for combo finisher otherwise." },
    ["ambush"]             = { danger="survive",   tip="HIGH BURST — stealth ambush!", pvp="Always have a pet/minion to break stealth." },
    ["backstab"]           = { danger="survive",   tip="FACE THEM — high back damage!", pvp="Rotate to face Rogues every GCD." },
    ["blade flurry"]       = { danger="survive",   tip="POP DEFENSIVE — rapid multi-hit!", pvp="Blade Flurry shreds defensives — pop your best CD." },
    ["drain soul"]         = { danger="interrupt", tip="INTERRUPT — soul drain!", pvp="Drain Soul amps each tick. Interrupt early." },
    ["rallying cry"]       = { danger="interrupt", tip="INTERRUPT — enemy-wide attack buff!", pvp="Interrupt or every mob becomes a threat." },
    ["blink"]              = { danger="watch",     tip="GAP CLOSE — teleporting!", pvp="Use gap-close immediately after Blink lands." },
    ["phase shift"]        = { danger="watch",     tip="WAIT — going invisible!", pvp="Don't move. They'll reappear at last position." },
    ["sprint"]             = { danger="watch",     tip="SNARE — fleeing/closing!", pvp="Root or snare immediately." },
    ["gouge"]              = { danger="survive",   tip="FACE THEM — stun imminent!", pvp="Always face Rogues. Gouge requires facing." },
}

local DANGER_STYLE = {
    interrupt = { r=1.0, g=0.1, b=0.1, label="|cffFF2222⚡ INTERRUPT|r" },
    dodge     = { r=1.0, g=0.55,b=0.0, label="|cffFF8C00⚡ DODGE|r" },
    dispel    = { r=0.6, g=0.2, b=1.0, label="|cffAA44FF⚡ DISPEL|r" },
    survive   = { r=1.0, g=0.8, b=0.0, label="|cffFFCC00⚡ DEFENSIVE|r" },
    watch     = { r=0.4, g=0.8, b=1.0, label="|cff66CCFF⚠ WATCH|r" },
    immune    = { r=0.5, g=0.5, b=0.5, label="|cff999999⛔ IMMUNE|r" },
    burst     = { r=1.0, g=0.2, b=0.2, label="|cffFF3300⚡ BURST|r" },
    defensive = { r=0.3, g=0.7, b=1.0, label="|cff44AAFF🛡 DEFENSIVE|r" },
    heal      = { r=0.2, g=1.0, b=0.4, label="|cff33FF66⚡ INTERRUPT|r" },
    cc        = { r=1.0, g=0.6, b=0.0, label="|cffFFAA00⚠ CC ACTIVE|r" },
}

-- ─────────────────────────────────────────────────────────────
-- OFFENSIVE SUGGESTION ENGINE
-- Based on target state → what should player cast RIGHT NOW
-- ─────────────────────────────────────────────────────────────
local function GetOffensiveTip(hpPct, isCasting, castName, isPlayer, buffs)
    -- Check for immune buff → don't waste spells
    if buffs then
        for _, bname in ipairs(buffs) do
            local bd = BUFF_DB[bname:lower()]
            if bd and bd.danger == "immune" then
                return "|cff999999IMMUNE — switch targets or wait.|r"
            end
        end
    end

    -- Casting — interrupt priority
    if isCasting and castName then
        local cd = CAST_DB[castName:lower()]
        if cd and cd.danger == "interrupt" then
            return "|cffFF2222⚡ USE INTERRUPT NOW — " .. castName .. "|r"
        end
    end

    -- Check for heal buff → dispel
    if buffs then
        for _, bname in ipairs(buffs) do
            local bd = BUFF_DB[bname:lower()]
            if bd and bd.danger == "heal" then
                return "|cff33FF66⚡ DISPEL HEAL — " .. bname .. "|r"
            end
        end
    end

    -- Defensive buff on target → switch or wait
    if buffs then
        for _, bname in ipairs(buffs) do
            local bd = BUFF_DB[bname:lower()]
            if bd and bd.danger == "defensive" then
                return "|cff44AAFF🛡 SWITCH TARGETS — " .. bname .. " active|r"
            end
        end
    end

    -- Burst window
    if buffs then
        for _, bname in ipairs(buffs) do
            local bd = BUFF_DB[bname:lower()]
            if bd and bd.danger == "burst" then
                return "|cffFF3300⚡ DEFENSIVE — " .. bname .. " on THEM means damage spike!|r"
            end
        end
    end

    -- HP thresholds
    if hpPct <= 0.20 then
        return "|cffFF4444🔥 EXECUTE PHASE — Use your finisher / execute ability!|r"
    elseif hpPct <= 0.35 then
        return "|cffFF8800💀 LOW HP — Burn all damage cooldowns NOW!|r"
    elseif hpPct <= 0.55 then
        return "|cffFFCC00⚔ MID FIGHT — Maintain DoTs / debuffs. Watch for defensive CDs.|r"
    elseif hpPct <= 0.80 then
        return "|cff88FF88📈 OPENING — Apply debuffs, build resources, set up burst.|r"
    else
        return "|cff88FF88🎯 FRESH TARGET — Open with your highest priority DoT/debuff.|r"
    end
end

-- ─────────────────────────────────────────────────────────────
-- INCOMING THREAT SCANNER
-- Checks player's debuffs — are any from the current enemy?
-- ─────────────────────────────────────────────────────────────
local function GetIncomingThreat()
    local threats = {}
    for i = 1, 16 do
        local name, _, _, _, _, _, _, caster = UnitDebuff("player", i)
        if not name then break end
        if caster == "target" then
            local idb = INCOMING_DB[name:lower()]
            if idb then
                table.insert(threats, { name=name, tip=idb.tip, survive=idb.survive })
            else
                table.insert(threats, { name=name, tip=name .. " on you!", survive="Dispel or heal through." })
            end
        end
    end
    return threats
end

-- ─────────────────────────────────────────────────────────────
-- Loot + Quest tables
-- ─────────────────────────────────────────────────────────────
local LOOT_DB    = {}
local QUEST_MOBS = {}

local function BuildLookups()
    local raw = {
        [69]  = { name="Timber Wolf",              drops={ {"Ruined Pelt",40},{"Linen Cloth",15} } },
        [113] = { name="Stonetusk Boar",            drops={ {"Chunk of Boar Meat",45},{"Ruined Pelt",20} } },
        [114] = { name="Defias Thug",               drops={ {"Linen Cloth",35},{"Minor Healing Potion",10} } },
        [36]  = { name="Kobold Vermin",             drops={ {"Kobold Candle",60},{"Linen Cloth",20} } },
        [432] = { name="Harvest Golem",             drops={ {"Mechanical Parts",50},{"Linen Cloth",20} } },
        [434] = { name="Defias Pillager",           drops={ {"Linen Cloth",40},{"Minor Healing Potion",8} } },
        [666] = { name="Young Stranglethorn Tiger", drops={ {"Tiger Pelt",40},{"Tiger Meat",25} } },
        [653] = { name="Bloodscalp Troll",          drops={ {"Bloodscalp Tusk",18},{"Wool Cloth",30} } },
        [6564]= { name="Wastewander Bandit",        drops={ {"Silk Cloth",30},{"Wastewander Note",8} } },
        [8532]= { name="Plague Spreader",           drops={ {"Mageweave Cloth",35},{"Embalming Ichor",15} } },
    }
    for id, data in pairs(raw) do
        LOOT_DB[id] = data
        if data.name then LOOT_DB[data.name:lower()] = data end
    end
    if CoALevelGuide_Steps then
        for _, phase in ipairs(CoALevelGuide_Steps) do
            if phase.steps then
                for _, step in ipairs(phase.steps) do
                    if step.type == "kill" and step.text then
                        for mob in step.text:gmatch("Kill%s+([A-Z][a-zA-Z]+%s+[A-Z][a-zA-Z]+)") do
                            QUEST_MOBS[mob:lower()] = true
                        end
                    end
                end
            end
        end
    end
end

-- ─────────────────────────────────────────────────────────────
-- Colour helpers
-- ─────────────────────────────────────────────────────────────
local function HpColor(p)
    if p > 0.6 then return 0.15,0.85,0.35
    elseif p > 0.3 then return 1.0,0.65,0.05
    else return 0.95,0.15,0.15 end
end

local CLASS_COLORS = {
    WARRIOR      = {r=0.78,g=0.61,b=0.43},
    PALADIN      = {r=0.96,g=0.55,b=0.73},
    HUNTER       = {r=0.67,g=0.83,b=0.45},
    ROGUE        = {r=1.00,g=0.96,b=0.41},
    PRIEST       = {r=1.00,g=1.00,b=1.00},
    DEATHKNIGHT  = {r=0.77,g=0.12,b=0.23},
    SHAMAN       = {r=0.00,g=0.44,b=0.87},
    MAGE         = {r=0.41,g=0.80,b=0.94},
    WARLOCK      = {r=0.58,g=0.51,b=0.79},
    DRUID        = {r=1.00,g=0.49,b=0.04},
    -- CoA custom classes
    FELSWORN     = {r=0.70,g=0.10,b=0.90},
    NECROMANCER  = {r=0.20,g=0.80,b=0.40},
    WITCH_HUNTER = {r=0.90,g=0.70,b=0.10},
    RUNEMASTER   = {r=0.30,g=0.70,b=1.00},
    REAPER       = {r=0.60,g=0.10,b=0.10},
    SPIRITWALKER = {r=0.20,g=0.90,b=0.70},
    TINKER       = {r=0.90,g=0.80,b=0.30},
    CHRONOMANCER = {r=0.70,g=0.40,b=1.00},
}

-- ─────────────────────────────────────────────────────────────
-- Nameplate detection
-- ─────────────────────────────────────────────────────────────
local function IsNameplate(f)
    if not f or f:GetName() then return false end
    for _, c in ipairs({ f:GetChildren() }) do
        if c:GetObjectType() == "StatusBar" then return true end
    end
    return false
end

local function GetNPHealthBar(f)
    for _, c in ipairs({ f:GetChildren() }) do
        if c:GetObjectType() == "StatusBar" then return c end
    end
end

local function GetSafeRegions(f)
    if not f then return {} end
    local regions
    local ok = pcall(function()
        regions = { f:GetRegions() }
    end)
    return (ok and regions) or {}
end

local function GetNPName(f)
    for _, r in ipairs(GetSafeRegions(f)) do
        if r:GetObjectType() == "FontString" then
            local t = r:GetText()
            if t and t ~= "" then return t end
        end
    end
end

local function GetActiveClass()
    if CoAAT_Engine and CoAAT_Engine.GetClassId then
        return CoAAT_Engine.GetClassId()
    end
    return nil
end

local function GetCastData(unit)
    local now = GetTime()
    local name, _, _, _, startTime, endTime, _, _, notInterruptible = UnitCastingInfo(unit)
    if name then
        local s, e = startTime / 1000, endTime / 1000
        local pct = math.max(0, math.min(1, (now - s) / (e - s)))
        return name, pct, false, not notInterruptible
    end
    local cname, _, _, _, startTime, endTime, _, notInterruptible = UnitChannelInfo(unit)
    if cname then
        local s, e = startTime / 1000, endTime / 1000
        local pct = math.max(0, math.min(1, 1 - (now - s) / (e - s)))
        return cname, pct, true, not notInterruptible
    end
    return nil
end

-- ─────────────────────────────────────────────────────────────
-- Build overlay — pure textures + FontStrings, ZERO frames
-- ─────────────────────────────────────────────────────────────
local function BuildOverlay(np)
    local hp = GetNPHealthBar(np)
    if not hp then return nil end
    local ov = { hpBar=hp, np=np, pulse=0, castPhase=0 }

    -- 1. Accent line
    local accent = np:CreateTexture(nil,"OVERLAY",nil,7)
    accent:SetHeight(2)
    accent:SetPoint("BOTTOMLEFT",hp,"TOPLEFT",0,1)
    accent:SetPoint("BOTTOMRIGHT",hp,"TOPRIGHT",0,1)
    accent:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    accent:SetVertexColor(0.2,0.85,1.0,0.9)
    ov.accent = accent

    -- 2. HP% text
    local hpTxt = np:CreateFontString(nil,"OVERLAY")
    hpTxt:SetFont("Fonts\\FRIZQT__.TTF",7,"OUTLINE")
    hpTxt:SetPoint("RIGHT",hp,"RIGHT",-2,0)
    hpTxt:SetTextColor(1,1,1,0.92)
    ov.hpTxt = hpTxt

    -- 3. Quest mark
    local quest = np:CreateFontString(nil,"OVERLAY")
    quest:SetFont("Fonts\\FRIZQT__.TTF",10,"OUTLINE")
    quest:SetPoint("RIGHT",hp,"LEFT",-18,0)
    quest:SetText("")
    ov.questMark = quest

    -- 4. PvP / Player badge
    local pvpBadge = np:CreateFontString(nil,"OVERLAY")
    pvpBadge:SetFont("Fonts\\FRIZQT__.TTF",7,"OUTLINE")
    pvpBadge:SetPoint("LEFT",hp,"LEFT",2,0)
    pvpBadge:SetText("")
    ov.pvpBadge = pvpBadge

    -- 5. Target ring
    local ring = np:CreateTexture(nil,"OVERLAY",nil,6)
    ring:SetSize(72,22)
    ring:SetPoint("CENTER",hp,"CENTER",0,0)
    ring:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    ring:SetAlpha(0)
    ov.ring = ring

    -- 6. Cast bar BG
    local castBG = np:CreateTexture(nil,"OVERLAY",nil,5)
    castBG:SetHeight(5)
    castBG:SetPoint("TOPLEFT",hp,"BOTTOMLEFT",0,-3)
    castBG:SetPoint("TOPRIGHT",hp,"BOTTOMRIGHT",0,-3)
    castBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    castBG:SetVertexColor(0.05,0.05,0.1,0.7)
    castBG:SetAlpha(0)
    ov.castBG = castBG

    -- 7. Cast bar fill
    local castFill = np:CreateTexture(nil,"OVERLAY",nil,6)
    castFill:SetHeight(5)
    castFill:SetPoint("TOPLEFT",hp,"BOTTOMLEFT",0,-3)
    castFill:SetWidth(1)
    castFill:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    castFill:SetVertexColor(1.0,0.2,0.2,0.95)
    castFill:SetAlpha(0)
    ov.castFill = castFill

    -- 8. Cast spell name
    local castName = np:CreateFontString(nil,"OVERLAY")
    castName:SetFont("Fonts\\FRIZQT__.TTF",7,"OUTLINE")
    castName:SetPoint("LEFT",hp,"BOTTOMLEFT",0,-3)
    castName:SetText("")
    ov.castName = castName

    -- 9. Danger label (above nameplate)
    local dangerTxt = np:CreateFontString(nil,"OVERLAY")
    dangerTxt:SetFont("Fonts\\FRIZQT__.TTF",8,"OUTLINE")
    dangerTxt:SetPoint("BOTTOM",hp,"TOP",0,22)
    dangerTxt:SetText("")
    ov.dangerTxt = dangerTxt

    -- 10. Counter tip (cast-specific)
    local counterTxt = np:CreateFontString(nil,"OVERLAY")
    counterTxt:SetFont("Fonts\\FRIZQT__.TTF",6,"OUTLINE")
    counterTxt:SetPoint("TOPLEFT",hp,"BOTTOMLEFT",0,-10)
    counterTxt:SetWidth(130)
    counterTxt:SetJustifyH("LEFT")
    counterTxt:SetTextColor(0.85,0.85,0.85,1)
    counterTxt:SetText("")
    ov.counterTxt = counterTxt

    -- 11. Offensive tip (what to do vs this target now)
    local offTip = np:CreateFontString(nil,"OVERLAY")
    offTip:SetFont("Fonts\\FRIZQT__.TTF",6,"OUTLINE")
    offTip:SetPoint("TOPLEFT",hp,"BOTTOMLEFT",0,-19)
    offTip:SetWidth(200)
    offTip:SetJustifyH("LEFT")
    offTip:SetText("")
    ov.offTip = offTip

    -- 12. Incoming threat (debuffs on player from target)
    local incomingTxt = np:CreateFontString(nil,"OVERLAY")
    incomingTxt:SetFont("Fonts\\FRIZQT__.TTF",6,"OUTLINE")
    incomingTxt:SetPoint("TOPLEFT",hp,"BOTTOMLEFT",0,-28)
    incomingTxt:SetWidth(200)
    incomingTxt:SetJustifyH("LEFT")
    incomingTxt:SetText("")
    ov.incomingTxt = incomingTxt

    -- 13. Loot line
    local lootTxt = np:CreateFontString(nil,"OVERLAY")
    lootTxt:SetFont("Fonts\\FRIZQT__.TTF",6,"OUTLINE")
    lootTxt:SetPoint("TOPLEFT",hp,"BOTTOMLEFT",0,-37)
    lootTxt:SetWidth(180)
    lootTxt:SetJustifyH("LEFT")
    lootTxt:SetTextColor(0.9,0.8,0.5,0.9)
    lootTxt:SetText("")
    ov.lootTxt = lootTxt

    -- 14. Enemy buff icons (target only, up to 6 key PvP buffs)
    local buffIcons = {}
    for i = 1, 6 do
        local icon = np:CreateTexture(nil,"OVERLAY",nil,7)
        icon:SetSize(14,14)
        if i == 1 then
            icon:SetPoint("BOTTOMLEFT",hp,"TOPLEFT",0,5)
        else
            icon:SetPoint("LEFT",buffIcons[i-1].icon,"RIGHT",2,0)
        end
        icon:SetTexCoord(0.07,0.93,0.07,0.93)
        icon:SetAlpha(0)
        -- coloured border for danger level
        local border = np:CreateTexture(nil,"OVERLAY",nil,6)
        border:SetSize(16,16)
        border:SetPoint("CENTER",icon,"CENTER",0,0)
        border:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
        border:SetVertexColor(1,0,0,0)
        buffIcons[i] = { icon=icon, border=border }
    end
    ov.buffIcons = buffIcons

    -- 15. Debuff icons (player-applied, below HP bar)
    local debuffs = {}
    for i = 1, 5 do
        local icon = np:CreateTexture(nil,"OVERLAY",nil,7)
        icon:SetSize(12,12)
        local yOff = -47
        if i == 1 then
            icon:SetPoint("TOPLEFT",hp,"BOTTOMLEFT",0,yOff)
        else
            icon:SetPoint("LEFT",debuffs[i-1].icon,"RIGHT",2,0)
        end
        icon:SetTexCoord(0.07,0.93,0.07,0.93)
        icon:SetAlpha(0)
        local cnt = np:CreateFontString(nil,"OVERLAY")
        cnt:SetFont("Fonts\\FRIZQT__.TTF",6,"OUTLINE")
        cnt:SetPoint("BOTTOMRIGHT",icon,"BOTTOMRIGHT",2,-1)
        cnt:SetText("")
        debuffs[i] = { icon=icon, cnt=cnt }
    end
    ov.debuffs = debuffs

    return ov
end

-- ─────────────────────────────────────────────────────────────
-- Refresh overlay
-- ─────────────────────────────────────────────────────────────
local function RefreshOverlay(ov, isTarget, dt)
    local hp  = ov.hpBar
    local cur, mn, mx = hp:GetValue(), hp:GetMinMaxValues()
    local range = (mx or 1)-(mn or 0)
    local pct   = range > 0 and ((cur-mn)/range) or 1.0
    pct = math.max(0,math.min(1,pct))

    -- HP text + accent colour
    if ov.hpTxt  then ov.hpTxt:SetText(string.format("%d%%",math.ceil(pct*100))) end
    if ov.accent then
        local r,g,b = HpColor(pct)
        ov.accent:SetVertexColor(r,g,b,0.85)
    end

    -- Target ring pulse
    if ov.ring then
        if isTarget then
            ov.pulse = (ov.pulse or 0) + (dt or 0)*3.2
            ov.ring:SetAlpha(0.5+0.42*math.sin(ov.pulse))
            ov.ring:SetVertexColor(1.0,0.85,0.1,1.0)
        else
            ov.ring:SetAlpha(0)
            ov.pulse = 0
        end
    end

    -- Quest mark
    local npName = GetNPName(ov.np)
    if ov.questMark then
        ov.questMark:SetText((npName and QUEST_MOBS[npName:lower()]) and "|cffFFD700❕|r" or "")
    end

    -- PvP badge
    if ov.pvpBadge then
        if isTarget then
            if UnitIsPlayer("target") then
                local _,cls = UnitClass("target")
                local cc = cls and CLASS_COLORS[cls]
                if cc then
                    ov.pvpBadge:SetText(string.format(
                        "|cff%02x%02x%02x[PvP: %s]|r",
                        cc.r*255, cc.g*255, cc.b*255,
                        (cls or "?"):sub(1,4)))
                else
                    ov.pvpBadge:SetText("|cffFF6666[PvP]|r")
                end
            else
                ov.pvpBadge:SetText("")
            end
        else
            ov.pvpBadge:SetText("")
        end
    end

    -- Loot
    if ov.lootTxt then
        local data = npName and LOOT_DB[npName:lower()]
        if data and data.drops and #data.drops > 0 then
            local parts = {}
            for i = 1, math.min(2,#data.drops) do
                local d = data.drops[i]
                table.insert(parts, string.format("|cffbbaa66%s|r |cff888888%d%%|r",d[1],d[2]))
            end
            ov.lootTxt:SetText(table.concat(parts,"  "))
        else
            ov.lootTxt:SetText("")
        end
    end

    -- ── TARGET-ONLY SYSTEMS ───────────────────────────────────
    if not isTarget then
        if ov.castBG    then ov.castBG:SetAlpha(0) end
        if ov.castFill  then ov.castFill:SetAlpha(0) end
        if ov.castName  then ov.castName:SetText("") end
        if ov.dangerTxt then ov.dangerTxt:SetText("") end
        if ov.counterTxt then ov.counterTxt:SetText("") end
        if ov.offTip    then ov.offTip:SetText("") end
        if ov.incomingTxt then ov.incomingTxt:SetText("") end
        if ov.buffIcons then
            for _,b in ipairs(ov.buffIcons) do b.icon:SetAlpha(0) b.border:SetVertexColor(0,0,0,0) end
        end
        if ov.debuffs then
            for _,d in ipairs(ov.debuffs) do d.icon:SetAlpha(0) d.cnt:SetText("") end
        end
        return
    end

    -- ── ENEMY BUFF SCANNING (target) ─────────────────────────
    local activePvPBuffs = {}
    local buffSlot = 0
    for i = 1, 32 do
        local bname, _, bicon = UnitBuff("target", i)
        if not bname then break end
        local bd = BUFF_DB[bname:lower()]
        if bd then
            buffSlot = buffSlot + 1
            table.insert(activePvPBuffs, bname)
            if ov.buffIcons and buffSlot <= #ov.buffIcons then
                local slot = ov.buffIcons[buffSlot]
                if bicon then slot.icon:SetTexture(bicon) end
                slot.icon:SetAlpha(0.95)
                -- colour border by danger
                local ds = DANGER_STYLE[bd.danger] or DANGER_STYLE.watch
                slot.border:SetVertexColor(ds.r, ds.g, ds.b, 0.7)
                if buffSlot >= #ov.buffIcons then break end
            end
        end
    end
    -- clear unused buff slots
    if ov.buffIcons then
        for i = buffSlot+1, #ov.buffIcons do
            ov.buffIcons[i].icon:SetAlpha(0)
            ov.buffIcons[i].border:SetVertexColor(0,0,0,0)
        end
    end

    -- ── CAST BAR ─────────────────────────────────────────────
    local castSpell, castPct, isChannel, canInterrupt = GetCastData("target")
    local classId = GetActiveClass()

    if castSpell and castPct then
        local barW = hp:GetWidth()
        if barW == 0 then barW = 80 end
        local fillW = math.max(1, barW * castPct)
        if ov.castBG   then ov.castBG:SetAlpha(1) end
        if ov.castFill then ov.castFill:SetWidth(fillW) ov.castFill:SetAlpha(1) end
        if ov.castName then ov.castName:SetText("|cffFFFFFF"..castSpell.."|r") end

        local cdata = CAST_DB[castSpell:lower()]
        local style = cdata and DANGER_STYLE[cdata.danger] or DANGER_STYLE["watch"]

        if ov.castFill and cdata then
            ov.castFill:SetVertexColor(style.r,style.g,style.b,0.95)
        end

        if ov.dangerTxt and cdata then
            ov.castPhase = (ov.castPhase or 0) + (dt or 0)*6
            local flash = 0.7 + 0.3*math.abs(math.sin(ov.castPhase))
            ov.dangerTxt:SetAlpha(flash)
            ov.dangerTxt:SetText(style.label)
        elseif ov.dangerTxt then
            ov.dangerTxt:SetText("")
        end

        if ov.counterTxt and cdata then
            local tip = ""
            -- Check for buff-based immune first
            for _,bname in ipairs(activePvPBuffs) do
                local bd = BUFF_DB[bname:lower()]
                if bd and bd.danger == "immune" then
                    tip = "|cff999999TARGET IMMUNE — save spells|r"
                    break
                end
            end
            if tip == "" then
                if classId and cdata.classes and cdata.classes[classId] then
                    tip = "|cff00ccff"..cdata.classes[classId].."|r"
                elseif cdata.pvp and UnitIsPlayer("target") then
                    tip = "|cffFF8C00"..cdata.pvp.."|r"
                elseif cdata.tip then
                    tip = "|cffdddddd"..cdata.tip.."|r"
                end
            end
            ov.counterTxt:SetText(tip)
        elseif ov.counterTxt then
            ov.counterTxt:SetText("")
        end
    else
        if ov.castBG   then ov.castBG:SetAlpha(0) end
        if ov.castFill then ov.castFill:SetAlpha(0) end
        if ov.castName then ov.castName:SetText("") end
        if ov.dangerTxt then ov.dangerTxt:SetText("") ov.castPhase = 0 end
        if ov.counterTxt then ov.counterTxt:SetText("") end
    end

    -- ── OFFENSIVE TIP ─────────────────────────────────────────
    if ov.offTip then
        local tip = GetOffensiveTip(pct, castSpell~=nil, castSpell,
                                    UnitIsPlayer("target"), activePvPBuffs)
        ov.offTip:SetText(tip)
    end

    -- ── INCOMING THREAT (debuffs on player from this enemy) ───
    if ov.incomingTxt then
        local threats = GetIncomingThreat()
        if #threats > 0 then
            local t = threats[1] -- show worst one
            ov.incomingTxt:SetText(
                "|cffFF4444⚠ ON YOU:|r |cffFF8800"..t.tip.."|r")
        else
            ov.incomingTxt:SetText("")
        end
    end

    -- ── DEBUFF ICONS (player-applied on target) ───────────────
    if ov.debuffs then
        local shown = 0
        for i = 1, 5 do
            local s = ov.debuffs[i]
            local dname,_,dicon,dcount,_,_,_,caster = UnitDebuff("target",i)
            if dname and dicon and (caster=="player" or caster==nil) then
                s.icon:SetTexture(dicon)
                s.icon:SetAlpha(0.95)
                s.cnt:SetText((dcount and dcount>1) and tostring(dcount) or "")
                shown = shown + 1
            else
                s.icon:SetAlpha(0)
                s.cnt:SetText("")
            end
        end
    end
end

-- ─────────────────────────────────────────────────────────────
-- Hide / Show helpers
-- ─────────────────────────────────────────────────────────────
local function HideOverlay(ov)
    if ov.accent     then ov.accent:Hide() end
    if ov.hpTxt      then ov.hpTxt:SetText("") end
    if ov.ring       then ov.ring:SetAlpha(0) end
    if ov.questMark  then ov.questMark:SetText("") end
    if ov.pvpBadge   then ov.pvpBadge:SetText("") end
    if ov.castBG     then ov.castBG:SetAlpha(0) end
    if ov.castFill   then ov.castFill:SetAlpha(0) end
    if ov.castName   then ov.castName:SetText("") end
    if ov.dangerTxt  then ov.dangerTxt:SetText("") end
    if ov.counterTxt then ov.counterTxt:SetText("") end
    if ov.offTip     then ov.offTip:SetText("") end
    if ov.incomingTxt then ov.incomingTxt:SetText("") end
    if ov.lootTxt    then ov.lootTxt:SetText("") end
    if ov.buffIcons then
        for _,b in ipairs(ov.buffIcons) do b.icon:SetAlpha(0) b.border:SetVertexColor(0,0,0,0) end
    end
    if ov.debuffs then
        for _,d in ipairs(ov.debuffs) do d.icon:SetAlpha(0) d.cnt:SetText("") end
    end
end

local function ShowOverlay(ov)
    if ov.accent then ov.accent:Show() end
end

-- ─────────────────────────────────────────────────────────────
-- Main scan
-- ─────────────────────────────────────────────────────────────
local function ScanNameplates(dt)
    if not (CoAAT_DB and CoAAT_DB.nameplateHUD ~= false) then
        for _,ov in pairs(_injected) do HideOverlay(ov) end
        CoAAT_TargetNameplateFrame = nil
        return
    end

    local targetName = UnitExists("target") and UnitName("target") or nil
    local targetHp = UnitExists("target") and UnitHealth("target") or 0
    local targetMax = UnitExists("target") and UnitHealthMax("target") or 1
    local targetHpPct = targetHp / math.max(1, targetMax)

    local kids = { WorldFrame:GetChildren() }
    local seen = {}
    local bestTargetFrame = nil
    local bestTargetAlpha = -1

    for _, frame in ipairs(kids) do
        if frame:IsShown() and not frame:GetName() then
            if IsNameplate(frame) then
                seen[frame] = true
                if not _injected[frame] then
                    local ov = BuildOverlay(frame)
                    if ov then _injected[frame] = ov end
                end

                if targetName then
                    local npName = GetNPName(frame)
                    if npName == targetName then
                        local hp = GetNPHealthBar(frame)
                        if hp then
                            local cur, mn, mx = hp:GetValue(), hp:GetMinMaxValues()
                            local range = (mx or 1) - (mn or 0)
                            local npPct = range > 0 and ((cur - mn) / range) or 1.0

                            if math.abs(npPct - targetHpPct) <= 0.015 then
                                local alpha = frame:GetAlpha() or 1.0
                                if alpha > bestTargetAlpha then
                                    bestTargetAlpha = alpha
                                    bestTargetFrame = frame
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    CoAAT_TargetNameplateFrame = bestTargetFrame

    for frame, _ in pairs(seen) do
        local ov = _injected[frame]
        if ov then
            ShowOverlay(ov)
            local isTgt = (frame == bestTargetFrame)
            RefreshOverlay(ov, isTgt, dt)
        end
    end

    for frame, ov in pairs(_injected) do
        if not seen[frame] then
            HideOverlay(ov)
            _injected[frame] = nil
        end
    end
end

-- ─────────────────────────────────────────────────────────────
-- Public API
-- ─────────────────────────────────────────────────────────────
function CoAAT_NameplateHUD.Build()
    if _controller then return end
    BuildLookups()

    _controller = CreateFrame("Frame","COAATNameplateHUD",UIParent)
    _controller:SetAllPoints(WorldFrame)
    _controller:SetFrameStrata("TOOLTIP")
    _controller:SetAlpha(1)

    _controller:SetScript("OnUpdate", function(self, elapsed)
        _ticker = _ticker + elapsed
        if _ticker >= _TICK then
            ScanNameplates(_ticker)
            _ticker = 0
        end
    end)

    local EVENTS = {
        "PLAYER_TARGET_CHANGED",
        "UNIT_SPELLCAST_START","UNIT_SPELLCAST_STOP","UNIT_SPELLCAST_INTERRUPTED",
        "UNIT_SPELLCAST_CHANNEL_START","UNIT_SPELLCAST_CHANNEL_STOP",
        "UNIT_AURA",
    }
    for _,e in ipairs(EVENTS) do _controller:RegisterEvent(e) end

    _controller:SetScript("OnEvent", function(self, event, unit)
        if event == "PLAYER_TARGET_CHANGED"
        or event == "UNIT_AURA"
        or (unit == "target" and event:find("UNIT_SPELLCAST")) then
            ScanNameplates(0)
        end
    end)
end

function CoAAT_NameplateHUD.Enable()
    if CoAAT_DB then CoAAT_DB.nameplateHUD = true end
    if _controller then _controller:Show() end
end

function CoAAT_NameplateHUD.Disable()
    if CoAAT_DB then CoAAT_DB.nameplateHUD = false end
    for _,ov in pairs(_injected) do HideOverlay(ov) end
end

function CoAAT_NameplateHUD.Toggle()
    local on = not (CoAAT_DB and CoAAT_DB.nameplateHUD == false)
    if on then CoAAT_NameplateHUD.Disable() else CoAAT_NameplateHUD.Enable() end
end
