-- ============================================================
-- CoAAbilityTrainer - Settings Frame (Simplistic Single-Button Design)
-- Class / Spec picker + Options panel
-- ============================================================

CoAAT_SettingsFrame = {}

local _frame = nil

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
    { id="runemaster",      specs={"engravement","glyphic","runeblade"} },
    { id="starcaller",      specs={"astral","solar","lunar"} },
    { id="stormbringer",    specs={"lightning","tempest","thunder"} },
    { id="sun_cleric",      specs={"light","solar","healing"} },
    { id="templar",         specs={"retribution","justice","protection"} },
    { id="tinker",          specs={"battletech","medic","juggernaut"} },
    { id="venomancer",      specs={"poison","shadow","toxin"} },
    { id="witch_doctor",    specs={"voodoo","hex","healing"} },
    { id="witch_hunter",    specs={"inquisitor","ravager","warden"} },
}

local SPEC_NAMES = {
    berserker        = "Berserker",
    wild             = "Wild",
    chieftain        = "Chieftain",
    vitality         = "Vitality",
    crimson          = "Crimson",
    sanguine         = "Sanguine",
    acceleration     = "Acceleration",
    temporal_rift    = "Temporal Rift",
    timeless         = "Timeless",
    darkness         = "Darkness",
    shadow           = "Shadow",
    corruption       = "Corruption",
    infernal         = "Infernal (Caster)",
    slayer           = "Slayer (Melee)",
    tyrant           = "Tyrant (Tank)",
    defense          = "Defense",
    protection       = "Protection",
    valor            = "Valor",
    destruction      = "Destruction",
    doom             = "Doom",
    hellfire         = "Hellfire",
    reanimation      = "Reanimation",
    death            = "Death",
    frost            = "Frost",
    elemental        = "Elemental",
    beast            = "Beast",
    wildgrowth       = "Wildgrowth",
    fire             = "Fire",
    ember            = "Ember",
    combustion       = "Combustion",
    marksmanship     = "Marksmanship",
    survival         = "Survival",
    beast_master     = "Beast Master",
    harvest          = "Harvest",
    soul             = "Soul",
    defiance         = "Defiance",
    engravement      = "Engravement",
    glyphic          = "Glyphic",
    runeblade        = "Runeblade",
    astral           = "Astral",
    solar            = "Solar",
    lunar            = "Lunar",
    lightning        = "Lightning",
    tempest          = "Tempest",
    thunder          = "Thunder",
    light            = "Light",
    healing          = "Healing",
    retribution      = "Retribution",
    color            = "Color",
    battletech       = "Battletech",
    medic            = "Medic",
    juggernaut       = "Juggernaut",
    poison           = "Poison",
    toxin            = "Toxin",
    voodoo           = "Voodoo",
    hex              = "Hex",
    inquisitor       = "Inquisitor",
    ravager          = "Ravager",
    warden           = "Warden",
}

function CoAAT_SettingsFrame.Build()
    local f = CreateFrame("Frame", "CoAATSettingsFrame", UIParent)
    f:SetSize(380, 560)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetToplevel(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop",  function(self) self:StopMovingOrSizing() end)

    -- Background (glassmorphic vertical gradient)
    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0.03, 0.04, 0.10, 0.97)
    if bg.SetGradientAlpha then
        bg:SetGradientAlpha("VERTICAL", 0.015, 0.02, 0.05, 0.98, 0.045, 0.06, 0.15, 0.94)
    end

    -- Borders (softened to 0.15 alpha to remove boxiness)
    local function makeLine(parent, w, h, point, relPoint, offX, offY)
        local l = parent:CreateTexture(nil, "OVERLAY")
        l:SetSize(w, h)
        l:SetTexture(0.0, 0.5, 0.8, 0.15)
        l:SetPoint(point, parent, relPoint, offX, offY)
        return l
    end
    makeLine(f, 380, 1, "TOPLEFT",     "TOPLEFT",     0,  0)
    makeLine(f, 380, 1, "BOTTOMLEFT",  "BOTTOMLEFT",  0,  0)
    makeLine(f, 1, 560, "TOPLEFT",     "TOPLEFT",     0,  0)
    makeLine(f, 1, 560, "TOPRIGHT",    "TOPRIGHT",    0,  0)

    -- Close button (top right)
    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
    close:SetScript("OnClick", function()
        CoAAT_SettingsFrame.Toggle()
    end)

    -- Tutorial/Help button [?] (Next to close button)
    local helpBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    helpBtn:SetSize(22, 22)
    helpBtn:SetPoint("TOPRIGHT", close, "TOPLEFT", -2, -5)
    helpBtn:SetText("?")
    helpBtn:SetScript("OnClick", function()
        local classId = CoAAT_Engine.GetClassId() or "general"
        CoAAT_TutorialPanel.ShowClassIntro(classId)
    end)

    -- Title
    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -14)
    title:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    title:SetText("|cff00ccff⚔ CoA Ability Trainer|r")

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

    -- ── Section: Options ──
    local optHdr = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    optHdr:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -110)
    optHdr:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    optHdr:SetText("|cffFFD700HUD Configuration & Customization|r")

    -- Checkboxes: Col 1 (X = 10)
    local hideCombatCB = CreateFrame("CheckButton", "CoAATHideCombatCB", f, "UICheckButtonTemplate")
    hideCombatCB:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -130)
    _G[hideCombatCB:GetName() .. "Text"]:SetText("|cffddddddHide out of combat|r")
    hideCombatCB:SetChecked(CoAAT_DB and CoAAT_DB.hideOutOfCombat or false)
    hideCombatCB:SetScript("OnClick", function(self)
        if CoAAT_DB then CoAAT_DB.hideOutOfCombat = self:GetChecked() end
    end)

    local rotHelperCB = CreateFrame("CheckButton", "CoAATRotHelperCB", f, "UICheckButtonTemplate")
    rotHelperCB:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -156)
    _G[rotHelperCB:GetName() .. "Text"]:SetText("|cffddddddShow Rotation HUD|r")
    rotHelperCB:SetChecked(CoAAT_DB and CoAAT_DB.showRotHelper ~= false)
    rotHelperCB:SetScript("OnClick", function(self)
        if CoAAT_DB then CoAAT_DB.showRotHelper = self:GetChecked() end
        CoAAT_CombatHUD.RefreshLayout()
    end)

    local resBarCB = CreateFrame("CheckButton", "CoAATResBarCB", f, "UICheckButtonTemplate")
    resBarCB:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -182)
    _G[resBarCB:GetName() .. "Text"]:SetText("|cffddddddShow Resource Bar|r")
    resBarCB:SetChecked(CoAAT_DB and CoAAT_DB.showResourceBar ~= false)
    resBarCB:SetScript("OnClick", function(self)
        if CoAAT_DB then CoAAT_DB.showResourceBar = self:GetChecked() end
        CoAAT_CombatHUD.RefreshLayout()
    end)

    local aurasCB = CreateFrame("CheckButton", "CoAATAurasCB", f, "UICheckButtonTemplate")
    aurasCB:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -208)
    _G[aurasCB:GetName() .. "Text"]:SetText("|cffddddddShow Aura Tracker|r")
    aurasCB:SetChecked(CoAAT_DB and CoAAT_DB.showAuras ~= false)
    aurasCB:SetScript("OnClick", function(self)
        if CoAAT_DB then CoAAT_DB.showAuras = self:GetChecked() end
        CoAAT_CombatHUD.RefreshLayout()
    end)

    local nameplateCB = CreateFrame("CheckButton", "CoAATAttachNameplateCB", f, "UICheckButtonTemplate")
    nameplateCB:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -234)
    _G[nameplateCB:GetName() .. "Text"]:SetText("|cffddddddAttach to 3D Nameplate|r")
    nameplateCB:SetChecked(CoAAT_DB and CoAAT_DB.attachToNameplate ~= false)
    nameplateCB:SetScript("OnClick", function(self)
        if CoAAT_DB then CoAAT_DB.attachToNameplate = self:GetChecked() end
        CoAAT_CombatHUD.RefreshLayout()
    end)

    -- Checkboxes: Col 2 (X = 190)
    local procAlertCB = CreateFrame("CheckButton", "CoAATShowProcAlertCB", f, "UICheckButtonTemplate")
    procAlertCB:SetPoint("TOPLEFT", f, "TOPLEFT", 190, -130)
    _G[procAlertCB:GetName() .. "Text"]:SetText("|cffddddddShow proc alerts|r")
    procAlertCB:SetChecked(CoAAT_DB and CoAAT_DB.showProcAlerts ~= false)
    procAlertCB:SetScript("OnClick", function(self)
        if CoAAT_DB then CoAAT_DB.showProcAlerts = self:GetChecked() end
    end)

    local aoeModeCB = CreateFrame("CheckButton", "CoAATAoEModeCB", f, "UICheckButtonTemplate")
    aoeModeCB:SetPoint("TOPLEFT", f, "TOPLEFT", 190, -156)
    _G[aoeModeCB:GetName() .. "Text"]:SetText("|cffddddddEnable AoE Mode|r")
    aoeModeCB:SetChecked(CoAAT_Engine.GetAoEMode())
    aoeModeCB:SetScript("OnClick", function(self)
        CoAAT_Engine.ToggleAoEMode()
    end)
    f._aoeModeCB = aoeModeCB

    local cdStripCB = CreateFrame("CheckButton", "CoAATCdStripCB", f, "UICheckButtonTemplate")
    cdStripCB:SetPoint("TOPLEFT", f, "TOPLEFT", 190, -182)
    _G[cdStripCB:GetName() .. "Text"]:SetText("|cffddddddShow Cooldowns|r")
    cdStripCB:SetChecked(CoAAT_DB and CoAAT_DB.showCooldowns ~= false)
    cdStripCB:SetScript("OnClick", function(self)
        if CoAAT_DB then CoAAT_DB.showCooldowns = self:GetChecked() end
        CoAAT_CombatHUD.RefreshLayout()
    end)

    local hideBorderCB = CreateFrame("CheckButton", "CoAATHideBorderCB", f, "UICheckButtonTemplate")
    hideBorderCB:SetPoint("TOPLEFT", f, "TOPLEFT", 190, -208)
    _G[hideBorderCB:GetName() .. "Text"]:SetText("|cffddddddHide Drag Border|r")
    hideBorderCB:SetChecked(CoAAT_DB and CoAAT_DB.hideDragBorder or false)
    hideBorderCB:SetScript("OnClick", function(self)
        if CoAAT_DB then CoAAT_DB.hideDragBorder = self:GetChecked() end
        CoAAT_CombatHUD.RefreshLayout()
    end)

    local cursorHUDCB = CreateFrame("CheckButton", "CoAATCursorHUDCB", f, "UICheckButtonTemplate")
    cursorHUDCB:SetPoint("TOPLEFT", f, "TOPLEFT", 190, -234)
    _G[cursorHUDCB:GetName() .. "Text"]:SetText("|cffddddddAttach Vitals to Cursor|r")
    cursorHUDCB:SetChecked(CoAAT_DB and CoAAT_DB.showCursorHUD or false)
    cursorHUDCB:SetScript("OnClick", function(self)
        if CoAAT_DB then CoAAT_DB.showCursorHUD = self:GetChecked() end
        CoAAT_CombatHUD.RefreshLayout()
    end)

    -- Dropdown: Cursor HUD Layout
    local layoutLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    layoutLabel:SetPoint("TOPLEFT", f, "TOPLEFT", 190, -260)
    layoutLabel:SetText("|cffddddddCursor HUD Layout:|r")

    local layoutDropdown = CreateFrame("Frame", "CoAATCursorHUDLayoutDropdown", f, "UIDropDownMenuTemplate")
    layoutDropdown:SetPoint("TOPLEFT", f, "TOPLEFT", 175, -276)
    UIDropDownMenu_SetWidth(layoutDropdown, 120)

    local function Dropdown_OnClick(self)
        UIDropDownMenu_SetSelectedValue(layoutDropdown, self.value)
        if CoAAT_DB then
            CoAAT_DB.cursorHUDOrientation = self.value
        end
        UIDropDownMenu_SetText(layoutDropdown, self.text)
        CoAAT_CombatHUD.RefreshLayout()
    end

    UIDropDownMenu_Initialize(layoutDropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        
        info.text = "Angled Corner"
        info.value = "angled"
        info.func = Dropdown_OnClick
        info.checked = (CoAAT_DB and CoAAT_DB.cursorHUDOrientation == "angled")
        UIDropDownMenu_AddButton(info, level)

        info.text = "Vertical Brackets"
        info.value = "vertical"
        info.func = Dropdown_OnClick
        info.checked = (CoAAT_DB and CoAAT_DB.cursorHUDOrientation == "vertical")
        UIDropDownMenu_AddButton(info, level)

        info.text = "Horizontal Stack"
        info.value = "horizontal"
        info.func = Dropdown_OnClick
        info.checked = (CoAAT_DB and CoAAT_DB.cursorHUDOrientation == "horizontal")
        UIDropDownMenu_AddButton(info, level)
    end)

    local currentOrient = CoAAT_DB and CoAAT_DB.cursorHUDOrientation or "angled"
    UIDropDownMenu_SetSelectedValue(layoutDropdown, currentOrient)
    UIDropDownMenu_SetText(layoutDropdown, (currentOrient == "horizontal" and "Horizontal Stack") or (currentOrient == "vertical" and "Vertical Brackets") or "Angled Corner")

    -- Divider
    local div2 = f:CreateTexture(nil, "OVERLAY")
    div2:SetSize(352, 1)
    div2:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -288)
    div2:SetTexture(0.0, 0.4, 0.7, 0.4)

    -- Sliders Row 1: Scale & Opacity (Y = -295)
    local scaleSlider = CreateFrame("Slider", "CoAATHUDScaleSlider", f, "OptionsSliderTemplate")
    scaleSlider:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -295)
    scaleSlider:SetWidth(150)
    scaleSlider:SetMinMaxValues(0.5, 1.5)
    scaleSlider:SetValueStep(0.05)
    _G[scaleSlider:GetName() .. "Text"]:SetText("HUD Scale: 1.00")
    _G[scaleSlider:GetName() .. "Low"]:SetText("0.5")
    _G[scaleSlider:GetName() .. "High"]:SetText("1.5")
    scaleSlider:SetScript("OnValueChanged", function(self, value)
        if CoAAT_DB then CoAAT_DB.hudScale = value end
        _G[self:GetName() .. "Text"]:SetText("HUD Scale: " .. string.format("%.2f", value))
        CoAAT_CombatHUD.RefreshLayout()
    end)
    f._scaleSlider = scaleSlider

    local alphaSlider = CreateFrame("Slider", "CoAATHUDAlphaSlider", f, "OptionsSliderTemplate")
    alphaSlider:SetPoint("TOPLEFT", f, "TOPLEFT", 190, -295)
    alphaSlider:SetWidth(150)
    alphaSlider:SetMinMaxValues(0.2, 1.0)
    alphaSlider:SetValueStep(0.05)
    _G[alphaSlider:GetName() .. "Text"]:SetText("HUD Opacity: 1.00")
    _G[alphaSlider:GetName() .. "Low"]:SetText("0.2")
    _G[alphaSlider:GetName() .. "High"]:SetText("1.0")
    alphaSlider:SetScript("OnValueChanged", function(self, value)
        if CoAAT_DB then CoAAT_DB.hudAlpha = value end
        _G[self:GetName() .. "Text"]:SetText("HUD Opacity: " .. string.format("%.2f", value))
        CoAAT_CombatHUD.RefreshLayout()
    end)
    f._alphaSlider = alphaSlider

    -- Sliders Row 2: Rotation & Cooldown sizes (Y = -340)
    local rotIconSizeSlider = CreateFrame("Slider", "CoAATRotIconSizeSlider", f, "OptionsSliderTemplate")
    rotIconSizeSlider:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -340)
    rotIconSizeSlider:SetWidth(150)
    rotIconSizeSlider:SetMinMaxValues(30, 80)
    rotIconSizeSlider:SetValueStep(1)
    _G[rotIconSizeSlider:GetName() .. "Text"]:SetText("Rotation Icon: 50")
    _G[rotIconSizeSlider:GetName() .. "Low"]:SetText("30")
    _G[rotIconSizeSlider:GetName() .. "High"]:SetText("80")
    rotIconSizeSlider:SetScript("OnValueChanged", function(self, value)
        if CoAAT_DB then CoAAT_DB.rotIconSize = value end
        _G[self:GetName() .. "Text"]:SetText("Rotation Icon: " .. string.format("%.0f", value))
        CoAAT_CombatHUD.RefreshLayout()
    end)
    f._rotIconSizeSlider = rotIconSizeSlider

    local cdIconSizeSlider = CreateFrame("Slider", "CoAATCdIconSizeSlider", f, "OptionsSliderTemplate")
    cdIconSizeSlider:SetPoint("TOPLEFT", f, "TOPLEFT", 190, -340)
    cdIconSizeSlider:SetWidth(150)
    cdIconSizeSlider:SetMinMaxValues(25, 70)
    cdIconSizeSlider:SetValueStep(1)
    _G[cdIconSizeSlider:GetName() .. "Text"]:SetText("Cooldown Icon: 46")
    _G[cdIconSizeSlider:GetName() .. "Low"]:SetText("25")
    _G[cdIconSizeSlider:GetName() .. "High"]:SetText("70")
    cdIconSizeSlider:SetScript("OnValueChanged", function(self, value)
        if CoAAT_DB then CoAAT_DB.cdIconSize = value end
        _G[cdIconSizeSlider:GetName() .. "Text"]:SetText("Cooldown Icon: " .. string.format("%.0f", value))
        CoAAT_CombatHUD.RefreshLayout()
    end)
    f._cdIconSizeSlider = cdIconSizeSlider

    -- Sliders Row 3: Resource Bar Width (Y = -385)
    local resBarWidthSlider = CreateFrame("Slider", "CoAATResBarWidthSlider", f, "OptionsSliderTemplate")
    resBarWidthSlider:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -385)
    resBarWidthSlider:SetWidth(150)
    resBarWidthSlider:SetMinMaxValues(150, 400)
    resBarWidthSlider:SetValueStep(5)
    _G[resBarWidthSlider:GetName() .. "Text"]:SetText("Resource Bar: 264")
    _G[resBarWidthSlider:GetName() .. "Low"]:SetText("150")
    _G[resBarWidthSlider:GetName() .. "High"]:SetText("400")
    resBarWidthSlider:SetScript("OnValueChanged", function(self, value)
        if CoAAT_DB then CoAAT_DB.resBarWidth = value end
        _G[resBarWidthSlider:GetName() .. "Text"]:SetText("Resource Bar: " .. string.format("%.0f", value))
        CoAAT_CombatHUD.RefreshLayout()
    end)
    f._resBarWidthSlider = resBarWidthSlider

    -- Divider
    local div3 = f:CreateTexture(nil, "OVERLAY")
    div3:SetSize(352, 1)
    div3:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -425)
    div3:SetTexture(0.0, 0.4, 0.7, 0.4)

    -- ── Quick Rotation Summary ──
    local rotHdr = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    rotHdr:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -435)
    rotHdr:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    rotHdr:SetText("|cffFFD700Current Rotation Summary|r")

    local rotSummary = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    rotSummary:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -455)
    rotSummary:SetSize(352, 55)
    rotSummary:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    rotSummary:SetJustifyH("LEFT")
    rotSummary:SetJustifyV("TOP")
    rotSummary:SetText("|cffaaaaaa[No class selected]|r")
    f._rotSummary = rotSummary

    -- ── Bottom Buttons ──
    local saveBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    saveBtn:SetSize(220, 32)
    saveBtn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 14, 12)
    saveBtn:SetText("⚡ Save & Setup Hotbar")
    saveBtn:SetScript("OnClick", function()
        CoAAT_SettingsFrame.SaveAndSetup()
    end)
    f._saveBtn = saveBtn

    local resetBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    resetBtn:SetSize(122, 32)
    resetBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -14, 12)
    resetBtn:SetText("↺ Reset Layout")
    resetBtn:SetScript("OnClick", function()
        if CoAAT_DB then
            CoAAT_DB.positions = {}
            print("|cff00ccff[CoAAT] HUD layouts reset to default!|r")
            CoAAT_CombatHUD.RefreshLayout()
        end
    end)
    f._resetBtn = resetBtn

    f:Hide()
    _frame = f
    CoAAT_SettingsFrame._frame = f

    -- Hook: update rotation summary when class changes
    hooksecurefunc(CoAAT_Engine, "SetClass", function(classId, specId)
        CoAAT_SettingsFrame.UpdateRotSummary()
    end)
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

    -- Sync toggles
    if f._aoeModeCB then
        f._aoeModeCB:SetChecked(CoAAT_Engine.GetAoEMode())
    end
    _G["CoAATHideCombatCB"]:SetChecked(CoAAT_DB and CoAAT_DB.hideOutOfCombat or false)
    _G["CoAATRotHelperCB"]:SetChecked(CoAAT_DB and CoAAT_DB.showRotHelper ~= false)
    _G["CoAATResBarCB"]:SetChecked(CoAAT_DB and CoAAT_DB.showResourceBar ~= false)
    _G["CoAATAurasCB"]:SetChecked(CoAAT_DB and CoAAT_DB.showAuras ~= false)
    _G["CoAATShowProcAlertCB"]:SetChecked(CoAAT_DB and CoAAT_DB.showProcAlerts ~= false)
    _G["CoAATCdStripCB"]:SetChecked(CoAAT_DB and CoAAT_DB.showCooldowns ~= false)
    _G["CoAATHideBorderCB"]:SetChecked(CoAAT_DB and CoAAT_DB.hideDragBorder or false)
    _G["CoAATCursorHUDCB"]:SetChecked(CoAAT_DB and CoAAT_DB.showCursorHUD or false)

    -- Sync dropdown values
    if CoAATCursorHUDLayoutDropdown then
        local currentOrient = CoAAT_DB and CoAAT_DB.cursorHUDOrientation or "angled"
        UIDropDownMenu_SetSelectedValue(CoAATCursorHUDLayoutDropdown, currentOrient)
        UIDropDownMenu_SetText(CoAATCursorHUDLayoutDropdown, (currentOrient == "horizontal" and "Horizontal Stack") or (currentOrient == "vertical" and "Vertical Brackets") or "Angled Corner")
    end

    -- Sync sliders
    if f._scaleSlider then
        f._scaleSlider:SetValue(CoAAT_DB and CoAAT_DB.hudScale or 1.0)
    end
    if f._alphaSlider then
        f._alphaSlider:SetValue(CoAAT_DB and CoAAT_DB.hudAlpha or 1.0)
    end
    if f._rotIconSizeSlider then
        f._rotIconSizeSlider:SetValue(CoAAT_DB and CoAAT_DB.rotIconSize or 50)
    end
    if f._cdIconSizeSlider then
        f._cdIconSizeSlider:SetValue(CoAAT_DB and CoAAT_DB.cdIconSize or 46)
    end
    if f._resBarWidthSlider then
        f._resBarWidthSlider:SetValue(CoAAT_DB and CoAAT_DB.resBarWidth or 264)
    end

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
end

function CoAAT_SettingsFrame.Toggle()
    if _frame then
        if _frame:IsShown() then
            PlaySound(830)
            _frame:Hide()
        else
            PlaySound(829)
            _frame:SetAlpha(1.0)
            CoAAT_SettingsFrame.OnOpen()
            _frame:Show()
        end
    end
end

-- ─────────────────────────────────────────────
-- Consolidated Save & Auto-Setup logic
-- ─────────────────────────────────────────────
function CoAAT_SettingsFrame.SaveAndSetup()
    local classId = CoAAT_SettingsFrame._pendingClass
    local specId  = CoAAT_SettingsFrame._pendingSpec
    
    if classId and specId then
        CoAAT_Engine.SetClass(classId, specId)
    end

    -- Setup Hotbar Page 2 macros
    CoAAT_SettingsFrame.SetupHotbarPage2()

    -- Close window
    CoAAT_SettingsFrame.Toggle()
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
        return
    end

    print("|cff00ccff[CoAAT] Setting up hotbar Page 2 for " .. specDef.name .. "...|r")

    ClearCursor()

    -- 1. Formulate the one-button rotation castsequence macro (CoA_Rot)
    local generator, spender, debuff
    for _, abi in ipairs(specDef.abilities) do
        if abi.type == "generator" then
            generator = abi.name
        elseif abi.type == "spender" then
            spender = abi.name
        elseif abi.type == "debuff" then
            debuff = abi.name
        end
    end

    local seqParts = {}
    if debuff then table.insert(seqParts, debuff) end
    if generator then 
        table.insert(seqParts, generator)
        table.insert(seqParts, generator)
    end
    if spender then table.insert(seqParts, spender) end
    local castSeq = #seqParts > 0 and table.concat(seqParts, ", ") or nil

    if castSeq then
        local rotMacroName = "CoA_Rot"
        local rotMacroBody = "#showtooltip\n/use 13\n/use 14\n/use 10\n/castsequence reset=combat/target " .. castSeq
        local rotMacroIndex = GetMacroIndexByName(rotMacroName)

        if not rotMacroIndex or rotMacroIndex == 0 then
            local _, numChar = GetNumMacros()
            if numChar < 18 then
                rotMacroIndex = CreateMacro(rotMacroName, "INV_Misc_QuestionMark", rotMacroBody, 1)
            else
                local numGlobal = GetNumMacros()
                if numGlobal < 36 then
                    rotMacroIndex = CreateMacro(rotMacroName, "INV_Misc_QuestionMark", rotMacroBody, nil)
                end
            end
        else
            EditMacro(rotMacroIndex, nil, nil, rotMacroBody)
        end

        if rotMacroIndex and rotMacroIndex > 0 then
            PickupMacro(rotMacroIndex)
            PlaceAction(13) -- Place one-button rotation in Slot 13 (Page 2 Slot 1)
            ClearCursor()
            print("|cff00ffaa[CoAAT] Created/Updated One-Button Rotation Macro: CoA_Rot|r")
        end
    end

    -- 2. Create/Update individual optimized abilities macros (pop trinkets + engineering)
    for i, ability in ipairs(specDef.abilities) do
        local slot = 13 + i -- Place individual macros in slots 14 onwards
        if slot > 24 then break end

        -- Warn if spell not learned
        if not GetSpellInfo(ability.name) then
            print("|cffffaa00[CoAAT] Alert: You have not learned " .. ability.name .. " yet. Visit your trainer!|r")
        end

        local macroName = "CoA_" .. ability.name:gsub("%s", ""):sub(1, 12)
        local macroBody = "#showtooltip " .. ability.name .. "\n/use 13\n/use 14\n/use 10\n/cast " .. ability.name

        local macroIndex = GetMacroIndexByName(macroName)
        if not macroIndex or macroIndex == 0 then
            local _, numChar = GetNumMacros()
            if numChar < 18 then
                macroIndex = CreateMacro(macroName, "INV_Misc_QuestionMark", macroBody, 1)
            else
                local numGlobal = GetNumMacros()
                if numGlobal < 36 then
                    macroIndex = CreateMacro(macroName, "INV_Misc_QuestionMark", macroBody, nil)
                end
            end
        else
            EditMacro(macroIndex, nil, nil, macroBody)
        end

        if macroIndex and macroIndex > 0 then
            PickupMacro(macroIndex)
            PlaceAction(slot)
            ClearCursor()
        end
    end

    print("|cff00ccff[CoAAT] Hotbar Page 2 setup complete! Switched page 2 icons.|r")
end
