-- ============================================================
-- CoAAbilityTrainer - Rotation Helper (Full UI Overhaul with Keybinds, GCD & Range)
-- Centralized WeakAura style HUD showing exact rotational priority
-- ============================================================

CoAAT_RotationHelper = {}

local _frame     = nil
local _current   = nil
local _urgency   = nil
local _animPhase = 0

local UGC = {
    critical = { r=1.0, g=0.1, b=0.1, pulse=6.0 },
    high     = { r=1.0, g=0.6, b=0.0, pulse=4.0 },
    medium   = { r=0.2, g=0.8, b=1.0, pulse=2.5 },
    low      = { r=0.5, g=0.6, b=0.7, pulse=1.0 },
}

-- Cache mapping spell names to their active keybinds
local spellKeybinds = {}

-- ─────────────────────────────────────────────
-- Helper to format raw keybind strings
-- ─────────────────────────────────────────────
local function FormatKeybind(key)
    if not key then return "" end
    
    key = key:upper()
    key = key:gsub("ALT%-", "A-")
    key = key:gsub("CTRL%-", "C-")
    key = key:gsub("SHIFT%-", "S-")
    key = key:gsub("BUTTON", "M")
    key = key:gsub("MOUSEWHEELUP", "WU")
    key = key:gsub("MOUSEWHEELDOWN", "WD")
    key = key:gsub("NUMPAD", "N")
    key = key:gsub("SPACE", "SP")
    key = key:gsub("INSERT", "INS")
    key = key:gsub("DELETE", "DEL")
    key = key:gsub("HOME", "HM")
    key = key:gsub("PAGEUP", "PU")
    key = key:gsub("PAGEDOWN", "PD")
    
    return key
end

-- ─────────────────────────────────────────────
-- Scan action bars to map spells/macros to keybinds
-- ─────────────────────────────────────────────
local slotBindings = {
    [1] = "ACTIONBUTTON1", [2] = "ACTIONBUTTON2", [3] = "ACTIONBUTTON3", [4] = "ACTIONBUTTON4", [5] = "ACTIONBUTTON5", [6] = "ACTIONBUTTON6",
    [7] = "ACTIONBUTTON7", [8] = "ACTIONBUTTON8", [9] = "ACTIONBUTTON9", [10] = "ACTIONBUTTON10", [11] = "ACTIONBUTTON11", [12] = "ACTIONBUTTON12",
    [13] = "BONUSACTIONBUTTON1", [14] = "BONUSACTIONBUTTON2", [15] = "BONUSACTIONBUTTON3", [16] = "BONUSACTIONBUTTON4", [17] = "BONUSACTIONBUTTON5", [18] = "BONUSACTIONBUTTON6",
    [19] = "BONUSACTIONBUTTON7", [20] = "BONUSACTIONBUTTON8", [21] = "BONUSACTIONBUTTON9", [22] = "BONUSACTIONBUTTON10", [23] = "BONUSACTIONBUTTON11", [24] = "BONUSACTIONBUTTON12",
    [25] = "MULTIACTIONBAR3BUTTON1", [26] = "MULTIACTIONBAR3BUTTON2", [27] = "MULTIACTIONBAR3BUTTON3", [28] = "MULTIACTIONBAR3BUTTON4", [29] = "MULTIACTIONBAR3BUTTON5", [30] = "MULTIACTIONBAR3BUTTON6",
    [31] = "MULTIACTIONBAR3BUTTON7", [32] = "MULTIACTIONBAR3BUTTON8", [33] = "MULTIACTIONBAR3BUTTON9", [34] = "MULTIACTIONBAR3BUTTON10", [35] = "MULTIACTIONBAR3BUTTON11", [36] = "MULTIACTIONBAR3BUTTON12",
    [37] = "MULTIACTIONBAR4BUTTON1", [38] = "MULTIACTIONBAR4BUTTON2", [39] = "MULTIACTIONBAR4BUTTON3", [40] = "MULTIACTIONBAR4BUTTON4", [41] = "MULTIACTIONBAR4BUTTON5", [42] = "MULTIACTIONBAR4BUTTON6",
    [43] = "MULTIACTIONBAR4BUTTON7", [44] = "MULTIACTIONBAR4BUTTON8", [45] = "MULTIACTIONBAR4BUTTON9", [46] = "MULTIACTIONBAR4BUTTON10", [47] = "MULTIACTIONBAR4BUTTON11", [48] = "MULTIACTIONBAR4BUTTON12",
    [49] = "MULTIACTIONBAR2BUTTON1", [50] = "MULTIACTIONBAR2BUTTON2", [51] = "MULTIACTIONBAR2BUTTON3", [52] = "MULTIACTIONBAR2BUTTON4", [53] = "MULTIACTIONBAR2BUTTON5", [54] = "MULTIACTIONBAR2BUTTON6",
    [55] = "MULTIACTIONBAR2BUTTON7", [56] = "MULTIACTIONBAR2BUTTON8", [57] = "MULTIACTIONBAR2BUTTON9", [58] = "MULTIACTIONBAR2BUTTON10", [59] = "MULTIACTIONBAR2BUTTON11", [60] = "MULTIACTIONBAR2BUTTON12",
    [61] = "MULTIACTIONBAR1BUTTON1", [62] = "MULTIACTIONBAR1BUTTON2", [63] = "MULTIACTIONBAR1BUTTON3", [64] = "MULTIACTIONBAR1BUTTON4", [65] = "MULTIACTIONBAR1BUTTON5", [66] = "MULTIACTIONBAR1BUTTON6",
    [67] = "MULTIACTIONBAR1BUTTON7", [68] = "MULTIACTIONBAR1BUTTON8", [69] = "MULTIACTIONBAR1BUTTON9", [70] = "MULTIACTIONBAR1BUTTON10", [71] = "MULTIACTIONBAR1BUTTON11", [72] = "MULTIACTIONBAR1BUTTON12",
}

local function GetBindingForSlot(slot)
    if slotBindings[slot] then
        return slotBindings[slot]
    elseif slot >= 73 and slot <= 120 then
        local btn = ((slot - 1) % 12) + 1
        return "ACTIONBUTTON" .. btn
    end
    return nil
end

local function GetClassSpells()
    local spells = {}
    local classId = CoAAT_Engine and CoAAT_Engine.classId
    if classId and CoAAT_Abilities and CoAAT_Abilities[classId] then
        local classDef = CoAAT_Abilities[classId]
        if classDef.specs then
            for specName, specDef in pairs(classDef.specs) do
                if specDef.abilities then
                    for _, ab in ipairs(specDef.abilities) do
                        if ab.name then
                            spells[ab.name:lower()] = true
                        end
                    end
                end
            end
        end
    end
    return spells
end

function CoAAT_RotationHelper.UpdateKeybindCache()
    wipe(spellKeybinds)
    
    local classSpells = GetClassSpells()
    
    for slot = 1, 120 do
        if HasAction(slot) then
            local actionType, id = GetActionInfo(slot)
            local bindingName = GetBindingForSlot(slot)
            if bindingName then
                local key = GetBindingKey(bindingName)
                if key then
                    local formattedKey = FormatKeybind(key)
                    if actionType == "spell" then
                        local spellName = GetSpellInfo(id)
                        if spellName then
                            spellKeybinds[spellName:lower()] = formattedKey
                        end
                    elseif actionType == "macro" then
                        local mName, mIcon, mBody = GetMacroInfo(id)
                        if mBody then
                            local bodyLower = mBody:lower()
                            -- Scan macro text to see if it casts any of our spec spells
                            for spellName, _ in pairs(classSpells) do
                                if bodyLower:find(spellName, 1, true) then
                                    spellKeybinds[spellName] = formattedKey
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- ─────────────────────────────────────────────
-- Build the rotation helper panel
-- ─────────────────────────────────────────────
function CoAAT_RotationHelper.Build(parent)
    local f = CreateFrame("Frame", "CoAATRotationHelper", parent)
    f:SetSize(400, 120)
    f:SetPoint("CENTER", parent, "CENTER", 0, 0)
    f:SetFrameStrata("HIGH")

    -- Helper to create colored icon slots
    local function createIconSlot(parentFrame, size, r, g, b)
        local border = parentFrame:CreateTexture(nil, "BACKGROUND")
        border:SetSize(size + 4, size + 4)
        border:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
        border:SetVertexColor(r, g, b, 0.85)

        local iconBG = parentFrame:CreateTexture(nil, "ARTWORK")
        iconBG:SetSize(size, size)
        iconBG:SetPoint("CENTER", border, "CENTER")
        iconBG:SetTexture(0.02, 0.02, 0.05, 0.95)

        local tex = parentFrame:CreateTexture(nil, "ARTWORK")
        tex:SetSize(size, size)
        tex:SetPoint("CENTER", border, "CENTER")
        tex:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        -- Keybind Text Overlay
        local keyText = parentFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmallOutline")
        keyText:SetPoint("TOPRIGHT", border, "TOPRIGHT", -2, -2)
        keyText:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
        keyText:SetTextColor(1, 1, 1, 0.95)

        -- Cooldown frame overlay (GCD / cooldown sweep)
        local cdFrame = CreateFrame("Cooldown", nil, parentFrame, "CooldownFrameTemplate")
        cdFrame:SetSize(size, size)
        cdFrame:SetPoint("CENTER", border, "CENTER")
        cdFrame:Hide()

        -- Gloss/Highlight overlay
        local gloss = parentFrame:CreateTexture(nil, "OVERLAY")
        gloss:SetSize(size, size)
        gloss:SetPoint("CENTER", border, "CENTER")
        gloss:SetTexture(1.0, 1.0, 1.0, 0.05)
        gloss:SetBlendMode("ADD")
        gloss:SetAlpha(0.4)

        return tex, border, keyText, cdFrame
    end

    -- Primary Icon (Centered, Floating)
    f._icon1, f._border1, f._key1, f._cd1 = createIconSlot(f, 40, 0.0, 0.6, 1.0)
    f._border1:SetPoint("CENTER", f, "CENTER", 0, 0)

    -- Pulsing glow ring around primary icon
    local glowRing = f:CreateTexture(nil, "OVERLAY")
    glowRing:SetSize(68, 68)
    glowRing:SetPoint("CENTER", f._icon1, "CENTER", 0, 0)
    glowRing:SetTexture("Interface\\Cooldown\\star4")
    glowRing:SetBlendMode("ADD")
    glowRing:SetAlpha(0)
    f._glowRing = glowRing

    -- Secondary / Tertiary slots (Hidden for clean single-icon floating look)
    f._icon2, f._border2, f._key2, f._cd2 = createIconSlot(f, 48, 1.0, 0.5, 0.0)
    f._border2:SetPoint("LEFT", f._border1, "RIGHT", 15, -12)
    f._border2:Hide()

    f._icon3, f._border3, f._key3, f._cd3 = createIconSlot(f, 36, 1.0, 0.0, 0.0)
    f._border3:SetPoint("LEFT", f._border2, "RIGHT", 10, -6)
    f._border3:Hide()

    -- AoE Mode Badge
    local aoeBadge = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    aoeBadge:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -5)
    aoeBadge:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    aoeBadge:SetText("|cff22ff22[SINGLE TARGET]|r")
    f._aoeBadge = aoeBadge

    -- Ability name (large, prominent above primary)
    local abilityName = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    abilityName:SetPoint("BOTTOM", f._border1, "TOP", 0, 8)
    abilityName:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    abilityName:SetText("")
    f._abilityName = abilityName

    -- Dynamic Teaching Hint (Above ability name)
    local hintText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    hintText:SetPoint("BOTTOM", abilityName, "TOP", 0, 4)
    hintText:SetWidth(250)
    hintText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    hintText:SetJustifyH("CENTER")
    hintText:SetText("|cffaaaaaa Waiting for combat...|r")
    f._hintText = hintText

    f:SetScript("OnUpdate", function(self, dt)
        _animPhase = _animPhase + dt
        CoAAT_RotationHelper.AnimTick(self, dt)
    end)

    -- Keybind Update Events
    f:RegisterEvent("UPDATE_BINDINGS")
    f:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:SetScript("OnEvent", function(self, event, ...)
        CoAAT_RotationHelper.UpdateKeybindCache()
    end)

    _frame = f
    f:Show()
    
    -- Initial scan
    CoAAT_RotationHelper.UpdateKeybindCache()
    
    return f
end

-- Action button glow overlays registry
local glowFrames = {}
local function CreateGlowFrame(button)
    if not button then return nil end
    local name = button:GetName()
    if not name then return nil end
    if glowFrames[name] then return glowFrames[name] end

    local g = CreateFrame("Frame", name .. "CoAATGlow", button)
    g:SetAllPoints(button)
    g:SetFrameLevel(button:GetFrameLevel() + 2)

    local tex = g:CreateTexture(nil, "OVERLAY")
    tex:SetAllPoints()
    tex:SetTexture("Interface\\Buttons\\CheckButtonHilight")
    tex:SetBlendMode("ADD")
    g.tex = tex

    g:Hide()
    glowFrames[name] = g
    return g
end

local function UpdateActionBarGlows(spellGlows)
    for _, g in pairs(glowFrames) do g:Hide() end
    if not spellGlows or #spellGlows == 0 then return end

    local prefixes = {
        "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
        "MultiBarLeftButton", "MultiBarRightButton"
    }

    for _, prefix in ipairs(prefixes) do
        for i = 1, 12 do
            local buttonName = prefix .. i
            local button = _G[buttonName]
            if button and button:IsShown() and button.action then
                local actionType, id = GetActionInfo(button.action)
                if actionType == "spell" then
                    local name = GetSpellInfo(id)
                    if name then
                        for _, sg in ipairs(spellGlows) do
                            if name:lower() == sg.spellName:lower() then
                                local g = CreateGlowFrame(button)
                                if g then
                                    g.tex:SetVertexColor(sg.r, sg.g, sg.b, 0.95)
                                    g:Show()
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- ─────────────────────────────────────────────
-- Set the next suggested abilities
-- ─────────────────────────────────────────────
function CoAAT_RotationHelper.SetNextAbilities(m1, m2, m3)
    local f = _frame
    if not f then return end

    local spellsToGlow = {}

    -- Primary
    if m1 and m1.abilityDef then
        f._icon1:SetTexture(m1.abilityDef.icon)
        
        -- If it's a learned counter action, override the title and hint text!
        if m1.counterType then
            local colorHex = (m1.counterType == "interrupt") and "|cffff2222" or "|cff00ffff"
            f._abilityName:SetText(colorHex .. m1.abilityDef.name .. " ⚡|r")
            f._hintText:SetText(colorHex .. m1.counterText .. "|r")
        else
            f._abilityName:SetText("|cff22ff22" .. m1.abilityDef.name .. "|r")
            f._hintText:SetText("|cffffd700" .. (m1.abilityDef.hint or m1.abilityDef.description or "Use immediately!") .. "|r")
        end
        
        table.insert(spellsToGlow, { spellName = m1.abilityDef.name, r = 0.0, g = 1.0, b = 0.0 })
        
        -- Store name for range check
        f._spellName1 = m1.abilityDef.name
        
        -- Keybind Lookup
        local bind = spellKeybinds[m1.abilityDef.name:lower()] or ""
        if bind == "NO_BIND" then bind = "" end
        f._key1:SetText(bind)

        -- Cooldown / GCD Sweep
        local start, duration = GetSpellCooldown(m1.abilityDef.name)
        if start and duration and duration > 0 then
            f._cd1:SetCooldown(start, duration)
            f._cd1:Show()
        else
            f._cd1:Hide()
        end
        
        _current = m1.abilityId
        _urgency = m1.urgency
    else
        f._icon1:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        f._abilityName:SetText("|cffaaaaaa—|r")
        f._hintText:SetText("|cffaaaaaa Waiting for combat...|r")
        f._key1:SetText("")
        f._cd1:Hide()
        f._spellName1 = nil
        _current = nil
        _urgency = nil
    end

    -- Secondary
    if m2 and m2.abilityDef then
        f._icon2:SetTexture(m2.abilityDef.icon)
        table.insert(spellsToGlow, { spellName = m2.abilityDef.name, r = 1.0, g = 0.5, b = 0.0 })
        f._spellName2 = m2.abilityDef.name
        
        local bind = spellKeybinds[m2.abilityDef.name:lower()] or ""
        if bind == "NO_BIND" then bind = "" end
        f._key2:SetText(bind)

        local start, duration = GetSpellCooldown(m2.abilityDef.name)
        if start and duration and duration > 0 then
            f._cd2:SetCooldown(start, duration)
            f._cd2:Show()
        else
            f._cd2:Hide()
        end
    else
        f._icon2:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        f._key2:SetText("")
        f._cd2:Hide()
        f._spellName2 = nil
    end

    -- Tertiary
    if m3 and m3.abilityDef then
        f._icon3:SetTexture(m3.abilityDef.icon)
        table.insert(spellsToGlow, { spellName = m3.abilityDef.name, r = 1.0, g = 0.0, b = 0.0 })
        f._spellName3 = m3.abilityDef.name
        
        local bind = spellKeybinds[m3.abilityDef.name:lower()] or ""
        if bind == "NO_BIND" then bind = "" end
        f._key3:SetText(bind)

        local start, duration = GetSpellCooldown(m3.abilityDef.name)
        if start and duration and duration > 0 then
            f._cd3:SetCooldown(start, duration)
            f._cd3:Show()
        else
            f._cd3:Hide()
        end
    else
        f._icon3:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        f._key3:SetText("")
        f._cd3:Hide()
        f._spellName3 = nil
    end

    UpdateActionBarGlows(spellsToGlow)

    local ugc = UGC[_urgency] or UGC.low
    f._glowRing:SetVertexColor(ugc.r, ugc.g, ugc.b)

    -- if m1 and CoAAT_AuraDisplay.SetHighlighted then
    --     CoAAT_AuraDisplay.SetHighlighted(m1.abilityId, m1.urgency)
    -- end
end

function CoAAT_RotationHelper.SetNextAbility(abilityId, urgency, abilityDef)
    if abilityId then
        CoAAT_RotationHelper.SetNextAbilities({abilityId=abilityId, urgency=urgency, abilityDef=abilityDef}, nil, nil)
    else
        CoAAT_RotationHelper.SetNextAbilities(nil, nil, nil)
    end
end

-- ─────────────────────────────────────────────
-- AoE Mode Toggle Badge update
-- ─────────────────────────────────────────────
function CoAAT_RotationHelper.OnAoEToggled(isAoE)
    if _frame and _frame._aoeBadge then
        if isAoE then
            _frame._aoeBadge:SetText("|cff00ffff[AOE MODE]|r")
        else
            _frame._aoeBadge:SetText("|cff22ff22[SINGLE TARGET]|r")
        end
    end
end

function CoAAT_RotationHelper.OnProcTriggered(procName)
    if _frame and _frame._glowRing then
        _frame._glowRing:SetAlpha(1.0)
    end
end

function CoAAT_RotationHelper.OnClassChanged(classId, specId)
    _current = nil
    _urgency = nil
    if _frame then
        _frame._abilityName:SetText("|cffFFD700Ready to help!|r")
        _frame._hintText:SetText("|cffaaaaaa Enter combat to see rotation suggestions|r")
        _frame._icon1:SetTexture("Interface\\Icons\\Ability_Warrior_Rampage")
        _frame._icon2:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        _frame._icon3:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        _frame._key1:SetText("")
        _frame._key2:SetText("")
        _frame._key3:SetText("")
        _frame._cd1:Hide()
        _frame._cd2:Hide()
        _frame._cd3:Hide()
        _frame._spellName1 = nil
        _frame._spellName2 = nil
        _frame._spellName3 = nil
        -- Reset AoE indicator
        _frame._aoeBadge:SetText("|cff22ff22[SINGLE TARGET]|r")
    end
end

function CoAAT_RotationHelper.OnCombatChange(inCombat)
    local setting = CoAAT_DB and CoAAT_DB.hideOutOfCombat
    if setting and _frame then
        if inCombat then _frame:Show()
        else
            _current = nil
            CoAAT_RotationHelper.SetNextAbility(nil, nil, nil)
        end
    end
end

-- ─────────────────────────────────────────────
-- Ticker checking range of targets
-- ─────────────────────────────────────────────
function CoAAT_RotationHelper.AnimTick(f, dt)
    -- Hide hints and helper texts in combat for absolute WeakAura cleanliness
    if InCombatLockdown() then
        f._abilityName:Hide()
        f._hintText:Hide()
        f._aoeBadge:Hide()
    else
        f._abilityName:Show()
        f._hintText:Show()
        f._aoeBadge:Show()
    end

    -- 1. Pulse animations
    local size = CoAAT_DB and CoAAT_DB.rotIconSize or 50
    local ringSize = size + 28

    if _current then
        local ugc = UGC[_urgency] or UGC.low
        local pulse = ugc.pulse

        local glowAlpha = math.abs(math.sin(_animPhase * pulse * 0.5)) * 0.7
        if _urgency == "critical" then
            glowAlpha = math.abs(math.sin(_animPhase * 5)) * 0.95
        end
        f._glowRing:SetAlpha(glowAlpha)

        -- Animate scaling of icon, border, and sweep CD overlay
        local scaleMult = 1.0 + math.sin(_animPhase * pulse * 1.5) * 0.08
        f._icon1:SetSize(size * scaleMult, size * scaleMult)
        f._border1:SetSize((size + 4) * scaleMult, (size + 4) * scaleMult)
        f._cd1:SetSize(size * scaleMult, size * scaleMult)

        -- Scale glow ring to pulse in tandem
        local glowScale = 1.0 + math.sin(_animPhase * pulse * 1.5) * 0.15
        f._glowRing:SetSize(ringSize * glowScale, ringSize * glowScale)
    else
        -- Reset to normal size if nothing suggested
        f._icon1:SetSize(size, size)
        f._border1:SetSize(size + 4, size + 4)
        f._cd1:SetSize(size, size)
        f._glowRing:SetSize(ringSize, ringSize)
        f._glowRing:SetAlpha(0)
    end

    -- 2. Range Telemetry checking
    if not UnitExists("target") or UnitIsDead("target") then
        f._icon1:SetVertexColor(1, 1, 1, 1)
        f._icon2:SetVertexColor(1, 1, 1, 1)
        f._icon3:SetVertexColor(1, 1, 1, 1)
        return
    end

    local function checkRange(icon, spellName)
        if not spellName then return end
        local inRange = IsSpellInRange(spellName, "target")
        if inRange == 0 then
            icon:SetVertexColor(1.0, 0.25, 0.25, 0.6) -- Out of range: Red/Dimmed
        else
            icon:SetVertexColor(1.0, 1.0, 1.0, 1.0) -- In range
        end
    end

    checkRange(f._icon1, f._spellName1)
    checkRange(f._icon2, f._spellName2)
    checkRange(f._icon3, f._spellName3)
end

function CoAAT_RotationHelper.Toggle()
    if _frame then
        if _frame:IsShown() then _frame:Hide() else _frame:Show() end
    end
end

function CoAAT_RotationHelper.IsSpellOnHotbar(spellName)
    if not spellName then return false end
    local key = spellName:lower()
    return spellKeybinds[key] ~= nil
end

function CoAAT_RotationHelper.UpdateSizes()
    local f = _frame
    if not f then return end
    local db = CoAAT_DB
    local size = db and db.rotIconSize or 50
    local ringSize = size + 28

    if f._icon1 then
        f._icon1:SetSize(size, size)
        f._border1:SetSize(size + 4, size + 4)
        f._cd1:SetSize(size, size)
        if f._glowRing then
            f._glowRing:SetSize(ringSize, ringSize)
        end
    end
end

function CoAAT_RotationHelper.ApplyTheme(r, g, b, hex)
    local f = _frame
    if not f then return end
    if f._border1 then
        f._border1:SetVertexColor(r, g, b, 0.85)
    end
end

