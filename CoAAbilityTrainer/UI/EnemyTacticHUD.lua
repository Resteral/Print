-- ============================================================
-- CoAAbilityTrainer - Enemy Tactic HUD
-- Appears on the RIGHT side of the screen during combat.
-- Shows real-time intel on the current target:
--   • Enemy attack patterns / abilities to watch for
--   • Phase warnings (HP thresholds)
--   • Counter-strategy tailored to your class
--   • Live combat tips that update as the fight changes
-- ============================================================

CoAAT_EnemyTacticHUD = {}

local _frame      = nil
local UPDATE_FREQ = 0.3
local _elapsed    = 0
local _inCombat   = false
local _lastMob    = nil

-- ─────────────────────────────────────────────────────────────
-- ENEMY DATABASE
-- Key: mob name (lowercase)
-- Fields:
--   type        = "caster" | "melee" | "elite" | "boss"
--   attacks     = list of ability names to warn about
--   phases      = { { hp=50, warning="text" }, ... }  (% thresholds)
--   counters    = { classId = "tip text", ... }
--   generalTip  = fallback tip for any class
-- ─────────────────────────────────────────────────────────────
local ENEMY_DATA = {

    -- ── Vault of the Inquisition ──────────────────────────
    ["inquisitor valdris"] = {
        type    = "boss",
        attacks = {
            "|cffFF4444Inquisitor's Brand|r — targets random player, interrupt!",
            "|cffFF8C00Chains of Faith|r — roots you in place, keep moving!",
            "|cffAA00FFJudgment Bolt|r — frontal cone, step to his side!",
        },
        phases  = {
            { hp=75, warning="|cffFF8C00Phase 2:|r Valdris gains Inquisitor's Fury — damage increases 30%!" },
            { hp=40, warning="|cffFF0000Phase 3:|r Chains of Faith now AoE — spread out immediately!" },
        },
        counters = {
            felsworn    = "Interrupt Inquisitor's Brand with your gap-close. Use Idan's Guard during Chains of Faith.",
            necromancer = "Keep Army of the Dead up for Phase 3. Interrupt Brand with Death Coil.",
            witch_hunter= "Mark him first. Stay max range to dodge the cone. Use Purge to strip Inquisitor's Fury.",
            tinker      = "Place turret at max range, drop mines along his patrol path. Use Rocket Barrage in Phase 3.",
            runemaster  = "Use Arcane Binding to interrupt Brand. Detonate charges during Chains of Faith downtime.",
            chronomancer= "Save Rewind for Phase 3 AoE. Use Time Rupture to pressure during Chains.",
            spiritwalker= "Drop Earthbind Totem in Phase 3 to slow Valdris. Heal through Brand damage with Ancestral Guidance.",
            reaper      = "Shadow Phase through Brand cast. Use Soul Infusion in Phase 2 for max burst window.",
        },
        generalTip = "Always interrupt Inquisitor's Brand. Step to the side during Judgment Bolt cone.",
    },

    ["warden of the vault"] = {
        type    = "elite",
        attacks = {
            "|cffFF4444Vault Crush|r — heavy melee, pop defensive CD!",
            "|cffFF8C00Binding Chains|r — slows movement, break it fast!",
        },
        phases  = {
            { hp=50, warning="|cffFF8C00Enrage at 50%:|r Vault Crush hits harder — use defensives now!" },
        },
        counters = {
            felsworn    = "Pop Vengeance before Vault Crush hits. Parry the chain then counter-strike.",
            reaper      = "Keep Siphon Strike up — the healing will offset Vault Crush damage.",
            witch_hunter= "Kite! Stay at range and use Cursed Shot to pressure during Binding Chains.",
            tinker      = "Turret + mines setup before engaging. Rocket Barrage the enrage phase.",
        },
        generalTip = "Save your defensive cooldown for the 50% enrage. Don't let Binding Chains stack.",
    },

    ["soul-bound acolyte"] = {
        type    = "caster",
        attacks = {
            "|cffFF4444Soul Sear|r — cast spell, INTERRUPT this!",
            "|cffAA00FFVoid Shield|r — shields himself, burst it down fast!",
        },
        phases  = {},
        counters = {
            runemaster  = "Arcane Binding on Soul Sear cast. Elemental Brand up, burst Void Shield with Runic Detonation.",
            felsworn    = "Interrupt Soul Sear with Fel Hoof Charge dash. Spam Engulf during Void Shield.",
            necromancer = "Army of the Dead absorbs Void Shield hits. Keep Plague Strike on for damage amp.",
            spiritwalker= "Interrupt Soul Sear with Chain Storm stun component. Earthbind on the group.",
        },
        generalTip = "ALWAYS interrupt Soul Sear — it hurts. Burst through Void Shield with your hardest-hitting ability.",
    },

    -- ── Road to the Other Side ────────────────────────────
    ["deathmarch sergeant"] = {
        type    = "elite",
        attacks = {
            "|cffFF4444March Order|r — buffs nearby allies, kill sergeant FIRST!",
            "|cffFF8C00Rallying Cry|r — calls reinforcements, interrupt or reposition!",
        },
        phases  = {
            { hp=30, warning="|cffFF0000Desperate Stand at 30%:|r Sergeant gains 50% damage — burn him down fast!" },
        },
        counters = {
            felsworn    = "Slayer: Slayer Cleave to AoE down his allies. Keep him interrupted with Fel Hoof Charge.",
            witch_hunter= "Mark the sergeant immediately. Shadow Tonic + Cursed Shot to kill him before he rallies.",
            tinker      = "Mines on the rally point. Turret on the sergeant, Rocket Barrage to clear ads.",
            chronomancer= "Paradox Explosion in the sergeant + ally cluster for max AoE value.",
            reaper      = "Soul spec: Echo of Death will chain-proc killing his allies. Prioritize sergeant first.",
        },
        generalTip = "Kill the Sergeant FIRST — his March Order makes all nearby enemies hit harder. Interrupt Rallying Cry!",
    },

    ["void herald"] = {
        type    = "boss",
        attacks = {
            "|cffAA00FFVoid Rift|r — spawns void zones, stand OUT of purple circles!",
            "|cffFF4444Herald's Scream|r — silence debuff, pop trinket or wait it out!",
            "|cffFF8C00Entropic Surge|r — targeted AoE on a random player, move away from party!",
        },
        phases  = {
            { hp=60, warning="|cffFF8C00Phase 2:|r Void Rifts spawn twice as fast — watch your footing!" },
            { hp=25, warning="|cffFF0000Phase 3:|r Herald gains Void Empowerment — maximum DPS burst now!" },
        },
        counters = {
            felsworn    = "Infernal: Chaos Incursion on the move to dodge Void Rifts. Save Engulf for Phase 3 burst.",
            necromancer = "Position Army of the Dead between you and Entropic Surge. Use Runic Tap during Herald's Scream.",
            witch_hunter= "Stay mobile. Shadow Tonic during Phase 3. Purge Herald's Scream debuff off allies.",
            runemaster  = "Arcane Binding to stop a Void Rift channel. Detonate during Phase 3 Empowerment.",
            chronomancer= "Save Rewind for Phase 3. Paradox during Phase 2 Void Rift clusters.",
            spiritwalker= "Drop Spirit Ward before Phase 2. Chain Storm to interrupt Rift spawning.",
            reaper      = "Shadow Phase through Herald's Scream. Full burst Soul Infusion during Phase 3.",
            tinker      = "Place turret far from Void Rifts. Use Overclock during Phase 3.",
        },
        generalTip = "NEVER stand in Void Rifts. Move away from party when targeted by Entropic Surge. Interrupt Herald's Scream where possible.",
    },

    ["rift stalker"] = {
        type    = "melee",
        attacks = {
            "|cffFF4444Rift Lunge|r — charges at you, sidestep or stun!",
            "|cffAA00FFPhase Shift|r — goes invisible briefly, stay in place!",
        },
        phases  = {},
        counters = {
            felsworn    = "Tyrant: Vengeance parries Rift Lunge. Slayer: dodge to the side, then Slayer Cleave.",
            reaper      = "Harvest: Siphon Strike + Life Drain combo burst. Soul: Void Step to re-position after Lunge.",
            witch_hunter= "Curse him before Phase Shift — dot damage tracks him while invisible.",
            runemaster  = "Root him with Arcane Binding to stop Rift Lunge. Detonate charges.",
        },
        generalTip = "Sidestep Rift Lunge — it deals double damage if it connects head-on. During Phase Shift, don't move — he'll reappear near you.",
    },

    -- ── Elwynn Forest (1-10) ──────────────────────────────
    ["kobold vermin"] = {
        type="melee", attacks={"|cffFF8C00Scratch|r — basic melee."}, phases={},
        counters={ felsworn="Spam generators freely, save no cooldowns.", necromancer="Minion up, Death Coil if you dip." },
        generalTip="Easy mob. Pull multiple and AoE. Don't waste cooldowns here.",
    },
    ["defias thug"] = {
        type="melee", attacks={"|cffFF8C00Cheap Shot|r — brief stun opener."}, phases={},
        counters={ witch_hunter="Stay at max range to avoid Cheap Shot.", felsworn="Gap close after opener — they're squishy." },
        generalTip="Humanoid, drops Linen Cloth. Pull singles near Moonbrook.",
    },
    ["harvest golem"] = {
        type="melee",
        attacks={"|cffFF8C00Cleave|r — hits 3 in front.", "|cffFF8C00Trample|r — knockback at low HP!"},
        phases={ { hp=20, warning="Trample at 20% — step aside now!" } },
        counters={ tinker="Turret + Landmines. Pull into your setup.", felsworn="Attack from the flank to avoid Cleave." },
        generalTip="Mechanical — immune to poison/bleed. Trample at low HP, stay to the side.",
    },
    -- ── Westfall (10-20) ───────────────────────────────
    ["dust devil"] = {
        type="caster", attacks={"|cffAA00FFGust|r — knock-back, position against a wall."}, phases={},
        counters={ witch_hunter="Stay at range and kite.", runemaster="Root with Arcane Binding." },
        generalTip="Elemental. Knock-back interrupts casts. Position with back to something solid.",
    },
    ["defias pillager"] = {
        type="caster",
        attacks={"|cffFF4444Fireball|r — interrupt this!", "|cffFF8C00Sprint|r — flees at 20% HP!"},
        phases={ { hp=20, warning="Sprint at 20% — stun or root immediately!" } },
        counters={ runemaster="Arcane Binding at 21% stops the flee.", witch_hunter="DoT him — he'll die even while running.", necromancer="Army blocks his escape route." },
        generalTip="Interrupt Fireball. Stun/root at 20% or he'll flee and bring adds.",
    },
    -- ── Redridge Mountains (15-25) ─────────────────────
    ["redridge gnoll"] = {
        type="melee", attacks={"|cffFF8C00Hamstring|r — slows you, kite carefully."}, phases={},
        counters={ spiritwalker="Earthbind Totem negates Hamstring.", tinker="Landmines near patrol route." },
        generalTip="Pull carefully — they travel in packs. Dense area east of Lakeshire.",
    },
    ["blackrock orc"] = {
        type="melee",
        attacks={"|cffFF4444Battle Shout|r — buffs nearby orcs, kill him first!", "|cffFF8C00Shield Bash|r — interrupts casts."},
        phases={},
        counters={ necromancer="Army of the Dead clears the buffed group.", chronomancer="Time Rupture then kite." },
        generalTip="Kill Battle Shout orcs first — the buff stacks across the whole group.",
    },
    -- ── Duskwood (18-30) ────────────────────────────────
    ["worgen stalker"] = {
        type="melee", attacks={"|cffFF4444Rend|r — bleed DoT.", "|cffFF8C00Claw|r — fast attacks."}, phases={},
        counters={ reaper="Siphon Strike healing offsets Rend bleed.", spiritwalker="Ancestral Guidance crits heal the bleed." },
        generalTip="Bleed ignores armor. Watch for high mob density in Duskwood.",
    },
    ["mor'ladim"] = {
        type="elite",
        attacks={"|cffFF0000Cleave|r — massive frontal AoE.", "|cffFF4444Fear|r — routes players, spread out!", "|cffAA00FFShadow Nova|r — AoE burst at 50%."},
        phases={ { hp=50, warning="Shadow Nova at 50% — spread and pop defensives NOW!" } },
        counters={ felsworn="Tyrant: Idan's Guard during Shadow Nova.", reaper="Soul Infusion AoE taunt holds aggro through fear.", necromancer="Fear breaks minion — resummon after." },
        generalTip="Elite undead. Spread group for Fear. Shadow Nova at 50% is the deadly phase.",
    },
    -- ── Stranglethorn Vale (25-40) ─────────────────────
    ["bloodscalp troll"] = {
        type="melee",
        attacks={"|cffFF8C00Enrage|r — damage spikes at low HP.", "|cffFF4444Hex|r — polymorphs a player, dispel!"},
        phases={ { hp=30, warning="Enrage at 30% — pop defensives or burst to finish!" } },
        counters={ witch_hunter="Purge Hex off allies. Shadow Tonic the enrage phase.", tinker="Rocket Barrage to burst through enrage threshold." },
        generalTip="Dispel Hex immediately. Burn through 30% HP as fast as possible.",
    },
    ["skullsplitter mystic"] = {
        type="caster",
        attacks={"|cffAA00FFShadow Word: Pain|r — tough DoT.", "|cffFF4444Hex|r — interrupt or dispel!"},
        phases={},
        counters={ runemaster="Arcane Binding on Hex cast.", chronomancer="Time Rupture + Paradox on the pack." },
        generalTip="Priority target. Silence Hex, dispel Shadow Word Pain ASAP.",
    },
    -- ── Arathi Highlands (25-35) ──────────────────────
    ["syndicate footpad"] = {
        type="melee", attacks={"|cffFF8C00Backstab|r — always face them.", "|cffFF4444Gouge|r — brief stun."}, phases={},
        counters={ felsworn="Never let them behind you. Infernal Alacrity for quick reactions.", witch_hunter="Stay at range — can't Backstab at distance." },
        generalTip="Always face these mobs. Backstab from behind is their only real damage.",
    },
    -- ── Thousand Needles / Tanaris (25-50) ───────────────
    ["galak centaur"] = {
        type="melee", attacks={"|cffFF8C00Stomp|r — AoE knockdown.", "|cffFF4444Stampede|r — charges a random target."}, phases={},
        counters={ tinker="Mines around your position — Stampede triggers them.", spiritwalker="Earthbind Totem stops Stampede charge." },
        generalTip="Stay spread — Stomp AoE chain-knockdowns grouped players.",
    },
    ["southsea pirate"] = {
        type="melee", attacks={"|cffFF8C00Cheap Shot|r — stun opener.", "|cffFF4444Blade Flurry|r — rapid hits, pop defensive CD."}, phases={},
        counters={ felsworn="Tyrant: Vengeance parries Blade Flurry.", reaper="Defiance: Parry of Souls lines up perfectly." },
        generalTip="Blade Flurry is fast — pop a defensive when you see it.",
    },
    ["wastewander rogue"] = {
        type="melee", attacks={"|cffFF4444Ambush|r — high burst from stealth.", "|cffFF8C00Eviscerate|r — combo finisher."}, phases={},
        counters={ witch_hunter="Mark before ambush. Shadow Tonic to burst their combo.", necromancer="Minion breaks stealth approach." },
        generalTip="Keep minion/pet in front to break their Ambush setup.",
    },
    -- ── Feralas / Un'Goro (40-55) ─────────────────────
    ["gordunni ogre"] = {
        type="elite",
        attacks={"|cffFF0000Ground Slam|r — massive AoE, move away!", "|cffFF8C00War Stomp|r — stuns all nearby." },
        phases={ { hp=40, warning="Berserker Rage at 40% — all defensives NOW!" } },
        counters={ tinker="Turret at range + Rocket Barrage during War Stomp.", chronomancer="Rewind for the 40% burst window." },
        generalTip="Stay at range during Ground Slam. War Stomp interrupts casts — anticipate it.",
    },
    ["devilsaur"] = {
        type="elite",
        attacks={"|cffFF0000Terrifying Roar|r — AoE fear!", "|cffFF4444Rend|r — stacking bleed.", "|cffFF0000Frenzy|r — enrages at 20%!"},
        phases={ { hp=20, warning="FRENZY at 20% — maximum defensives and burst NOW!" } },
        counters={ felsworn="Tyrant: Idan's Guard during Frenzy.", reaper="Soul Infusion invulnerability through Frenzy.", tinker="Kite with turret + Rocket Barrage + Landmines." },
        generalTip="ELITE — don't solo unless 3+ levels above. AoE fear + Frenzy at 20% is lethal.",
    },
    -- ── Burning Steppes / Eastern Plaguelands (50-60) ──────
    ["black dragonspawn"] = {
        type="melee", attacks={"|cffFF4444Flame Breath|r — frontal fire cone!", "|cffFF8C00Knockback|r — sends you flying."}, phases={},
        counters={ runemaster="Root with Arcane Binding to stop knockback.", necromancer="Army of the Dead absorbs Flame Breath." },
        generalTip="Stand to the SIDE — Flame Breath frontal is lethal. Knockback throws you into more mobs.",
    },
    ["plagued warrior"] = {
        type="melee", attacks={"|cffAA00FFCorruption|r — stacking disease, dispel ASAP!", "|cffFF4444Rend|r — bleed on top of disease."}, phases={},
        counters={ spiritwalker="Drop Spirit Ward before pulling.", reaper="Siphon Strike offsets the stacking disease damage." },
        generalTip="Dispel Corruption — it stacks. Undead mob: Holy abilities deal extra damage.",
    },
    ["lich apprentice"] = {
        type="caster",
        attacks={"|cffAA00FFFrost Bolt|r — interrupt!", "|cffFF0000Frost Nova|r — roots all nearby!", "|cffAA00FFBlink|r — teleports away from melee."},
        phases={},
        counters={ runemaster="Arcane Binding stops both Frost Bolt and Frost Nova.", felsworn="Fel Hoof Charge to re-close after Blink.", witch_hunter="Stay at max range — Frost Nova only roots melee range." },
        generalTip="Interrupt Frost Bolt every time. Pre-move away before Frost Nova completes.",
    },
    -- ── Dungeon Bosses ──────────────────────────────────
    ["defias overseer"] = {
        type="elite",
        attacks={"|cffFF8C00Commanding Shout|r — buffs all nearby Defias, kill first!", "|cffFF4444Execute|r — finisher below 20%."},
        phases={ { hp=20, warning="Execute range — tank hold aggro, pop defensives!" } },
        counters={ witch_hunter="Purge Commanding Shout. Mark and priority-kill.", tinker="Rocket Barrage to burst through Execute threshold." },
        generalTip="Always kill the Overseer first — Commanding Shout buffs the entire Defias pack.",
    },
    ["zul'farrak high priest"] = {
        type="boss",
        attacks={"|cffAA00FFMind Blast|r — INTERRUPT!", "|cffFF0000Resurrection|r — resurrects dead trolls, interrupt!"},
        phases={ { hp=50, warning="Mass Resurrection at 50% — ALL interrupts on him NOW!" } },
        counters={ runemaster="Arcane Binding on Resurrection — critical interrupt.", felsworn="Gap close and interrupt every Resurrection attempt.", spiritwalker="Chain Storm interrupt on Resurrection." },
        generalTip="CRITICAL: Interrupt Resurrection or all dead trolls come back fully healed. Save interrupt for this only.",
    },
    ["stratholme undead"] = {
        type="melee", attacks={"|cffAA00FFCorrupted Touch|r — random disease.", "|cffFF4444Unholy Ground|r — don't stand in death-zones."}, phases={},
        counters={ necromancer="Home turf — Army of the Dead, Plague Strike, everything.", felsworn="Tyrant Chaos Finisher AoE + self-heal on packs." },
        generalTip="Dense undead packs — AoE is king. Dispel diseases before they stack.",
    },

    -- ── General World Enemies ──────────────────────────────
    ["fel ravager"] = {
        type    = "melee",
        attacks = {
            "|cffFF4444Felbite|r — stacks bleed, dispel or heal through it!",
            "|cffFF8C00Rampage|r — randomly targets a party member, tank re-taunt!",
        },
        phases  = { { hp=30, warning="|cffFF8C00Enrage at 30%:|r Felbite bleeds hit harder — use defensives!" } },
        counters = {
            felsworn    = "Tyrant: Whip Crack re-taunt after Rampage. Slayer: Idan's Guard during Felbite stacks.",
            reaper      = "Defiance: Parry of Souls to negate Felbite. Dark Sustenance to heal the bleeds.",
        },
        generalTip = "Tank must re-taunt after Rampage. Dispel Felbite bleeds if you can — they stack dangerously.",
    },

    ["bone golem"] = {
        type    = "elite",
        attacks = {
            "|cffFFFFFFBone Shatter|r — PBAoE, get away if you're melee!",
            "|cffFF8C00Reconstruct|r — heals to full at 20% HP, interrupt it!",
        },
        phases  = { { hp=20, warning="|cffFF0000INTERRUPT RECONSTRUCT NOW or the fight resets!" } },
        counters = {
            runemaster  = "Arcane Binding at 21% to prevent Reconstruct. All cooldowns in the 20% window.",
            necromancer = "Army of the Dead at 25%. Interrupt Reconstruct with Death Coil.",
            tinker      = "Landmines + Rocket Barrage to burst past 20% quickly without giving him a cast window.",
        },
        generalTip = "CRITICAL: Interrupt Reconstruct at 20% or the fight resets. Save your interrupt for this moment only.",
    },

    ["shadow wraith"] = {
        type    = "caster",
        attacks = {
            "|cffAA00FFShadow Bolt Volley|r — AoE, spread out!",
            "|cffAA00FFDrain Soul|r — channels on lowest HP player, interrupt!",
        },
        phases  = {},
        counters = {
            felsworn    = "Infernal: Cast Chaos Incursion on the move during Volley. Interrupt Drain Soul.",
            witch_hunter= "Shadow Bolt Volley punishes clusters. Stay spread, stay at range.",
            chronomancer= "Rewind saves you from Drain Soul. Time Rupture + Paradox for fast burst.",
        },
        generalTip = "Spread out during Shadow Bolt Volley. Interrupt Drain Soul immediately — it gets stronger every tick.",
    },

    -- ── Scorched Highlands ────────────────────────────────
    ["pyre guardian"] = {
        type = "elite",
        attacks = { "|cffFF4444Magma Breath|r — frontal flame wave, dodge!", "|cffFF8C00Molten Armor|r — reflects 10% damage, stop attacking!" },
        phases = { { hp=40, warning="|cffFF0000Enrage at 40%:|r Damage reflect increased!" } },
        counters = { default = "Stop DPS when Molten Armor is active." },
        generalTip = "Never stand in front of Pyre Guardians.",
    },
    ["ash spirit"] = {
        type = "caster",
        attacks = { "|cffFFD700Smolder|r — ticking dot, cleanse fast!", "|cffAA00FFIgnite|r — burst fire damage, interrupt!" },
        phases = {},
        counters = { default = "Cleanse Smolder immediately." },
        generalTip = "Focus down Ash Spirits before they stack Smolder.",
    },

    -- ── Whispering Woods ──────────────────────────────────
    ["thicket stalker"] = {
        type = "melee",
        attacks = { "|cffFF4444Entangle|r — root, break it!", "|cffAA00FFVenom Spit|r — poison, use anti-venom!" },
        phases = {},
        counters = { default = "Stay behind him to avoid frontal venom." },
        generalTip = "Keep an anti-venom potion on your bar.",
    },
    ["dryad queen"] = {
        type = "boss",
        attacks = { "|cffFF4444Thorn Wall|r — blocks path, destroy sections!", "|cffAA00FFNature's Wrath|r — raid-wide damage, use shielding!" },
        phases = { { hp=50, warning="|cff00FF00Summoning Treants!|r Swap target to treants immediately." } },
        counters = { default = "Prioritize treants before the queen." },
        generalTip = "Save big burst for treant phases.",
    },
}

-- Generic fallback tips by mob type
local TYPE_TIPS = {
    caster  = {
        attack  = "|cffFF4444CASTER ENEMY:|r Interrupt every cast you can. Close distance to disrupt.",
        counter = "Stay in melee range if possible — many casters have no close-range escape.",
    },
    melee   = {
        attack  = "|cffFF8C00MELEE ENEMY:|r Face them away from your party. Side-step heavy attacks.",
        counter = "Kite if your class can — put distance between you and their swing timer.",
    },
    elite   = {
        attack  = "|cffFF8C00ELITE:|r Save major cooldowns. Don't overextend — fight near your healer.",
        counter = "Use all resources — elites warrant burning every cooldown you have.",
    },
    boss    = {
        attack  = "|cffFF0000BOSS:|r Learn phase transitions. Watch for HP threshold warnings above.",
        counter = "Position matters most in boss fights. Always face the boss away from allies.",
    },
}

-- ─────────────────────────────────────────────────────────────
-- Helpers
-- ─────────────────────────────────────────────────────────────
local function GetEnemyData(unit)
    local name = UnitName(unit)
    if not name then return nil end
    return ENEMY_DATA[name:lower()], name
end

local function GetPhaseWarning(data, unit)
    if not data or not data.phases or #data.phases == 0 then return nil end
    local hp    = UnitHealth(unit) or 0
    local maxHp = UnitHealthMax(unit) or 1
    local pct   = (hp / maxHp) * 100
    -- Find the FIRST phase threshold we're at or below
    for _, phase in ipairs(data.phases) do
        if pct <= phase.hp then
            return phase.warning
        end
    end
    return nil
end

-- ─────────────────────────────────────────────────────────────
-- Build
-- ─────────────────────────────────────────────────────────────
function CoAAT_EnemyTacticHUD.Build()
    local f = CreateFrame("Frame", "CoAATEnemyTacticHUD", UIParent)
    f:SetSize(250, 190)
    f:SetPoint("RIGHT", UIParent, "RIGHT", -20, 60)
    f:SetFrameStrata("HIGH")
    f:SetToplevel(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop",  function(self) self:StopMovingOrSizing() end)
    f:Hide()

    -- Background
    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0.05, 0.02, 0.02, 0.93)

    -- Red top accent bar
    local accent = f:CreateTexture(nil, "ARTWORK")
    accent:SetSize(250, 3)
    accent:SetPoint("TOPLEFT")
    accent:SetTexture(1.0, 0.15, 0.15, 0.95)

    -- Borders
    local function Bord(w, h, pt, rpt, ox, oy)
        local t = f:CreateTexture(nil, "OVERLAY")
        t:SetSize(w, h) ; t:SetPoint(pt, f, rpt, ox, oy)
        t:SetTexture(0.8, 0.2, 0.2, 0.5)
    end
    Bord(250, 1, "TOPLEFT",    "TOPLEFT",    0, 0)
    Bord(250, 1, "BOTTOMLEFT", "BOTTOMLEFT", 0, 0)
    Bord(1, 190, "TOPLEFT",    "TOPLEFT",    0, 0)
    Bord(1, 190, "TOPRIGHT",   "TOPRIGHT",   0, 0)

    -- Header: "⚔ Enemy Intel"
    local header = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    header:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -8)
    header:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    header:SetText("|cffFF4444⚔ Enemy Intel|r")
    f._header = header

    -- Mob name + type badge
    local mobName = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    mobName:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -22)
    mobName:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    mobName:SetText("")
    f._mobName = mobName

    -- Phase warning banner (hidden unless triggered)
    local phaseBG = f:CreateTexture(nil, "BACKGROUND")
    phaseBG:SetSize(250, 16)
    phaseBG:SetPoint("TOPLEFT", f, "TOPLEFT", 0, -36)
    phaseBG:SetTexture(0.8, 0.1, 0.0, 0.8)
    f._phaseBG = phaseBG

    local phaseWarn = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    phaseWarn:SetPoint("TOPLEFT", f, "TOPLEFT", 6, -38)
    phaseWarn:SetSize(238, 0)
    phaseWarn:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    phaseWarn:SetJustifyH("LEFT")
    phaseWarn:SetText("")
    f._phaseWarn = phaseWarn

    -- Section label: "⚠ Watch For:"
    local watchLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    watchLabel:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -56)
    watchLabel:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    watchLabel:SetText("|cffFFD700⚠ Watch For:|r")
    f._watchLabel = watchLabel

    -- Up to 3 attack warning lines
    local attackLines = {}
    for i = 1, 3 do
        local al = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        al:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -56 - (i * 13))
        al:SetSize(230, 0)
        al:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        al:SetJustifyH("LEFT")
        al:SetText("")
        attackLines[i] = al
    end
    f._attackLines = attackLines

    -- Section label: "🗡 How to Beat It:"
    local counterLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    counterLabel:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -104)
    counterLabel:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    counterLabel:SetText("|cff44FF88🗡 How to Beat It:|r")
    f._counterLabel = counterLabel

    -- Counter strategy text (wraps)
    local counterText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    counterText:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -118)
    counterText:SetSize(230, 60)
    counterText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    counterText:SetJustifyH("LEFT")
    counterText:SetJustifyV("TOP")
    counterText:SetText("")
    f._counterText = counterText

    -- Drag hint
    local dragHint = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    dragHint:SetPoint("TOPRIGHT", f, "TOPRIGHT", -6, -6)
    dragHint:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
    dragHint:SetText("|cff444444drag|r")
    f._dragHint = dragHint

    -- OnUpdate loop
    f:SetScript("OnUpdate", function(self, dt)
        _elapsed = _elapsed + dt
        if _elapsed < UPDATE_FREQ then return end
        _elapsed = 0

        if not _inCombat then
            self:Hide()
            return
        end

        local unit = "target"
        if not UnitExists(unit) or UnitIsPlayer(unit) or UnitIsFriend("player", unit) then
            self:Hide()
            return
        end

        CoAAT_EnemyTacticHUD.Refresh()
    end)

    _frame = f
end

-- ─────────────────────────────────────────────────────────────
-- Refresh content
-- ─────────────────────────────────────────────────────────────
function CoAAT_EnemyTacticHUD.Refresh()
    if not _frame then return end

    local unit   = "target"
    local data, name = GetEnemyData(unit)
    local mobKey = name and name:lower() or ""

    -- Mob name line
    local typeTag = ""
    if data then
        local t = data.type or "melee"
        local typeColors = { boss="|cffFF0000", elite="|cffFF8C00", caster="|cffAA00FF", melee="|cffFFFFFF" }
        local typeNames  = { boss="[BOSS]", elite="[ELITE]", caster="[CASTER]", melee="[MELEE]" }
        typeTag = (typeColors[t] or "|cffFFFFFF") .. (typeNames[t] or "") .. "|r "
    end
    _frame._mobName:SetText(typeTag .. "|cffFFFFFF" .. (name or "Unknown") .. "|r")

    -- Phase warning
    local phaseWarnText = data and GetPhaseWarning(data, unit)
    if phaseWarnText then
        _frame._phaseBG:Show()
        _frame._phaseWarn:SetText(phaseWarnText)
    else
        _frame._phaseBG:Hide()
        _frame._phaseWarn:SetText("")
    end

    -- Attack warnings
    local attacks = (data and data.attacks) or
                    (data and data.type and TYPE_TIPS[data.type] and { TYPE_TIPS[data.type].attack }) or
                    { "|cff808080No attack data — stay alert!|r" }
    for i = 1, 3 do
        if attacks[i] then
            _frame._attackLines[i]:SetText("• " .. attacks[i])
        else
            _frame._attackLines[i]:SetText("")
        end
    end

    -- Counter strategy (class-specific first, then general, then type)
    local classId = CoAAT_Engine and CoAAT_Engine.GetClassId and CoAAT_Engine.GetClassId()
    local counter = nil
    if data then
        counter = (classId and data.counters and data.counters[classId])
               or data.generalTip
    end
    if not counter and data and data.type then
        local td = TYPE_TIPS[data.type]
        counter = td and td.counter
    end
    counter = counter or "|cff808080No specific strategy — use your best rotation and stay alive.|r"
    _frame._counterText:SetText(counter)

    _frame:Show()
end

-- ─────────────────────────────────────────────────────────────
-- Event wiring
-- ─────────────────────────────────────────────────────────────
function CoAAT_EnemyTacticHUD.RegisterEvents()
    local ev = CreateFrame("Frame")
    ev:RegisterEvent("PLAYER_REGEN_DISABLED")   -- entered combat
    ev:RegisterEvent("PLAYER_REGEN_ENABLED")    -- left combat
    ev:RegisterEvent("PLAYER_TARGET_CHANGED")

    ev:SetScript("OnEvent", function(self, event)
        if event == "PLAYER_REGEN_DISABLED" then
            _inCombat = true
            CoAAT_EnemyTacticHUD.Refresh()
        elseif event == "PLAYER_REGEN_ENABLED" then
            _inCombat = false
            if _frame then _frame:Hide() end
        elseif event == "PLAYER_TARGET_CHANGED" then
            if _inCombat then
                CoAAT_EnemyTacticHUD.Refresh()
            end
        end
    end)
end
