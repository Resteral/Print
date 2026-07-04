-- ============================================================
-- CoALevelGuide - Endgame Gearing Data
-- Step-by-step gear progression guide for level 60 players
-- ============================================================

CoALevelGuide_GearSteps = {
    {
        title = "Phase 1: Entry Level 60 Gearing",
        desc = "Focus on replacing leveling greens with ilvl 58-60 blues to boost your average item level so you can queue for Heroics.",
        tips = {
            "Auction House: Purchase cheap level 60 mail/leather/plate gear to skip early farming.",
            "Call Board Dailies: Do the daily Call Board quests in Orgrimmar or Stormwind. Caches scale with your current average item level.",
            "Normal Dungeons: Run Normal dungeons using Dungeon Finder to collect baseline blues and Marks of Triumph.",
        }
    },
    {
        title = "Phase 2: Heroic Dungeons (ilvl 61+)",
        desc = "Once you reach average ilvl 61, queue for Heroic Dungeons. This is where your actual stat optimization starts.",
        tips = {
            "Badges of Justice: Every boss in Heroic dungeons drops Badges of Justice.",
            "Shattrath Vendor: Take the portal to Shattrath and find G'eras. Spend Badges of Justice on your BiS relic, trinket, and chestpiece.",
        }
    },
    {
        title = "Phase 3: Mythic Dungeons & Keys (ilvl 64+)",
        desc = "Push keystones to scale dungeon difficulty and loot item levels infinitely.",
        tips = {
            "Mythic Keystones: Get your first keystone by completing any Mythic dungeon. Pushing a +2 to +5 keys provides major item level upgrades.",
            "Marks of Ascension: Earned from daily heroic quests and weekly raids. Use them to purchase tier tokens and high-level gear upgrades.",
        }
    },
    {
        title = "Phase 4: Ascended Raids & BiS Enchanting",
        desc = "The final endgame tier. Raid with your guild and optimize every item slot with custom enchants.",
        tips = {
            "Faction Leader Raids: Attack Alliance/Horde leaders for massive weekly rewards.",
            "Scourge Invasions: Complete weekly Scourge portal invasion events for epic shards.",
            "Mystic Enchantments: Apply custom class enchants at the Mystic Alter to boost your rotation mechanics.",
        }
    }
}

CoALevelGuide_PvPGear = {
    phases = {
        {
            title = "Step 1: Honor Starter Gear (Savage / Hateful Gladiator)",
            desc = "Acquire your baseline PvP sets to survive initial encounters. Resilience is mandatory.",
            tips = {
                "Earn Honor: Complete Battleground dailies ('Call to Arms') and weekly PvP quests.",
                "PvP Vendors: Go to the Hall of Legends in Orgrimmar or Champion's Hall in Stormwind to spend Honor.",
                "Offsets: Spend Honor first on Gladiator neck, cloak, wrists, belt, and boots to quickly stack Resilience.",
            }
        },
        {
            title = "Step 2: Arena Entry (Furious Gladiator - ilvl 65+)",
            desc = "Queue Arenas (1v1, 2v2, or 3v3) to earn Arena Points. Rating requirements start here.",
            tips = {
                "Gloves & Shoulders: Gloves require a 1550 arena rating. Shoulders require 2050 rating.",
                "Arena Vendors: Spend Arena Points at the Arena vendors in Orgrimmar, Stormwind, or Shattrath.",
            }
        },
        {
            title = "Step 3: Best-in-Slot PvP (Relentless / Wrathful Gladiator - ilvl 70+)",
            desc = "The ultimate competitive PvP set. Requires high arena ratings to purchase.",
            tips = {
                "Wrathful Weapons: Reach 2200 rating to unlock the BiS PvP weapons.",
                "Gems & Enchants: Socket full Stamina/Resilience gems and apply PvP-specific enchantments.",
            }
        }
    },
    comparison = {
        { stat = "Resilience", pvp = "High (Reduces incoming player damage by up to 30%)", pve = "None (You will get instant-killed / globalled)" },
        { stat = "Stamina", pvp = "Very High (Provides survival buffer against player burst)", pve = "Moderate (Optimized for pure dps outputs)" },
        { stat = "Hit Rating", pvp = "Low Cap (5% melee / 4% spell is all that's required)", pve = "High Cap (Requires 8% melee / 17% spell for raid bosses)" },
        { stat = "Damage Output", pvp = "Moderate-High (Balanced with survival stats)", pve = "Maximum (No slot stats wasted on survival)" }
    }
}

-- Class-Specific Best in Slot Gearing Guide (Supports all 21 classes)
CoALevelGuide_ClassBiS = {
    felsworn = {
        pve_stats = "Agility > Stamina > Melee Hit (5% cap) > Crit (Slayer) or Spell Power > Intellect (Infernal)",
        pvp_stats = "Resilience > Agility > Stamina > Melee Hit (5%) > AP",
        bis_weapon = "Wrathful Gladiator's Fel Scythe (PvP 2200) / Void-Injected Blade (BRD Dungeon)",
        drop_loc = "PvP Arena Vendor (Orgrimmar) / General Angerforge in Blackrock Depths (PvE)"
    },
    necromancer = {
        pve_stats = "Spell Damage > Intellect > Spell Hit (17% cap) > Haste > Critical Strike",
        pvp_stats = "Resilience > Spell Power > Intellect > Spell Hit (4% cap) > Stamina",
        bis_weapon = "Staff of the Lich King (Icecrown Citadel) / Wrathful Gladiator's Bone Staff",
        drop_loc = "Lich King boss drop (PvE) / PvP Arena Vendor (Orgrimmar) (PvP)"
    },
    witch_hunter = {
        pve_stats = "Agility > Attack Power > Physical Hit (8% cap) > Critical Strike",
        pvp_stats = "Resilience > Agility > Stamina > Physical Hit (5% cap)",
        bis_weapon = "Purging Crossbow of the Warden / Wrathful Gladiator's Heavy Crossbow",
        drop_loc = "Eastwall Towers elite cache (PvE) / PvP Arena Vendor (PvP)"
    },
    tinker = {
        pve_stats = "Intellect > Spell Power > Haste > Spirit (Medic) or Stamina > Armor (Juggernaut)",
        pvp_stats = "Resilience > Intellect > Stamina > Spell Power",
        bis_weapon = "Titan-Steel Rocket launcher (Crafted Woodworking/Engi) / Wrathful Rifle",
        drop_loc = "Crafted by high-level Engineers (PvE) / PvP Arena Vendor (PvP)"
    },
    runemaster = {
        pve_stats = "Strength > Stamina > Defense (Inscription) or Strength > Crit > AP (Runic Fury)",
        pvp_stats = "Resilience > Strength > Stamina > Melee Hit (5% cap)",
        bis_weapon = "Rune-Carved Claymore / Wrathful Greatsword",
        drop_loc = "Molten Core Firelord Boss (PvE) / PvP Arena Vendor (PvP)"
    },
    chronomancer = {
        pve_stats = "Spell Power > Haste > Intellect > Spirit",
        pvp_stats = "Resilience > Spell Power > Intellect > Haste",
        bis_weapon = "Temporal Chrono-Scepter (Shattrath Badge) / Wrathful Mageblade",
        drop_loc = "G'eras Badge Vendor in Shattrath (PvE) / PvP Arena Vendor (PvP)"
    },
    reaper = {
        pve_stats = "Agility > Stamina > Crit > Hit (Harvest) or Agility > Dodge > Armor (Defiance)",
        pvp_stats = "Resilience > Agility > Stamina > Spell Penetration (130 min)",
        bis_weapon = "Harvest Scythe of the Lich / Wrathful Gladiator's Reaper",
        drop_loc = "Raid World Boss (PvE) / PvP Arena Vendor (PvP)"
    }
}

-- Autopopulate remaining classes to ensure 100% active state for all 21 classes
local default_bis_classes = {
    "barbarian", "bloodmage", "cultist", "guardian", "knight_of_xoroth",
    "primalist", "pyromancer", "ranger", "starcaller", "stormbringer",
    "sun_cleric", "templar", "venomancer", "witch_doctor"
}

for _, cid in ipairs(default_bis_classes) do
    if not CoALevelGuide_ClassBiS[cid] then
        CoALevelGuide_ClassBiS[cid] = {
            pve_stats = "Primary Stat > Spell Power / Attack Power > Crit > Haste > Raid Hit Cap",
            pvp_stats = "Resilience > Primary Stat > Stamina > PvP Hit Cap (5%)",
            bis_weapon = "Wrathful Gladiator's Weapon (PvP) / Tier-Specific Raid Weapon (PvE)",
            drop_loc = "PvP Arena Vendor (Orgrimmar/Stormwind) / Level 60 raid drops"
        }
    end
end

CoALevelGuide_LowerLevelGear = {
    {
        levelRange = "Levels 10-19",
        title = "Level 10-19 BiS — Deadmines & Wailing Caverns",
        items = {
            "Weapon (Melee): Cruel Barb (Edwin VanCleef - Deadmines)",
            "Weapon (Caster): Crescent Staff (Fang Quest - Wailing Caverns)",
            "Weapon (Ranged): Silver-Plated Shotgun (Crafted Engineering)",
            "Armor Set: Blackened Defias Armor (Leather - Deadmines)",
            "Trinket: Arena Grand Master (Gurubashi Arena Booty Run)"
        }
    },
    {
        levelRange = "Levels 20-29",
        title = "Level 20-29 BiS — Shadowfang Keep & BFD",
        items = {
            "Weapon (Melee): Butcher's Slicer (Razorclaw - Shadowfang Keep)",
            "Weapon (Caster): Meteor Shard (Archmage Arugal - Shadowfang Keep)",
            "Weapon (Shield): Commander's Crest (Commander Springvale - SFK)",
            "Armor (Chest): Armor of Westfall (Deadmines quest reward)",
            "Ring: Seal of Wrynn / Seal of Sylvanas (Faction questlines)"
        }
    },
    {
        levelRange = "Levels 30-39",
        title = "Level 30-39 BiS — Scarlet Monastery & Gnomeregan",
        items = {
            "Weapon (Melee): Ravager 2H Axe (Herod - SM Armory) or Mograine's Might (SM Cath)",
            "Weapon (Caster): Illusionary Rod (Arcanist Doan - SM Library)",
            "Weapon (2H Melee): Thermaplugg's Left Arm (Thermaplugg - Gnomeregan)",
            "Neck: Triune Amulet (High Inquisitor Whitemane - SM Cathedral)",
            "Shoulders: Herod's Shoulder (Herod - SM Armory)"
        }
    },
    {
        levelRange = "Levels 40-49",
        title = "Level 40-49 BiS — Zul'Farrak & Maraudon",
        items = {
            "Weapon (Melee): Sul'thraze the Lasher (Combine swords - Zul'Farrak)",
            "Weapon (Caster): Inventor's Focal Sword (Tinkerer Gizlock - Maraudon)",
            "Trinket: Mark of the Chosen (Maraudon quest - The Pariah's Instructions)",
            "Armor (Hands): Gauntlets of the Sea (Crafted Blacksmithing)",
            "Helm: Raging Berserker's Helm (Herod - SM Armory)"
        }
    },
    {
        levelRange = "Levels 50-59",
        title = "Level 50-59 BiS — Sunken Temple & Blackrock Depths",
        items = {
            "Trinket (Physical): Hand of Justice (General Angerforge - BRD)",
            "Weapon (Melee): Ironfoe 1H Mace (Emperor Dagran Thaurissan - BRD)",
            "Weapon (Caster): Firemote Staff (Crafted/ST Dungeon)",
            "Armor (Chest): Savage Gladiator Chain (Ring of Law - BRD)",
            "Ring: Blackstone Band (Princess Theradras - Maraudon)"
        }
    }
}

CoALevelGuide_Professions = {
    {
        name = "Engineering (Top Tier Utility)",
        desc = "The best choice for both PvP & PvE. Offers unparalleled glove haste enchants, nitro boots, and bombs.",
        bonus = "Glove Haste (+340 Haste for 12s on use)  •  Nitro Boosts (movement speed)  •  Frag Belt (ranged stun)"
    },
    {
        name = "Jewelcrafting (Highest Stat Gains)",
        desc = "Allows socketing 3 powerful Chimera's Eye gems (+34 Agility / +34 Intellect / +34 Resilience).",
        bonus = "Chimera's Eyes (socket 3x custom high-stat gems of your choice)"
    },
    {
        name = "Woodworking (Custom CoA Relics)",
        desc = "Custom CoA primary profession. Allows crafting caster staves and unique class relics that speed up resource gains.",
        bonus = "Class-specific relics (boosts Felfury / Runic Power generation rates)"
    },
    {
        name = "Leatherworking (Armor Crafting)",
        desc = "Perfect for Felsworn, Reaper, and Witch Hunter. Allows crafting epic leather sets and custom wrist fur lining.",
        bonus = "Fur Lining (Wrist: +130 Attack Power / +76 Spell Power)"
    },
    {
        name = "Inscription (Shoulder Enchants)",
        desc = "Provides master-tier shoulder enchants, saving you from having to farm reputation with Sons of Hodir.",
        bonus = "Master's Inscription (Shoulder: +120 Attack Power / +70 Spell Power)"
    }
}
