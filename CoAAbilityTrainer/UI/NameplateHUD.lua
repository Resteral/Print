-- ============================================================
-- CoAAbilityTrainer - Nameplate HUD (v3)
-- Box-free overlay on every enemy nameplate:
--   · HP% + coloured accent line
--   · Quest mob indicator ❕
--   · Loot drop ticker (top 2 drops)
--   · LIVE CAST BAR — shows what enemy is casting in real-time
--   · Danger flash  ⚠  + interrupt/dodge/counter tip
--   · Class-specific PvP counter pulled from active class
--   · Debuff icons (player-applied, on target)
-- ============================================================

CoAAT_NameplateHUD = {}

local _injected   = {}
local _ticker     = 0
local _TICK       = 0.07
local _controller = nil

-- ─────────────────────────────────────────────────────────────
-- CAST COUNTER DATABASE
-- Key: spell name (lowercase)
-- danger : "interrupt" | "dodge" | "dispel" | "survive" | "watch"
-- tip     : general what-to-do string
-- pvp     : extra tip specifically for PvP scenarios
-- classes : [classId] = class-specific counter tip
-- ─────────────────────────────────────────────────────────────
local CAST_DB = {

    -- ═══════════════════════════════════════════════════
    -- UNIVERSAL HIGH-PRIORITY INTERRUPTS
    -- ═══════════════════════════════════════════════════
    ["chaos bolt"]         = { danger="interrupt", tip="INTERRUPT — huge single-target nuke!", pvp="Top priority interrupt in arena. Spell Lock or Kick immediately." },
    ["pyroblast"]          = { danger="interrupt", tip="INTERRUPT — massive fire damage!", pvp="Don't let this land — it crits for 40-60% of your HP in PvP." },
    ["mind blast"]         = { danger="interrupt", tip="INTERRUPT — high Shadow burst!", pvp="Interrupt or it combos into Shadow Word: Death for a kill attempt." },
    ["mind flay"]          = { danger="dispel",    tip="MOVE OUT or INTERRUPT — slows and drains.", pvp="Break LoS to cancel the channel. Don't let it tick fully." },
    ["shadow bolt"]        = { danger="interrupt", tip="INTERRUPT — main Shadow nuke.", pvp="Silence or interrupt. Casters have no melee fallback." },
    ["fireball"]           = { danger="interrupt", tip="INTERRUPT — primary fire nuke.", pvp="Close distance — many fire casters stop casting in melee." },
    ["frostbolt"]          = { danger="interrupt", tip="INTERRUPT — slows and nukes!", pvp="Interrupt or you'll be perma-slowed and burst down.",
        classes={ runemaster="Arcane Binding to stop the slow chain.", felsworn="Fel Hoof Charge to close gap and interrupt.", witch_hunter="Stay max range — you outrange Frostbolt." } },
    ["heal"]               = { danger="interrupt", tip="INTERRUPT — healing the enemy!", pvp="Top priority — every tick wasted is potential death.",
        classes={ runemaster="Arcane Binding on heal cast.", necromancer="Death Coil interrupts and deals damage.", witch_hunter="Cursed Shot + interrupt combo — don't let them top off." } },
    ["greater heal"]       = { danger="interrupt", tip="INTERRUPT — large heal incoming!", pvp="If you can't interrupt, switch targets to drain their mana." },
    ["flash heal"]         = { danger="interrupt", tip="INTERRUPT — instant heal attempt!", pvp="Flash Heal is fast — you have a half-second window. React!" },
    ["holy light"]         = { danger="interrupt", tip="INTERRUPT — Paladin burst heal!", pvp="Interrupt or Silence. Paladin healers are mana-starved — drain them." },
    ["chain heal"]         = { danger="interrupt", tip="INTERRUPT — heals up to 3 targets!", pvp="Chain Heal cascading makes it the highest value interrupt in group PvP." },
    ["resurrection"]       = { danger="interrupt", tip="INTERRUPT — reviving a dead ally!", pvp="NEVER let a resurrection land in PvP. Instant priority." },
    ["raise dead"]         = { danger="interrupt", tip="INTERRUPT — summons undead pet!", pvp="Stop the minion summon — it becomes a damage & distraction tool." },
    ["soul sear"]          = { danger="interrupt", tip="INTERRUPT — high Shadow nuke!", pvp="Interrupt immediately. Caster has no backup without this." },
    ["inquisitor's brand"] = { danger="interrupt", tip="INTERRUPT — AoE brand targeting you!", pvp="Interrupt or use a CC. Getting branded is a death sentence." },
    ["resurrection channel"]={ danger="interrupt", tip="INTERRUPT — REVIVING ENEMY!", pvp="ALL interrupts on this. A fully revived player resets the fight." },
    ["frost nova"]         = { danger="dodge",    tip="MOVE AWAY — incoming freeze!", pvp="Pre-move sideways. If frozen, use every movement ability to break.",
        classes={ felsworn="Fel Hoof Charge breaks freeze.", runemaster="Arcane Binding pre-empts the cast.", reaper="Void Step out of the freeze radius." } },
    ["rallying cry"]       = { danger="interrupt", tip="INTERRUPT — buffs all nearby enemies!", pvp="Interrupt or every mob in range becomes a major threat." },
    ["commanding shout"]   = { danger="interrupt", tip="INTERRUPT — enemy-wide attack buff!", pvp="Silence or interrupt the buff source immediately." },
    ["war stomp"]          = { danger="dodge",    tip="MOVE OUT — AoE stun incoming!", pvp="Get out of range (8 yards). War Stomp breaks your rotation." },

    -- ═══════════════════════════════════════════════════
    -- DODGE / SIDESTEP
    -- ═══════════════════════════════════════════════════
    ["breath"]             = { danger="dodge",    tip="DODGE — frontal cone breath attack!" },
    ["flame breath"]       = { danger="dodge",    tip="MOVE SIDE — frontal fire cone!", pvp="Step to his flank — cone damage will kill you in 1-2 ticks." },
    ["magma breath"]       = { danger="dodge",    tip="SIDESTEP — frontal magma wave!", pvp="Never face a Guardian in PvP — flank and attack the back." },
    ["judgment bolt"]      = { danger="dodge",    tip="SIDESTEP — frontal cone!", pvp="Step 90° to his side. Cone is instant on cast completion." },
    ["void rift"]          = { danger="dodge",    tip="MOVE OUT of purple void zone NOW!", pvp="Void zones are positional pressure — use them to force movement." },
    ["ground slam"]        = { danger="dodge",    tip="MOVE AWAY — massive AoE knockback!", pvp="Knock into walls = stunned. Back against something solid." },
    ["entropic surge"]     = { danger="dodge",    tip="MOVE from party — targeted AoE!", pvp="Break away from allies. Surge chains to anyone within 5 yards." },
    ["shadow nova"]        = { danger="dodge",    tip="SPREAD OUT — AoE Shadow burst!", pvp="Shadow Nova has a 12-yard radius. Everyone spread NOW." },
    ["thorn wall"]         = { danger="dodge",    tip="DO NOT walk into Thorn Wall!", pvp="Thorn Wall blocks paths — fight around it." },
    ["bone shatter"]       = { danger="dodge",    tip="MOVE AWAY if melee — PBAoE!", pvp="Step back out of melee range for 2 seconds." },
    ["rift lunge"]         = { danger="dodge",    tip="SIDESTEP — charge coming!", pvp="Sidestep right — lunge deals double if it connects head-on." },

    -- ═══════════════════════════════════════════════════
    -- DISPEL / CLEANSE
    -- ═══════════════════════════════════════════════════
    ["corruption"]         = { danger="dispel",   tip="DISPEL — stacking disease!", pvp="Corruption stacks = death spiral. Dispel immediately.",
        classes={ spiritwalker="Spirit Ward + Purge cleanses Corruption instantly.", witch_hunter="Purge ability removes Corruption in one GCD." } },
    ["smolder"]            = { danger="dispel",   tip="DISPEL — fire DoT ticking!", pvp="Smolder is a mana-efficiency drain. Cleanse before it stacks." },
    ["venom spit"]         = { danger="dispel",   tip="DISPEL — poison DoT!", pvp="Anti-venom or dispel. Poison DoTs are disproportionately powerful vs low-armor." },
    ["rend"]               = { danger="dispel",   tip="DISPEL — bleed DoT!", pvp="Bleeds ignore armor. Dispel or heal through.",
        classes={ reaper="Siphon Strike healing offsets bleed damage.", spiritwalker="Ancestral Guidance crit-heals counter bleeds." } },
    ["shadow word: pain"]  = { danger="dispel",   tip="DISPEL — powerful DoT!", pvp="Shadow Word: Pain is the opener for most Shadow burst combos. Remove it." },
    ["siphon strike"]      = { danger="dispel",   tip="DISPEL — enemy lifesteal debuff!", pvp="Remove it — every hit they land heals them through your burst." },
    ["curse of weakness"]  = { danger="dispel",   tip="DISPEL — attack power curse!", pvp="Curses require specific dispel (Mages/Druids). Check your toolkit." },
    ["hex"]                = { danger="dispel",   tip="DISPEL ally — polymorph on teammate!", pvp="Free the polymorphed player IMMEDIATELY. They're a free kill otherwise." },
    ["corrupted touch"]    = { danger="dispel",   tip="DISPEL — random disease spreading!", pvp="If multiple players are diseased, prioritise healers first." },

    -- ═══════════════════════════════════════════════════
    -- SURVIVE / POP DEFENSIVE
    -- ═══════════════════════════════════════════════════
    ["enrage"]             = { danger="survive",  tip="POP DEFENSIVE — enemy enraging!", pvp="Enrage = burst window. Shield up, kite, or use CC immediately.",
        classes={ felsworn="Idan's Guard during enrage.", reaper="Defiance: Parry of Souls negates the first heavy hit.", spiritwalker="Drop Earthbind and kite the enrage out." } },
    ["frenzy"]             = { danger="survive",  tip="POP DEFENSIVE — frenzied state!", pvp="Frenzy triples attack speed. Every defensive cooldown NOW." },
    ["berserker rage"]     = { danger="survive",  tip="POP DEFENSIVE — berserking!", pvp="They're immune to fear/CC during berserk. Kite or hard-defend." },
    ["desperate stand"]    = { danger="survive",  tip="POP DEFENSIVE — 50% damage buff!", pvp="Burn all defensives. This is the kill window for the enemy." },
    ["void empowerment"]   = { danger="survive",  tip="POP DEFENSIVE — empowered damage!", pvp="Maximum defensives + healing CDs. This is a wipe mechanic." },
    ["vault crush"]        = { danger="survive",  tip="POP DEFENSIVE — heavy melee hit!", pvp="Time your defensive CD to the swing — it's predictable." },
    ["march order"]        = { danger="survive",  tip="POP DEFENSIVE — all enemies buffed!", pvp="Every enemy in range now deals more damage. Defensive priority." },
    ["inquisitor's fury"]  = { danger="survive",  tip="POP DEFENSIVE — 30% damage increase!", pvp="Interrupt if possible. Otherwise maximum defensives.",
        classes={ witch_hunter="Purge Inquisitor's Fury — fastest removal.", reaper="Shadow Phase delays damage during Fury uptime." } },

    -- ═══════════════════════════════════════════════════
    -- CC / CONTROL — REACT FAST
    -- ═══════════════════════════════════════════════════
    ["fear"]               = { danger="survive",  tip="TRINKET or MOVE — fear incoming!", pvp="Fear is a PvP death sentence. Trinket it, or have a pre-macro ready.",
        classes={ felsworn="Infernal Fortitude prevents fear.", necromancer="Undead racial or Death Coil can fear back.", runemaster="Arcane Binding pre-empts the Fear cast." } },
    ["chains of faith"]    = { danger="dodge",    tip="KEEP MOVING — root incoming!", pvp="Root + follow-up burst is the Inquisitor kill combo. Pre-move." },
    ["binding chains"]     = { danger="dodge",    tip="BREAK IT — movement slow!", pvp="Chains reduce your kite ability. Break with blink/charge/sprint.",
        classes={ felsworn="Fel Hoof Charge breaks movement impairment.", reaper="Void Step instantly breaks snares." } },
    ["phase shift"]        = { danger="watch",    tip="WAIT — enemy going invisible!", pvp="Don't move. They will reappear near their last position." },
    ["blink"]              = { danger="watch",    tip="GAP CLOSE — enemy teleporting!", pvp="Use your gap-close immediately after Blink lands.",
        classes={ felsworn="Fel Hoof Charge to re-close instantly.", witch_hunter="Shadow Trap at their predicted destination." } },
    ["cheap shot"]         = { danger="survive",  tip="STUN — PvP opener!", pvp="If stunned: trinket if low HP, otherwise wait for combo finisher." },
    ["ambush"]             = { danger="survive",  tip="HIGH BURST — stealth ambush!", pvp="Always have a pet/minion in front to break stealth before Ambush.",
        classes={ necromancer="Minion detects stealth approach.", witch_hunter="Mark before combat — detects stealthed enemies." } },
    ["gouge"]              = { danger="survive",  tip="FACE THEM — stun imminent!", pvp="Always face Rogues. Gouge requires you to face them." },
    ["backstab"]           = { danger="survive",  tip="FACE THEM — high back damage!", pvp="Rotate to face Rogues every GCD. Backstab from behind is 300% damage." },
    ["eviscerate"]         = { danger="survive",  tip="POP DEFENSIVE — finisher incoming!", pvp="Eviscerate at 5 combo points = your HP bar in one hit at late game." },
    ["blade flurry"]       = { danger="survive",  tip="POP DEFENSIVE — rapid multi-hit!", pvp="Blade Flurry shreds through defensives — pop your best CD now." },
    ["sprint"]             = { danger="watch",    tip="SNARE — enemy fleeing or closing gap!", pvp="Root or snare immediately. Don't let them disengage safely." },
    ["war cry"]            = { danger="survive",  tip="POP DEFENSIVE — AoE attack buff!", pvp="War Cry affects every enemy nearby. Massive damage spike incoming." },
    ["avenging wrath"]     = { danger="survive",  tip="POP DEFENSIVE — Paladin wings!", pvp="Avenging Wrath triples their damage. Maximum defensives immediately." },

    -- ═══════════════════════════════════════════════════
    -- WATCH / INFORMATIONAL
    -- ═══════════════════════════════════════════════════
    ["reconstruct"]        = { danger="interrupt", tip="INTERRUPT — healing to full!", pvp="Interrupt Reconstruct or the fight resets completely." },
    ["void shield"]        = { danger="watch",    tip="BURST through Void Shield!", pvp="Void Shield absorbs X damage. Cooldowns + burn now." },
    ["drain soul"]         = { danger="interrupt", tip="INTERRUPT — soul drain channel!", pvp="Drain Soul channels amp in damage each tick. Interrupt early." },
    ["shadow bolt volley"] = { danger="dodge",    tip="SPREAD OUT — AoE shadow volley!", pvp="Spread 8+ yards. Volley chains AoE between clustered targets." },
    ["molten armor"]       = { danger="watch",    tip="STOP DPS — reflect active!", pvp="Molten Armor reflects 10% damage. Stop auto-attacks." },
    ["overclock"]          = { danger="survive",  tip="POP DEFENSIVE — enemy burst proc!", pvp="Overclock = burst window. Pop defensive cooldowns." },
    ["nature's wrath"]     = { danger="survive",  tip="POP DEFENSIVE — AoE raid damage!", pvp="Nature's Wrath is a wipe if not healed. Max defensive." },
    ["ancestral guidance"]= { danger="interrupt", tip="INTERRUPT or kite — enemy self-healing!", pvp="Ancestral Guidance turns crits into heals. Stop your DPS or interrupt." },
    ["time rupture"]       = { danger="dodge",    tip="MOVE — time zone forming!", pvp="Time Rupture creates a persistent damage zone. Don't stand in it." },
    ["paradox explosion"]  = { danger="dodge",    tip="SPREAD — Chronomancer AoE!", pvp="Paradox Explosion radius is large. Spread or take 80% HP." },
}

-- ─────────────────────────────────────────────────────────────
-- Danger level → visual settings
-- ─────────────────────────────────────────────────────────────
local DANGER_STYLE = {
    interrupt = { r=1.0, g=0.1, b=0.1, label="|cffFF2222⚡ INTERRUPT|r" },
    dodge     = { r=1.0, g=0.55, b=0.0, label="|cffFF8C00⚡ DODGE|r" },
    dispel    = { r=0.6, g=0.2, b=1.0, label="|cffAA44FF⚡ DISPEL|r" },
    survive   = { r=1.0, g=0.8, b=0.0, label="|cffFFCC00⚡ DEFENSIVE|r" },
    watch     = { r=0.4, g=0.8, b=1.0, label="|cff66CCFF⚠ WATCH|r" },
}

-- ─────────────────────────────────────────────────────────────
-- Loot + Quest lookup tables (populated on Build)
-- ─────────────────────────────────────────────────────────────
local LOOT_DB   = {}
local QUEST_MOBS = {}

local function BuildLookups()
    local raw = {
        [69]  = { name="Timber Wolf",             drops={ {"Ruined Pelt",40}, {"Linen Cloth",15} } },
        [113] = { name="Stonetusk Boar",           drops={ {"Chunk of Boar Meat",45}, {"Ruined Pelt",20} } },
        [114] = { name="Defias Thug",              drops={ {"Linen Cloth",35}, {"Minor Healing Potion",10} } },
        [62]  = { name="Young Forest Bear",        drops={ {"Bear Meat",30}, {"Ruined Leather Scraps",25} } },
        [36]  = { name="Kobold Vermin",            drops={ {"Kobold Candle",60}, {"Linen Cloth",20} } },
        [37]  = { name="Kobold Worker",            drops={ {"Linen Cloth",25}, {"Copper Ore",10} } },
        [432] = { name="Harvest Golem",            drops={ {"Mechanical Parts",50}, {"Linen Cloth",20} } },
        [434] = { name="Defias Pillager",          drops={ {"Linen Cloth",40}, {"Minor Healing Potion",8} } },
        [1487]= { name="Defias Looter",            drops={ {"Linen Cloth",35}, {"Minor Mana Potion",6} } },
        [1726]= { name="Worgen Rager",             drops={ {"Worgen Claw",30}, {"Linen Cloth",15} } },
        [1792]= { name="Blackrock Orc",            drops={ {"Wool Cloth",30}, {"Blackrock Badge",12} } },
        [666] = { name="Young Stranglethorn Tiger",drops={ {"Tiger Pelt",40}, {"Tiger Meat",25} } },
        [653] = { name="Bloodscalp Troll",         drops={ {"Bloodscalp Tusk",18}, {"Wool Cloth",30} } },
        [3256]= { name="Razormane Quilboar",       drops={ {"Linen Cloth",20}, {"Quillboar Tusk",12} } },
        [3254]= { name="Plainstrider",             drops={ {"Plainstrider Leg",50}, {"Plainstrider Feather",35} } },
        [6564]= { name="Wastewander Bandit",       drops={ {"Silk Cloth",30}, {"Wastewander Note",8} } },
        [8532]= { name="Plague Spreader",          drops={ {"Mageweave Cloth",35}, {"Embalming Ichor",15} } },
        [3110]= { name="Felstalker",               drops={ {"Glowing Scorpid Blood",20}, {"Fel Crystal Shard",8} } },
        [1]   = { name="Test Mob",                 drops={ {"Thunderfury",100} } },
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
                        for mob in step.text:gmatch("Kill%s+([A-Za-z][A-Za-z%s']+)%s+[%(%-%—]") do
                            QUEST_MOBS[mob:lower():gsub("%s+$","")] = true
                        end
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
-- HP colour
-- ─────────────────────────────────────────────────────────────
local function HpColor(p)
    if p > 0.6 then return 0.15,0.85,0.35
    elseif p > 0.3 then return 1.0,0.65,0.05
    else return 0.95,0.15,0.15 end
end

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

local function GetNPName(f)
    for _, r in ipairs({ f:GetRegions() }) do
        if r:GetObjectType() == "FontString" then
            local t = r:GetText()
            if t and t ~= "" then return t end
        end
    end
end

-- ─────────────────────────────────────────────────────────────
-- Get active class from Engine
-- ─────────────────────────────────────────────────────────────
local function GetActiveClass()
    if CoAAT_Engine and CoAAT_Engine._state then
        return CoAAT_Engine._state.classId, CoAAT_Engine._state.specId
    end
    return nil, nil
end

-- ─────────────────────────────────────────────────────────────
-- Build overlay — pure textures + FontStrings, ZERO frames
-- ─────────────────────────────────────────────────────────────
local function BuildOverlay(np)
    local hp = GetNPHealthBar(np)
    if not hp then return nil end

    local ov = { hpBar=hp, np=np, pulse=0, castPhase=0 }

    -- 1. Accent line above HP bar
    local accent = np:CreateTexture(nil, "OVERLAY", nil, 7)
    accent:SetHeight(2)
    accent:SetPoint("BOTTOMLEFT",  hp, "TOPLEFT",  0, 1)
    accent:SetPoint("BOTTOMRIGHT", hp, "TOPRIGHT", 0, 1)
    accent:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    accent:SetVertexColor(0.2, 0.85, 1.0, 0.9)
    ov.accent = accent

    -- 2. HP% text
    local hpTxt = np:CreateFontString(nil, "OVERLAY")
    hpTxt:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE")
    hpTxt:SetPoint("RIGHT", hp, "RIGHT", -2, 0)
    hpTxt:SetTextColor(1, 1, 1, 0.92)
    ov.hpTxt = hpTxt

    -- 3. Quest indicator ❕
    local quest = np:CreateFontString(nil, "OVERLAY")
    quest:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    quest:SetPoint("RIGHT", hp, "LEFT", -16, 0)
    quest:SetText("")
    ov.questMark = quest

    -- 4. Target ring (texture)
    local ring = np:CreateTexture(nil, "OVERLAY", nil, 6)
    ring:SetSize(72, 22)
    ring:SetPoint("CENTER", hp, "CENTER", 0, 0)
    ring:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    ring:SetAlpha(0)
    ov.ring = ring

    -- 5. Skull (texture)
    local skull = np:CreateTexture(nil, "OVERLAY", nil, 7)
    skull:SetSize(10, 10)
    skull:SetPoint("RIGHT", hp, "LEFT", -4, 0)
    skull:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Skull")
    skull:SetAlpha(0)
    ov.skull = skull

    -- 6. CAST BAR — background fill + foreground fill (textures only)
    local castBG = np:CreateTexture(nil, "OVERLAY", nil, 5)
    castBG:SetHeight(5)
    castBG:SetPoint("TOPLEFT",  hp, "BOTTOMLEFT",  0, -3)
    castBG:SetPoint("TOPRIGHT", hp, "BOTTOMRIGHT", 0, -3)
    castBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    castBG:SetVertexColor(0.05, 0.05, 0.1, 0.7)
    castBG:SetAlpha(0)
    ov.castBG = castBG

    local castFill = np:CreateTexture(nil, "OVERLAY", nil, 6)
    castFill:SetHeight(5)
    castFill:SetPoint("TOPLEFT", hp, "BOTTOMLEFT", 0, -3)
    castFill:SetWidth(1)
    castFill:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    castFill:SetVertexColor(1.0, 0.2, 0.2, 0.95)
    castFill:SetAlpha(0)
    ov.castFill = castFill

    -- 7. Cast spell name text
    local castName = np:CreateFontString(nil, "OVERLAY")
    castName:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE")
    castName:SetPoint("LEFT", hp, "BOTTOMLEFT", 0, -3)
    castName:SetTextColor(1, 1, 1, 1)
    castName:SetText("")
    ov.castName = castName

    -- 8. Danger label  ⚡ INTERRUPT / ⚡ DODGE etc.
    local dangerTxt = np:CreateFontString(nil, "OVERLAY")
    dangerTxt:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
    dangerTxt:SetPoint("BOTTOM", hp, "TOP", 0, 18)
    dangerTxt:SetText("")
    ov.dangerTxt = dangerTxt

    -- 9. Counter tip text (2 lines below HP bar)
    local counterTxt = np:CreateFontString(nil, "OVERLAY")
    counterTxt:SetFont("Fonts\\FRIZQT__.TTF", 6, "OUTLINE")
    counterTxt:SetPoint("TOPLEFT", hp, "BOTTOMLEFT", 0, -11)
    counterTxt:SetWidth(120)
    counterTxt:SetJustifyH("LEFT")
    counterTxt:SetTextColor(0.85, 0.85, 0.85, 1)
    counterTxt:SetText("")
    ov.counterTxt = counterTxt

    -- 10. Loot line
    local lootTxt = np:CreateFontString(nil, "OVERLAY")
    lootTxt:SetFont("Fonts\\FRIZQT__.TTF", 6, "OUTLINE")
    lootTxt:SetPoint("TOPLEFT", hp, "BOTTOMLEFT", 0, -20)
    lootTxt:SetWidth(130)
    lootTxt:SetJustifyH("LEFT")
    lootTxt:SetTextColor(0.9, 0.8, 0.5, 0.9)
    lootTxt:SetText("")
    ov.lootTxt = lootTxt

    -- 11. Debuff icons (textures, 5 slots)
    local debuffs = {}
    for i = 1, 5 do
        local icon = np:CreateTexture(nil, "OVERLAY", nil, 7)
        icon:SetSize(12, 12)
        if i == 1 then
            icon:SetPoint("BOTTOMLEFT", hp, "TOPLEFT", 0, 6)
        else
            icon:SetPoint("LEFT", debuffs[i-1].icon, "RIGHT", 2, 0)
        end
        icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        icon:SetAlpha(0)
        local cnt = np:CreateFontString(nil, "OVERLAY")
        cnt:SetFont("Fonts\\FRIZQT__.TTF", 6, "OUTLINE")
        cnt:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -1)
        cnt:SetText("")
        debuffs[i] = { icon=icon, cnt=cnt }
    end
    ov.debuffs = debuffs

    return ov
end

-- ─────────────────────────────────────────────────────────────
-- Get cast info for target or nearby unit token
-- Returns: spellName, startTime, endTime, isChannel, castPct (0-1)
-- ─────────────────────────────────────────────────────────────
local function GetCastData(unitToken)
    local now = GetTime()
    -- Try normal cast first
    local name, _, _, startMS, endMS, _, notInterruptible = UnitCastingInfo(unitToken)
    if name then
        local start = startMS / 1000
        local finish = endMS / 1000
        local pct = math.max(0, math.min(1, (now - start) / (finish - start)))
        return name, pct, false, not notInterruptible
    end
    -- Try channel
    local cname, _, _, cstartMS, cendMS = UnitChannelInfo(unitToken)
    if cname then
        local start = cstartMS / 1000
        local finish = cendMS / 1000
        local pct = math.max(0, math.min(1, 1 - (now - start) / (finish - start)))
        return cname, pct, true, true  -- channels are usually interruptible
    end
    return nil
end

-- ─────────────────────────────────────────────────────────────
-- Refresh one overlay
-- ─────────────────────────────────────────────────────────────
local function RefreshOverlay(ov, isTarget, dt, unitToken)
    local hp = ov.hpBar
    local now = GetTime()

    -- HP%
    local cur, mn, mx = hp:GetValue(), hp:GetMinMaxValues()
    local range = (mx or 1) - (mn or 0)
    local pct = (range > 0) and ((cur - mn) / range) or 1.0
    pct = math.max(0, math.min(1, pct))
    if ov.hpTxt then ov.hpTxt:SetText(string.format("%d%%", math.ceil(pct * 100))) end

    -- Accent colour
    if ov.accent then
        local r,g,b = HpColor(pct)
        ov.accent:SetVertexColor(r, g, b, 0.85)
    end

    -- Target ring pulse
    if ov.ring then
        if isTarget then
            ov.pulse = (ov.pulse or 0) + (dt or 0) * 3.2
            ov.ring:SetAlpha(0.5 + 0.42 * math.sin(ov.pulse))
            ov.ring:SetVertexColor(1.0, 0.85, 0.1, 1.0)
        else
            ov.ring:SetAlpha(0)
            ov.pulse = 0
        end
    end

    -- Skull
    if ov.skull then ov.skull:SetAlpha(isTarget and 0.85 or 0) end

    -- Quest mark
    local npName = GetNPName(ov.np)
    if ov.questMark then
        ov.questMark:SetText((npName and QUEST_MOBS[npName:lower()]) and "|cffFFD700❕|r" or "")
    end

    -- Loot
    if ov.lootTxt then
        local data = npName and LOOT_DB[npName:lower()]
        if data and data.drops and #data.drops > 0 then
            local parts = {}
            for i = 1, math.min(2, #data.drops) do
                local d = data.drops[i]
                table.insert(parts, string.format("|cffbbaa66%s|r |cff888888%d%%|r", d[1], d[2]))
            end
            ov.lootTxt:SetText(table.concat(parts, "  "))
        else
            ov.lootTxt:SetText("")
        end
    end

    -- ── CAST BAR + COUNTER ────────────────────────────────────
    local token = unitToken or (isTarget and "target" or nil)
    local castSpell, castPct, isChannel, canInterrupt = nil, 0, false, false
    if token then
        castSpell, castPct, isChannel, canInterrupt = GetCastData(token)
    end

    if castSpell and castPct then
        -- Show cast bar
        local barW = hp:GetWidth()
        if barW == 0 then barW = 80 end
        local fillW = math.max(1, barW * castPct)

        if ov.castBG  then ov.castBG:SetAlpha(1) end
        if ov.castFill then
            ov.castFill:SetWidth(fillW)
            ov.castFill:SetAlpha(1)
        end
        if ov.castName then ov.castName:SetText("|cffFFFFFF" .. castSpell .. "|r") end

        -- Look up counter data
        local cdata = CAST_DB[castSpell:lower()]
        local classId = GetActiveClass()
        local style = cdata and DANGER_STYLE[cdata.danger] or DANGER_STYLE["watch"]

        -- Cast fill colour = danger level
        if ov.castFill and cdata then
            ov.castFill:SetVertexColor(style.r, style.g, style.b, 0.95)
        end

        -- Pulse danger text
        if ov.dangerTxt and cdata then
            ov.castPhase = (ov.castPhase or 0) + (dt or 0) * 6
            local flash = 0.7 + 0.3 * math.abs(math.sin(ov.castPhase))
            ov.dangerTxt:SetAlpha(flash)
            ov.dangerTxt:SetText(style.label)
        elseif ov.dangerTxt then
            ov.dangerTxt:SetText("")
        end

        -- Counter tip: class-specific > pvp > general tip
        if ov.counterTxt and cdata then
            local tip = ""
            if classId and cdata.classes and cdata.classes[classId] then
                tip = "|cff00ccff" .. cdata.classes[classId] .. "|r"
            elseif cdata.pvp and UnitIsPlayer("target") then
                tip = "|cffFF8C00" .. cdata.pvp .. "|r"
            elseif cdata.tip then
                tip = "|cffdddddd" .. cdata.tip .. "|r"
            end
            ov.counterTxt:SetText(tip)
        elseif ov.counterTxt then
            ov.counterTxt:SetText("")
        end
    else
        -- No cast — hide cast elements
        if ov.castBG   then ov.castBG:SetAlpha(0) end
        if ov.castFill then ov.castFill:SetAlpha(0) end
        if ov.castName then ov.castName:SetText("") end
        if ov.dangerTxt then
            ov.dangerTxt:SetText("")
            ov.castPhase = 0
        end
        if ov.counterTxt then ov.counterTxt:SetText("") end
    end

    -- ── DEBUFFS ──────────────────────────────────────────────
    if ov.debuffs then
        if isTarget then
            local shown = 0
            for i = 1, 5 do
                local s = ov.debuffs[i]
                local dname, _, icon, count, _, _, _, caster = UnitDebuff("target", i)
                if dname and icon and (caster == "player" or caster == nil) then
                    s.icon:SetTexture(icon)
                    s.icon:SetAlpha(0.95)
                    s.cnt:SetText((count and count > 1) and tostring(count) or "")
                    shown = shown + 1
                else
                    s.icon:SetAlpha(0)
                    s.cnt:SetText("")
                end
            end
        else
            for i = 1, 5 do
                ov.debuffs[i].icon:SetAlpha(0)
                ov.debuffs[i].cnt:SetText("")
            end
        end
    end
end

-- ─────────────────────────────────────────────────────────────
-- Hide/show helpers
-- ─────────────────────────────────────────────────────────────
local function HideOverlay(ov)
    if ov.accent    then ov.accent:Hide() end
    if ov.hpTxt     then ov.hpTxt:SetText("") end
    if ov.ring      then ov.ring:SetAlpha(0) end
    if ov.skull     then ov.skull:SetAlpha(0) end
    if ov.questMark then ov.questMark:SetText("") end
    if ov.castBG    then ov.castBG:SetAlpha(0) end
    if ov.castFill  then ov.castFill:SetAlpha(0) end
    if ov.castName  then ov.castName:SetText("") end
    if ov.dangerTxt then ov.dangerTxt:SetText("") end
    if ov.counterTxt then ov.counterTxt:SetText("") end
    if ov.lootTxt   then ov.lootTxt:SetText("") end
    if ov.debuffs then
        for i=1,5 do ov.debuffs[i].icon:SetAlpha(0) ov.debuffs[i].cnt:SetText("") end
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
        for _, ov in pairs(_injected) do HideOverlay(ov) end
        return
    end

    local targetName = UnitExists("target") and UnitName("target") or nil
    local kids = { WorldFrame:GetChildren() }
    local seen = {}

    for _, frame in ipairs(kids) do
        if frame:IsShown() and not frame:GetName() then
            if IsNameplate(frame) then
                seen[frame] = true
                if not _injected[frame] then
                    local ov = BuildOverlay(frame)
                    if ov then _injected[frame] = ov end
                end
                local ov = _injected[frame]
                if ov then
                    ShowOverlay(ov)
                    local npName  = GetNPName(frame)
                    local isTgt   = (targetName and npName == targetName) and true or false
                    local token   = isTgt and "target" or nil
                    RefreshOverlay(ov, isTgt, dt, token)
                end
            end
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

    _controller = CreateFrame("Frame", "CoAATNameplateHUD", UIParent)
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

    _controller:RegisterEvent("PLAYER_TARGET_CHANGED")
    _controller:RegisterEvent("UNIT_SPELLCAST_START")
    _controller:RegisterEvent("UNIT_SPELLCAST_STOP")
    _controller:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
    _controller:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
    _controller:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")

    _controller:SetScript("OnEvent", function(self, event, unit)
        if event == "PLAYER_TARGET_CHANGED" or
           (unit == "target" and (
               event == "UNIT_SPELLCAST_START" or
               event == "UNIT_SPELLCAST_STOP" or
               event == "UNIT_SPELLCAST_INTERRUPTED" or
               event == "UNIT_SPELLCAST_CHANNEL_START" or
               event == "UNIT_SPELLCAST_CHANNEL_STOP"
           )) then
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
    for _, ov in pairs(_injected) do HideOverlay(ov) end
end

function CoAAT_NameplateHUD.Toggle()
    local on = not (CoAAT_DB and CoAAT_DB.nameplateHUD == false)
    if on then CoAAT_NameplateHUD.Disable() else CoAAT_NameplateHUD.Enable() end
end
