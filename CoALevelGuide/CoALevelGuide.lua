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

    elseif msg == "zone" then
        -- Print best zone info to chat
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
        -- Set waypoint for current step
        local phase = CoALevelGuide_Utils.GetCurrentPhase()
        if phase then
            for phaseIdx, p in ipairs(CoALevelGuide_Steps) do
                if p == phase then
                    local nextStep = CoALevelGuide_Progress.GetNextStep(phaseIdx, phase)
                    if nextStep then
                        CoALevelGuide_Waypoints.SetFromStep(nextStep)
                    else
                        CoALevelGuide_Utils.Print("All steps in current phase are complete!")
                    end
                    break
                end
            end
        else
            CoALevelGuide_Utils.Print("No active phase found for your level/faction.")
        end

    elseif msg == "class" then
        -- Print current class leveling tips
        local _, playerClass = UnitClass("player")
        local found = false
        if playerClass then
            for _, cls in ipairs(CoALevelGuide_Classes) do
                -- Match by class name fragment (CoA classes don't match WoW native classes directly)
                -- So we just show all classes as CoA overrides the system
                break
            end
        end
        CoALevelGuide_MainFrame.Show()
        CoALevelGuide_MainFrame.SwitchTab(2) -- Switch to Classes tab
        CoALevelGuide_Utils.Print("Opened |cffFFD700Classes|r tab — browse all 21 CoA classes!")

    elseif msg == "help" then
        CoALevelGuide_Utils.Print("|cffFFD700Available Commands:|r")
        CoALevelGuide_Utils.Print("  |cff00ccff/coalvl|r            — Toggle guide window")
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
