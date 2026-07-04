-- ============================================================
-- CoALevelGuide - Utility Functions
-- ============================================================

CoALevelGuide_Utils = {}

-- Print a formatted message to chat
function CoALevelGuide_Utils.Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[CoA Guide]|r " .. tostring(msg))
end

-- Print an error message
function CoALevelGuide_Utils.Error(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cffff4444[CoA Guide Error]|r " .. tostring(msg))
end

-- Get player faction
function CoALevelGuide_Utils.GetFaction()
    local faction = UnitFactionGroup("player")
    return faction or "Alliance"
end

-- Get the current player level
function CoALevelGuide_Utils.GetLevel()
    return UnitLevel("player") or 1
end

-- Get the player class name
function CoALevelGuide_Utils.GetClass()
    local _, class = UnitClass("player")
    return class or "WARRIOR"
end

-- Find the best zone for the player's current level + faction
function CoALevelGuide_Utils.GetBestZone()
    local level   = CoALevelGuide_Utils.GetLevel()
    local faction = CoALevelGuide_Utils.GetFaction()

    local best = nil
    for _, zone in ipairs(CoALevelGuide_Zones) do
        if zone.faction == "Both" or zone.faction == faction then
            if level >= zone.minLevel and level <= zone.maxLevel then
                if not best or zone.minLevel > best.minLevel then
                    best = zone
                end
            end
        end
    end
    return best
end

-- Find the best phase/guide for the player
function CoALevelGuide_Utils.GetCurrentPhase()
    local level   = CoALevelGuide_Utils.GetLevel()
    local faction = CoALevelGuide_Utils.GetFaction()

    local best = nil
    for _, phase in ipairs(CoALevelGuide_Steps) do
        if phase.faction == "Both" or phase.faction == faction then
            if level >= phase.minLevel and level <= phase.maxLevel then
                if not best or phase.minLevel > best.minLevel then
                    best = phase
                end
            end
        end
    end
    return best
end

-- Get the icon for a step type
function CoALevelGuide_Utils.GetStepIcon(stepType)
    local icons = {
        quest_get  = "|TInterface\\GossipFrame\\AvailableQuestIcon:14:14|t",
        quest_turn = "|TInterface\\GossipFrame\\ActiveQuestIcon:14:14|t",
        kill       = "|TInterface\\Icons\\Ability_Warrior_SavageBlow:14:14|t",
        travel     = "|TInterface\\Icons\\Ability_Rider_Deathchargelevel2:14:14|t",
        dungeon    = "|TInterface\\Icons\\Achievement_Dungeon_Classic:14:14|t",
        explore    = "|TInterface\\Icons\\Spell_Holy_GuardianSpirit:14:14|t",
        tip        = "|TInterface\\Icons\\INV_Misc_Note_01:14:14|t",
    }
    return icons[stepType] or "|TInterface\\Icons\\INV_Misc_QuestionMark:14:14|t"
end

-- Get a color for step type
function CoALevelGuide_Utils.GetStepColor(stepType)
    local colors = {
        quest_get  = "|cffffcc00",
        quest_turn = "|cff00ff00",
        kill       = "|cffff6644",
        travel     = "|cff44aaff",
        dungeon    = "|cffcc55ff",
        explore    = "|cff55ddaa",
        tip        = "|cffaaaaaa",
    }
    return colors[stepType] or "|cffffffff"
end

-- Format step type to human label
function CoALevelGuide_Utils.GetStepLabel(stepType)
    local labels = {
        quest_get  = "Accept Quest",
        quest_turn = "Turn In",
        kill       = "Kill",
        travel     = "Travel",
        dungeon    = "Dungeon",
        explore    = "Explore",
        tip        = "Tip",
    }
    return labels[stepType] or stepType
end

-- Clamp a number between min and max
function CoALevelGuide_Utils.Clamp(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
end

-- Table contains check
function CoALevelGuide_Utils.TableContains(t, val)
    for _, v in ipairs(t) do
        if v == val then return true end
    end
    return false
end

-- Smooth Fade In transition
function CoALevelGuide_Utils.FadeIn(frame, duration)
    if not frame then return end
    duration = duration or 0.25
    frame:Show()
    frame:SetAlpha(0.01)
    
    local elapsed = 0
    local f = CreateFrame("Frame")
    f:SetScript("OnUpdate", function(self, dt)
        elapsed = elapsed + dt
        local alpha = math.min(1.0, elapsed / duration)
        frame:SetAlpha(alpha)
        if alpha >= 1.0 then
            frame:SetAlpha(1.0)
            self:SetScript("OnUpdate", nil)
        end
    end)
end

-- Smooth Fade Out transition
function CoALevelGuide_Utils.FadeOut(frame, duration, callback)
    if not frame then return end
    duration = duration or 0.25
    
    local elapsed = 0
    local f = CreateFrame("Frame")
    f:SetScript("OnUpdate", function(self, dt)
        elapsed = elapsed + dt
        local alpha = 1.0 - math.min(1.0, elapsed / duration)
        frame:SetAlpha(alpha)
        if alpha <= 0 then
            frame:SetAlpha(0)
            frame:Hide()
            self:SetScript("OnUpdate", nil)
            if callback then callback() end
        end
    end)
end
