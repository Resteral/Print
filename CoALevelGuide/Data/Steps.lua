-- ============================================================
-- CoALevelGuide - Step Data
-- Detailed step-by-step questing guide for 1-60
-- Each step has: type, text, optional coords (x,y), zone, and optional notes
-- ============================================================

-- Step types: "quest_get", "quest_turn", "kill", "travel", "dungeon", "explore", "tip"
CoALevelGuide_Steps = {
    -- ========================================
    -- PHASE 1: 1-10 (Alliance: Elwynn Forest)
    -- ========================================
    {
        phase = 1,
        title = "Phase 1: Alliance 1-10 — Elwynn Forest",
        faction = "Alliance",
        minLevel = 1,
        maxLevel = 10,
        steps = {
            { id=1,  type="tip",        text="Open your quest log (default: L). Make sure 'Ascension Guide Quests' appear — follow these if you get stuck." },
            { id=2,  type="quest_get",  text="Accept all quests from Marshal McBride in Northshire Abbey.", zone="Elwynn Forest", x=47.1, y=41.6 },
            { id=3,  type="kill",       text="Kill Kobold Vermin & Laborers around Northshire Valley. Loot everything.", zone="Elwynn Forest" },
            { id=4,  type="quest_turn", text="Turn in: Kobold Candles, Bounty on Garrick Padfoot, Report to Goldshire.", zone="Elwynn Forest", x=47.1, y=41.6 },
            { id=5,  type="travel",     text="Head south to Goldshire. Pick up ALL quests from NPCs at the inn and town square.", zone="Elwynn Forest", x=43.5, y=65.8 },
            { id=6,  type="quest_get",  text="Pick up: A Fishy Peril, Wolves Across the Border, Gold Dust Exchange, Lost Necklace.", zone="Elwynn Forest", x=43.5, y=65.8 },
            { id=7,  type="kill",       text="Kill Young Wolves south of Goldshire (40,72-75). Also kill Young Forest Bears.", zone="Elwynn Forest", x=42.0, y=72.0 },
            { id=8,  type="explore",    text="Visit the Fargodeep Mine (38,82) — kill Kobolds inside and collect Gold Dust.", zone="Elwynn Forest", x=38.0, y=82.0 },
            { id=9,  type="kill",       text="Kill Murlocs along Stone Cairn Lake for the Murloc quest. Take the necklace.", zone="Elwynn Forest", x=64.0, y=50.0 },
            { id=10, type="quest_turn", text="Return to Goldshire. Turn in all quests. Take follow-ups.", zone="Elwynn Forest", x=43.5, y=65.8 },
            { id=11, type="quest_get",  text="Pick up quests from Stormwind (Elwynn side): The Sawmill, Elmore's Task, Cloth Collection.", zone="Elwynn Forest" },
            { id=12, type="kill",       text="Kill Defias Bandits near Jasperlode Mine (63,49). Complete cloth and badge collection.", zone="Elwynn Forest", x=63.0, y=49.0 },
            { id=13, type="explore",    text="Enter Jasperlode Mine. Kill Kobolds inside until level 7-8.", zone="Elwynn Forest", x=66.2, y=46.0 },
            { id=14, type="tip",        text="TIP: By level 8, head northwest to Westfall or stay for the Stormwind quests (Tradesman's Terrace) for XP bonus." },
            { id=15, type="quest_turn", text="Turn in all remaining Elwynn quests. Grab your level 10 class ability upgrade.", zone="Elwynn Forest" },
        },
    },
    -- ========================================
    -- PHASE 2: 10-20 (Alliance: Westfall)
    -- ========================================
    {
        phase = 2,
        title = "Phase 2: Alliance 10-20 — Westfall",
        faction = "Alliance",
        minLevel = 10,
        maxLevel = 20,
        steps = {
            { id=1,  type="travel",     text="Travel to Westfall via the road south from Elwynn. Take the flight path from Sentinel Hill.", zone="Westfall", x=56.6, y=47.8 },
            { id=2,  type="quest_get",  text="Accept ALL quests at Sentinel Hill: The Defias Brotherhood, Furlbrow's Deed, What Comes Around, Poor Old Blanchy, Westfall Stew.", zone="Westfall", x=56.6, y=47.8 },
            { id=3,  type="kill",       text="Kill Harvest Golems (52,30) for Mechanical parts and quest items.", zone="Westfall", x=52.0, y=30.0 },
            { id=4,  type="kill",       text="Kill Dust Devils east of Sentinel Hill for the Dust Devil quest (62,55).", zone="Westfall", x=62.0, y=55.0 },
            { id=5,  type="kill",       text="Kill Defias Pillagers and Looters (35-45,40-60 area) — required for Defias Brotherhood chain.", zone="Westfall", x=40.0, y=50.0 },
            { id=6,  type="explore",    text="Visit Alexia Ironknife in Moonbrook (27,67) to advance the Defias chain.", zone="Westfall", x=27.0, y=67.0 },
            { id=7,  type="quest_get",  text="Pick up the WANTED: VanCleef quest from the Sentinel Hill notice board.", zone="Westfall", x=56.0, y=47.0 },
            { id=8,  type="kill",       text="Kill Defias Encampment mobs in and around Moonbrook for questlines and XP.", zone="Westfall", x=27.0, y=67.0 },
            { id=9,  type="quest_turn", text="Return to Sentinel Hill. Turn in: Defias Brotherhood, Furlbrow's Deed, completed collections.", zone="Westfall", x=56.6, y=47.8 },
            { id=10, type="dungeon",    text="DUNGEON: The Deadmines (Westfall Mine entrance, 23,91) at level 17+. Bring VanCleef WANTED quest!", zone="Westfall", x=23.0, y=91.0 },
            { id=11, type="tip",        text="TIP: Deadmines gives great gear and huge XP. Run it 1-2 times before moving to Redridge at 18-20." },
            { id=12, type="tip",        text="IMPORTANT: At level 10 you unlocked your class Specialization! Visit your trainer and make your spec choice now." },
        },
    },
    -- ========================================
    -- PHASE 3: 20-30 (Alliance: Redridge & Duskwood)
    -- ========================================
    {
        phase = 3,
        title = "Phase 3: Alliance 20-30 — Redridge & Duskwood",
        faction = "Alliance",
        minLevel = 20,
        maxLevel = 30,
        steps = {
            { id=1,  type="travel",     text="Travel east to Redridge Mountains. Take the road from Elwynn. Register the Lakeshire flight path.", zone="Redridge Mountains", x=65.0, y=48.0 },
            { id=2,  type="quest_get",  text="Pick up all Lakeshire quests: Messenger to Stormwind, Investigate the Camp, Wanted: Redridge Gnolls, Lake Everstill Supply Run.", zone="Redridge Mountains", x=65.0, y=48.0 },
            { id=3,  type="kill",       text="Kill Redridge Gnolls (Stonewatch East, 75,50-60). Clear rapidly — they're dense.", zone="Redridge Mountains", x=75.0, y=55.0 },
            { id=4,  type="kill",       text="Kill Murlocs and Fish at Lake Everstill (40-55,55-65) for the lake quests.", zone="Redridge Mountains", x=47.0, y=60.0 },
            { id=5,  type="kill",       text="Kill Blackrock Orcs near Tower of Althalaxx (78,35-45) — Ardo Dirtpaw wants their heads.", zone="Redridge Mountains", x=78.0, y=40.0 },
            { id=6,  type="quest_turn", text="Turn in all Redridge quests. Chain all follow-ups, especially the Stonewatch Keep chain.", zone="Redridge Mountains", x=65.0, y=48.0 },
            { id=7,  type="travel",     text="Head south via road to Duskwood. Register the Darkshire flight path immediately.", zone="Duskwood", x=75.0, y=43.0 },
            { id=8,  type="quest_get",  text="Pick up ALL Darkshire quests: The Hermit, Wolves at Our Heels, Raven Hill Cemetery, The Legend of Stalvan, The Embalmer.", zone="Duskwood", x=75.0, y=43.0 },
            { id=9,  type="kill",       text="Kill Worgen (Starving Wolves at 50,45-65) and undead in Raven Hill Cemetery (18,48).", zone="Duskwood", x=18.0, y=48.0 },
            { id=10, type="kill",       text="Track down and kill the rare elites: Mor'Ladim (27,76) and Watch Commander Zalaphil for their quests.", zone="Duskwood", x=27.0, y=76.0 },
            { id=11, type="tip",        text="TIP: Stalvan chain is long but worth it — 12,000+ XP total and great level 24 gear reward." },
            { id=12, type="dungeon",    text="DUNGEON: Shadowfang Keep (Silverpine Forest, 44,67) is great at 20-26. Grab the Duskwood chain quest for it.", zone="Shadowfang Keep" },
            { id=13, type="quest_turn", text="Turn in all Duskwood quests before leaving. Note: some final steps require level 26-28.", zone="Duskwood", x=75.0, y=43.0 },
        },
    },
    -- ========================================
    -- PHASE 1: 1-10 (Horde: Durotar)
    -- ========================================
    {
        phase = 1,
        title = "Phase 1: Horde 1-10 — Durotar",
        faction = "Horde",
        minLevel = 1,
        maxLevel = 10,
        steps = {
            { id=1,  type="tip",        text="Durotar is efficient — the quests loop naturally. Don't leave until level 10." },
            { id=2,  type="quest_get",  text="Accept ALL quests from Valley of Trials NPCs: Cutting Teeth, Sting of the Scorpid, Vile Familiars.", zone="Durotar", x=43.2, y=73.0 },
            { id=3,  type="kill",       text="Kill Scorpids and Vile Familiars around Valley of Trials. Loot the burning blade journal.", zone="Durotar" },
            { id=4,  type="quest_turn", text="Turn in at Valley of Trials. Pick up follow-ups: Report to Sen'jin Village.", zone="Durotar", x=43.2, y=73.0 },
            { id=5,  type="travel",     text="Travel north to Razor Hill. Pick up ALL quests on the way and in the town.", zone="Durotar", x=52.0, y=43.0 },
            { id=6,  type="quest_get",  text="At Razor Hill: Vile Familiars, Vanquish the Betrayers, Hana'zua, Honor Students, Burning Blade Medallion.", zone="Durotar", x=52.0, y=43.0 },
            { id=7,  type="explore",    text="Enter the Burning Blade Coven (45,55) — kill mobs inside and collect the Medallion.", zone="Durotar", x=45.0, y=55.0 },
            { id=8,  type="travel",     text="Visit Sen'jin Village (55,74). Pick up troll starting quests and the raptor quests.", zone="Durotar", x=55.0, y=74.0 },
            { id=9,  type="kill",       text="Kill Zalazane at Echo Isles (61,79) — he's elite-ish, use your class CDs.", zone="Durotar", x=61.0, y=79.0 },
            { id=10, type="quest_turn", text="Return to Razor Hill. Turn in all quests. Pick up Orgrimmar quests.", zone="Durotar", x=52.0, y=43.0 },
            { id=11, type="travel",     text="Head to Orgrimmar — train your level 10 abilities and pick up class spec!", zone="Durotar" },
            { id=12, type="tip",        text="IMPORTANT: Visit your class trainer in Orgrimmar at level 10 to unlock your specialization!" },
        },
    },
    -- ========================================
    -- PHASE 2: 10-25 (Horde: The Barrens)
    -- ========================================
    {
        phase = 2,
        title = "Phase 2: Horde 10-25 — The Barrens",
        faction = "Horde",
        minLevel = 10,
        maxLevel = 25,
        steps = {
            { id=1,  type="travel",     text="Fly or run south from Orgrimmar to The Crossroads, the Barrens main hub.", zone="The Barrens", x=51.0, y=30.0 },
            { id=2,  type="quest_get",  text="Pick up EVERY quest at The Crossroads — do not leave until you have at least 10 quests in your log.", zone="The Barrens", x=51.0, y=30.0 },
            { id=3,  type="kill",       text="Kill Razormane Quillboar to the east (60-70,20-45). Dense and fast respawn.", zone="The Barrens", x=65.0, y=33.0 },
            { id=4,  type="kill",       text="Kill Plainstriders and Zhevra for their drop quests (38,35 area). Very fast to complete.", zone="The Barrens", x=38.0, y=35.0 },
            { id=5,  type="kill",       text="Kill Raptors at Raptor Grounds (63,49) for the raptor collection quests.", zone="The Barrens", x=63.0, y=49.0 },
            { id=6,  type="dungeon",    text="DUNGEON: Wailing Caverns (42,55) at level 15-22. Pick up the long questchain beforehand!", zone="The Barrens", x=42.0, y=55.0 },
            { id=7,  type="kill",       text="Kill Kolkar Centaur in the southern Barrens (55-65,60-80) for the centaur lance and head quests.", zone="The Barrens", x=60.0, y=70.0 },
            { id=8,  type="quest_get",  text="Visit Ratchet (65,34) for goblin quests — Stolen Booty, etc. Good neutral bonus XP.", zone="The Barrens", x=65.0, y=34.0 },
            { id=9,  type="kill",       text="Bael'dun Digsite (41,56) — kill dwarves for Bael'dun Digsite quests.", zone="The Barrens", x=41.0, y=56.0 },
            { id=10, type="dungeon",    text="DUNGEON: Razorfen Kraul (40,93) at level 22-27. Grab quests from Crossroads first.", zone="The Barrens", x=40.0, y=93.0 },
            { id=11, type="tip",        text="TIP: The Barrens has the most quests of any zone for Horde 10-25. Be thorough!" },
            { id=12, type="quest_turn", text="Turn in all quests at Crossroads. Grab flight to Tarren Mill for phase 3.", zone="The Barrens", x=51.0, y=30.0 },
        },
    },
    -- ========================================
    -- PHASE 4: 25-40 (Both: Stranglethorn Vale)
    -- ========================================
    {
        phase = 4,
        title = "Phase 4: Both Factions 25-40 — Stranglethorn Vale",
        faction = "Both",
        minLevel = 25,
        maxLevel = 40,
        steps = {
            { id=1,  type="travel",     text="Alliance: Take the road south from Duskwood into STV. Horde: Fly to Ratchet → boat to Booty Bay.", zone="Stranglethorn Vale", x=32.0, y=94.0 },
            { id=2,  type="quest_get",  text="Pick up Booty Bay quests: Bloodscalp Clan Heads, Headhunting, Supply and Demand, Zanzil's Secret.", zone="Stranglethorn Vale", x=32.0, y=94.0 },
            { id=3,  type="quest_get",  text="Visit Nesingwary's Expedition (36,9). Pick up: Tiger Hunting, Panther Mastery, Raptor Mastery chain.", zone="Stranglethorn Vale", x=36.0, y=9.0 },
            { id=4,  type="kill",       text="Kill Young Stranglethorn Tigers (34,17-28). 10 needed for first quest. Very fast.", zone="Stranglethorn Vale", x=34.0, y=22.0 },
            { id=5,  type="kill",       text="Kill Young Stranglethorn Panthers south (30,36-48). Panther drops needed too.", zone="Stranglethorn Vale", x=30.0, y=40.0 },
            { id=6,  type="kill",       text="Kill Jungle Stalkers and Vale Screechers for the Raptor chain (31,27-36).", zone="Stranglethorn Vale", x=31.0, y=32.0 },
            { id=7,  type="quest_turn", text="Return to Nesingwary — turn in first tier. Pick up next: Mok'thardin's Enchantment, Panther chain 2.", zone="Stranglethorn Vale", x=36.0, y=9.0 },
            { id=8,  type="kill",       text="Kill Bloodscalp Trolls (Bloodscalp Ruins 27,22-35) for Booty Bay heads and tusk quests.", zone="Stranglethorn Vale", x=27.0, y=28.0 },
            { id=9,  type="kill",       text="Kill Skullsplitter Trolls (56,25-42) — rival troll faction for more head collection quests.", zone="Stranglethorn Vale", x=56.0, y=32.0 },
            { id=10, type="quest_get",  text="Alliance: Pick up Colonel Kurzen quests from Rebel Camp (35,4). Horde: Pick up Grom'gol Base Camp quests (31,68).", zone="Stranglethorn Vale" },
            { id=11, type="kill",       text="Kill Colonel Kurzen's men at Kurzen's Compound (42-47,14-20) for Alliance rebel quests.", zone="Stranglethorn Vale", x=44.0, y=17.0 },
            { id=12, type="kill",       text="Kill Shadowmaw Panthers (33,48) for the final Nesingwary chain. Higher level needed (~34+).", zone="Stranglethorn Vale", x=33.0, y=48.0 },
            { id=13, type="dungeon",    text="DUNGEON: Zul'Gurub (38,12) if available at 40+ OR The Temple of Atal'Hakkar (50,72) — bring STV dungeon quests!", zone="Stranglethorn Vale" },
            { id=14, type="tip",        text="WARNING: STV is heavily contested PvP. Stay near quest objectives, use terrain to break LoS from gankers." },
            { id=15, type="tip",        text="TIP: The Nesingwary completion chain at level 40+ gives a significant XP bonus. Complete all 3 tiers." },
        },
    },
    -- ========================================
    -- PHASE 5: 40-50 (Both: Tanaris & Feralas)
    -- ========================================
    {
        phase = 5,
        title = "Phase 5: Both Factions 40-50 — Tanaris & Feralas",
        faction = "Both",
        minLevel = 40,
        maxLevel = 50,
        steps = {
            { id=1,  type="travel",     text="Fly to Gadgetzan, Tanaris. This is your main hub for 40-47.", zone="Tanaris", x=50.0, y=27.0 },
            { id=2,  type="quest_get",  text="Pick up ALL Gadgetzan quests: Thistleshrub Valley, WANTED: Andre Firebeard, Noxious Lair Investigation, Screecher Spirits.", zone="Tanaris", x=50.0, y=27.0 },
            { id=3,  type="kill",       text="Kill Wastewander Pirates on the east coast (63-70,22-38). Fast XP and good drop table.", zone="Tanaris", x=66.0, y=30.0 },
            { id=4,  type="kill",       text="Kill Thistleshrub Valley plants (30,52-62). Dense, fast, and no running around.", zone="Tanaris", x=30.0, y=57.0 },
            { id=5,  type="kill",       text="Kill Sandsorrow Watch Silithid (55,20-30) for the Noxious Lair Investigation chain.", zone="Tanaris", x=55.0, y=25.0 },
            { id=6,  type="dungeon",    text="DUNGEON: Zul'Farrak (36,17) at level 43+. Has an amazing event in the middle. Run 2x for full XP.", zone="Tanaris", x=36.0, y=17.0 },
            { id=7,  type="quest_turn", text="Turn in Tanaris quests. When hitting 45, consider moving to Feralas.", zone="Tanaris", x=50.0, y=27.0 },
            { id=8,  type="travel",     text="Fly to Feathermoon Stronghold (Alliance) or Camp Mojache (Horde) in Feralas.", zone="Feralas" },
            { id=9,  type="quest_get",  text="Pick up Feralas quests: Gordunni Cobalt, Wandering Shay, Haze of Evil, The Ogres of Feralas.", zone="Feralas" },
            { id=10, type="kill",       text="Kill Gordunni Ogres (53,40-55) — dense packs with multiple quest items.", zone="Feralas", x=53.0, y=48.0 },
            { id=11, type="dungeon",    text="DUNGEON: Dire Maul (59,44) at level 45+. Run all wings over multiple sessions.", zone="Feralas", x=59.0, y=44.0 },
            { id=12, type="tip",        text="TIP: Dire Maul Tribute run (DM West) gives a goodie bag with great rewards — find a group for this!" },
            { id=13, type="tip",        text="TIP: At level 48-50, also do quests in The Hinterlands for a nice XP supplement." },
        },
    },
    -- ========================================
    -- PHASE 6: 50-60 (Both: EPL / Burning Steppes / Winterspring)
    -- ========================================
    {
        phase = 6,
        title = "Phase 6: Both Factions 50-60 — The Final Push",
        faction = "Both",
        minLevel = 50,
        maxLevel = 60,
        steps = {
            { id=1,  type="travel",     text="Travel to Un'Goro Crater via Tanaris (north gate). Hub: Marshal's Stand (A) or entry path (H).", zone="Un'Goro Crater", x=50.0, y=6.0 },
            { id=2,  type="quest_get",  text="Pick up Un'Goro quests: It's a Secret to Everybody, Lost! (A-Me 01 escort), Larion and Muigin, Crystals.", zone="Un'Goro Crater" },
            { id=3,  type="kill",       text="Collect ALL 4 crystal types in Un'Goro: Red (Fire area), Blue (Golakka), Green (northwest), Yellow (east).", zone="Un'Goro Crater" },
            { id=4,  type="explore",    text="Do the A-Me 01 escort quest ASAP — it gives massive XP and nearby quest items.", zone="Un'Goro Crater", x=49.0, y=78.0 },
            { id=5,  type="travel",     text="Move to Burning Steppes at level 52-54. Register Morgan's Vigil (A) / Flame Crest (H) flight paths.", zone="Burning Steppes" },
            { id=6,  type="quest_get",  text="Pick up Burning Steppes quests: The Smoldering Ruins, Blood of the Black Dragon, Warlord's Command, Gor'tesh's Skull.", zone="Burning Steppes" },
            { id=7,  type="kill",       text="Kill Black Dragonspawn (46,38-52) — dense packs, fast XP, needed for dragon quest chain.", zone="Burning Steppes", x=46.0, y=45.0 },
            { id=8,  type="dungeon",    text="DUNGEON: Blackrock Depths (BRD) at level 52+. Multiple quest chains and 2-3 run sessions needed.", zone="Burning Steppes" },
            { id=9,  type="travel",     text="At level 54+, add Eastern Plaguelands quests from Light's Hope Chapel alongside Burning Steppes.", zone="Eastern Plaguelands", x=80.0, y=53.0 },
            { id=10, type="quest_get",  text="Pick up EPL quests: Villains of Darrowshire, Healthy Dragon Scale, Defender of the Argent Dawn.", zone="Eastern Plaguelands", x=80.0, y=53.0 },
            { id=11, type="kill",       text="Kill Undead in Crown Guard Tower and Corin's Crossing (57-70,35-55) for Argent Dawn rep and XP.", zone="Eastern Plaguelands", x=63.0, y=45.0 },
            { id=12, type="dungeon",    text="DUNGEON: Stratholme (54+) — run both Undead side and Living side for maximum XP and gear.", zone="Eastern Plaguelands" },
            { id=13, type="dungeon",    text="DUNGEON: Scholomance (57+) — intensive dungeon with great gear. Grab all quests from Western Plaguelands.", zone="Western Plaguelands" },
            { id=14, type="tip",        text="At level 58+, begin building your Argent Dawn reputation to Honored for free level 60 gear enchants." },
            { id=15, type="tip",        text="CONGRATS! At level 60, unlock Heroic/Mythic dungeons, Mythic+, and CoA endgame content. Grind CoA dungeons for gear!" },
        },
    },
}
