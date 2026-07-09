-- ============================================================
-- COAlAbilityTrainer - Main Entry Point
-- Events, initialization, slash commands
-- ============================================================

local ADDON_NAME = "COAlAbilityTrainer"

-- ─────────────────────────────────────────────────────────────
-- Safe call wrapper — prevents one broken module from killing
-- the entire addon
-- ─────────────────────────────────────────────────────────────
local function SafeCall(label, fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        DEFAULT_CHAT_FRAME:AddMessage(
            "|cffFF4444[COAl Error]|r " .. label .. ": " .. tostring(err))
    end
end

-- ─────────────────────────────────────────────────────────────
-- Fade helpers (used by other modules)
-- ─────────────────────────────────────────────────────────────
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

-- ─────────────────────────────────────────────────────────────
-- SavedVariables defaults
-- ─────────────────────────────────────────────────────────────
local function InitDB()
    if not CoAAT_DB then CoAAT_DB = {} end
    local defaults = {
        selectedClass     = false,
        selectedSpec      = false,
        hideOutOfCombat   = false,
        showProcAlerts    = true,
        showRotHelper     = true,
        firstRun          = true,
        hudPos            = false,
        rotHelperPos      = false,
        minimapAngle      = 45,
        combatLearn       = {},
        hudScale          = 1.0,
        hudAlpha          = 1.0,
        showResourceBar   = true,
        showCooldowns     = true,
        showAuras         = true,
        hideDragBorder    = false,
        showCursorHUD     = false,
        cursorHUDOrientation = "angled",
        attachToNameplate = true,
        rotIconSize       = 50,
        cdIconSize        = 46,
        resBarWidth       = 264,
        positions         = {},
        nameplateHUD      = true,
        auraDisabled      = {},
    }
    for k, v in pairs(defaults) do
        -- only set if truly absent (don't overwrite false/0)
        if CoAAT_DB[k] == nil then
            CoAAT_DB[k] = v
        end
    end
end

-- ─────────────────────────────────────────────────────────────
-- Build all UI modules safely
-- ─────────────────────────────────────────────────────────────
local function BuildAllModules()
    SafeCall("CombatHUD",      function() CoAAT_CombatHUD.Build()              end)
    SafeCall("MobInfoHUD",     function() CoAAT_MobInfoHUD.Build()             end)
    SafeCall("MobInfoEvents",  function() CoAAT_MobInfoHUD.RegisterEvents()    end)
    SafeCall("EnemyTacticHUD", function() CoAAT_EnemyTacticHUD.Build()         end)
    SafeCall("EnemyTacticEvt", function() CoAAT_EnemyTacticHUD.RegisterEvents() end)
    SafeCall("TreasureHUD",    function() CoAAT_TreasureHUD.Build()            end)
    SafeCall("CombatLog",      function() CoAAT_CombatLog.Build()              end)
    SafeCall("PvPHUD",         function() CoAAT_PvPHUD.Build()                 end)
    SafeCall("SettingsFrame",  function() CoAAT_SettingsFrame.Build()          end)
    SafeCall("TutorialPanel",  function() CoAAT_TutorialPanel.Build()          end)
    SafeCall("MinimapButton",  function() CoAAT_MinimapButton.Create()         end)
    SafeCall("Engine",         function() CoAAT_Engine.Init()                  end)
    SafeCall("MacroBuilder",   function() CoAAT_MacroBuilder.Build()           end)
    SafeCall("NameplateHUD",   function() CoAAT_NameplateHUD.Build()           end)
end

-- ─────────────────────────────────────────────────────────────
-- Event frame
-- ─────────────────────────────────────────────────────────────
local eventFrame = CreateFrame("Frame", ADDON_NAME .. "EventFrame", UIParent)
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")   -- fallback
eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:RegisterEvent("SPELLS_CHANGED")

local initialized = false

eventFrame:SetScript("OnEvent", function(self, event, ...)
    -- ── ADDON_LOADED ──────────────────────────────────────────
    if event == "ADDON_LOADED" then
        local name = ...
        if name == ADDON_NAME then
            InitDB()
        end

    -- ── LOGIN / ENTERING WORLD ────────────────────────────────
    elseif (event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD") and not initialized then
        -- Make sure DB is ready even if ADDON_LOADED somehow fired late
        if not CoAAT_DB then InitDB() end
        initialized = true

        BuildAllModules()
        if CoAAT_Engine and CoAAT_Engine.ScanSpellbook then
            CoAAT_Engine.ScanSpellbook()
        end

        -- Ensure nameplates are visible
        pcall(SetCVar, "nameplateShowEnemies", 1)
        pcall(SetCVar, "nameplateMotion", 1)

        -- First run tutorial
        if CoAAT_DB.firstRun then
            CoAAT_DB.firstRun = false
            C_Timer_After(2, function()
                if CoAAT_TutorialPanel and CoAAT_TutorialPanel.ShowLesson then
                    CoAAT_TutorialPanel.ShowLesson("general", 1)
                end
            end)
        end

        -- Welcome message
        DEFAULT_CHAT_FRAME:AddMessage(
            "|cffcc88ff[COAl]|r |cff00ccffAddon loaded!|r  " ..
            "Type |cffFFD700/coal|r to open settings  •  " ..
            "|cffFFD700/coal macros|r for macros  •  " ..
            "|cffFFD700/coal np|r toggle nameplates"
        )
        if CoAAT_DB.selectedClass then
            DEFAULT_CHAT_FRAME:AddMessage(
                "|cffcc88ff[COAl]|r Class: |cffFFD700" ..
                CoAAT_DB.selectedClass ..
                " — " .. (CoAAT_DB.selectedSpec or "?") .. "|r"
            )
        end

    -- ── ENTER COMBAT ─────────────────────────────────────────
    elseif event == "PLAYER_REGEN_DISABLED" then
        if CoAAT_Engine and CoAAT_Engine.SetCombat then
            CoAAT_Engine.SetCombat(true)
        end

    -- ── LEAVE COMBAT ─────────────────────────────────────────
    elseif event == "PLAYER_REGEN_ENABLED" then
        if CoAAT_Engine and CoAAT_Engine.SetCombat then
            CoAAT_Engine.SetCombat(false)
        end

    -- ── LEVEL UP ─────────────────────────────────────────────
    elseif event == "PLAYER_LEVEL_UP" then
        local newLevel = ...
        DEFAULT_CHAT_FRAME:AddMessage(
            "|cffcc88ff[COAl]|r |cffFFD700Level " .. newLevel ..
            "!|r Check your trainer for new abilities!")

    -- ── COMBAT LOG ───────────────────────────────────────────
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        if CoAAT_Engine and CoAAT_Engine.OnCLEU then
            SafeCall("CLEU", CoAAT_Engine.OnCLEU, ...)
        end

    -- ── ZONE CHANGE ──────────────────────────────────────────
    elseif event == "ZONE_CHANGED_NEW_AREA" then
        if CoAAT_CombatLog and CoAAT_CombatLog.OnZoneChanged then
            CoAAT_CombatLog.OnZoneChanged()
        end

    -- ── SPELLS CHANGED ────────────────────────────────────────
    elseif event == "SPELLS_CHANGED" then
        if CoAAT_Engine and CoAAT_Engine.ScanSpellbook then
            CoAAT_Engine.ScanSpellbook()
        end
    end
end)

eventFrame:SetScript("OnUpdate", function(self, elapsed)
    if initialized and CoAAT_Engine and CoAAT_Engine.OnUpdate then
        CoAAT_Engine.OnUpdate(elapsed)
    end
end)

-- ─────────────────────────────────────────────────────────────
-- Slash Commands  /coal  /coaat
-- ─────────────────────────────────────────────────────────────
SLASH_COAAT1 = "/coal"
SLASH_COAAT2 = "/coaat"
SLASH_COAAT3 = "/coaltrainer"

SlashCmdList["COAAT"] = function(msg)
    -- Trim + lower safely
    msg = (msg or ""):lower()
    msg = msg:match("^%s*(.-)%s*$") or ""

    if msg == "" or msg == "settings" or msg == "config" then
        if CoAAT_SettingsFrame and CoAAT_SettingsFrame.Toggle then
            CoAAT_SettingsFrame.Toggle()
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffcc88ff[COAl]|r Settings not loaded yet.")
        end

    elseif msg == "macros" or msg == "macro" then
        if CoAAT_MacroBuilder and CoAAT_MacroBuilder.Toggle then
            SafeCall("MacroBuilder.Toggle", CoAAT_MacroBuilder.Toggle)
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffcc88ff[COAl]|r Macro Builder not loaded.")
        end

    elseif msg == "nameplates" or msg == "np" then
        if CoAAT_NameplateHUD and CoAAT_NameplateHUD.Toggle then
            SafeCall("NameplateHUD.Toggle", CoAAT_NameplateHUD.Toggle)
            local state = (CoAAT_DB and CoAAT_DB.nameplateHUD ~= false)
                and "|cff00ff88ON|r" or "|cffff4444OFF|r"
            DEFAULT_CHAT_FRAME:AddMessage("|cffcc88ff[COAl]|r Nameplates " .. state)
        end

    elseif msg == "hud" then
        if CoAAT_CombatHUD and CoAAT_CombatHUD.Toggle then
            CoAAT_CombatHUD.Toggle()
        end

    elseif msg == "log" then
        if CoAAT_CombatLog and CoAAT_CombatLog.Toggle then
            CoAAT_CombatLog.Toggle()
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffcc88ff[COAl]|r Combat Log not loaded.")
        end

    elseif msg == "enemy" then
        if CoAAT_EnemyTacticHUD and CoAAT_EnemyTacticHUD.Toggle then
            CoAAT_EnemyTacticHUD.Toggle()
        end

    elseif msg == "treasure" then
        if CoAAT_TreasureHUD and CoAAT_TreasureHUD.Toggle then
            CoAAT_TreasureHUD.Toggle()
        end

    elseif msg == "pvp" or msg == "pvphud" then
        if CoAAT_PvPHUD and CoAAT_PvPHUD.Toggle then
            CoAAT_PvPHUD.Toggle()
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffcc88ff[COAl]|r PvP HUD not loaded.")
        end

    elseif msg == "aoe" or msg == "mode" then
        if CoAAT_Engine and CoAAT_Engine.ToggleAoEMode then
            CoAAT_Engine.ToggleAoEMode()
        end

    elseif msg:sub(1,5) == "class" then
        local parts = {}
        for part in msg:gmatch("%S+") do parts[#parts+1] = part end
        local classId = parts[2]
        local specId  = parts[3]
        if classId and CoAAT_Abilities and CoAAT_Abilities[classId] then
            if CoAAT_Engine and CoAAT_Engine.SetClass then
                CoAAT_Engine.SetClass(classId, specId or "")
            end
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffcc88ff[COAl]|r Usage: /coal class <id> [specid]")
            DEFAULT_CHAT_FRAME:AddMessage("|cffaaaaaa  e.g. /coal class felsworn infernal")
        end

    elseif msg == "reset" then
        if CoAAT_Engine and CoAAT_Engine._state then
            CoAAT_Engine._state.resource = 0
            DEFAULT_CHAT_FRAME:AddMessage("|cffcc88ff[COAl]|r Resource reset.")
        end

    elseif msg == "reload" or msg == "rl" then
        ReloadUI()

    elseif msg == "help" or msg == "?" then
        DEFAULT_CHAT_FRAME:AddMessage("|cffcc88ff[COAl]|r |cffFFD700Commands:|r")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coal|r                — Settings panel")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coal macros|r         — Macro Builder")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coal log|r            — Toggle Combat Log")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coal pvp|r            — Toggle PvP HUD Tracker")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coal np|r              — Toggle nameplate HUD")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coal hud|r             — Toggle Combat HUD")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coal enemy|r           — Toggle Enemy Tactic HUD")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coal treasure|r        — Toggle Treasure Map HUD")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coal aoe|r             — Toggle AoE mode")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coal class <id>|r      — Set class")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coal rl|r              — Reload UI")
        DEFAULT_CHAT_FRAME:AddMessage("  |cff00ccff/coal help|r            — This list")

    else
        DEFAULT_CHAT_FRAME:AddMessage(
            "|cffcc88ff[COAl]|r Unknown: '" .. msg ..
            "' — try |cff00ccff/coal help|r")
    end
end

-- Tutorial shortcut
SLASH_COAATTUT1 = "/coaattut"
SlashCmdList["COAATTUT"] = function(msg)
    msg = (msg or ""):match("^%s*(.-)%s*$") or ""
    local classId = (msg ~= "") and msg or (CoAAT_Engine and CoAAT_Engine.GetClassId and CoAAT_Engine.GetClassId()) or "general"
    if CoAAT_TutorialPanel and CoAAT_TutorialPanel.ShowClassIntro then
        CoAAT_TutorialPanel.ShowClassIntro(classId)
    end
end

-- Simulation command
SLASH_COAATSIM1 = "/coaatsim"
SlashCmdList["COAATSIM"] = function(msg)
    local val = tonumber(msg)
    if val then
        if CoAAT_Engine and CoAAT_Engine.SetResource then
            CoAAT_Engine.SetResource(val)
            DEFAULT_CHAT_FRAME:AddMessage("|cffcc88ff[COAl Sim]|r Resource set to " .. val)
        end
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cffcc88ff[COAl Sim]|r Starting simulation...")
        local simFrame = CreateFrame("Frame")
        local elapsed  = 0
        simFrame:SetScript("OnUpdate", function(self, dt)
            elapsed = elapsed + dt
            local res = math.min(100, math.floor(elapsed * 15))
            if CoAAT_Engine and CoAAT_Engine.SetResource then
                CoAAT_Engine.SetResource(res)
            end
            if elapsed > 7 then
                self:SetScript("OnUpdate", nil)
                DEFAULT_CHAT_FRAME:AddMessage("|cffcc88ff[COAl Sim]|r Done.")
            end
        end)
    end
end
