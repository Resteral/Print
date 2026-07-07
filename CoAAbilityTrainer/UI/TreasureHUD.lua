-- ============================================================
-- CoAAbilityTrainer - Treasure Hunt HUD
-- High-Risk PvP Treasure Hunting Spots
-- Shows: zone, coords, loot tier, PvP risk level,
--        best class for the run, and escape strategy
-- Toggle: /coaat treasure
-- ============================================================

CoAAT_TreasureHUD = {}

local _frame      = nil
local _visible    = false
local _currentIdx = 1

-- ─────────────────────────────────────────────────────────────
-- TREASURE DATABASE
-- Risk: "extreme" | "high" | "medium"
-- tier: "S" | "A" | "B"  (loot quality tier)
-- ─────────────────────────────────────────────────────────────
local TREASURES = {

    -- ══════════════════════════════════════════════
    --  Page 1: High-Risk PvP Mode
    -- ══════════════════════════════════════════════
    {
        name    = "High-Risk PvP Mode Overview",
        zone    = "Azeroth PvP Rules",
        coords  = "Capital City Flag",
        tier    = "S",
        risk    = "extreme",
        respawn = "Always Active",
        loot    = {
            "Enables full-loot PvP in contested zones.",
            "Requires turning on PvP mode in capital city.",
            "Gives +25% bonus XP and Reputation.",
            "Unlocks 'Treasure Hunter' mechanics.",
        },
        pvpNote  = "Warning: In High-Risk mode, dying in contested zones to other players will cause you to drop random gear/inventory items!",
        bestClass = {
            runemaster  = "Runeblade: High burst damage allows you to drop gankers quickly. Keep Arcane Binding ready.",
            felsworn    = "Slayer spec: Highly mobile. Use Fel Hoof Charge to close gaps or retreat.",
            witch_hunter= "Inquisitor spec: Mark targets from max range to see gankers before they see you.",
            tinker      = "Battletech spec: Set up a defensive perimeter with Landmines and Turrets.",
            necromancer = "Reanimation spec: Raise undead minions to create a buffer against attackers.",
            reaper      = "Soul spec: Shadow Phase provides a 4s window of untargetability to escape ambushes.",
            chronomancer= "Temporal Rift spec: Rewind heals you to full health when caught in a burst window.",
        },
        escapeClass = {
            runemaster  = "Arcane Binding roots the primary attacker, allowing you to mount and flee.",
            felsworn    = "Fel Hoof Charge through the enemy pack, mount at maximum distance.",
            witch_hunter= "Shadow Tonic grants instant speed boost and stealth to break combat.",
            tinker      = "Rocket Barrage AoE knockback clears path for Overclock sprint.",
            necromancer = "Death Coil causes fear, Army of the Dead blocks chasing paths.",
            reaper      = "Shadow Phase through chasers, Void Step blink away.",
            chronomancer= "Temporal Flux slows chasers by 80% for easy escape.",
        },
        generalEscape = "Keep your mount hotkeyed. Never stand in one spot for more than 2 minutes.",
    },

    -- ══════════════════════════════════════════════
    --  Page 2: Treasure Hunter Buff
    -- ══════════════════════════════════════════════
    {
        name    = "Treasure Hunter Buff Guide",
        zone    = "High-Risk Buff",
        coords  = "Requires 5 Kills",
        tier    = "S",
        risk    = "high",
        respawn = "Buff State",
        loot    = {
            "Increases mob gold drops by 50%.",
            "Increases Ephemeral Key drop rate by 100%.",
            "Enables radar tracking for Hidden Caches.",
            "Increases chance of rare item drops.",
        },
        pvpNote  = "To get the buff, you must score 5 honorable kills in High-Risk mode without dying. Buff is lost upon death.",
        bestClass = {
            runemaster  = "Runeblade: Group up with allies and secure kills using Rune Carve executes.",
            felsworn    = "Slayer: Target isolated low health players in contested zones for quick kills.",
            witch_hunter= "Inquisitor: Hunt down targets using Mark Target. Use Shadow Tonic to engage.",
            tinker      = "Battletech: Set traps in high-traffic corridors like Blackrock Mountain.",
            necromancer = "Reanimation: Push targets with Army of the Dead and execute with Corpse Explosion.",
            reaper      = "Soul: Ambush solo players using Void Step and execute with Harvest.",
            chronomancer= "Temporal Rift: Support your group with Haste buffs while dotting targets.",
        },
        escapeClass = {
            runemaster  = "Root and run. Do not risk your 5-kill streak in bad matchups.",
            felsworn    = "Fel Hoof Charge away immediately if you are outnumbered.",
            witch_hunter= "Shadow Tonic and run to neutral guards if you pull aggro.",
            tinker      = "Drop Landmines behind you while kiting to safety.",
            necromancer = "Sacrifice a pet for Runic Tap heal, run for support.",
            reaper      = "Use Shadow Phase to negate the opening stuns of gankers.",
            chronomancer= "Rewind immediately upon entering critical health range.",
        },
        generalEscape = "If you have the buff, play defensively. Avoid crowded main roads and farm at borders.",
    },

    -- ══════════════════════════════════════════════
    --  Page 3: Ephemeral Key Farming
    -- ══════════════════════════════════════════════
    {
        name    = "Ephemeral Key Farming Guide",
        zone    = "Key Farming",
        coords  = "Elite Mobs Only",
        tier    = "A",
        risk    = "high",
        respawn = "Mob Drops",
        loot    = {
            "Farming spots: Azshara (Nagas), Blasted Lands (Demons).",
            "Drop rate: 2% from normals, 10% from elites.",
            "Keys are consumed to open Hidden Caches.",
            "WARNING: Keys are lost on PvP death!",
        },
        pvpNote  = "High risk of gankers camping key mobs. Cleanse keys at a Fel Commutator to make them permanent.",
        bestClass = {
            runemaster  = "Engravement: Use Rune Shield to tank elite nagas/demons solo with zero downtime.",
            felsworn    = "Tyrant: High sustain and armor makes tanking elites trivial.",
            witch_hunter= "Inquisitor: Kite elites from range using shadow bolts to avoid damage.",
            tinker      = "Battletech: Let your Turret tank the elite while you repair it.",
            necromancer = "Reanimation: Let your raised undead pets tank the elite while you cast.",
            reaper      = "Harvest: High life drain sustain makes soloing elites easy.",
            chronomancer= "Temporal Rift: Slow elites with Temporal Flux and kite them down.",
        },
        escapeClass = {
            runemaster  = "Arcane Binding roots the elite and players, allowing escape.",
            felsworn    = "Fel Hoof Charge through the mob to escape player ganks.",
            witch_hunter= "Shadow Tonic removes mob aggro and player target.",
            tinker      = "Drop Landmine to stun the chasing elite/player.",
            necromancer = "Fear targets with Death Coil to buy time.",
            reaper      = "Shadow Phase and run to break line of sight.",
            chronomancer= "Slow with Temporal Flux and blink away.",
        },
        generalEscape = "Cleanse your keys frequently. Do not carry more than 3 keys at a time.",
    },

    -- ══════════════════════════════════════════════
    --  Page 4: Hidden Cache: Azshara
    -- ══════════════════════════════════════════════
    {
        name    = "Hidden Cache: Azshara Ruins",
        zone    = "Azshara Shore",
        coords  = "64, 22",
        tier    = "A",
        risk    = "extreme",
        respawn = "15-30 min",
        loot    = {
            "|cffA335EE[Corrupted Glinting Blade]|r",
            "|cffFF8C00[Fel-Inscribed Pauldrons]|r",
            "|cffffd700Blood Shards (cleanse currency)|r",
            "|cff1EFF00[High-Risk Chest Key]|r",
        },
        pvpNote  = "Caches spawn along Hetaera's Clutch ruins and underwater cliffs. Naga elites patrol nearby.",
        bestClass = {
            runemaster  = "Engravement: Use Ward of Protection to loot the chest under attack.",
            felsworn    = "Tyrant: Use Fel Barrier to prevent spell interrupts while looting.",
            witch_hunter= "Inquisitor: Shadow Tonic to stealth-loot the cache without clearing nagas.",
            tinker      = "Battletech: Place Turret to draw naga aggro, then loot.",
            necromancer = "Reanimation: Raise pets to distract nagas, then loot.",
            reaper      = "Soul: Shadow Phase allows you to grab the cache untargeted.",
            chronomancer= "Temporal Rift: Slow nagas, grab cache, Rewind if targeted.",
        },
        escapeClass = {
            runemaster  = "Jump off the cliff into the sea, Arcane Binding any pursuer.",
            felsworn    = "Swim speed buffs or Fel Hoof Charge to the shore.",
            witch_hunter= "Water walking potions + Shadow Tonic sprint.",
            tinker      = "Rocket Barrage into the water for swim escape.",
            necromancer = "Water breathing buff + swim down to avoid players.",
            reaper      = "Void Step blink down the cliff to the water.",
            chronomancer= "Slow chasers, jump, and Rewind if you take fall damage.",
        },
        generalEscape = "Head east and jump off the cliff edge into the deep water below to lose players.",
    },

    -- ══════════════════════════════════════════════
    --  Page 5: Hidden Cache: Blasted Lands
    -- ══════════════════════════════════════════════
    {
        name    = "Hidden Cache: Blasted Lands",
        zone    = "Tainted Scar",
        coords  = "35, 55",
        tier    = "A",
        risk    = "extreme",
        respawn = "15-30 min",
        loot    = {
            "|cffA335EE[Demon-Carved Runeblade]|r",
            "|cffFF8C00[Tainted Fel Greaves]|r",
            "|cffffd700Demonic Rune Cache|r",
            "|cff1EFF00[Fel-Sparks x5]|r",
        },
        pvpNote  = "The Tainted Scar is packed with level 60 elite demons. High risk of player ambushes.",
        bestClass = {
            runemaster  = "Engravement: High mitigation prevents getting crushed by demon elites.",
            felsworn    = "Tyrant: High armor and fel resistance makes this area safer.",
            witch_hunter= "Inquisitor: Stealth through the scar using Shadow Tonic.",
            tinker      = "Battletech: Place Landmines at narrow paths to block elites.",
            necromancer = "Reanimation: Let pets handle elite aggro while you loot.",
            reaper      = "Soul: Phase through elite pack to reach the cache.",
            chronomancer= "Temporal Rift: Use Haste to sprint past demons to the cache.",
        },
        escapeClass = {
            runemaster  = "Arcane Binding on the elite demon to lock it in place, then mount.",
            felsworn    = "Fel Hoof Charge through the demon models to clear the path.",
            witch_hunter= "Shadow Tonic to drop all demon and player aggro.",
            tinker      = "Rocket Barrage AoE knockback to clear the path.",
            necromancer = "Fear the closest elite to block the pathway.",
            reaper      = "Shadow Phase and Void Step through the cave exit.",
            chronomancer= "Temporal Flux on the chasing player/mob.",
        },
        generalEscape = "Run toward the Searing Gorge tunnel or Slay/Invis to break combat.",
    },

    -- ══════════════════════════════════════════════
    --  Page 6: Fel Commutation Guide
    -- ══════════════════════════════════════════════
    {
        name    = "Fel Commutation Guide",
        zone    = "Felwood Cavity",
        coords  = "35, 50",
        tier    = "B",
        risk    = "medium",
        respawn = "Safe Cleansing",
        loot    = {
            "Cleanse corrupted items from Hidden Caches.",
            "Converts temporary PvP items to permanent items.",
            "Requires 10 Blood Shards per cleanse.",
            "Requires 1 Fel-Spark per cleanse.",
        },
        pvpNote  = "Location: Shadowhold depth, near the Fel Commutator. Highly contested choke points.",
        bestClass = {
            runemaster  = "Engravement: Use Ward of Protection when clicking the Fel Commutator.",
            felsworn    = "Tyrant: Activate Fel Barrier to avoid spell interrupts.",
            witch_hunter= "Inquisitor: Check the room with Mark Target first for hidden players.",
            tinker      = "Battletech: Set Turret and Landmines at the doorway before cleansing.",
            necromancer = "Reanimation: Summon Army of the Dead to block the entrance door.",
            reaper      = "Soul: Shadow Phase during the commutator cast window.",
            chronomancer= "Temporal Rift: Set a Time Loop on yourself before clicking.",
        },
        escapeClass = {
            runemaster  = "Arcane Binding the door camper and sprint out.",
            felsworn    = "Fel Hoof Charge through the door blockers.",
            witch_hunter= "Shadow Tonic to vanish and walk out of the cave.",
            tinker      = "Rocket Barrage the choke point, then sprint.",
            necromancer = "Death Coil the door camper, run behind your pets.",
            reaper      = "Shadow Phase and Void Step through the camper.",
            chronomancer= "Temporal Flux the chaser and run out.",
        },
        generalEscape = "Always check the commutator room for stealthers before starting the cleanse cast.",
    },
}

-- ─────────────────────────────────────────────────────────────
-- Color helpers
-- ─────────────────────────────────────────────────────────────
local TIER_COLORS = { S="|cffFF0000", A="|cffFF8C00", B="|cffFFD700" }
local RISK_COLORS = {
    extreme = "|cffFF0000",
    high    = "|cffFF8C00",
    medium  = "|cffFFFF00",
}
local RISK_ICONS = { extreme="☠", high="⚠", medium="◈" }

-- ─────────────────────────────────────────────────────────────
-- Build
-- ─────────────────────────────────────────────────────────────
function CoAAT_TreasureHUD.Build()
    local f = CreateFrame("Frame", "CoAATTreasureHUD", UIParent)
    f:SetSize(300, 340)
    f:SetPoint("LEFT", UIParent, "LEFT", 20, 60)
    f:SetFrameStrata("DIALOG")
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
    bg:SetTexture(0.03, 0.05, 0.03, 0.95)

    -- Gold top accent
    local accent = f:CreateTexture(nil, "ARTWORK")
    accent:SetSize(300, 4)
    accent:SetPoint("TOPLEFT")
    accent:SetTexture(1.0, 0.8, 0.0, 1.0)

    -- Borders
    local function B(w,h,pt,rpt,ox,oy)
        local t=f:CreateTexture(nil,"OVERLAY"); t:SetSize(w,h)
        t:SetPoint(pt,f,rpt,ox,oy); t:SetTexture(0.8,0.65,0.0,0.6)
    end
    B(300,1,"TOPLEFT","TOPLEFT",0,0); B(300,1,"BOTTOMLEFT","BOTTOMLEFT",0,0)
    B(1,340,"TOPLEFT","TOPLEFT",0,0); B(1,340,"TOPRIGHT","TOPRIGHT",0,0)

    -- Close button
    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetSize(22,22)
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", 2, 2)
    closeBtn:SetScript("OnClick", function() CoAAT_TreasureHUD.Hide() end)

    -- Header
    local header = f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    header:SetPoint("TOPLEFT",f,"TOPLEFT",8,-8)
    header:SetFont("Fonts\\FRIZQT__.TTF",12,"OUTLINE")
    header:SetText("|cffFFD700💰 High-Risk Treasure Spots|r")

    -- Counter (e.g. "3 / 9")
    local counter = f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    counter:SetPoint("TOPRIGHT",f,"TOPRIGHT",-28,-10)
    counter:SetFont("Fonts\\FRIZQT__.TTF",10,"OUTLINE")
    counter:SetText("")
    f._counter = counter

    -- ── Entry name ──
    local entryName = f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    entryName:SetPoint("TOPLEFT",f,"TOPLEFT",8,-28)
    entryName:SetSize(260,0)
    entryName:SetFont("Fonts\\FRIZQT__.TTF",12,"OUTLINE")
    entryName:SetJustifyH("LEFT")
    entryName:SetText("")
    f._entryName = entryName

    -- ── Zone / coords / tier / risk row ──
    local metaLine = f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    metaLine:SetPoint("TOPLEFT",f,"TOPLEFT",8,-46)
    metaLine:SetSize(280,0)
    metaLine:SetFont("Fonts\\FRIZQT__.TTF",10,"OUTLINE")
    metaLine:SetJustifyH("LEFT")
    metaLine:SetText("")
    f._metaLine = metaLine

    -- ── Respawn ──
    local respawnLine = f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    respawnLine:SetPoint("TOPLEFT",f,"TOPLEFT",8,-58)
    respawnLine:SetFont("Fonts\\FRIZQT__.TTF",10,"OUTLINE")
    respawnLine:SetText("")
    f._respawnLine = respawnLine

    -- ── PvP warning banner ──
    local pvpBG = f:CreateTexture(nil,"BACKGROUND")
    pvpBG:SetSize(300,14)
    pvpBG:SetPoint("TOPLEFT",f,"TOPLEFT",0,-72)
    pvpBG:SetTexture(0.6,0.05,0.05,0.85)
    f._pvpBG = pvpBG

    local pvpNote = f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    pvpNote:SetPoint("TOPLEFT",f,"TOPLEFT",6,-74)
    pvpNote:SetSize(288,0)
    pvpNote:SetFont("Fonts\\FRIZQT__.TTF",9,"OUTLINE")
    pvpNote:SetJustifyH("LEFT")
    pvpNote:SetText("")
    f._pvpNote = pvpNote

    -- ── Loot label ──
    local lootLabel = f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    lootLabel:SetPoint("TOPLEFT",f,"TOPLEFT",8,-92)
    lootLabel:SetFont("Fonts\\FRIZQT__.TTF",10,"OUTLINE")
    lootLabel:SetText("|cffFFD700💎 Notable Loot:|r")
    f._lootLabel = lootLabel

    -- Loot lines (up to 4)
    local lootLines = {}
    for i=1,4 do
        local ll = f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        ll:SetPoint("TOPLEFT",f,"TOPLEFT",12,-92-(i*13))
        ll:SetSize(276,0)
        ll:SetFont("Fonts\\FRIZQT__.TTF",9,"OUTLINE")
        ll:SetJustifyH("LEFT")
        ll:SetText("")
        lootLines[i] = ll
    end
    f._lootLines = lootLines

    -- ── Class strategy label ──
    local classLabel = f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    classLabel:SetPoint("TOPLEFT",f,"TOPLEFT",8,-150)
    classLabel:SetFont("Fonts\\FRIZQT__.TTF",10,"OUTLINE")
    classLabel:SetText("|cff44FF88🗡 Your Strategy:|r")
    f._classLabel = classLabel

    local classText = f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    classText:SetPoint("TOPLEFT",f,"TOPLEFT",10,-163)
    classText:SetSize(280,50)
    classText:SetFont("Fonts\\FRIZQT__.TTF",9,"OUTLINE")
    classText:SetJustifyH("LEFT")
    classText:SetJustifyV("TOP")
    classText:SetText("")
    f._classText = classText

    -- ── Escape label ──
    local escapeLabel = f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    escapeLabel:SetPoint("TOPLEFT",f,"TOPLEFT",8,-218)
    escapeLabel:SetFont("Fonts\\FRIZQT__.TTF",10,"OUTLINE")
    escapeLabel:SetText("|cffFF4444🏃 Escape Plan:|r")
    f._escapeLabel = escapeLabel

    local escapeText = f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    escapeText:SetPoint("TOPLEFT",f,"TOPLEFT",10,-231)
    escapeText:SetSize(280,48)
    escapeText:SetFont("Fonts\\FRIZQT__.TTF",9,"OUTLINE")
    escapeText:SetJustifyH("LEFT")
    escapeText:SetJustifyV("TOP")
    escapeText:SetText("")
    f._escapeText = escapeText

    -- ── Prev / Next buttons ──
    local prevBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    prevBtn:SetSize(80,22)
    prevBtn:SetPoint("BOTTOMLEFT",f,"BOTTOMLEFT",8,8)
    prevBtn:SetText("◀ Prev")
    prevBtn:SetScript("OnClick", function()
        _currentIdx = _currentIdx - 1
        if _currentIdx < 1 then _currentIdx = #TREASURES end
        CoAAT_TreasureHUD.Refresh()
    end)

    local nextBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    nextBtn:SetSize(80,22)
    nextBtn:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-8,8)
    nextBtn:SetText("Next ▶")
    nextBtn:SetScript("OnClick", function()
        _currentIdx = _currentIdx + 1
        if _currentIdx > #TREASURES then _currentIdx = 1 end
        CoAAT_TreasureHUD.Refresh()
    end)

    -- drag hint
    local drag = f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    drag:SetPoint("BOTTOM",f,"BOTTOM",0,10)
    drag:SetFont("Fonts\\FRIZQT__.TTF",8,"OUTLINE")
    drag:SetText("|cff444444drag to move  •  /coaat treasure to close|r")

    _frame = f
    CoAAT_TreasureHUD.Refresh()
end

-- ─────────────────────────────────────────────────────────────
-- Refresh content for current index
-- ─────────────────────────────────────────────────────────────
function CoAAT_TreasureHUD.Refresh()
    if not _frame then return end
    local t = TREASURES[_currentIdx]
    if not t then return end

    -- Counter
    _frame._counter:SetText(_currentIdx .. " / " .. #TREASURES)

    -- Tier + risk colors
    local tc = TIER_COLORS[t.tier]   or "|cffFFFFFF"
    local rc = RISK_COLORS[t.risk]   or "|cffFFFFFF"
    local ri = RISK_ICONS[t.risk]    or "?"

    -- Name
    _frame._entryName:SetText(tc .. "[" .. t.tier .. "-Tier] " .. "|r|cffFFFFFF" .. t.name .. "|r")

    -- Meta
    _frame._metaLine:SetText(
        "|cffaaaaaa📍 " .. t.zone .. " (" .. t.coords .. ")|r  " ..
        rc .. ri .. " " .. t.risk:upper() .. " RISK|r"
    )

    -- Respawn
    _frame._respawnLine:SetText("|cff888888⏱ Respawn: " .. t.respawn .. "|r")

    -- PvP note
    _frame._pvpNote:SetText("|cffFFAAAA" .. t.pvpNote .. "|r")

    -- Loot
    for i=1,4 do
        if t.loot and t.loot[i] then
            _frame._lootLines[i]:SetText("• " .. t.loot[i])
            _frame._lootLines[i]:Show()
        else
            _frame._lootLines[i]:SetText("")
            _frame._lootLines[i]:Hide()
        end
    end

    -- Class strategy
    local classId = CoAAT_Engine and CoAAT_Engine.GetClassId and CoAAT_Engine.GetClassId()
    local strat = (classId and t.bestClass and t.bestClass[classId])
                or "|cff808080Select your class (/coaat class) for specific strategies.|r"
    _frame._classText:SetText(strat)

    -- Escape plan
    local esc = (classId and t.escapeClass and t.escapeClass[classId])
             or t.generalEscape
             or "|cff808080Mount immediately and flee to the nearest town.|r"
    _frame._escapeText:SetText("|cffFF4444" .. esc .. "|r")
end

-- ─────────────────────────────────────────────────────────────
-- Show / Hide / Toggle
-- ─────────────────────────────────────────────────────────────
function CoAAT_TreasureHUD.Show()
    if not _frame then CoAAT_TreasureHUD.Build() end
    CoAAT_TreasureHUD.Refresh()
    _frame:Show()
    _visible = true
    DEFAULT_CHAT_FRAME:AddMessage("|cffFFD700[CoAT]|r 💰 Treasure HUD opened. Use ◀ ▶ to browse " .. #TREASURES .. " spots.")
end

function CoAAT_TreasureHUD.Hide()
    if _frame then _frame:Hide() end
    _visible = false
end

function CoAAT_TreasureHUD.Toggle()
    if _visible then
        CoAAT_TreasureHUD.Hide()
    else
        CoAAT_TreasureHUD.Show()
    end
end
