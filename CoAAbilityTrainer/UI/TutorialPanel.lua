-- ============================================================
-- CoAAbilityTrainer - Tutorial Panel
-- Pop-up "lesson" system that teaches ability concepts
-- Shows on first combat, on level-up, or on demand
-- ============================================================

CoAAT_TutorialPanel = {}

local _panel = nil
local lessonQueue = {}
local currentLesson = nil

-- Lesson topics per class
local LESSONS = {
    general = {
        {
            title = "Welcome to the Ability Trainer!",
            icon  = "Interface\\Icons\\Ability_Warrior_Rampage",
            pages = {
                "This addon teaches you how to play your CoA class effectively. It shows you what to cast, when to cast it, and why.",
                "▶ The TOP panel shows your NEXT suggested ability. Cast it to progress your rotation!",
                "▶ The ICON GRID shows all your abilities. Glowing ones need your attention.",
                "▶ The RESOURCE BAR tracks your class resource. Don't let it cap — spend it!",
                "▶ PROC ALERTS flash center-screen when a reactive ability triggers.",
            },
        },
        {
            title = "Understanding Ability Types",
            icon  = "Interface\\Icons\\INV_Misc_QuestionMark",
            pages = {
                "|cff44aaff[GEN]|r GENERATOR abilities build your resource. Spam them until you reach your spend threshold.",
                "|cffff8844[USE]|r SPENDER abilities cost your resource. Use them when the bar says 'SPEND!'",
                "|cffcc44ff[CD]|r COOLDOWN abilities have timers. Use them the moment they come off cooldown.",
                "|cffffdd00[PROC]|r PROC abilities react to game events. Use them IMMEDIATELY when they glow!",
                "|cff44ff88[BUFF]|r BUFF abilities must stay active at all times. Reapply if they drop.",
                "|cffff4444[DBFF]|r DEBUFF abilities go on your target. Keep them refreshed for max damage.",
            },
        },
    },

    felsworn = {
        {
            title = "Felsworn — Class Introduction (July 2026)",
            icon  = "Interface\\Icons\\Spell_Shadow_Metamorphosis",
            pages = {
                "You are a |cffb048b5Felsworn|r — a melee combatant or shadow caster that channels demonic powers and burning fel energy.",
                "Core Resource: |cffb048b5Felfury (0-100)|r. Build Felfury using your combos and basic attacks, then unleash it for powerful finishers.",
                "You have three specs: |cffb048b5Infernal|r (Caster DPS), |cffff4444Slayer|r (Melee DPS), and |cff00ff88Tyrant|r (Evasion Tank).",
                "Each spec uses Felfury finishers to dominate the battlefield. Choose your role and master the rotation!",
            },
        },
        {
            title = "Felsworn: Infernal (Caster DPS)",
            icon  = "Interface\\Icons\\Spell_Fire_FelFlame",
            pages = {
                "Infernal is a highly mobile caster DPS. You cast shadowflame and fel spells while moving.",
                "STEP 1: Keep |cffb048b5Voidblaze DoT|r active on your target. Ticks generate passive Felfury.",
                "STEP 2: Cast |cffb048b5Chaos Incursion|r to build Felfury. You can cast it on the move!",
                "STEP 3: When |cffb048b5Infernal Magicks procs|r, cast Engulf immediately (instant and cheaper).",
                "STEP 4: Spend at 80+ Felfury with |cffb048b5Engulf|r for massive single-target damage.",
            },
        },
        {
            title = "Felsworn: Slayer (Melee DPS)",
            icon  = "Interface\\Icons\\Ability_Warrior_SavageBlow",
            pages = {
                "Slayer is a fast dual-wielding fighter. You use mobility and attack speed stacks to slice down targets.",
                "STEP 1: Use |cffb048b5Fel Hoof Charge|r to close the gap and build 25 Felfury.",
                "STEP 2: Maintain |cffb048b5Infernal Alacrity stacks (up to 5)|r by casting Voidblaze at 40 Felfury.",
                "STEP 3: Spam |cffb048b5Fell Strike|r to build Felfury to 80.",
                "STEP 4: Spend 80 Felfury with |cffff4444Slayer Cleave|r to hit all nearby enemies.",
            },
        },
        {
            title = "Felsworn: Tyrant (Evasion Tank)",
            icon  = "Interface\\Icons\\Spell_Shadow_AntiShadow",
            pages = {
                "Tyrant is an agile, evasion-based tank. You use dodge/parry to deflect damage and counterattack.",
                "STEP 1: Keep your passive |cff00ff88Fel Barrier stance|r active for 20% damage reduction.",
                "STEP 2: Use |cff00ff88Whip Crack|r on pull to taunt the target and boost your armor.",
                "STEP 3: Activate |cff00ff88Vengeance|r to gain 30% parry. Parrying triggers counter Fel Strikes.",
                "STEP 4: Use |cff00ff88Vengeful Strike procs|r for instant 20 Felfury after you dodge/parry.",
                "STEP 5: Spend 80 Felfury on |cff00ff88Chaos Finisher|r to deal high threat AoE and heal 25% HP.",
            },
        },
        {
            title = "Felsworn: Secrets & Top Combos",
            icon  = "Interface\\Icons\\Ability_Fremzy",
            pages = {
                "SECRET 1 (Slayer DPS): Maintain your Felfury between 40-79. Casting |cffff4444Slayer Cleave|r at exactly 100 Felfury consumes all energy and guarantees a Critical Strike due to the hidden 'Fel Overload' passive!",
                "SECRET 2 (Infernal Burst): Cast |cff00ccffFel Prison (stun)|r right before casting Engulf. |cffb048b5Engulf|r deals double damage to stunned targets. Stun → instant Engulf procs can hit for a 300% critical strike!",
                "SECRET 3 (Tyrant Survival): Time |cff00ff88Vengeance|r right before a boss's heavy swing. Every parry heals you for 5% max HP via 'Siphoned Blood'. Casting Chaos Finisher at 100 Felfury buffs self-heal to 40%.",
                "SECRET 4 (Weapon Morphs): Felsworn can equip any standard agility/intellect swords, axes, or daggers. When entering combat, they visually morph into dual flaming |cffb048b5Fel Scythes|r with spell power scaling!",
            },
        },
    },

    necromancer = {
        {
            title = "Playing the Necromancer",
            icon  = "Interface\\Icons\\Spell_Shadow_RaiseDead",
            pages = {
                "You are a death mage. Your undead minion fights alongside you — never let it die!",
                "If your undead is dead: STOP everything and cast |cff51c2c5Raise Dead|r immediately.",
                "ALWAYS keep |cff51c2c5Plague Strike|r on your target. It amplifies ALL your damage by 20%!",
                "Build Runic Power with |cff51c2c5Death Coil|r spam — it's also free healing for your minion.",
                "Spend at 60+ with |cff51c2c5Runic Tap|r — big damage AND a 20% self-heal!",
                "After every kill: use |cff51c2c5Corpse Explosion|r to nuke nearby mobs with AoE.",
                "Save |cff51c2c5Army of the Dead|r for elite mobs — it's a 3-minute cooldown.",
            },
        },
    },

    witch_hunter = {
        {
            title = "Playing the Witch Hunter",
            icon  = "Interface\\Icons\\Ability_Hunter_MarkedForDeath",
            pages = {
                "You are a monster hunter. Mark your prey and eliminate it from range.",
                "FIRST: Apply |cff4a9153Mark Target|r. This increases all your damage by 15%. Never skip this!",
                "Then: Use |cff4a9153Shadow Tonic|r on cooldown — 30% damage boost for 10 seconds.",
                "STAY AT RANGE: Shadow Bolt deals 10% more from maximum distance.",
                "Build Focus with Shadow Bolt spam until you hit 50.",
                "SPEND at 50: |cff4a9153Cursed Shot|r hits much harder on a marked target.",
                "REACT: When |cff4a9153Purge|r procs on a buffed enemy — strip their buff for free Focus!",
            },
        },
    },

    tinker = {
        {
            title = "Playing the Tinker",
            icon  = "Interface\\Icons\\Trade_Engineering",
            pages = {
                "You are an engineer. Your turret is your best friend — deploy it before every fight!",
                "ALWAYS: Place your |cffffd700Turret|r BEFORE pulling enemies. It starts attacking on aggro.",
                "SETUP: Drop |cffffd700Landmines|r near spawn points before engaging packs.",
                "PULL: Drag enemies through your mine field and into turret range.",
                "SPEND at 40: |cffffd700Rocket Barrage|r is exceptional AoE — great on grouped mobs.",
                "FILL: Use |cffffd700Laser Blast|r between cooldowns.",
                "REACT: When |cffffd700Overclock|r procs — your turret fires at 3x speed for 5s!",
            },
        },
    },

    runemaster = {
        {
            title = "Playing the Runemaster",
            icon  = "Interface\\Icons\\Spell_Arcane_RuneStrike",
            pages = {
                "You carve elemental runes into your enemies. Precise timing is key!",
                "ALWAYS: Keep |cff2266cc Elemental Brand|r on your target — 20% damage bonus!",
                "CRITICAL: Refresh Elemental Brand when it has 2 seconds left. Never let it fall off!",
                "BUILD: Spam |cff2266ccRune Strike|r to stack Rune Charges (aim for 3+).",
                "DETONATE: Use |cff2266ccRunic Detonation|r at 3+ charges for massive damage.",
                "REACT: |cff2266ccRune Mastery|r proc means charges generating 2x — detonate sooner!",
                "UTILITY: Use |cff2266ccArcane Binding|r to silence casters before they cast.",
            },
        },
    },

    chronomancer = {
        {
            title = "Playing the Chronomancer",
            icon  = "Interface\\Icons\\Spell_Holy_Borrowedtime",
            pages = {
                "You bend time itself. Complex, but extremely rewarding when mastered.",
                "APPLY: Start every fight with |cff7b68eeTime Rupture|r — it's your main resource engine.",
                "CRITICAL: Refresh Time Rupture at 3 seconds remaining. It's your primary DoT!",
                "FILL: Use |cff7b68eeChrono Blast|r between refreshes to build Temporal Energy.",
                "SPEND at 70: |cff7b68eeParadox Explosion|r deals MORE damage the more DoTs are on target.",
                "REACT: |cff7b68eeTime Loop|r proc reduces Paradox cost — cast it immediately!",
                "EMERGENCY: |cff7b68eeRewind|r saves your life when HP < 25%. SAVE IT for that!",
            },
        },
    },

    spiritwalker = {
        {
            title = "Playing the Spiritwalker (Stormcaller)",
            icon  = "Interface\\Icons\\Spell_Nature_HealingTouch",
            pages = {
                "You are nature incarnate. Your totems sustain you while lightning destroys your foes.",
                "ALWAYS: Drop |cff00ff7fSpirit Ward|r totem at the start of combat. Free 2% HP/3s healing!",
                "AoE: Use |cff00ff7fChain Storm|r every 8 seconds — hits all nearby enemies.",
                "FILL: |cff00ff7fLightning Bolt|r is your main damage. It chains to 2 extra targets!",
                "LOW MANA: Drop |cff00ff7fEarthbind Totem|r to root enemies and give yourself breathing room.",
                "PROCS: |cff00ff7fAncestral Guidance|r triggers when you crit — free self-healing!",
                "Stormcaller is great for solo but remember your true power is in healing dungeons.",
            },
        },
    },

    -- ══════════════════════════════════════════════════════════
    --  REAPER  — July 2026 CoA Full Launch Update
    -- ══════════════════════════════════════════════════════════
    reaper = {
        {
            title = "The Reaper — Class Introduction (July 2026)",
            icon  = "Interface\\Icons\\Spell_Shadow_SoulLeech_3",
            pages = {
                "You are a |cff9900ccReaper|r — a warrior possessed by hungry spirits trapped in an enchanted scythe. |cff9900ccAll your weapons visually transform into scythes.|r",
                "Core Mechanic 1: |cff9900ccReaped Souls (0–5)|r. Build souls with your abilities and kills. At 5 stacks, |cffFFD700Soul Infusion|r becomes available — your most powerful attack.",
                "Core Mechanic 2: |cff9900ccHealth-as-Resource|r. Many of your strongest abilities COST a % of your max HP. This is intentional — you are designed to SPEND health to deal damage...",
                "...and then RECOVER that health through |cff9900ccLifesteal / Siphon|r abilities. The Reaper is a high-risk, high-reward class. Low HP = higher damage from |cff9900ccDeath's Embrace|r!",
                "You have THREE specs: |cff9900ccHarvest|r (2H Bruiser DPS), |cff9900ccSoul|r (Dual-Wield Shadow Assassin), and |cff9900ccDefiance|r (Lifestealing Parry Tank).",
                "Stat Priority: |cffFFD700Stamina > Agility > Strength|r for Harvest/Defiance. |cffFFD700Agility > Intellect > Stamina|r for Soul spec. Prioritize gear with 'of the Shadow' or 'of the Reaper'.",
                "Key Rule: NEVER panic-heal yourself out of the |cff9900ccDeath's Embrace|r zone (below 50% HP). That zone is where your power is maximum. Trust your lifesteal!",
            },
        },
        {
            title = "Reaper: Harvest Spec (2H Bruiser DPS)",
            icon  = "Interface\\Icons\\Ability_Warrior_ColossusSmash",
            pages = {
                "Harvest is the most accessible Reaper spec. Your goal: keep |cff9900ccSiphon Strike|r on your target at ALL times, then SWING and DRAIN.",
                "STEP 1: Apply |cff9900ccSiphon Strike|r debuff IMMEDIATELY. This is your healing engine — every hit heals 8% of damage dealt. Without it, Life Drain will kill you.",
                "STEP 2: Spam |cff9900ccDeath Reap|r — your 2H scythe swing. Each cast builds 1 Reaped Soul. You need 5 for Soul Infusion.",
                "STEP 3: Use |cff9900ccLife Drain|r on cooldown (6s). It costs 20% max HP — but Siphon Strike heals it back instantly. This is your primary damage spike.",
                "STEP 4: Use |cff9900ccSoul Harvest|r (20s CD) — 2s channel that gives +3 souls AND heals 25% HP. Use freely when low souls or low HP.",
                "STEP 5: The moment you hit 5 Reaped Souls — cast |cff9900ccSoul Infusion|r IMMEDIATELY. It detonates all souls for MASSIVE AoE damage around you.",
                "BONUS: |cff9900ccDeath's Embrace|r passively boosts your damage 25% when below 50% HP. Play in the danger zone — that's where Harvest shines!",
                "EXECUTE: |cff9900ccReaping Strike|r (45s CD) deals TRIPLE damage when the target is below 30% HP. Save it for the kill window.",
            },
        },
        {
            title = "Reaper: Soul Spec (Dual-Wield Assassin)",
            icon  = "Interface\\Icons\\Ability_Rogue_Shadowdance",
            pages = {
                "Soul spec is the highest skill-cap Reaper playstyle. You weave through shadow, set up debuffs, then unleash devastating burst windows.",
                "OPENER: ALWAYS start from |cff9900ccShadow Phase|r (25s CD). You become untargetable for 4s AND all HP-cost abilities are 50% cheaper. First strike gets +80% damage!",
                "DEBUFFS FIRST: Apply |cff9900ccDeath Mark|r (+20% shadow damage to target), then |cff9900ccSoul Rend|r (DoT that passively generates Reaped Souls with each tick).",
                "POSITIONING: Use |cff9900ccVoid Step|r (12s CD) to teleport behind the target. Free soul gained + next hit deals 50% bonus damage. Always be behind your target!",
                "SOUL BUILDING: Spam |cff9900ccSpectral Slash|r — your dual-wield combo generates 2 Reaped Souls per cast. With Soul Rend ticking, you fill to 5 stacks very fast.",
                "SPEND: |cff9900ccGhostly Strike|r (8s CD, costs 15% HP) is your spender. Deals massive shadow damage. Use RIGHT AFTER exiting Shadow Phase for the 40% bonus.",
                "DETONATE: At 5 Reaped Souls, |cff9900ccSoul Infusion|r unleashes a shadow nova — damages your target AND stuns all nearby enemies for 2 seconds!",
                "PROC: |cff9900ccEcho of Death|r — when Soul Rend's DoT kills an enemy, you get a FREE Spectral Slash + 2 bonus souls. Pull packs to chain these procs!",
            },
        },
        {
            title = "Reaper: Defiance Spec (Lifestealing Tank)",
            icon  = "Interface\\Icons\\Spell_Shadow_AntiShadow",
            pages = {
                "Defiance turns the Reaper into one of the most durable tanks in CoA — sustaining through lifesteal, parries, and soul-powered shields.",
                "ALWAYS ON: |cff9900ccSoul Barrier|r — your 20% damage reduction aura that also generates 1 Reaped Soul every 3 seconds passively. Reapply INSTANTLY if it falls off.",
                "ALWAYS ON: |cff9900ccDomination Aura|r — passive party buff giving allies 5% lifesteal and 10% damage reduction. No maintenance needed, but verify it's active.",
                "CORE CD: |cff9900ccParry of Souls|r (15s CD) — activates 6s of greatly increased parry. Each successful parry = 1 Reaped Soul + 5% HP healed. Pop this before big hits!",
                "PROC: |cff9900ccHarvest Soul|r triggers from Parry of Souls. When active, your next |cff9900ccSoul Strike|r deals 3× damage and generates 3 souls. REACT immediately!",
                "SUSTAIN: |cff9900ccDark Sustenance|r costs 2 Reaped Souls and drains nearby enemies for 20% max HP healing. Use when HP drops below 40%.",
                "UTILITY: |cff9900ccSoul Shriek|r (30s CD) silences ALL enemies within 8 yards for 3 seconds. Critical for interrupting dungeon caster packs! Use proactively.",
                "ULTIMATE: At 5 Reaped Souls, |cff9900ccSoul Infusion|r triggers an AoE taunt + 8-second invulnerability shield. Save for dangerous pulls or boss enrages!",
            },
        },
    },
    vault_of_the_inquisition = {
        {
            title = "Vault of the Inquisition — Dungeon Overview",
            icon = "Interface\\\\Icons\\\\INV_Misc_QuestionMark",
            pages = {
                "This dungeon features many caster mobs. Use Soul Shriek to silence them and maintain control.",
                "Maintain your resource (Felfury, Runic Power, etc.) to burst down adds quickly.",
                "Watch for environmental hazards; avoid standing in fire.",
                "Coordinate interrupts across the party for maximum efficiency."
            }
        },
    },
    road_to_the_other_side = {
        {
            title = "Road to the Other Side — Dungeon Overview",
            icon = "Interface\\\\Icons\\\\INV_Misc_QuestionMark",
            pages = {
                "A fast-paced dungeon with multiple AoE trash packs. Keep Soul Shriek on cooldown to silence waves of casters.",
                "Prioritize resource generation early to handle heavy damage phases.",
                "Use defensive cooldowns when encountering elite encounters.",
                "Stay mobile to avoid ground hazards and keep your rotation smooth."
            }
        },
    },
}

-- ─────────────────────────────────────────────
-- Build the tutorial panel
-- ─────────────────────────────────────────────
function CoAAT_TutorialPanel.Build()
    local f = CreateFrame("Frame", "CoAATTutorialPanel", UIParent)
    f:SetSize(420, 260)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
    f:SetFrameStrata("DIALOG")
    f:SetToplevel(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    -- Background
    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0.03, 0.04, 0.10, 0.95)

    -- Top gradient
    local topGrad = f:CreateTexture(nil, "ARTWORK")
    topGrad:SetSize(420, 36)
    topGrad:SetPoint("TOPLEFT")
    topGrad:SetGradientAlpha("HORIZONTAL",
        0.0, 0.55, 0.85, 0.95,
        0.0, 0.15, 0.30, 0.95)

    -- Borders
    local function border(w, h, point, relPoint, ox, oy)
        local t = f:CreateTexture(nil, "OVERLAY")
        t:SetSize(w, h)
        t:SetPoint(point, f, relPoint, ox, oy)
        t:SetTexture(0.0, 0.6, 1.0, 0.5)
    end
    border(420, 1, "TOPLEFT",     "TOPLEFT",     0, 0)
    border(420, 1, "BOTTOMLEFT",  "BOTTOMLEFT",  0, 0)
    border(1, 260, "TOPLEFT",     "TOPLEFT",     0, 0)
    border(1, 260, "TOPRIGHT",    "TOPRIGHT",    0, 0)

    -- Close button
    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetSize(22, 22)
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", 2, 2)
    closeBtn:SetScript("OnClick", function() f:Hide() end)

    -- Ability icon (left)
    local icon = f:CreateTexture(nil, "ARTWORK")
    icon:SetSize(52, 52)
    icon:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -40)
    icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    f._icon = icon

    -- Title
    local titleText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titleText:SetPoint("TOPLEFT", f, "TOPLEFT", 72, -10)
    titleText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
    titleText:SetText("|cffFFD700Ability Tutorial|r")
    f._titleText = titleText

    -- Page content
    local contentText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    contentText:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -100)
    contentText:SetSize(396, 130)
    contentText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    contentText:SetJustifyH("LEFT")
    contentText:SetJustifyV("TOP")
    contentText:SetText("")
    f._contentText = contentText

    -- Page indicator
    local pageIndicator = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    pageIndicator:SetPoint("BOTTOM", f, "BOTTOM", 0, 32)
    pageIndicator:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    pageIndicator:SetText("")
    f._pageIndicator = pageIndicator

    -- Prev / Next buttons
    local prevBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    prevBtn:SetSize(80, 24)
    prevBtn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 12, 8)
    prevBtn:SetText("◀ Prev")
    prevBtn:SetScript("OnClick", function() CoAAT_TutorialPanel.PrevPage() end)
    f._prevBtn = prevBtn

    local nextBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    nextBtn:SetSize(80, 24)
    nextBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -12, 8)
    nextBtn:SetText("Next ▶")
    nextBtn:SetScript("OnClick", function() CoAAT_TutorialPanel.NextPage() end)
    f._nextBtn = nextBtn

    -- "Got it!" button (appears on last page)
    local doneBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    doneBtn:SetSize(100, 24)
    doneBtn:SetPoint("BOTTOM", f, "BOTTOM", 0, 8)
    doneBtn:SetText("✓ Got it!")
    doneBtn:SetScript("OnClick", function()
        f:Hide()
        CoAAT_TutorialPanel.ShowNext()
    end)
    doneBtn:Hide()
    f._doneBtn = doneBtn

    -- 🎮 Play Combo Button (appears on page 1 of spec tutorials)
    local playBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    playBtn:SetSize(110, 24)
    playBtn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 100, 8)
    playBtn:SetText("🎮 Play Combo")
    playBtn:SetScript("OnClick", function()
        CoAAT_TutorialPanel.StartSim()
    end)
    playBtn:Hide()
    f._playBtn = playBtn

    -- ── Simulated Elements (Hidden by default) ──
    local simBanner = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    simBanner:SetPoint("TOP", f, "TOP", 0, -50)
    simBanner:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    simBanner:Hide()
    f._simBanner = simBanner

    -- Sim Resource Bar
    local simBar = CreateFrame("Frame", nil, f)
    simBar:SetSize(240, 8)
    simBar:SetPoint("TOP", f, "TOP", 0, -80)
    local simBarBG = simBar:CreateTexture(nil, "BACKGROUND")
    simBarBG:SetAllPoints()
    simBarBG:SetTexture(0.02, 0.02, 0.06, 0.95)
    
    local simBarFill = simBar:CreateTexture(nil, "ARTWORK")
    simBarFill:SetHeight(8)
    simBarFill:SetPoint("LEFT", simBar, "LEFT", 0, 0)
    simBarFill:SetTexture(0.7, 0.1, 0.9) -- purple felsworn resource color
    simBar:Hide()
    f._simBar = simBar
    f._simBarFill = simBarFill

    -- Sim Combat Text
    local simCombatText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    simCombatText:SetPoint("TOP", f, "TOP", 0, -110)
    simCombatText:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
    simCombatText:Hide()
    f._simCombatText = simCombatText

    -- Sim Quit Button
    local simQuitBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    simQuitBtn:SetSize(100, 24)
    simQuitBtn:SetPoint("BOTTOM", f, "BOTTOM", 0, 8)
    simQuitBtn:SetText("✕ Exit Sim")
    simQuitBtn:SetScript("OnClick", function()
        CoAAT_TutorialPanel.EndSim()
    end)
    simQuitBtn:Hide()
    f._simQuitBtn = simQuitBtn

    -- Sim Action Buttons (row of 4)
    f._simButtons = {}
    for i = 1, 4 do
        local btn = CreateFrame("Button", nil, f)
        btn:SetSize(40, 40)
        btn:SetPoint("BOTTOM", f, "BOTTOM", -90 + (i-1)*60, 48)
        
        local iconTex = btn:CreateTexture(nil, "BACKGROUND")
        iconTex:SetAllPoints()
        btn._icon = iconTex

        -- Glow ring
        local glow = btn:CreateTexture(nil, "OVERLAY")
        glow:SetTexture("Interface\\Buttons\\CheckButtonHilight")
        glow:SetBlendMode("ADD")
        glow:SetAllPoints()
        glow:Hide()
        btn._glow = glow

        -- Binding shortcut text
        local bind = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        bind:SetPoint("TOPLEFT", btn, "TOPLEFT", 2, -2)
        bind:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        bind:SetText(tostring(i))

        btn:SetScript("OnClick", function()
            CoAAT_TutorialPanel.OnSimBtnClick(i)
        end)
        
        btn:Hide()
        table.insert(f._simButtons, btn)
    end

    f._currentPage = 1
    f:Hide()
    _panel = f
end

-- ─────────────────────────────────────────────
-- Show a lesson by topic
-- ─────────────────────────────────────────────
function CoAAT_TutorialPanel.ShowLesson(topic, lessonIdx)
    local lessonList = LESSONS[topic] or LESSONS.general
    local lesson = lessonList[lessonIdx or 1]
    if not lesson then return end

    currentLesson = { lesson = lesson, page = 1, topic = topic }
    CoAAT_TutorialPanel.RenderPage()
    if _panel then
        PlaySound(829) -- Window open sound
        _panel:SetAlpha(1.0)
        _panel:Show()
    end
end

function CoAAT_TutorialPanel.RenderPage()
    if not currentLesson or not _panel then return end
    local lesson = currentLesson.lesson
    local page   = currentLesson.page
    local pages  = lesson.pages

    _panel._titleText:SetText("|cff00ccff📖 " .. lesson.title .. "|r")
    _panel._icon:SetTexture(lesson.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
    _panel._contentText:SetText("|cffdddddd" .. (pages[page] or "") .. "|r")
    _panel._pageIndicator:SetText("|cffaaaaaa" .. page .. " / " .. #pages .. "|r")

    _panel._prevBtn:SetEnabled(page > 1)
    _panel._nextBtn:SetEnabled(page < #pages)

    if page == #pages then
        _panel._doneBtn:Show()
        _panel._nextBtn:Hide()
    else
        _panel._doneBtn:Hide()
        _panel._nextBtn:Show()
    end

    if currentLesson and currentLesson.topic ~= "general" and page == 1 then
        _panel._playBtn:Show()
    else
        _panel._playBtn:Hide()
    end
end

function CoAAT_TutorialPanel.NextPage()
    if not currentLesson then return end
    currentLesson.page = math.min(currentLesson.page + 1, #currentLesson.lesson.pages)
    CoAAT_TutorialPanel.RenderPage()
end

function CoAAT_TutorialPanel.PrevPage()
    if not currentLesson then return end
    currentLesson.page = math.max(currentLesson.page - 1, 1)
    CoAAT_TutorialPanel.RenderPage()
end

function CoAAT_TutorialPanel.ShowNext()
    if #lessonQueue > 0 then
        local next = table.remove(lessonQueue, 1)
        CoAAT_TutorialPanel.ShowLesson(next.topic, next.idx)
    end
end

function CoAAT_TutorialPanel.Queue(topic, idx)
    lessonQueue[#lessonQueue + 1] = { topic = topic, idx = idx }
end

function CoAAT_TutorialPanel.ShowClassIntro(classId)
    CoAAT_TutorialPanel.ShowLesson("general", 1)
    if LESSONS[classId] then
        CoAAT_TutorialPanel.Queue(classId, 1)
    end
end

-- ─────────────────────────────────────────────
-- Interactive Combo Simulator Mode
-- ─────────────────────────────────────────────
local isPlayingSim = false
local simStep = 1
local simResource = 0
local simMaxResource = 100
local simActiveSeq = {}

local SIM_SEQUENCES = {
    felsworn = {
        resourceName = "Felfury",
        color = {0.7, 0.1, 0.9},
        abilities = {
            { name = "Fel Hoof Charge", icon = "Interface\\Icons\\Ability_Rider_Deathchargelevel2" },
            { name = "Fell Strike",     icon = "Interface\\Icons\\Ability_Warrior_SavageBlow" },
            { name = "Voidblaze",       icon = "Interface\\Icons\\Spell_Fire_SelfDestruct" },
            { name = "Slayer Cleave",   icon = "Interface\\Icons\\Ability_Warrior_Cleave" }
        },
        steps = {
            { targetBtn = 1, resourceAdd = 25,  desc = "Enemy spotted! Click Fel Hoof Charge to engage." },
            { targetBtn = 2, resourceAdd = 15,  desc = "Perfect! Now click Fell Strike to build Felfury to 40." },
            { targetBtn = 3, resourceAdd = -40, desc = "Stack Haste! Click Voidblaze at 40 Felfury to gain Haste." },
            { targetBtn = 2, resourceAdd = 15,  desc = "Build Power! Click Fell Strike to reach 15 Felfury." },
            { targetBtn = 2, resourceAdd = 20,  desc = "Keep building! Click Fell Strike to reach 35 Felfury." },
            { targetBtn = 2, resourceAdd = 25,  desc = "Almost there! Click Fell Strike to reach 60 Felfury." },
            { targetBtn = 2, resourceAdd = 40,  desc = "Max Felfury! Click Fell Strike to hit 100 Felfury." },
            { targetBtn = 4, resourceAdd = -100, desc = "FINISHER READY! Click Slayer Cleave to execute the target!", damage = "* CRITICAL! 18,400 Shadowflame *" },
            { desc = "🎉 Combo Mastered! You executed the perfect Slayer burst! Click Exit Sim." }
        }
    },
    necromancer = {
        resourceName = "Runic Power",
        color = {0.1, 0.8, 0.8},
        abilities = {
            { name = "Raise Dead",        icon = "Interface\\Icons\\Spell_Shadow_RaiseDead" },
            { name = "Plague Strike",     icon = "Interface\\Icons\\Spell_Shadow_Contagion" },
            { name = "Runic Tap",         icon = "Interface\\Icons\\Spell_Shadow_RunicTap" },
            { name = "Corpse Explosion",  icon = "Interface\\Icons\\Spell_Shadow_CorpseExplosion" }
        },
        steps = {
            { targetBtn = 1, resourceAdd = 20,  desc = "Summon Minion! Click Raise Dead to summon your ghoul." },
            { targetBtn = 2, resourceAdd = 25,  desc = "Infect Target! Click Plague Strike to apply diseases." },
            { targetBtn = 3, resourceAdd = -35, desc = "Heal Minion! Click Runic Tap to keep your pet alive." },
            { targetBtn = 4, resourceAdd = -10, desc = "MINION DIED! Click Corpse Explosion to blow up the body!", damage = "* BOOM! 15,200 Shadow damage *" },
            { desc = "🎉 Mastery Achieved! You executed the Necromancer corpse combo! Click Exit Sim." }
        }
    },
    witch_hunter = {
        resourceName = "Focus",
        color = {0.9, 0.6, 0.1},
        abilities = {
            { name = "Mark Target",   icon = "Interface\\Icons\\Ability_Hunter_MarkedForDeath" },
            { name = "Cursed Shot",   icon = "Interface\\Icons\\Ability_Hunter_SniperShot" },
            { name = "Purge",         icon = "Interface\\Icons\\Spell_Holy_DispelMagic" },
            { name = "Shadow Tonic",  icon = "Interface\\Icons\\INV_Potion_16" }
        },
        steps = {
            { targetBtn = 1, resourceAdd = 20,  desc = "Debuff! Click Mark Target to mark your prey." },
            { targetBtn = 2, resourceAdd = 20,  desc = "Shoot! Click Cursed Shot to deal heavy damage." },
            { targetBtn = 3, resourceAdd = -30, desc = "Target Buffed! Click Purge to banish active magic." },
            { targetBtn = 4, resourceAdd = 90,  desc = "BURST CD! Click Shadow Tonic to restore Focus instantly!", damage = "* PURGED! 12,900 Arcane-Shadow *" },
            { desc = "🎉 Mastery Achieved! You executed the Witch Hunter purge combo! Click Exit Sim." }
        }
    }
}

-- Fallback generic sequence
local GENERIC_SEQ = {
    resourceName = "Resource",
    color = {0.4, 0.8, 0.4},
    abilities = {
        { name = "Generator", icon = "Interface\\Icons\\Spell_Nature_StoneClawTotem" },
        { name = "Spender",   icon = "Interface\\Icons\\Spell_Fire_FireBolt02" },
        { name = "Cooldown",  icon = "Interface\\Icons\\Spell_Magic_LesserInvisibilty" },
        { name = "Utility",   icon = "Interface\\Icons\\Spell_Shadow_Frenzy" }
    },
    steps = {
        { targetBtn = 3, resourceAdd = 20,  desc = "Pop Cooldown! Click your primary 30s Cooldown." },
        { targetBtn = 1, resourceAdd = 30,  desc = "Generate! Click your Generator to build power to 50%." },
        { targetBtn = 1, resourceAdd = 30,  desc = "Keep building! Click your Generator to build power to 80%." },
        { targetBtn = 2, resourceAdd = -80, desc = "FINISHER! Click your Spender to dump resource.", damage = "* SIMULATED CRIT! *" },
        { desc = "🎉 Mastery Achieved! You executed the class rotation! Click Exit Sim." }
    }
}

function CoAAT_TutorialPanel.StartSim()
    if not currentLesson or not _panel then return end
    isPlayingSim = true
    simStep = 1
    simResource = 0

    local topic = currentLesson.topic
    simActiveSeq = SIM_SEQUENCES[topic] or GENERIC_SEQ

    -- Hide regular text tutorial elements
    _panel._icon:Hide()
    _panel._contentText:Hide()
    _panel._pageIndicator:Hide()
    _panel._prevBtn:Hide()
    _panel._nextBtn:Hide()
    _panel._playBtn:Hide()
    _panel._doneBtn:Hide()

    -- Show simulated elements
    _panel._simBanner:Show()
    _panel._simBar:Show()
    _panel._simQuitBtn:Show()

    -- Set resource bar color
    local c = simActiveSeq.color
    _panel._simBarFill:SetTexture(c[1], c[2], c[3])

    -- Setup action buttons
    for i = 1, 4 do
        local btn = _panel._simButtons[i]
        local abi = simActiveSeq.abilities[i]
        if btn and abi then
            btn._icon:SetTexture(abi.icon)
            btn:Show()
        end
    end

    CoAAT_TutorialPanel.UpdateSimUI()
end

function CoAAT_TutorialPanel.EndSim()
    isPlayingSim = false
    
    -- Hide simulated elements
    _panel._simBanner:Hide()
    _panel._simBar:Hide()
    _panel._simQuitBtn:Hide()
    _panel._simCombatText:Hide()
    for _, btn in ipairs(_panel._simButtons) do
        btn:Hide()
    end

    -- Restore text tutorial elements
    _panel._icon:Show()
    _panel._contentText:Show()
    _panel._pageIndicator:Show()
    _panel._prevBtn:Show()
    _panel._nextBtn:Show()
    
    CoAAT_TutorialPanel.RenderPage()
end

function CoAAT_TutorialPanel.UpdateSimUI()
    if not isPlayingSim or not _panel then return end

    local step = simActiveSeq.steps[simStep]
    if not step then return end

    -- Update Banner Text
    _panel._simBanner:SetText(step.desc)

    -- Update Resource Bar width
    local pct = simResource / simMaxResource
    _panel._simBarFill:SetWidth(math.max(1, 240 * pct))

    -- Set buttons glows
    for i = 1, 4 do
        local btn = _panel._simButtons[i]
        if btn then
            if step.targetBtn == i then
                btn._glow:Show()
            else
                btn._glow:Hide()
            end
        end
    end
end

function CoAAT_TutorialPanel.OnSimBtnClick(btnIdx)
    if not isPlayingSim then return end

    local step = simActiveSeq.steps[simStep]
    if not step or not step.targetBtn then return end

    if btnIdx == step.targetBtn then
        -- Correct! Play cast sound
        PlaySound(856) -- Spell cast sound
        
        -- Modify resource
        simResource = math.max(0, math.min(simMaxResource, simResource + step.resourceAdd))

        -- Show damage text if present
        if step.damage then
            _panel._simCombatText:SetText(step.damage)
            _panel._simCombatText:Show()
            UIFrameFadeOut(_panel._simCombatText, 1.5, 1.0, 0.0) -- Smooth combat text fade out!
        end

        -- Go to next step
        simStep = simStep + 1
        CoAAT_TutorialPanel.UpdateSimUI()
    else
        -- Incorrect button! Play failure sound and brief red flash
        PlaySound(847) -- Error sound
        UIFrameFadeOut(_panel, 0.3, 0.8, 1.0)
    end
end

function CoAAT_TutorialPanel.Toggle()
    if _panel then
        if _panel:IsShown() then
            PlaySound(830) -- Window close
            _panel:Hide()
            if isPlayingSim then
                CoAAT_TutorialPanel.EndSim()
            end
        else
            if currentLesson then
                PlaySound(829) -- Window open
                _panel:SetAlpha(1.0)
                _panel:Show()
            else
                CoAAT_TutorialPanel.ShowLesson("general", 1)
            end
        end
    end
end
