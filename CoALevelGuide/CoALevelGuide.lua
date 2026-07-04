-- ============================================================
-- CoALevelGuide - Main Entry Point
-- Initializes all systems on ADDON_LOADED event
-- ============================================================

local ADDON_NAME = "CoALevelGuide"

-- ─────────────────────────────────────────────────────────────────────────────
-- Initialization
-- ─────────────────────────────────────────────────────────────────────────────
local initFrame = CreateFrame("Frame", ADDON_NAME .. "InitFrame", UIParent)
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:RegisterEvent("PLAYER_LOGIN")

local addonLoaded = false

initFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        addonLoaded = true
        -- Initialize saved variables first
        CoALevelGuide_Progress.Init()

    elseif event == "PLAYER_LOGIN" and addonLoaded then
        -- Build UI after login (all API is available)
        CoALevelGuide_MainFrame.Create()
        CoALevelGuide_MinimapButton.Create()

        -- Welcome message
        local level   = CoALevelGuide_Utils.GetLevel()
        local faction = CoALevelGuide_Utils.GetFaction()
        local zone    = CoALevelGuide_Utils.GetBestZone()

        CoALevelGuide_Utils.Print(
            "|cffFFD700Conquest of Azeroth Level Guide|r v1.0 loaded! " ..
            "Type |cff00ccff/coalvl|r to open."
        )

        if zone then
            CoALevelGuide_Utils.Print(
                "Recommended zone for |cff00ccff" .. faction .. " Lvl " .. level .. "|r: " ..
                "|cffFFD700" .. zone.name .. "|r (" .. zone.minLevel .. "-" .. zone.maxLevel .. ")"
            )
        else
            CoALevelGuide_Utils.Print(
                "Level " .. level .. " — check the Guide tab for your current phase!"
            )
        end

        self:UnregisterEvent("ADDON_LOADED")
        self:UnregisterEvent("PLAYER_LOGIN")
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Auto-Quest Accept & Turn-In QoL Feature
-- ─────────────────────────────────────────────────────────────────────────────
local autoQuestEnabled = true
local questFrame = CreateFrame("Frame", ADDON_NAME .. "QuestFrame", UIParent)
questFrame:RegisterEvent("QUEST_DETAIL")
questFrame:RegisterEvent("QUEST_PROGRESS")
questFrame:RegisterEvent("QUEST_COMPLETE")
questFrame:SetScript("OnEvent", function(self, event, ...)
    if not autoQuestEnabled then return end
    
    if event == "QUEST_DETAIL" then
        AcceptQuest()
    elseif event == "QUEST_PROGRESS" then
        if IsQuestCompletable() then
            CompleteQuest()
        end
    elseif event == "QUEST_COMPLETE" then
        local choices = GetNumQuestChoices()
        if choices == 0 or choices == 1 then
            GetQuestReward(1)
        end
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Slash Commands
-- ─────────────────────────────────────────────────────────────────────────────
SLASH_COALVL1 = "/coalvl"
SLASH_COALVL2 = "/coalevelguide"
SlashCmdList["COALVL"] = function(msg)
    msg = msg:lower():trim()

    if msg == "" or msg == "open" then
        CoALevelGuide_MainFrame.Toggle()

    elseif msg == "show" then
        CoALevelGuide_MainFrame.Show()

    elseif msg == "hide" then
        CoALevelGuide_MainFrame.Hide()

    elseif msg == "auto" then
        autoQuestEnabled = not autoQuestEnabled
        CoALevelGuide_Utils.Print("Auto Quest Accept/Turn-in set to: " .. (autoQuestEnabled and "|cff00ff00[ENABLED]|r" or "|cffff2222[DISABLED]|r"))

    elseif msg == "zone" then
        local zone = CoALevelGuide_Utils.GetBestZone()
        if zone then
            CoALevelGuide_Utils.Print("|cffFFD700" .. zone.name .. "|r (Lvl " .. zone.minLevel .. "-" .. zone.maxLevel .. ")")
            CoALevelGuide_Utils.Print(zone.description)
            CoALevelGuide_Utils.Print("Hub: |cff88ff88" .. zone.mainTown .. "|r  •  FP: |cffffd700" .. zone.flightPath .. "|r")
        else
            CoALevelGuide_Utils.Print("No zone recommendation available for level " .. CoALevelGuide_Utils.GetLevel())
        end

    elseif msg == "reset" then
        StaticPopup_Show("COA_LEVEL_GUIDE_RESET_CONFIRM")

    elseif msg == "wp" then
        local phase = CoALevelGuide_Utils.GetCurrentPhase()
        if phase then
            for phaseIdx, p in ipairs(CoALevelGuide_Steps) do
                if p == phase then
                    local nextStep = CoALevelGuide_Progress.GetNextStep(phaseIdx, phase)
                    if nextStep then
                        CoALevelGuide_Waypoints.SetFromStep(nextStep)
                    else
                        CoALevelGuide_Progress.Print("All steps in current phase are complete!")
                    end
                    break
                end
            end
        else
            CoALevelGuide_Utils.Print("No active phase found for your level/faction.")
        end

    elseif msg == "class" then
        local _, playerClass = UnitClass("player")
        CoALevelGuide_MainFrame.Show()
        CoALevelGuide_MainFrame.SwitchTab(2)
        CoALevelGuide_Utils.Print("Opened |cffFFD700Classes|r tab — browse all 21 CoA classes!")

    elseif msg == "help" then
        CoALevelGuide_Utils.Print("|cffFFD700Available Commands:|r")
        CoALevelGuide_Utils.Print("  |cff00ccff/coalvl|r            — Toggle guide window")
        CoALevelGuide_Utils.Print("  |cff00ccff/coalvl auto|r         — Toggle Auto Quest Accept/Turn-in")
        CoALevelGuide_Utils.Print("  |cff00ccff/coalvl zone|r       — Show recommended zone")
        CoALevelGuide_Utils.Print("  |cff00ccff/coalvl wp|r         — Set waypoint to next step")
        CoALevelGuide_Utils.Print("  |cff00ccff/coalvl class|r      — Open class browser")
        CoALevelGuide_Utils.Print("  |cff00ccff/coalvl reset|r      — Reset all progress")
        CoALevelGuide_Utils.Print("  |cff00ccff/coalvl help|r       — Show this help")

    else
        CoALevelGuide_Utils.Print("Unknown command. Type |cff00ccff/coalvl help|r for a list of commands.")
    end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Global quick-access (for macro usage)
-- ─────────────────────────────────────────────────────────────────────────────
function CoALevelGuide_Toggle()
    CoALevelGuide_MainFrame.Toggle()
end
