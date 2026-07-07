-- ============================================================
-- CoADpsAndMobTracker - Engine Logic
-- Handles combat event tracking for DPS and active Mob lists
-- ============================================================

CoADpsAndMobTracker_Engine = {}

-- Active Mob Tracker lists
CoADpsAndMobTracker_ActiveMobs = {}

-- Combat Session Data
CoADpsAndMobTracker_Session = {
    startTime = nil,
    endTime = nil,
    totalDamage = 0,
    players = {}
}

-- Boss Encounter Segments (last 10 boss fights saved)
CoADpsAndMobTracker_Encounters = {}
local _currentFight = nil   -- active fight segment being tracked
local _instanceName = nil   -- current instance for auto-reset detection

local inCombat = false
local playerGUID = nil

-- List of unit targets to scan for real-time mob HP, target, and threat details
local scanUnitIDs = { "target", "focus", "mouseover", "targettarget", "pettarget" }
for i = 1, 4 do
    table.insert(scanUnitIDs, "party" .. i .. "target")
    table.insert(scanUnitIDs, "party" .. i .. "pettarget")
end
for i = 1, 40 do
    table.insert(scanUnitIDs, "raid" .. i .. "target")
end

-- ─────────────────────────────────────────────
-- Helper: Format numbers (e.g. 12500 -> 12.5k)
-- ─────────────────────────────────────────────
function CoADpsAndMobTracker_Engine.FormatNumber(val)
    if val >= 1000000 then
        return string.format("%.2fM", val / 1000000)
    elseif val >= 1000 then
        return string.format("%.1fk", val / 1000)
    else
        return tostring(val)
    end
end

-- ─────────────────────────────────────────────
-- Helper: Parse NPC ID from GUID
-- ─────────────────────────────────────────────
local function GetNPCID(guid)
    if not guid then return nil end
    local isNPC = string.sub(guid, 1, 5) == "0xF13" or string.find(guid, "Creature-")
    if isNPC then
        return tonumber(string.sub(guid, 9, 12), 16)
    end
    return nil
end

-- ─────────────────────────────────────────────
-- Initialize SavedVariables and frames
-- ─────────────────────────────────────────────
local engineFrame = CreateFrame("Frame", "CoADpsAndMobTrackerEngineFrame", UIParent)
engineFrame:RegisterEvent("ADDON_LOADED")
engineFrame:RegisterEvent("PLAYER_LOGIN")
engineFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
engineFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
engineFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
engineFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

engineFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "CoADpsAndMobTracker" then
            CoADpsAndMobTrackerDB = CoADpsAndMobTrackerDB or {
                pos = { point = "CENTER", x = 150, y = 0 },
                scale = 1.0,
                alpha = 0.95,
                showHUD = true
            }
        end

    elseif event == "PLAYER_LOGIN" then
        playerGUID = UnitGUID("player")
        CoADpsAndMobTracker_Engine.ResetSession()

    elseif event == "PLAYER_REGEN_DISABLED" then
        inCombat = true
        if not CoADpsAndMobTracker_Session.startTime then
            CoADpsAndMobTracker_Session.startTime = GetTime()
        end
        CoADpsAndMobTracker_ActiveMobs = {}
        -- Start a new encounter segment if inside a dungeon or raid
        if not _currentFight then
            local _, instanceType = IsInInstance()
            if instanceType == "party" or instanceType == "raid" then
                _currentFight = {
                    name      = GetRealZoneText() or "Unknown Instance",
                    startTime = GetTime(),
                    bossName  = nil,
                    endTime   = nil,
                    duration  = nil,
                    players   = {},
                }
            end
        end

    elseif event == "PLAYER_REGEN_ENABLED" then
        inCombat = false
        CoADpsAndMobTracker_Session.endTime = GetTime()

    elseif event == "ZONE_CHANGED_NEW_AREA" then
        local _, instanceType = IsInInstance()
        local newName = GetRealZoneText() or ""
        if (instanceType == "party" or instanceType == "raid") and newName ~= _instanceName then
            _instanceName = newName
            _currentFight = nil
            CoADpsAndMobTracker_Engine.ResetSession()
            CoADpsAndMobTracker_Encounters = {}
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[CoA Tracker]|r Entered " .. newName .. " — session auto-reset.")
        elseif instanceType == "none" then
            _instanceName = nil
        end

    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        CoADpsAndMobTracker_Engine.OnCLEU(CombatLog_Object_IsA and select(1, ...) or ...)
    end
end)

-- Real-time scanner loop for targets/focus/mouseover threat & HP
local scanTimer = 0
engineFrame:SetScript("OnUpdate", function(self, elapsed)
    if not inCombat then return end
    scanTimer = scanTimer + elapsed
    if scanTimer >= 0.15 then
        scanTimer = 0
        CoADpsAndMobTracker_Engine.ScanMobs()
    end
end)

-- ─────────────────────────────────────────────
-- Reset active combat session logs
-- ─────────────────────────────────────────────
function CoADpsAndMobTracker_Engine.ResetSession()
    CoADpsAndMobTracker_Session = {
        startTime = inCombat and GetTime() or nil,
        endTime = nil,
        totalDamage = 0,
        players = {}
    }
    CoADpsAndMobTracker_ActiveMobs = {}
    if CoADpsAndMobTracker_UI and CoADpsAndMobTracker_UI.Refresh then
        CoADpsAndMobTracker_UI.Refresh()
    end
end

-- ─────────────────────────────────────────────
-- Register Mob to tracking table
-- ─────────────────────────────────────────────
local function RegisterMob(guid, name)
    if not guid or not name then return end
    local npcID = GetNPCID(guid)
    if not npcID then return end

    if not CoADpsAndMobTracker_ActiveMobs[guid] then
        CoADpsAndMobTracker_ActiveMobs[guid] = {
            guid = guid,
            name = name,
            hp = 100,
            maxHp = 100,
            target = "Unknown",
            threat = 0,
            lastUpdate = GetTime()
        }
    end
end

-- ─────────────────────────────────────────────
-- real-time unit scanner
-- ─────────────────────────────────────────────
function CoADpsAndMobTracker_Engine.ScanMobs()
    local now = GetTime()
    for _, unit in ipairs(scanUnitIDs) do
        if UnitExists(unit) and not UnitIsPlayer(unit) and not UnitIsDead(unit) then
            local guid = UnitGUID(unit)
            local name = UnitName(unit)
            if guid and name then
                RegisterMob(guid, name)
                local mob = CoADpsAndMobTracker_ActiveMobs[guid]
                if mob then
                    mob.hp = UnitHealth(unit)
                    mob.maxHp = UnitHealthMax(unit)
                    
                    -- Threat status (0=safe, 1=volatile, 2=pulling threat, 3=aggro/tanking)
                    local _, status = UnitDetailedThreatSituation("player", unit)
                    mob.threat = status or 0

                    -- Target info
                    local targetUnit = unit .. "target"
                    if UnitExists(targetUnit) then
                        mob.target = UnitName(targetUnit)
                    else
                        mob.target = "None"
                    end
                    mob.lastUpdate = now
                end
            end
        end
    end

    -- Prune dead or old targets (12s idle)
    for guid, mob in pairs(CoADpsAndMobTracker_ActiveMobs) do
        if mob.hp <= 0 or (now - mob.lastUpdate) > 12 then
            CoADpsAndMobTracker_ActiveMobs[guid] = nil
        end
    end

    if CoADpsAndMobTracker_UI and CoADpsAndMobTracker_UI.Refresh then
        CoADpsAndMobTracker_UI.Refresh()
    end
end

-- ─────────────────────────────────────────────
-- Combat Log Parsing
-- ─────────────────────────────────────────────
function CoADpsAndMobTracker_Engine.OnCLEU(...)
    local ts, event, _, srcGUID, srcName, srcFlags, _, destGUID, destName, destFlags, _ = ...
    srcFlags = srcFlags or 0
    destFlags = destFlags or 0

    -- Check if source is player, player's pet, or a group member
    local isPlayer = (srcGUID == playerGUID)
    local isPet = (bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PET) ~= 0 and bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0)
    local isGroup = (bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) ~= 0 or bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) ~= 0)

    local isDestPlayer = (destGUID == playerGUID)
    local isDestGroup = (bit.band(destFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) ~= 0 or bit.band(destFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) ~= 0)

    -- If combat timer hasn't started, start it on any player/group action
    if (isPlayer or isPet or isGroup or isDestPlayer or isDestGroup) and not CoADpsAndMobTracker_Session.startTime then
        CoADpsAndMobTracker_Session.startTime = GetTime()
    end

    -- 1. HEALING TRACKING
    if event == "SPELL_HEAL" or event == "SPELL_PERIODIC_HEAL" then
        if not (isPlayer or isPet or isGroup) then return end
        local spellName = select(13, ...) or "Unknown Heal"
        local amount = select(15, ...) or 0
        local overheal = select(16, ...) or 0
        local isCrit = select(18, ...) or false

        local healActual = amount - overheal
        if healActual <= 0 then return end

        local trackerGUID = srcGUID
        local trackerName = srcName
        if isPet then
            trackerGUID = playerGUID
            trackerName = UnitName("player") .. " (Pet)"
        end

        -- Get or create player log
        if not CoADpsAndMobTracker_Session.players[trackerGUID] then
            local _, classToken = UnitClass(isPlayer and "player" or srcName)
            CoADpsAndMobTracker_Session.players[trackerGUID] = {
                name = trackerName,
                class = classToken or "WARRIOR",
                damage = 0,
                healing = 0,
                tanked = 0,
                spells = {}
            }
        end

        local pLog = CoADpsAndMobTracker_Session.players[trackerGUID]
        pLog.healing = pLog.healing + healActual

        -- Update Spell details
        if not pLog.spells[spellName] then
            pLog.spells[spellName] = {
                damage = 0, -- heals count as damage in this nested table to reuse details UI!
                hits = 0,
                crits = 0,
                min = 9999999,
                max = 0
            }
        end
        local sLog = pLog.spells[spellName]
        sLog.damage = sLog.damage + healActual
        sLog.hits = sLog.hits + 1
        if isCrit then sLog.crits = sLog.crits + 1 end
        if healActual < sLog.min then sLog.min = healActual end
        if healActual > sLog.max then sLog.max = healActual end

        if CoADpsAndMobTracker_UI and CoADpsAndMobTracker_UI.Refresh then
            CoADpsAndMobTracker_UI.Refresh()
        end
        return
    end

    -- 2. DAMAGE TRACKING (DONE & TAKEN)
    local amount, spellName, isCrit = 0, nil, false
    if event == "SWING_DAMAGE" then
        amount = select(12, ...) or select(9, ...)
        spellName = "Melee Swing"
        isCrit = select(18, ...) or select(15, ...)
    elseif event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" or event == "RANGE_DAMAGE" then
        spellName = select(13, ...) or select(10, ...)
        amount = select(15, ...) or select(12, ...)
        isCrit = select(21, ...) or select(18, ...)
    end

    if not amount or type(amount) ~= "number" or amount <= 0 then return end
    if not spellName then spellName = "Unknown Spell" end
    -- Track Damage Tanked (Damage Taken by player/group)
    if isDestPlayer or isDestGroup then
        if not CoADpsAndMobTracker_Session.players[destGUID] then
            local _, classToken = UnitClass(isDestPlayer and "player" or destName)
            CoADpsAndMobTracker_Session.players[destGUID] = {
                name = destName,
                class = classToken or "WARRIOR",
                damage = 0,
                healing = 0,
                tanked = 0,
                spells = {}
            }
        end
        local pLog = CoADpsAndMobTracker_Session.players[destGUID]
        pLog.tanked = pLog.tanked + amount
    end

    -- Track Damage Done
    if isPlayer or isPet or isGroup then
        -- Register target NPC
        RegisterMob(destGUID, destName)

        local trackerGUID = srcGUID
        local trackerName = srcName
        if isPet then
            trackerGUID = playerGUID
            trackerName = UnitName("player") .. " (Pet)"
        end

        CoADpsAndMobTracker_Session.totalDamage = CoADpsAndMobTracker_Session.totalDamage + amount

        if not CoADpsAndMobTracker_Session.players[trackerGUID] then
            local _, classToken = UnitClass(isPlayer and "player" or srcName)
            CoADpsAndMobTracker_Session.players[trackerGUID] = {
                name = trackerName,
                class = classToken or "WARRIOR",
                damage = 0,
                healing = 0,
                tanked = 0,
                spells = {}
            }
        end

        local pLog = CoADpsAndMobTracker_Session.players[trackerGUID]
        pLog.damage = pLog.damage + amount

        -- Update Spell details
        if not pLog.spells[spellName] then
            pLog.spells[spellName] = {
                damage = 0,
                hits = 0,
                crits = 0,
                min = 9999999,
                max = 0
            }
        end

        local sLog = pLog.spells[spellName]
        sLog.damage = sLog.damage + amount
        sLog.hits = sLog.hits + 1
        if isCrit then
            sLog.crits = sLog.crits + 1
        end
        if amount < sLog.min then sLog.min = amount end
        if amount > sLog.max then sLog.max = amount end
    end

    -- Boss death detection → finalize encounter segment
    if event == "UNIT_DIED" then
        local isBoss = destFlags and (bit.band(destFlags, 0x08000000) ~= 0)
        if isBoss and _currentFight then
            _currentFight.endTime  = GetTime()
            _currentFight.duration = _currentFight.endTime - _currentFight.startTime
            _currentFight.bossName = destName or "Unknown Boss"
            _currentFight.players  = {}
            for guid, pData in pairs(CoADpsAndMobTracker_Session.players) do
                _currentFight.players[guid] = {
                    name    = pData.name,
                    class   = pData.class,
                    damage  = pData.damage,
                    healing = pData.healing,
                    tanked  = pData.tanked,
                }
            end
            table.insert(CoADpsAndMobTracker_Encounters, _currentFight)
            if #CoADpsAndMobTracker_Encounters > 10 then
                table.remove(CoADpsAndMobTracker_Encounters, 1)
            end
            DEFAULT_CHAT_FRAME:AddMessage(
                "|cffFFD700[CoA Tracker]|r ⚔ Boss killed: |cffFF8C00" ..
                _currentFight.bossName .. "|r  (" ..
                string.format("%.1fs", _currentFight.duration) .. ")"
            )
            _currentFight = nil
        end
    end

    -- Trigger UI updates
    if CoADpsAndMobTracker_UI and CoADpsAndMobTracker_UI.Refresh then
        CoADpsAndMobTracker_UI.Refresh()
    end
end

-- ─────────────────────────────────────────────
-- Calculate Player DPS
-- ─────────────────────────────────────────────
function CoADpsAndMobTracker_Engine.GetPlayerDPS(guid)
    local pLog = CoADpsAndMobTracker_Session.players[guid]
    if not pLog or pLog.damage == 0 then return 0 end
    local start = CoADpsAndMobTracker_Session.startTime
    local stop  = CoADpsAndMobTracker_Session.endTime or GetTime()
    if not start then return 0 end
    local duration = stop - start
    if duration <= 0.5 then duration = 0.5 end
    return math.floor(pLog.damage / duration)
end

-- ─────────────────────────────────────────────
-- Calculate Player HPS
-- ─────────────────────────────────────────────
function CoADpsAndMobTracker_Engine.GetPlayerHPS(guid)
    local pLog = CoADpsAndMobTracker_Session.players[guid]
    if not pLog or pLog.healing == 0 then return 0 end
    local start = CoADpsAndMobTracker_Session.startTime
    local stop  = CoADpsAndMobTracker_Session.endTime or GetTime()
    if not start then return 0 end
    local duration = stop - start
    if duration <= 0.5 then duration = 0.5 end
    return math.floor(pLog.healing / duration)
end

-- ─────────────────────────────────────────────
-- Get current session duration in seconds
-- ─────────────────────────────────────────────
function CoADpsAndMobTracker_Engine.GetSessionDuration()
    local start = CoADpsAndMobTracker_Session.startTime
    if not start then return 0 end
    return (CoADpsAndMobTracker_Session.endTime or GetTime()) - start
end

-- ─────────────────────────────────────────────
-- Format seconds as M:SS string
-- ─────────────────────────────────────────────
function CoADpsAndMobTracker_Engine.FormatDuration(secs)
    if not secs or secs <= 0 then return "0:00" end
    local m = math.floor(secs / 60)
    local s = math.floor(secs % 60)
    return string.format("%d:%02d", m, s)
end

-- ─────────────────────────────────────────────
-- Detect player role from combat data heuristics
-- ─────────────────────────────────────────────
function CoADpsAndMobTracker_Engine.GetPlayerRole(guid)
    local pLog = CoADpsAndMobTracker_Session.players[guid]
    if not pLog then return "DPS" end
    if (pLog.tanked or 0) > (pLog.damage or 0) and (pLog.tanked or 0) > 0 then
        return "TANK"
    elseif (pLog.healing or 0) > (pLog.damage or 0) and (pLog.healing or 0) > 0 then
        return "HEALER"
    end
    return "DPS"
end
