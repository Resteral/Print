-- ============================================================
-- CoAAbilityTrainer - Main Entry Point
-- Events, initialization, slash commands
-- ============================================================

local ADDON_NAME = "CoAAbilityTrainer"

-- Global Fade Transitions for Trainer Addon
function CoAAT_FadeIn(frame, duration)
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

function CoAAT_FadeOut(frame, duration, callback)
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

-- ─────────────────────────────────────────────────────────────────────────────
-- SavedVariables defaults
-- ─────────────────────────────────────────────────────────────────────────────
local function InitDB()
    if not CoAAT_DB then CoAAT_DB = {} end
    if CoAAT_DB.selectedClass    == nil then CoAAT_DB.selectedClass    = nil   end
    if CoAAT_DB.selectedSpec     == nil then CoAAT_DB.selectedSpec     = nil   end
    if CoAAT_DB.hideOutOfCombat  == nil then CoAAT_DB.hideOutOfCombat  = false end
    if CoAAT_DB.showProcAlerts   == nil then CoAAT_DB.showProcAlerts   = true  end
    if CoAAT_DB.showRotHelper    == nil then CoAAT_DB.showRotHelper    = true  end
    if CoAAT_DB.firstRun         == nil then CoAAT_DB.firstRun         = true  end
    if CoAAT_DB.hudPos           == nil then CoAAT_DB.hudPos           = nil   end
    if CoAAT_DB.rotHelperPos     == nil then CoAAT_DB.rotHelperPos     = nil   end
    if CoAAT_DB.minimapAngle     == nil then CoAAT_DB.minimapAngle     = 30    end
    if CoAAT_DB.combatLearn      == nil then CoAAT_DB.combatLearn      = {}    end
    -- HUD Customization Defaults
    if CoAAT_DB.hudScale         == nil then CoAAT_DB.hudScale         = 1.0   end
    if CoAAT_DB.hudAlpha         == nil then CoAAT_DB.hudAlpha         = 1.0   end
    if CoAAT_DB.showResourceBar  == nil then CoAAT_DB.showResourceBar  = true  end
    if CoAAT_DB.showCooldowns    == nil then CoAAT_DB.showCooldowns    = true  end
    if CoAAT_DB.showAuras        == nil then CoAAT_DB.showAuras        = true  end
    if CoAAT_DB.hideDragBorder   == nil then CoAAT_DB.hideDragBorder   = false end
    if CoAAT_DB.showCursorHUD    == nil then CoAAT_DB.showCursorHUD    = false end
    if CoAAT_DB.cursorHUDOrientation == nil then CoAAT_DB.cursorHUDOrientation = "angled" end
    if CoAAT_DB.attachToNameplate == nil then CoAAT_DB.attachToNameplate = true end
    if CoAAT_DB.rotIconSize      == nil then CoAAT_DB.rotIconSize      = 50   end
    if CoAAT_DB.cdIconSize       == nil then CoAAT_DB.cdIconSize       = 46   end
    if CoAAT_DB.resBarWidth      == nil then CoAAT_DB.resBarWidth      = 264  end
    if CoAAT_DB.positions        == nil then CoAAT_DB.positions        = {}    end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Event frame
-- ─────────────────────────────────────────────────────────────────────────────
local eventFrame = CreateFrame("Frame", ADDON_NAME .. "EventFrame", UIParent)
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")   -- enter combat
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")    -- leave combat
eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local addonReady = false

eventFrame:SetScript("OnEvent", function(self, event, ...)
    -- ── ADDON_LOADED ──
    if event == "ADDON_LOADED" and ... == ADDON_NAME then
        InitDB()
        addonReady = true

    -- ── PLAYER_LOGIN ──
    elseif event == "PLAYER_LOGIN" and addonReady then
        -- Build all UI
        CoAAT_CombatHUD.Build()
        CoAAT_MobInfoHUD.Build()
        CoAAT_MobInfoHUD.RegisterEvents()
        CoAAT_EnemyTacticHUD.Build()
        CoAAT_EnemyTacticHUD.RegisterEvents()
        CoAAT_TreasureHUD.Build()
        CoAAT_SettingsFrame.Build()
        CoAAT_TutorialPanel.Build()
        CoAAT_MinimapButton.Create()

        -- Init engine (restores saved class/spec)
        CoAAT_Engine.Init()

        -- Auto-configure CVars so nameplates display correctly above mob models
        SetCVar("nameplateShowEnemies", 1)
        SetCVar("nameplateMotion", 1) -- Stack nameplates above heads instead of overlapping body/HUD

        -- First run: show welcome tutorial
        if CoAAT_DB.firstRun then
            CoAAT_DB.firstRun = false
            C_Timer_After(2, function()
                CoAAT_TutorialPanel.ShowLesson("general", 1)
            end)
        end

        -- Print welcome
        DEFAULT_CHAT_FRAME:AddMessage(
            "|cffb048b5[CoA Ability Trainer]|r |cff00ccffv1.0 loaded!|r  " ..
            "Type |cff00ccff/coaat|r to open settings, |cff00ccff/coaattut|r for tutorial."
        )

        if CoAAT_DB.selectedClass then
            DEFAULT_CHAT_FRAME:AddMessage(
                "|cffb048b5[CoAT]|r Restoring: |cffFFD700" ..
                CoAAT_DB.selectedClass .. " — " .. (CoAAT_DB.selectedSpec or "?") .. "|r"
            )
        else
            DEFAULT_CHAT_FRAME:AddMessage(
                "|cffb048b5[CoAT]|r Type |cff00ccff/coaat|r and pick your class to get started!"
            )
        end

    -- ── ENTER COMBAT ──
    elseif event == "PLAYER_REGEN_DISABLED" then
        CoAAT_Engine.SetCombat(true)

    -- ── LEAVE COMBAT ──
    elseif event == "PLAYER_REGEN_ENABLED" then
        CoAAT_Engine.SetCombat(false)

    -- ── LEVEL UP ──
    elseif event == "PLAYER_LEVEL_UP" then
        local newLevel = ...
        DEFAULT_CHAT_FRAME:AddMessage(
            "|cffb048b5[CoAT]|r |cffFFD700Level up! " .. newLevel ..
            "|r — Check your trainer for new abilities!"
        )
        -- Queue level-up reminder tutorial
        local classId = CoAAT_Engine.GetClassId()
        if classId and LESSONS and CoAAT_TutorialPanel then
            C_Timer_After(3, function()
                if CoAAT_TutorialPanel.ShowLesson then
                    CoAAT_TutorialPanel.ShowLesson(classId, 1)
                end
            end)
        end

    -- ── COMBAT LOG ──
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        CoAAT_Engine.OnCLEU(CombatLog_Object_IsA and select(1, ...) or ...)
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Slash Commands
-- ─────────────────────────────────────────────────────────────────────────────
SLASH_COAAT1 = "/coaat"
SLASH_COAAT2 = "/coaabilitytrainer"
SlashCmdList["COAAT"] = function(msg)
    msg = msg:lower():trim()

    if msg == "" or msg == "settings" then
        CoAAT_SettingsFrame.Toggle()

    elseif msg == "hud" then
        CoAAT_CombatHUD.Toggle()

    elseif msg == "enemy" then
        CoAAT_EnemyTacticHUD.Toggle()

    elseif msg == "treasure" or msg == "pvp" then
        CoAAT_TreasureHUD.Toggle()

    elseif msg:sub(1, 5) == "class" then
        -- /coaat class felsworn inquisitor
        local parts = {}
        for part in msg:gmatch("%S+") do parts[#parts+1] = part end
        local classId = parts[2]
        local specId  = parts[3]
        if classId and CoAAT_Abilities[classId] then
            CoAAT_Engine.SetClass(classId, specId or "infernal_assault")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffb048b5[CoAT]|r Usage: /coaat class <classid> [specid]")
            DEFAULT_CHAT_FRAME:AddMessage("|cffaaaaaa  Classes: felsworn, necromancer, witch_hunter, tinker, runemaster, chronomancer, spiritwalker")
        end

    elseif msg == "aoe" or msg == "mode" then
        CoAAT_Engine.ToggleAoEMode()

    elseif msg == "reset" then
        CoAAT_Engine._state.resource = 0
        DEFAULT_CHAT_FRAME:AddMessage("|cffb048b5[CoAT]|r Resource reset to 0.")

    elseif msg == "help" then
        DEFAULT_CHAT_FRAME:AddMessage("|cffb048b5[CoAT]|r |cffFFD700Commands:|r")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coaat|r              — Open settings")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coaat hud|r          — Toggle Combat HUD")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coaat enemy|r        — Toggle Enemy Tactic HUD")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coaat treasure|r     — Toggle PvP Treasure Hunt HUD")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coaat aoe|r          — Toggle AoE/Single Target mode")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coaat class <id>|r   — Set active class")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coaattut|r           — Show tutorial")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coaat help|r         — This message")

    else
        DEFAULT_CHAT_FRAME:AddMessage("|cffb048b5[CoAT]|r Unknown command. Try |cff00ccff/coaat help|r")
    end
end

-- Tutorial shortcut
SLASH_COAATTUT1 = "/coaattut"
SlashCmdList["COAATTUT"] = function(msg)
    local classId = msg:trim():lower()
    if classId == "" then
        classId = CoAAT_Engine.GetClassId() or "general"
    end
    CoAAT_TutorialPanel.ShowClassIntro(classId)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Simulate resource generation for testing
-- (Since we can't hook CoA's custom resource APIs directly,
--  we provide a "/coaat sim" command to simulate combat)
-- ─────────────────────────────────────────────────────────────────────────────
SLASH_COAATSIM1 = "/coaatsim"
SlashCmdList["COAATSIM"] = function(msg)
    local val = tonumber(msg)
    if val then
        CoAAT_Engine.SetResource(val)
        DEFAULT_CHAT_FRAME:AddMessage("|cffb048b5[CoAT Sim]|r Resource set to " .. val)
    else
        -- Auto-simulate: ramp up resource over time
        DEFAULT_CHAT_FRAME:AddMessage("|cffb048b5[CoAT Sim]|r Starting resource simulation...")
        local simFrame = CreateFrame("Frame")
        local elapsed = 0
        simFrame:SetScript("OnUpdate", function(self, dt)
            elapsed = elapsed + dt
            local res = math.min(100, math.floor(elapsed * 15))
            CoAAT_Engine.SetResource(res)
            -- Simulate a proc at ~50 resource
            if res == 50 then
                local classId = CoAAT_Engine.GetClassId()
                if classId == "felsworn" then
                    CoAAT_Engine.TriggerProc("Fel Explosion", 6)
                elseif classId == "necromancer" then
                    -- Simulate pet dying for tutorial
                elseif classId == "witch_hunter" then
                    CoAAT_Engine.TriggerProc("Purge", 5)
                end
            end
            if elapsed > 7 then
                self:SetScript("OnUpdate", nil)
                DEFAULT_CHAT_FRAME:AddMessage("|cffb048b5[CoAT Sim]|r Simulation complete.")
            end
        end)
    end
end
