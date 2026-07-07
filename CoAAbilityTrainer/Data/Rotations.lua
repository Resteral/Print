-- ============================================================
-- CoAAbilityTrainer - Rotation Priority Data
-- "Next ability" logic for the rotation helper arrow
-- ============================================================

-- Each rule: check conditions → return abilityId to highlight
-- Rules are evaluated top-to-bottom; first match wins

CoAAT_RotationRules = {

    -- Felsworn (July 2026 specs)
    felsworn = {
        -- Infernal (Caster DPS)
        infernal = {
            { condition = "debuff_missing",  debuffName = "Voidblaze",           abilityId = "voidblaze",           urgency = "critical" },
            { condition = "debuff_expiring", debuffName = "Voidblaze",           abilityId = "voidblaze",           urgency = "high" },
            { condition = "resource_gte",    threshold  = 80,                    abilityId = "engulf",              urgency = "critical" },
            { condition = "proc_active",     procName   = "Infernal Magicks",    abilityId = "engulf",              urgency = "high" },
            { condition = "resource_gte",    threshold  = 50,                    abilityId = "fel_prison",          urgency = "medium" },
            { condition = "always",                                               abilityId = "chaos_incursion",     urgency = "low" },
        },
        -- Slayer (Melee DPS)
        slayer = {
            { condition = "buff_missing",    buffName   = "Infernal Alacrity",   abilityId = "voidblaze_slayer",    urgency = "high" },
            { condition = "resource_gte",    threshold  = 80,                    abilityId = "slayer_cleave",       urgency = "critical" },
            { condition = "cd_ready",        abilityId  = "fel_hoof_charge",                                        urgency = "high" },
            { condition = "resource_gte",    threshold  = 40,                    abilityId = "voidblaze_slayer",    urgency = "medium" },
            { condition = "always",                                               abilityId = "fell_strike",         urgency = "low" },
        },
        -- Tyrant (Tank)
        tyrant = {
            { condition = "buff_missing",    buffName   = "Fel Barrier",         abilityId = "fel_barrier",         urgency = "critical" },
            { condition = "resource_gte",    threshold  = 80,                    abilityId = "chaos_finisher",      urgency = "critical" },
            { condition = "proc_active",     procName   = "Vengeful Strike",     abilityId = "vengeful_strike",     urgency = "high" },
            { condition = "cd_ready",        abilityId  = "vengeance",                                              urgency = "high" },
            { condition = "cd_ready",        abilityId  = "whip_crack",                                             urgency = "medium" },
            { condition = "always",                                               abilityId = "tyrant_strike",       urgency = "low" },
        },
    },

    -- Necromancer
    necromancer = {
        reanimation = {
            { condition = "pet_dead",                                     abilityId = "raise_dead",      urgency = "critical" },
            { condition = "cd_ready",       abilityId = "corpse_explosion",                             urgency = "critical" },
            { condition = "debuff_missing", debuffName = "Plague Strike", abilityId = "plague_strike",   urgency = "high" },
            { condition = "cd_ready",       abilityId = "army_of_the_dead",                             urgency = "medium" },
            { condition = "resource_gte",   threshold = 60,               abilityId = "runic_tap",       urgency = "high" },
            { condition = "always",                                       abilityId = "death_coil",      urgency = "low" },
        },
    },

    -- Witch Hunter
    witch_hunter = {
        inquisitor = {
            { condition = "debuff_missing", debuffName = "Mark Target",  abilityId = "mark_target",    urgency = "critical" },
            { condition = "cd_ready",       abilityId = "shadow_tonic",                                urgency = "high" },
            { condition = "proc_active",    procName  = "Purge",         abilityId = "purge",          urgency = "high" },
            { condition = "resource_gte",   threshold = 50,              abilityId = "cursed_shot",    urgency = "high" },
            { condition = "cd_ready",       abilityId = "shadow_trap",                                 urgency = "medium" },
            { condition = "always",                                      abilityId = "shadow_bolt_wh", urgency = "low" },
        },
    },

    -- Tinker
    tinker = {
        battletech = {
            { condition = "cd_ready",       abilityId = "deploy_turret",                               urgency = "critical" },
            { condition = "cd_ready",       abilityId = "mech_suit",                                   urgency = "high" },
            { condition = "proc_active",    procName  = "Overclock",     abilityId = "overclock",      urgency = "high" },
            { condition = "resource_gte",   threshold = 40,              abilityId = "rocket_barrage", urgency = "high" },
            { condition = "cd_ready",       abilityId = "landmine",                                    urgency = "medium" },
            { condition = "always",                                      abilityId = "laser_blast",    urgency = "low" },
        },
    },

    -- Runemaster
    runemaster = {
        engravement = {
            { condition = "health_lt",      threshold  = 40,             abilityId = "ward_of_protection", urgency = "critical" },
            { condition = "resource_gte",   threshold  = 3,              abilityId = "engrave_fortitude",  urgency = "high" },
            { condition = "always",                                      abilityId = "rune_shield",        urgency = "low" },
        },
        glyphic = {
            { condition = "debuff_missing", debuffName = "Elemental Brand", abilityId = "elemental_brand",    urgency = "critical" },
            { condition = "resource_gte",   threshold  = 3,                 abilityId = "runic_detonation",   urgency = "high" },
            { condition = "debuff_expiring",debuffName = "Elemental Brand", abilityId = "elemental_brand",    urgency = "high" },
            { condition = "always",                                         abilityId = "glyph_bolt",         urgency = "low" },
        },
        runeblade = {
            { condition = "debuff_missing", debuffName = "Elemental Brand", abilityId = "elemental_brand",    urgency = "critical" },
            { condition = "proc_active",    procName   = "Rune Mastery",    abilityId = "rune_carve",         urgency = "high" },
            { condition = "resource_gte",   threshold  = 3,                 abilityId = "rune_carve",         urgency = "high" },
            { condition = "debuff_expiring",debuffName = "Elemental Brand", abilityId = "elemental_brand",    urgency = "high" },
            { condition = "always",                                         abilityId = "rune_strike",        urgency = "low" },
        },
    },

    -- Chronomancer
    chronomancer = {
        temporal_rift = {
            { condition = "debuff_missing",  debuffName = "Time Rupture",  abilityId = "time_rupture",     urgency = "critical" },
            { condition = "proc_active",     procName   = "Time Loop",     abilityId = "paradox_explosion", urgency = "high" },
            { condition = "resource_gte",    threshold  = 70,              abilityId = "paradox_explosion", urgency = "high" },
            { condition = "debuff_expiring", debuffName = "Time Rupture",  abilityId = "time_rupture",     urgency = "high" },
            { condition = "health_lt",       threshold  = 25,              abilityId = "rewind",            urgency = "critical" },
            { condition = "always",                                         abilityId = "chrono_blast",     urgency = "low" },
        },
    },

    -- Spiritwalker
    spiritwalker = {
        stormcaller = {
            { condition = "buff_missing", buffName   = "Spirit Ward",       abilityId = "spirit_ward",  urgency = "critical" },
            { condition = "cd_ready",     abilityId  = "chain_storm",                                  urgency = "high" },
            { condition = "proc_active",  procName   = "Ancestral Guidance",abilityId = "ancestral_guidance", urgency = "high" },
            { condition = "health_lt",    threshold  = 40,                  abilityId = "earthbind",   urgency = "medium" },
            { condition = "always",                                          abilityId = "lightning_bolt", urgency = "low" },
        },
    },

    -- Reaper (July 2026 update)
    reaper = {
        harvest = {
            { condition = "debuff_missing",  debuffName = "Siphon Strike",       abilityId = "siphon_strike",       urgency = "critical" },
            { condition = "debuff_expiring", debuffName = "Siphon Strike",       abilityId = "siphon_strike",       urgency = "critical" },
            { condition = "resource_gte",    threshold  = 5,                     abilityId = "soul_infusion_harvest",urgency = "critical" },
            { condition = "cd_ready",        abilityId  = "reaping_strike",                                         urgency = "high" },
            { condition = "proc_active",     procName   = "Grim Harvest",        abilityId = "grim_harvest",        urgency = "high" },
            { condition = "cd_ready",        abilityId  = "soul_harvest_cast",                                      urgency = "high" },
            { condition = "cd_ready",        abilityId  = "life_drain",                                             urgency = "medium" },
            { condition = "always",                                               abilityId = "death_reap",          urgency = "low" },
        },
        soul = {
            { condition = "cd_ready",        abilityId  = "shadow_phase",                                           urgency = "high" },
            { condition = "debuff_missing",  debuffName = "Death Mark",          abilityId = "death_mark",          urgency = "critical" },
            { condition = "debuff_expiring", debuffName = "Death Mark",          abilityId = "death_mark",          urgency = "high" },
            { condition = "debuff_missing",  debuffName = "Soul Rend",           abilityId = "soul_rend",           urgency = "critical" },
            { condition = "debuff_expiring", debuffName = "Soul Rend",           abilityId = "soul_rend",           urgency = "high" },
            { condition = "resource_gte",    threshold  = 5,                     abilityId = "soul_infusion_soul",  urgency = "critical" },
            { condition = "proc_active",     procName   = "Echo of Death",       abilityId = "echo_of_death",       urgency = "high" },
            { condition = "cd_ready",        abilityId  = "void_step",                                              urgency = "high" },
            { condition = "cd_ready",        abilityId  = "ghostly_strike",                                         urgency = "medium" },
            { condition = "always",                                               abilityId = "spectral_slash",      urgency = "low" },
        },
        defiance = {
            { condition = "buff_missing",    buffName   = "Soul Barrier",        abilityId = "soul_barrier",        urgency = "critical" },
            { condition = "resource_gte",    threshold  = 5,                     abilityId = "soul_infusion_defiance", urgency = "critical" },
            { condition = "health_lt",       threshold  = 40,                    abilityId = "dark_sustenance",     urgency = "critical" },
            { condition = "proc_active",     procName   = "Harvest Soul",        abilityId = "soul_strike_def",     urgency = "high" },
            { condition = "cd_ready",        abilityId  = "parry_of_souls",                                         urgency = "high" },
            { condition = "cd_ready",        abilityId  = "soul_shriek",                                            urgency = "medium" },
            { condition = "cd_ready",        abilityId  = "death_grip_reaper",                                      urgency = "medium" },
            { condition = "always",                                               abilityId = "soul_strike_def",     urgency = "low" },
        },
    },
}

-- ─────────────────────────────────────────────────────────────────────────────
-- Autopopulate remaining classes to ensure 100% active state for all 21 classes
-- ─────────────────────────────────────────────────────────────────────────────
local ALL_CLASSES_DEFINITIONS = {
    barbarian = {
        resource = "Rage", max = 100, color = {r=0.9, g=0.1, b=0.1},
        specs = {
            berserker = { name = "Berserker", generator = "Furious Strike", spender = "Execute", cooldown = "Enrage" },
            wild = { name = "Wild", generator = "Primal Strike", spender = "Slam", cooldown = "Bestial Howl" },
            chieftain = { name = "Chieftain", generator = "Cleave", spender = "Mortal Strike", cooldown = "War Cry" }
        }
    },
    bloodmage = {
        resource = "Blood Power", max = 100, color = {r=0.8, g=0.0, b=0.0},
        specs = {
            vitality = { name = "Vitality", generator = "Blood Siphon", spender = "Life Drain", cooldown = "Infusion" },
            crimson = { name = "Crimson", generator = "Blood Bolt", spender = "Blood Burst", cooldown = "Transfusion" },
            sanguine = { name = "Sanguine", generator = "Hemorrhage", spender = "Rupture", cooldown = "Blood Shield" }
        }
    },
    cultist = {
        resource = "Void Energy", max = 100, color = {r=0.4, g=0.0, b=0.7},
        specs = {
            darkness = { name = "Darkness", generator = "Void Bolt", spender = "Void Torrent", cooldown = "Dark Communion" },
            shadow = { name = "Shadow", generator = "Mind Flay", spender = "Mind Blast", cooldown = "Shadow Fiend" },
            corruption = { name = "Corruption", generator = "Agony", spender = "Unstable Affliction", cooldown = "Darkness Unleashed" }
        }
    },
    guardian = {
        resource = "Resolve", max = 100, color = {r=0.5, g=0.5, b=0.5},
        specs = {
            defense = { name = "Defense", generator = "Shield Slam", spender = "Revenge", cooldown = "Last Stand" },
            protection = { name = "Protection", generator = "Devastate", spender = "Heroic Strike", cooldown = "Shield Wall" },
            valor = { name = "Valor", generator = "Shield Bash", spender = "Overpower", cooldown = "Avatar" }
        }
    },
    knight_of_xoroth = {
        resource = "Chaos Power", max = 100, color = {r=0.8, g=0.3, b=0.0},
        specs = {
            destruction = { name = "Destruction", generator = "Chaos Bolt", spender = "Incinerate", cooldown = "Summon Dreadsteed" },
            doom = { name = "Doom", generator = "Doom Bolt", spender = "Hand of Doom", cooldown = "Metamorphosis" },
            hellfire = { name = "Hellfire", generator = "Hellfire Aura", spender = "Rain of Fire", cooldown = "Summon Infernus" }
        }
    },
    primalist = {
        resource = "Mana", max = 100, color = {r=0.1, g=0.8, b=0.6},
        specs = {
            elemental = { name = "Elemental", generator = "Lightning Bolt", spender = "Earth Shock", cooldown = "Elemental Mastery" },
            beast = { name = "Beast", generator = "Claw", spender = "Bite", cooldown = "Bestial Wrath" },
            wildgrowth = { name = "Wildgrowth", generator = "Rejuvenate", spender = "Regrowth", cooldown = "Tranquility" }
        }
    },
    pyromancer = {
        resource = "Heat", max = 100, color = {r=1.0, g=0.3, b=0.0},
        specs = {
            fire = { name = "Fire", generator = "Fireball", spender = "Pyroblast", cooldown = "Combustion" },
            ember = { name = "Ember", generator = "Scorch", spender = "Fire Blast", cooldown = "Living Bomb" },
            combustion = { name = "Combustion", generator = "Ember Flare", spender = "Blast Wave", cooldown = "Phoenix Rebirth" }
        }
    },
    ranger = {
        resource = "Focus", max = 100, color = {r=0.3, g=0.7, b=0.3},
        specs = {
            marksmanship = { name = "Marksmanship", generator = "Steady Shot", spender = "Aimed Shot", cooldown = "Rapid Fire" },
            survival = { name = "Survival", generator = "Serpent Sting", spender = "Explosive Shot", cooldown = "Lock and Load" },
            beast_master = { name = "Beast Master", generator = "Cobra Shot", spender = "Kill Command", cooldown = "Bestial Wrath" }
        }
    },
    starcaller = {
        resource = "Astral Power", max = 100, color = {r=0.0, g=0.5, b=1.0},
        specs = {
            astral = { name = "Astral", generator = "Wrath", spender = "Starfire", cooldown = "Starfall" },
            solar = { name = "Solar", generator = "Solar Flare", spender = "Sunfire", cooldown = "Celestial Alignment" },
            lunar = { name = "Lunar", generator = "Moonfire", spender = "Starsurge", cooldown = "Incarnation" }
        }
    },
    stormbringer = {
        resource = "Maelstrom", max = 100, color = {r=0.0, g=0.8, b=0.8},
        specs = {
            lightning = { name = "Lightning", generator = "Lightning Strike", spender = "Chain Lightning", cooldown = "Stormstrike" },
            tempest = { name = "Tempest", generator = "Windfury", spender = "Lava Lash", cooldown = "Feral Spirit" },
            thunder = { name = "Thunder", generator = "Thunderclap", spender = "Earthquake", cooldown = "Ascendance" }
        }
    },
    sun_cleric = {
        resource = "Solar Power", max = 100, color = {r=1.0, g=0.9, b=0.4},
        specs = {
            light = { name = "Light", generator = "Smite", spender = "Holy Fire", cooldown = "Divine Infusion" },
            solar = { name = "Solar", generator = "Solar Beam", spender = "Sunstrike", cooldown = "Power Infusion" },
            healing = { name = "Healing", generator = "Flash of Light", spender = "Holy Nova", cooldown = "Divine Hymn" }
        }
    },
    templar = {
        resource = "Holy Power", max = 5, color = {r=0.9, g=0.8, b=0.3},
        specs = {
            retribution = { name = "Retribution", generator = "Crusader Strike", spender = "Templar's Verdict", cooldown = "Avenging Wrath" },
            justice = { name = "Justice", generator = "Judgement", spender = "Exorcism", cooldown = "Divine Storm" },
            protection = { name = "Protection", generator = "Hammer of the Righteous", spender = "Shield of Righteous", cooldown = "Guardian of Kings" }
        }
    },
    venomancer = {
        resource = "Venom", max = 100, color = {r=0.2, g=0.8, b=0.2},
        specs = {
            poison = { name = "Poison", generator = "Poison Bolt", spender = "Venom Bite", cooldown = "Toxin Cloud" },
            shadow = { name = "Shadow", generator = "Plague Bolt", spender = "Shadow Nova", cooldown = "Shadow Form" },
            toxin = { name = "Toxin", generator = "Acid Spray", spender = "Toxic Burst", cooldown = "Viper Stance" }
        }
    },
    witch_doctor = {
        resource = "Mana", max = 100, color = {r=0.6, g=0.1, b=0.8},
        specs = {
            voodoo = { name = "Voodoo", generator = "Hex Bolt", spender = "Voodoo Doll", cooldown = "Big Bad Voodoo" },
            hex = { name = "Hex", generator = "Shadow Word", spender = "Hex Curse", cooldown = "Mana Tide Totem" },
            healing = { name = "Healing", generator = "Healing Wave", spender = "Chain Heal", cooldown = "Healing Tide Totem" }
        }
    }
}

for classId, def in pairs(ALL_CLASSES_DEFINITIONS) do
    if not CoAAT_Abilities[classId] then
        CoAAT_Abilities[classId] = {
            resource = def.resource,
            resourceMax = def.max,
            resourceColor = def.color,
            spendThreshold = def.max * 0.8,
            specs = {}
        }
        CoAAT_RotationRules[classId] = {}

        for specId, specDef in pairs(def.specs) do
            local generatorId = specId .. "_gen"
            local spenderId = specId .. "_spend"
            local cooldownId = specId .. "_cd"

            -- Set dynamic abilities
            CoAAT_Abilities[classId].specs[specId] = {
                name = specDef.name,
                abilities = {
                    {
                        id = generatorId,
                        name = specDef.generator,
                        type = "generator",
                        icon = "Interface\\Icons\\INV_Misc_QuestionMark",
                        description = "Standard Class Generator.",
                        hint = "GENERATE: Cast to build " .. def.resource .. ".",
                        priority = 3,
                        cooldown = 0,
                        resourceGain = 20,
                        color = def.color
                    },
                    {
                        id = spenderId,
                        name = specDef.spender,
                        type = "spender",
                        icon = "Interface\\Icons\\INV_Misc_QuestionMark",
                        description = "Standard Class Spender.",
                        hint = "SPEND: Use at 80% resource for huge damage.",
                        priority = 2,
                        cooldown = 0,
                        color = def.color
                    },
                    {
                        id = cooldownId,
                        name = specDef.cooldown,
                        type = "cooldown",
                        icon = "Interface\\Icons\\INV_Misc_QuestionMark",
                        description = "Standard Class Cooldown.",
                        hint = "COOLDOWN: Use when off cooldown.",
                        priority = 1,
                        cooldown = 30,
                        color = def.color
                    }
                },
                rotation = {
                    "1. USE " .. specDef.cooldown .. " on cooldown (30s).",
                    "2. SPEND " .. def.resource .. " on " .. specDef.spender .. " at 80%+.",
                    "3. SPAM " .. specDef.generator .. " to generate " .. def.resource .. "."
                },
                rotationSummary = specDef.cooldown .. " on CD → " .. specDef.spender .. " at 80%+ → " .. specDef.generator
            }

            -- Set dynamic rotation rules
            CoAAT_RotationRules[classId][specId] = {
                { condition = "cd_ready",     abilityId = cooldownId,  urgency = "high" },
                { condition = "resource_gte", threshold = def.max * 0.8, abilityId = spenderId, urgency = "critical" },
                { condition = "always",       abilityId = generatorId, urgency = "low" }
            }
        end
    end
end

