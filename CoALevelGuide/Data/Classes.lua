-- ============================================================
-- CoALevelGuide - Class Data
-- Conquest of Azeroth's 21 custom classes
-- ============================================================

CoALevelGuide_Classes = {
    -- ======================== DAMAGE ========================
    {
        id = "felsworn",
        name = "Felsworn",
        role = "DPS / Tank",
        resource = "Felfury",
        icon = "Interface\\Icons\\Spell_Shadow_Metamorphosis",
        color = "|cffb048b5",
        difficulty = 2, -- 1=Easy, 3=Hard
        description = "A demonic warrior harnessing fel energy to destroy enemies as a mobile shadowflame caster, a high-speed twin-blade slayer, or a chaotic evasion tank.",
        specs = {
            { name = "Infernal", role = "DPS", description = "Highly mobile caster spec weaving instant fel fire and shadowflame DoTs." },
            { name = "Slayer", role = "DPS", description = "Twin-blade melee spec focused on speed combos and rapid Felfury generation." },
            { name = "Tyrant", role = "Tank", description = "Agile, evasion-based demon tank relying on dodge, parry, and counter-attacks." },
        },
        levelingTips = {
            "Leveling Spec: Slayer for high solo speed, or Infernal for mobile AoE caster kiting.",
            "Priority Stats: Agility > Stamina for Slayer/Tyrant; Intellect > Stamina for Infernal.",
            "Mobility: Use 'Fel Hoof Charge' (Slayer) or cast 'Chaos Incursion' on the run (Infernal) to optimize combat tempo.",
            "Mitigation (Tyrant): Keep 'Fel Barrier' active and use 'Vengeance' on cooldown to gain parry stacks.",
            "Finishers: Spend Felfury at 80+ for maximum finisher value (Slayer Cleave / Engulf / Chaos Finisher).",
        },
        bestZones = { "Stranglethorn Vale", "Tanaris", "Felwood" },
    },

    {
        id = "witch_hunter",
        name = "Witch Hunter",
        role = "DPS (Ranged/Hybrid)",
        resource = "Focus",
        icon = "Interface\\Icons\\Ability_Hunter_MarkedForDeath",
        color = "|cff4a9153",
        difficulty = 2,
        description = "A shadowy monster hunter combining crossbow marksmanship with melee purging blades. Uses Focus to fuel precise shots and arcane-banishing abilities. Very strong against elites.",
        specs = {
            { name = "Inquisitor", role = "DPS", description = "Heavy shadow ranged spec with long-range curses and purge effects." },
            { name = "Ravager", role = "DPS", description = "Aggressive melee/ranged hybrid with devastating close-quarters combos." },
            { name = "Warden", role = "DPS/Support", description = "Crowd control specialist with traps, totems, and anti-magic fields." },
        },
        levelingTips = {
            "Leveling Spec: Inquisitor for efficient ranged kiting and mob tagging.",
            "Priority Stats: Agility > Intellect > Stamina for Inquisitor; Strength > Agility for Ravager.",
            "Always open combat from maximum range to get the ranged damage bonus.",
            "Use 'Mark Target' before every pull — the debuff increases all your damage.",
            "Keep your crossbow/rifle upgraded — it's your primary damage tool.",
            "Warden traps can solo content 2-3 levels above you when placed correctly.",
            "At level 30: 'Shadow Tonic' gives a powerful damage/mobility cooldown.",
            "Dungeon Role: Primary ranged DPS; bring Warden spec for CC-heavy pulls.",
        },
        bestZones = { "Duskwood", "Stranglethorn Vale", "Eastern Plaguelands" },
    },
    {
        id = "necromancer",
        name = "Necromancer",
        role = "DPS / Support",
        resource = "Runic Power",
        icon = "Interface\\Icons\\Spell_Shadow_RaiseDead",
        color = "|cff51c2c5",
        difficulty = 3,
        description = "A master of death magic who raises undead minions and spreads corrupting diseases. Complex but incredibly powerful — your army of undead makes soloing elites trivial.",
        specs = {
            { name = "Reanimation", role = "DPS/Pet", description = "Full pet spec — raise powerful undead champions and direct their assaults." },
            { name = "Death", role = "DPS", description = "Disease and decay specialist. Huge sustained damage through stacking DOTs." },
            { name = "Frost", role = "DPS/Burst", description = "Burst spec using frost runes and bone spikes for high proc-based damage." },
        },
        levelingTips = {
            "Leveling Spec: Reanimation is the strongest for solo leveling — never fight alone.",
            "Priority Stats: Spell Damage > Intellect > Stamina.",
            "Keep your undead minion alive — it's essentially free DPS and a meat shield.",
            "Use 'Corpse Explosion' after kills to deal huge AoE damage to nearby packs.",
            "The Death spec DOT rotation: Apply Plague → Blood Plague → Runic Tap → repeat.",
            "At level 20: Unlock 'Army of the Dead' — situational but devastating for elites.",
            "Runic Power management is key: don't waste it on low-priority spells.",
            "Dungeon Role: Bring as DPS; Reanimation spec adds an extra 'pet tank' for free.",
        },
        bestZones = { "Duskwood", "Hillsbrad Foothills", "Eastern Plaguelands" },
    },
    {
        id = "reaper",
        name = "Reaper",
        role = "DPS / Tank",
        resource = "Reaped Souls",
        icon = "Interface\\Icons\\Spell_Shadow_SoulGem",
        color = "|cffb048b5",
        difficulty = 2,
        description = "A grim harvester of souls who wields dual scythes or a massive polearm to siphon health and essence from their victims. Reaper can harvest souls for powerful spells, unleash necro-bursts, or build armor stacks to act as an unyielding tank.",
        specs = {
            { name = "Harvest", role = "DPS", description = "Dual-wield speed spec utilizing death-mark combos and rapid soul consumption." },
            { name = "Soul", role = "DPS", description = "Sustained magic spec casting shadows, plagues, and summoning brief phantom helpers." },
            { name = "Defiance", role = "Tank", description = "Fortified tank spec using barriers, armor buffs, and active soul shielding." },
        },
        levelingTips = {
            "Leveling Spec: Harvest spec for high melee burst and self-healing on kills.",
            "Priority Stats: Agility > Stamina > Haste (Harvest/Defiance); Intellect > Spell Power (Soul).",
            "Souldrain: Keep 'Reaper's Mark' on your target to passive-drain health during combat.",
            "Shielding (Defiance): Spend Reaped Souls at 5+ stacks to activate Soul Ward, absorbing 25% of all incoming spell damage.",
            "Elites: Use 'Summon Phantom' to distract the target while you channel your heavy execute spell 'Reap Essence'.",
        },
        bestZones = { "Duskwood", "Eastern Plaguelands", "Felwood" },
    },
    {
        id = "tinker",
        name = "Tinker",
        role = "DPS / Support",
        resource = "Energy",
        icon = "Interface\\Icons\\Trade_Engineering",
        color = "|cffffd700",
        difficulty = 2,
        description = "An inventive goblin/gnome engineer who deploys turrets, drops landmines, and pilots a devastating mech suit. Excellent for controlling large groups of enemies.",
        specs = {
            { name = "Battletech", role = "DPS", description = "Full offensive spec — high-damage turrets, laser beams, and rocket barrages." },
            { name = "Medic", role = "Support/Heal", description = "Support spec using repair bots, healing grenades, and mana regeneration devices." },
            { name = "Juggernaut", role = "Tank", description = "Heavy mech suit spec — absorbs massive damage and stomps enemies." },
        },
        levelingTips = {
            "Leveling Spec: Battletech for fastest kill speed solo.",
            "Priority Stats: Intellect > Spirit > Stamina (all spells scale with Intellect).",
            "Place your turrets BEFORE pulling — they start attacking immediately on aggro.",
            "Landmines deal huge damage but require setup time — use at quest objectives.",
            "At level 15: 'Overclock' passive increases turret attack speed significantly.",
            "Juggernaut Mech Suit is a powerful CD — use it for elite quests and dungeon pulls.",
            "Battletech's rocket barrage is exceptional for killing multiple mobs simultaneously.",
            "Dungeon Role: Turrets provide consistent DPS; Medic spec is a strong healer option.",
        },
        bestZones = { "Elwynn Forest", "Stranglethorn Vale", "Tanaris" },
    },
    {
        id = "runemaster",
        name = "Runemaster",
        role = "DPS / Tank",
        resource = "Rune Charges",
        icon = "Interface\\Icons\\Spell_Arcane_RuneStrike",
        color = "|cff2266cc",
        difficulty = 3,
        description = "A rune-inscribed warrior who channels elemental and arcane power through sigils carved into their weapons and armor. Builds Rune Charges and unleashes devastating elemental strikes.",
        specs = {
            { name = "Engravement", role = "Tank", description = "Defensive spec using protective runes to absorb and reflect damage." },
            { name = "Glyphic", role = "Ranged DPS", description = "Caster spec channeling elemental rune power into ranged spells." },
            { name = "Runeblade", role = "Melee DPS", description = "Aggressive melee spec engraving runes of power directly onto weapon strikes." },
        },
        levelingTips = {
            "Leveling Spec: Runeblade for consistent melee output, or Glyphic for safe ranged pulling.",
            "Priority Stats: Strength > Stamina > Spell Power (Glyphic) or Strength > Stamina > Crit (Runeblade).",
            "Queue up Rune Charges before engaging — enter combat at max stacks.",
            "The 'Elemental Brand' debuff is your most important ability — maintain it always.",
            "At level 25: 'Rune Mastery' passive makes Rune Charge generation 30% faster.",
            "Engravement spec makes you nearly unkillable — great for dangerous elite zones and soloing.",
            "Glyphic's Arcane Binding silence is invaluable against caster mobs — use it proactively.",
            "Dungeon Role: Tank with Engravement, caster DPS with Glyphic, melee DPS with Runeblade.",
        },
        bestZones = { "Arathi Highlands", "Burning Steppes", "Eastern Plaguelands" },
    },
    {
        id = "chronomancer",
        name = "Chronomancer",
        role = "DPS / Support",
        resource = "Temporal Energy",
        icon = "Interface\\Icons\\Spell_Holy_Borrowedtime",
        color = "|cff7b68ee",
        difficulty = 3,
        description = "A master of time magic who accelerates allies, slows enemies, and rewinds their own injuries. One of the most unique and complex classes to master.",
        specs = {
            { name = "Acceleration", role = "Support", description = "Haste-based support spec — grants huge speed and attack bonuses to the group." },
            { name = "Temporal Rift", role = "DPS", description = "Damage spec using time-based DoTs, rewinding blasts, and paradox explosions." },
            { name = "Timeless", role = "DPS/Survival", description = "Survival spec using time loops and rewinds to become extremely hard to kill." },
        },
        levelingTips = {
            "Leveling Spec: Temporal Rift — complex but the highest solo damage output.",
            "Priority Stats: Spell Damage > Haste Rating > Intellect.",
            "Time your 'Temporal Flux' slow precisely — it has a cast time and needs setup.",
            "'Rewind' is your emergency heal — save it for dangerous situations only.",
            "Acceleration spec trivializes dungeons — use it for group content whenever possible.",
            "At level 30: 'Chrono Strike' deals damage based on time spent in combat.",
            "Temporal Rift's DOTs stack with each other — maintain all 3 simultaneously.",
            "Dungeon Role: Acceleration provides unparalleled buff support; Rift is DPS.",
        },
        bestZones = { "Stranglethorn Vale", "Feralas", "Winterspring" },
    },
    -- ======================== TANK ========================
    {
        id = "warden",
        name = "Warden",
        role = "Tank / DPS",
        resource = "Resolve",
        icon = "Interface\\Icons\\Ability_Warrior_Defensivestance",
        color = "|cff8B4513",
        difficulty = 2,
        description = "A stalwart guardian who draws strength from enduring punishment. Builds Resolve from taking damage and uses it to empower retaliatory strikes.",
        specs = {
            { name = "Ironclad", role = "Tank", description = "Pure defensive spec with massive armor bonuses and damage reduction abilities." },
            { name = "Retribution", role = "DPS/Tank", description = "Hybrid spec dealing damage proportional to damage absorbed." },
            { name = "Sentinel", role = "Tank", description = "AoE threat spec using ground-based area effects and group-wide shields." },
        },
        levelingTips = {
            "Leveling Spec: Retribution for the best balance of tankiness and kill speed.",
            "Priority Stats: Strength > Stamina > Defense Rating.",
            "Use 'Stalwart Stance' for normal questing — Resolve generates faster.",
            "The 'Counter Blow' ability deals more damage the more you've been hit — save it.",
            "Don't neglect your shield — Warden's damage mitigation relies on it heavily.",
            "At level 20: 'Ironskin' dramatically reduces physical damage — toggle on for elites.",
            "Sentinel spec is ideal for dungeon grinding — maintains AoE threat effortlessly.",
            "Dungeon Role: Primary tank; Ironclad is almost unkillable in instanced content.",
        },
        bestZones = { "The Barrens", "Arathi Highlands", "Burning Steppes" },
    },
    -- ======================== HEALER ========================
    {
        id = "spiritwalker",
        name = "Spiritwalker",
        role = "Healer / Support",
        resource = "Mana / Spirit",
        icon = "Interface\\Icons\\Spell_Nature_HealingTouch",
        color = "|cff00ff7f",
        difficulty = 2,
        description = "A nature-attuned healer who channels spirit totems and healing winds. The Spiritwalker bridges the living and spirit worlds, bringing fallen allies back from the brink.",
        specs = {
            { name = "Restoration", role = "Healer", description = "Full healing spec with powerful HoTs, spirit buffs, and resurrection chains." },
            { name = "Ancestral", role = "Healer/DPS", description = "Hybrid spec dealing moderate damage while maintaining steady healing output." },
            { name = "Stormcaller", role = "DPS", description = "Offensive spec unleashing lightning bolts and chain storms while light-healing." },
        },
        levelingTips = {
            "Leveling Spec: Stormcaller deals enough damage to be viable for solo play.",
            "Priority Stats: Intellect > Spirit > Spell Healing.",
            "Use Restoration only in dungeon finder — solo leveling as Resto is very slow.",
            "Keep 'Spirit Ward' totem active at all times — free healing while you fight.",
            "Ancestral spec is the best leveling hybrid — can solo efficiently and heal dungeons.",
            "At level 25: 'Ancestral Guidance' makes healing trivially easy in 5-mans.",
            "Use 'Earthbind Totem' to kite while waiting for mana to regenerate.",
            "Dungeon Role: Primary or backup healer; Stormcaller provides competitive DPS too.",
        },
        bestZones = { "The Barrens", "Feralas", "Un'Goro Crater" },
    },
}

-- ─────────────────────────────────────────────────────────────────────────────
-- Autopopulate remaining classes to ensure 100% active state for all 21 classes
-- ─────────────────────────────────────────────────────────────────────────────
local ALL_LEVEL_CLASSES = {
    barbarian = { name = "Barbarian", role = "Melee DPS", resource = "Rage", icon = "Interface\\Icons\\Ability_Warrior_SavageBlow", color = "|cffcc2222", specs = { {name="Berserker", role="DPS"}, {name="Wild", role="DPS"}, {name="Chieftain", role="DPS"} } },
    bloodmage = { name = "Bloodmage", role = "Caster DPS / Heal", resource = "Blood Power", icon = "Interface\\Icons\\Spell_Shadow_LifeDrain", color = "|cff990000", specs = { {name="Vitality", role="Healer"}, {name="Crimson", role="DPS"}, {name="Sanguine", role="DPS"} } },
    cultist = { name = "Cultist", role = "Caster DPS", resource = "Void Energy", icon = "Interface\\Icons\\Spell_Shadow_CurseOfTounges", color = "|cff5500aa", specs = { {name="Darkness", role="DPS"}, {name="Shadow", role="DPS"}, {name="Corruption", role="DPS"} } },
    guardian = { name = "Guardian", role = "Tank", resource = "Resolve", icon = "Interface\\Icons\\Ability_Defend", color = "|cff888888", specs = { {name="Defense", role="Tank"}, {name="Protection", role="Tank"}, {name="Valor", role="Tank"} } },
    knight_of_xoroth = { name = "Knight of Xoroth", role = "Melee DPS / Tank", resource = "Chaos Power", icon = "Interface\\Icons\\Spell_Shadow_ShadowWordPain", color = "|cffcc5500", specs = { {name="Destruction", role="DPS"}, {name="Doom", role="DPS"}, {name="Hellfire", role="Tank"} } },
    primalist = { name = "Primalist", role = "DPS / Healer", resource = "Mana", icon = "Interface\\Icons\\Spell_Nature_Rye", color = "|cff11aa88", specs = { {name="Elemental", role="DPS"}, {name="Beast", role="DPS"}, {name="Wildgrowth", role="Healer"} } },
    pyromancer = { name = "Pyromancer", role = "Caster DPS", resource = "Heat", icon = "Interface\\Icons\\Spell_Fire_Fireball02", color = "|cffff3300", specs = { {name="Fire", role="DPS"}, {name="Ember", role="DPS"}, {name="Combustion", role="DPS"} } },
    ranger = { name = "Ranger", role = "Ranged DPS", resource = "Focus", icon = "Interface\\Icons\\Ability_Marksmanship", color = "|cff33aa33", specs = { {name="Marksmanship", role="DPS"}, {name="Survival", role="DPS"}, {name="Beast Master", role="DPS"} } },
    starcaller = { name = "Starcaller", role = "Caster DPS / Heal", resource = "Astral Power", icon = "Interface\\Icons\\Spell_Nature_StarFall", color = "|cff0066ff", specs = { {name="Astral", role="DPS"}, {name="Solar", role="DPS"}, {name="Lunar", role="Healer"} } },
    stormbringer = { name = "Stormbringer", role = "Melee / Caster DPS", resource = "Maelstrom", icon = "Interface\\Icons\\Spell_Nature_Cyclone", color = "|cff00cccc", specs = { {name="Lightning", role="DPS"}, {name="Tempest", role="DPS"}, {name="Thunder", role="DPS"} } },
    sun_cleric = { name = "Sun Cleric", role = "Healer / DPS", resource = "Solar Power", icon = "Interface\\Icons\\Spell_Holy_InnerFire", color = "|cffffcc00", specs = { {name="Light", role="Healer"}, {name="Solar", role="DPS"}, {name="Healing", role="Healer"} } },
    templar = { name = "Templar", role = "Tank / DPS", resource = "Holy Power", icon = "Interface\\Icons\\Spell_Holy_MindVision", color = "|cffddaa22", specs = { {name="Retribution", role="DPS"}, {name="Justice", role="DPS"}, {name="Protection", role="Tank"} } },
    venomancer = { name = "Venomancer", role = "Caster DPS", resource = "Venom", icon = "Interface\\Icons\\Spell_Nature_CorrosiveBreath", color = "|cff22aa22", specs = { {name="Poison", role="DPS"}, {name="Shadow", role="DPS"}, {name="Toxin", role="DPS"} } },
    witch_doctor = { name = "Witch Doctor", role = "Healer / DPS", resource = "Mana", icon = "Interface\\Icons\\Spell_Nature_HealingWaveGreater", color = "|cff8822cc", specs = { {name="Voodoo", role="DPS"}, {name="Hex", role="DPS"}, {name="Healing", role="Healer"} } }
}

for id, def in pairs(ALL_LEVEL_CLASSES) do
    local exists = false
    for _, cls in ipairs(CoALevelGuide_Classes) do
        if cls.id == id then exists = true break end
    end
    if not exists then
        table.insert(CoALevelGuide_Classes, {
            id = id,
            name = def.name,
            role = def.role,
            resource = def.resource,
            icon = def.icon,
            color = def.color,
            difficulty = 2,
            description = "A powerful custom class in Conquest of Azeroth. Excels in " .. def.role .. " roles.",
            specs = def.specs,
            levelingTips = {
                "Use spec-specific abilities to level efficiently.",
                "Prioritize stamina and primary power scaling stats.",
                "Maintain active shields/barriers during multi-mob pulls."
            },
            bestZones = { "Stranglethorn Vale", "Tanaris", "Un'Goro Crater" }
        })
    end
end

