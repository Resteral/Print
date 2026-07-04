-- ============================================================
-- CoAAbilityTrainer - Settings Frame
-- Class / Spec picker + options panel
-- ============================================================

CoAAT_SettingsFrame = {}

local _frame = nil

-- Class display order
local CLASS_ORDER = {
    { id="barbarian",       specs={"berserker","wild","chieftain"} },
    { id="bloodmage",       specs={"vitality","crimson","sanguine"} },
    { id="chronomancer",    specs={"acceleration","temporal_rift","timeless"} },
    { id="cultist",         specs={"darkness","shadow","corruption"} },
    { id="felsworn",        specs={"infernal","slayer","tyrant"} },
    { id="guardian",        specs={"defense","protection","valor"} },
    { id="knight_of_xoroth",specs={"destruction","doom","hellfire"} },
    { id="necromancer",     specs={"reanimation","death","frost"} },
    { id="primalist",       specs={"elemental","beast","wildgrowth"} },
    { id="pyromancer",      specs={"fire","ember","combustion"} },
    { id="ranger",          specs={"marksmanship","survival","beast_master"} },
    { id="reaper",          specs={"harvest","soul","defiance"} },
    { id="runemaster",      specs={"inscription","runic_fury","arcane_binding"} },
    { id="starcaller",      specs={"astral","solar","lunar"} },
    { id="stormbringer",    specs={"lightning","tempest","thunder"} },
    { id="sun_cleric",      specs={"light","solar","healing"} },
    { id="templar",         specs={"retribution","justice","protection"} },
    { id="tinker",          specs={"battletech","medic","juggernaut"} },
    { id="venomancer",      specs={"poison","shadow","toxin"} },
    { id="witch_doctor",    specs={"voodoo","hex","healing"} },
    { id="witch_hunter",    specs={"inquisitor","ravager","warden"} },
}

-- Friendly spec names
local SPEC_NAMES = {
    -- Barbarian
    berserker        = "Berserker",
    wild             = "Wild",
    chieftain        = "Chieftain",
    -- Bloodmage
    vitality         = "Vitality",
    crimson          = "Crimson",
    sanguine         = "Sanguine",
    -- Chronomancer
    acceleration     = "Acceleration",
    temporal_rift    = "Temporal Rift",
    timeless         = "Timeless",
    -- Cultist
    darkness         = "Darkness",
    shadow           = "Shadow",
    corruption       = "Corruption",
    -- Felsworn
    infernal         = "Infernal (Caster)",
    slayer           = "Slayer (Melee)",
    tyrant           = "Tyrant (Tank)",
    -- Guardian
    defense          = "Defense",
    protection       = "Protection",
    valor            = "Valor",
    -- Knight of Xoroth
    destruction      = "Destruction",
    doom             = "Doom",
    hellfire         = "Hellfire",
    -- Necromancer
    reanimation      = "Reanimation",
    death            = "Death",
    frost            = "Frost",
    -- Primalist
    elemental        = "Elemental",
    beast            = "Beast",
    wildgrowth       = "Wildgrowth",
    -- Pyromancer
    fire             = "Fire",
    ember            = "Ember",
    combustion       = "Combustion",
    -- Ranger
    marksmanship     = "Marksmanship",
    survival         = "Survival",
    beast_master     = "Beast Master",
    -- Reaper
    harvest          = "Harvest",
    soul             = "Soul",
    defiance         = "Defiance",
    -- Runemaster
    inscription      = "Inscription",
    runic_fury       = "Runic Fury",
    arcane_binding   = "Arcane Binding",
    -- Starcaller
    astral           = "Astral",
    solar            = "Solar",
    lunar            = "Lunar",
    -- Stormbringer
    lightning        = "Lightning",
    tempest          = "Tempest",
    thunder          = "Thunder",
    -- Sun Cleric
    light            = "Light",
    healing          = "Healing",
    -- Templar
    retribution      = "Retribution",
    justice          = "Justice",
    -- Tinker
    battletech       = "Battletech",
    medic            = "Medic",
    juggernaut       = "Juggernaut",
    -- Venomancer
    poison           = "Poison",
    toxin            = "Toxin",
    -- Witch Doctor
    voodoo           = "Voodoo",
    hex              = "Hex",
    -- Witch Hunter
    inquisitor       = "Inquisitor",
    ravager          = "Ravager",
    warden           = "Warden",
}

function CoAAT_SettingsFrame.Build()
    local f = CreateFrame("Frame", "CoAATSettingsFrame", UIParent)
    f:SetSize(380, 440)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetToplevel(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop",  function(self) self:StopMovingOrSizing() end)

    -- Background
    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0.03, 0.04, 0.10, 0.97)

    -- Borders (glowing blue thin lines)
    local function makeLine(parent, w, h, point, relPoint, offX, offY)
        local l = parent:CreateTexture(nil, "OVERLAY")
        l:SetSize(w, h)
        l:SetTexture(0.0, 0.5, 0.8, 0.5)
        l:SetPoint(point, parent, relPoint, offX, offY)
        return l
    end
    makeLine(f, 380, 1, "TOPLEFT",     "TOPLEFT",     0,  0)
    makeLine(f, 380, 1, "BOTTOMLEFT",  "BOTTOMLEFT",  0,  0)
    makeLine(f, 1, 440, "TOPLEFT",     "TOPLEFT",     0,  0)
    makeLine(f, 1, 440, "TOPRIGHT",    "TOPRIGHT",    0,  0)

    -- Close button
    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
    close:SetScript("OnClick", function()
        CoAAT_SettingsFrame.Toggle()
    end)

    -- Title
    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -14)
    title:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    title:SetText("|cff00ccff⚔ CoA Ability Trainer|r |cffaaaaaa— Settings|r")

    -- ── Section: Class Picker ──
    local classHdr = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    classHdr:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -36)
    classHdr:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    classHdr:SetText("|cffFFD700Select Your Class & Spec|r")

    local classDesc = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    classDesc:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -52)
    classDesc:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    classDesc:SetText("|cffaaaaaaaChoose the class you are currently playing in CoA|r")

    -- Class dropdown
    local classDropdown = CreateFrame("Frame", "CoAATClassDropdown", f, "UIDropDownMenuTemplate")
    classDropdown:SetPoint("TOPLEFT", f, "TOPLEFT", 6, -70)
    UIDropDownMenu_SetWidth(classDropdown, 160)
    UIDropDownMenu_SetText(classDropdown, "-- Select Class --")

    UIDropDownMenu_Initialize(classDropdown, function(self, level)
        for _, cls in ipairs(CLASS_ORDER) do
            local classDef = CoAAT_Abilities[cls.id]
            if classDef then
                local info = UIDropDownMenu_CreateInfo()
                local name = cls.id:gsub("_", " "):gsub("(%a)([%a']*)", function(f2,r) return f2:upper()..r end)
                info.text = name
                info.value = cls.id
                info.func = function()
                    UIDropDownMenu_SetText(classDropdown, name)
                    CoAAT_SettingsFrame._pendingClass = cls.id
                    CoAAT_SettingsFrame._pendingSpec  = cls.specs[1]
                    CoAAT_SettingsFrame.UpdateSpecDropdown(cls)
                    f._applyBtn:Enable()
                end
                UIDropDownMenu_AddButton(info)
            end
        end
    end)
    f._classDropdown = classDropdown

    -- Spec dropdown
    local specLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    specLabel:SetPoint("TOPLEFT", f, "TOPLEFT", 200, -52)
    specLabel:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    specLabel:SetText("|cffaaaaaa Specialization:|r")

    local specDropdown = CreateFrame("Frame", "CoAATSpecDropdown", f, "UIDropDownMenuTemplate")
    specDropdown:SetPoint("TOPLEFT", f, "TOPLEFT", 190, -70)
    UIDropDownMenu_SetWidth(specDropdown, 150)
    UIDropDownMenu_SetText(specDropdown, "-- Select Spec --")
    f._specDropdown = specDropdown

    -- ── Apply button ──
    local applyBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    applyBtn:SetSize(120, 26)
    applyBtn:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -110)
    applyBtn:SetText("✓ Apply Class")
    applyBtn:Disable()
    applyBtn:SetScript("OnClick", function()
        local classId = CoAAT_SettingsFrame._pendingClass
        local specId  = CoAAT_SettingsFrame._pendingSpec
        if classId then
            CoAAT_Engine.SetClass(classId, specId)
            CoAAT_TutorialPanel.ShowClassIntro(classId)
        end
        applyBtn:Disable()
    end)
    f._applyBtn = applyBtn

    -- Tutorial button
    local tutBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    tutBtn:SetSize(150, 26)
    tutBtn:SetPoint("TOPLEFT", f, "TOPLEFT", 144, -110)
    tutBtn:SetText("📖 View Tutorial")
    tutBtn:SetScript("OnClick", function()
        local classId = CoAAT_Engine.GetClassId() or "general"
        CoAAT_TutorialPanel.ShowClassIntro(classId)
    end)

    -- ── Divider ──
    local div1 = f:CreateTexture(nil, "OVERLAY")
    div1:SetSize(352, 1)
    div1:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -144)
    div1:SetTexture(0.0, 0.4, 0.7, 0.4)

    -- ── Options section ──
    local optHdr = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    optHdr:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -152)
    optHdr:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    optHdr:SetText("|cffFFD700Display Options|r")

    -- Option: Hide out of combat
    local hideCombatCB = CreateFrame("CheckButton", "CoAATHideCombatCB", f, "UICheckButtonTemplate")
    hideCombatCB:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -172)
    _G[hideCombatCB:GetName() .. "Text"]:SetText("|cffddddddHide tracker when out of combat|r")
    hideCombatCB:SetChecked(CoAAT_DB and CoAAT_DB.hideOutOfCombat or false)
    hideCombatCB:SetScript("OnClick", function(self)
        if CoAAT_DB then CoAAT_DB.hideOutOfCombat = self:GetChecked() end
    end)

    -- Option: Show proc alerts
    local procAlertCB = CreateFrame("CheckButton", "CoAATShowProcAlertCB", f, "UICheckButtonTemplate")
    procAlertCB:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -198)
    _G[procAlertCB:GetName() .. "Text"]:SetText("|cffddddddShow center-screen proc alerts|r")
    procAlertCB:SetChecked(CoAAT_DB and CoAAT_DB.showProcAlerts ~= false)
    procAlertCB:SetScript("OnClick", function(self)
        if CoAAT_DB then CoAAT_DB.showProcAlerts = self:GetChecked() end
    end)

    -- Option: Rotation helper visible
    local rotHelperCB = CreateFrame("CheckButton", "CoAATRotHelperCB", f, "UICheckButtonTemplate")
    rotHelperCB:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -224)
    _G[rotHelperCB:GetName() .. "Text"]:SetText("|cffddddddShow rotation helper (next ability)|r")
    rotHelperCB:SetChecked(CoAAT_DB and CoAAT_DB.showRotHelper ~= false)
    rotHelperCB:SetScript("OnClick", function(self)
        if CoAAT_DB then CoAAT_DB.showRotHelper = self:GetChecked() end
        CoAAT_RotationHelper.Toggle()
    end)

    -- ── Divider ──
    local div2 = f:CreateTexture(nil, "OVERLAY")
    div2:SetSize(352, 1)
    div2:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -254)
    div2:SetTexture(0.0, 0.4, 0.7, 0.4)

    -- ── Quick Rotation Summary ──
    local rotHdr = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    rotHdr:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -264)
    rotHdr:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    rotHdr:SetText("|cffFFD700Current Rotation Summary|r")

    local rotSummary = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    rotSummary:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -284)
    rotSummary:SetSize(352, 80)
    rotSummary:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    rotSummary:SetJustifyH("LEFT")
    rotSummary:SetJustifyV("TOP")
    rotSummary:SetText("|cffaaaaaa[No class selected]|r")
    f._rotSummary = rotSummary

    -- ── Bottom buttons ──
    local closeBtn2 = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    closeBtn2:SetSize(85, 24)
    closeBtn2:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -12, 12)
    closeBtn2:SetText("Close")
    closeBtn2:SetScript("OnClick", function() f:Hide() end)

    local resetBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    resetBtn:SetSize(120, 24)
    resetBtn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 12, 12)
    resetBtn:SetText("Reset Position")
    resetBtn:SetScript("OnClick", function()
        if CoAAT_CombatHUD._hud then
            CoAAT_CombatHUD._hud:ClearAllPoints()
            CoAAT_CombatHUD._hud:SetPoint("CENTER", UIParent, "CENTER", 0, -150)
        end
        if CoAAT_DB then CoAAT_DB.hudPos = nil end
    end)

    local setupBarBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    setupBarBtn:SetSize(140, 24)
    setupBarBtn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 136, 12)
    setupBarBtn:SetText("⚡ Setup Bar Page 2")
    setupBarBtn:SetScript("OnClick", function()
        CoAAT_SettingsFrame.SetupHotbarPage2()
    end)
    f._setupBarBtn = setupBarBtn

    f:Hide()
    _frame = f
    CoAAT_SettingsFrame._frame = f

    -- Hook: update rotation summary when class changes
    hooksecurefunc(CoAAT_Engine, "SetClass", function(classId, specId)
        CoAAT_SettingsFrame.UpdateRotSummary()
    end)
end

-- ─────────────────────────────────────────────
-- Dynamically create macros and place on Page 2
-- ─────────────────────────────────────────────
function CoAAT_SettingsFrame.SetupHotbarPage2()
    if InCombatLockdown() then
        print("|cffff2222[CoAAT] Error: Cannot setup action bar in combat!|r")
        return
    end

    local specDef = CoAAT_Engine.GetSpecDef()
    if not specDef or not specDef.abilities then
        print("|cffff2222[CoAAT] Error: No active class specialization selected.|r")
        return
    end

    print("|cff00ccff[CoAAT] Setting up hotbar Page 2 for " .. specDef.name .. "...|r")

    -- Clean up cursor first
    ClearCursor()

    for i, ability in ipairs(specDef.abilities) do
        local slot = 12 + i
        if slot > 24 then break end -- Only fill slots 13-24 (page 2)

        -- Clean macro name (WoW limit 16 characters)
        local macroName = "CoA_" .. ability.name:gsub("%s", ""):sub(1, 12)
        local macroBody = "/cast " .. ability.name

        -- Try to find existing macro (returns 1-54, or 0 if not found)
        local macroIndex = GetMacroIndexByName(macroName)
        if not macroIndex or macroIndex == 0 then
            local _, numChar = GetNumMacros()
            if numChar < 18 then
                -- Create character-specific macro
                macroIndex = CreateMacro(macroName, "INV_Misc_QuestionMark", macroBody, 1)
            else
                local numGlobal = GetNumMacros()
                if numGlobal < 36 then
                    -- Fallback to global macro
                    macroIndex = CreateMacro(macroName, "INV_Misc_QuestionMark", macroBody, nil)
                else
                    print("|cffff2222[CoAAT] Error: Macro list is full! Clear some macros.|r")
                    break
                end
            end
        else
            -- Update existing macro body
            EditMacro(macroIndex, nil, nil, macroBody)
        end

        if macroIndex and macroIndex > 0 then
            -- Place macro in slot
            PickupMacro(macroIndex)
            PlaceAction(slot)
            ClearCursor()
        end
    end

    print("|cff00ccff[CoAAT] Hotbar Page 2 setup complete! Switched page 2 icons.|r")
end

function CoAAT_SettingsFrame.UpdateSpecDropdown(cls)
    local f = _frame
    if not f then return end
    UIDropDownMenu_Initialize(f._specDropdown, function(self, level)
        for _, specId in ipairs(cls.specs) do
            local info = UIDropDownMenu_CreateInfo()
            info.text  = SPEC_NAMES[specId] or specId
            info.value = specId
            info.func  = function()
                UIDropDownMenu_SetText(f._specDropdown, SPEC_NAMES[specId] or specId)
                CoAAT_SettingsFrame._pendingSpec = specId
            end
            UIDropDownMenu_AddButton(info)
        end
    end)
    UIDropDownMenu_SetText(f._specDropdown, SPEC_NAMES[cls.specs[1]] or cls.specs[1])
end

function CoAAT_SettingsFrame.UpdateRotSummary()
    local f = _frame
    if not f then return end
    local specDef = CoAAT_Engine.GetSpecDef()
    if specDef and specDef.rotationSummary then
        f._rotSummary:SetText("|cffdddddd" .. specDef.rotationSummary .. "|r\n\n" ..
            "|cffaaaaaa(See Tutorial for full step-by-step guide)|r")
    else
        f._rotSummary:SetText("|cffaaaaaa[Select a class to see the rotation]|r")
    end
end

function CoAAT_SettingsFrame.OnOpen()
    local f = _frame
    if not f then return end

    local classId = CoAAT_Engine.GetClassId()
    local specId  = CoAAT_Engine.GetSpecId()

    if classId then
        local selectedCls = nil
        for _, cls in ipairs(CLASS_ORDER) do
            if cls.id == classId then
                selectedCls = cls
                break
            end
        end

        if selectedCls then
            local displayName = classId:gsub("_", " "):gsub("(%a)([%a']*)", function(first, rest) return first:upper() .. rest end)
            UIDropDownMenu_SetText(f._classDropdown, displayName)
            CoAAT_SettingsFrame._pendingClass = classId

            CoAAT_SettingsFrame.UpdateSpecDropdown(selectedCls)
            if specId then
                UIDropDownMenu_SetText(f._specDropdown, SPEC_NAMES[specId] or specId)
                CoAAT_SettingsFrame._pendingSpec = specId
            end
        end
    else
        UIDropDownMenu_SetText(f._classDropdown, "-- Select Class --")
        UIDropDownMenu_SetText(f._specDropdown, "-- Select Spec --")
        CoAAT_SettingsFrame._pendingClass = nil
        CoAAT_SettingsFrame._pendingSpec = nil
    end

    CoAAT_SettingsFrame.UpdateRotSummary()
    f._applyBtn:Disable()
end

function CoAAT_SettingsFrame.Toggle()
    if _frame then
        if _frame:IsShown() then
            PlaySound(830) -- Window close
            _frame:Hide()
        else
            PlaySound(829) -- Window open
            _frame:SetAlpha(1.0)
            CoAAT_SettingsFrame.OnOpen()
            _frame:Show()
        end
    end
end
