-- ============================================================
-- CoAAbilityTrainer - Rotation Helper
-- "Cast This Next" arrow + glowing next-ability indicator
-- Appears above the player as a clear visual cue
-- ============================================================

CoAAT_RotationHelper = {}

local _frame     = nil
local _current   = nil   -- current suggested abilityId
local _urgency   = nil
local _animPhase = 0

-- Urgency → colors and pulse speed
local UGC = {
    critical = { r=1.0, g=0.1, b=0.1, pulse=6.0, label="|cffff2222⚠ CRITICAL|r" },
    high     = { r=1.0, g=0.6, b=0.0, pulse=4.0, label="|cffff8800▶ USE NOW|r" },
    medium   = { r=0.2, g=0.8, b=1.0, pulse=2.5, label="|cff44aaff► NEXT|r" },
    low      = { r=0.5, g=0.6, b=0.7, pulse=1.0, label="|cffaaaaaa· FILLER|r" },
}

-- ─────────────────────────────────────────────
-- Build the rotation helper panel
-- ─────────────────────────────────────────────
function CoAAT_RotationHelper.Build(parent)
    local f = CreateFrame("Frame", "CoAATRotationHelper", parent)
    f:SetSize(300, 74)
    f:SetPoint("TOP", parent, "TOP", 0, -6)
    f:SetFrameStrata("HIGH")

    -- Glassmorphism-style background
    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0.03, 0.04, 0.10, 0.88)

    -- Top gradient accent strip
    local accentBar = f:CreateTexture(nil, "ARTWORK")
    accentBar:SetSize(300, 3)
    accentBar:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
    accentBar:SetGradientAlpha("HORIZONTAL",
        0.0, 0.7, 1.0, 0.0,
        0.0, 0.7, 1.0, 1.0)
    f._accentBar = accentBar

    -- Helper to create colored icon slots
    local function createIconSlot(parentFrame, size, xOff, r, g, b, keyText)
        local border = parentFrame:CreateTexture(nil, "BACKGROUND")
        border:SetSize(size + 4, size + 4)
        border:SetPoint("LEFT", parentFrame, "LEFT", xOff, 0)
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

        local lbl = parentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        lbl:SetPoint("BOTTOM", border, "TOP", 0, 1)
        lbl:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
        lbl:SetText(keyText)

        return tex, border
    end

    -- Create 3 priority icon slots (Green, Orange, Red)
    f._icon1, f._border1 = createIconSlot(f, 36, 12,  0.0, 1.0, 0.0, "|cff22ff22PRIMARY|r")
    f._icon2, f._border2 = createIconSlot(f, 30, 62,  1.0, 0.5, 0.0, "|cffffa500SECOND|r")
    f._icon3, f._border3 = createIconSlot(f, 24, 106, 1.0, 0.0, 0.0, "|cffff2222NEXT|r")

    -- Pulsing glow ring around primary icon
    local glowRing = f:CreateTexture(nil, "OVERLAY")
    glowRing:SetSize(52, 52)
    glowRing:SetPoint("CENTER", f._icon1, "CENTER", 0, 0)
    glowRing:SetTexture("Interface\\Cooldown\\star4")
    glowRing:SetBlendMode("ADD")
    glowRing:SetAlpha(0)
    f._glowRing = glowRing

    -- Urgency label
    local urgencyLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    urgencyLabel:SetPoint("TOPLEFT", f, "TOPLEFT", 146, -8)
    urgencyLabel:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    urgencyLabel:SetText("|cffaaaaaaG: Primary  O: Second  R: Next|r")
    f._urgencyLabel = urgencyLabel

    -- Ability name (large, prominent)
    local abilityName = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    abilityName:SetPoint("TOPLEFT", f, "TOPLEFT", 146, -22)
    abilityName:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
    abilityName:SetText("")
    f._abilityName = abilityName

    -- Teaching hint text
    local hintText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    hintText:SetPoint("TOPLEFT", f, "TOPLEFT", 146, -42)
    hintText:SetWidth(130)
    hintText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    hintText:SetJustifyH("LEFT")
    hintText:SetText("|cffaaaaaa Open settings to pick class|r")
    f._hintText = hintText

    -- "⬇ CAST" arrow indicator
    local castArrow = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    castArrow:SetPoint("RIGHT", f, "RIGHT", -6, 0)
    castArrow:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
    castArrow:SetText("|cff00ccff⬇|r")
    f._castArrow = castArrow

    f:SetScript("OnUpdate", function(self, dt)
        _animPhase = _animPhase + dt
        CoAAT_RotationHelper.AnimTick(self, dt)
    end)

    _frame = f

    -- Drag support
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        if CoAAT_DB then
            local pt, _, _, x, y = self:GetPoint()
            CoAAT_DB.rotHelperPos = { point=pt, x=x, y=y }
        end
    end)

    f:Show()
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

    -- Glowing overlay texture
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
    -- Hide all active action bar glows first
    for _, g in pairs(glowFrames) do
        g:Hide()
    end

    if not spellGlows or #spellGlows == 0 then return end

    -- WotLK Standard Action Button Prefixes
    local prefixes = {
        "ActionButton",
        "MultiBarBottomLeftButton",
        "MultiBarBottomRightButton",
        "MultiBarLeftButton",
        "MultiBarRightButton"
    }

    for _, prefix in ipairs(prefixes) do
        for i = 1, 12 do
            local buttonName = prefix .. i
            local button = _G[buttonName]
            if button and button:IsShown() then
                local action = button.action
                if action then
                    local actionType, id = GetActionInfo(action)
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
end

-- ─────────────────────────────────────────────
-- Set the next suggested abilities (with 3-tier colors)
-- ─────────────────────────────────────────────
function CoAAT_RotationHelper.SetNextAbilities(m1, m2, m3)
    local f = _frame
    if not f then return end

    local spellsToGlow = {}

    -- Slot 1: Primary (Green)
    if m1 and m1.abilityDef then
        f._icon1:SetTexture(m1.abilityDef.icon)
        f._abilityName:SetText("|cff22ff22" .. m1.abilityDef.name .. "|r")
        f._hintText:SetText("|cffcccccc" .. (m1.abilityDef.hint or m1.abilityDef.description or "") .. "|r")
        table.insert(spellsToGlow, { spellName = m1.abilityDef.name, r = 0.0, g = 1.0, b = 0.0 })
        _current = m1.abilityId
        _urgency = m1.urgency
    else
        f._icon1:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        f._abilityName:SetText("|cffaaaaaa—|r")
        f._hintText:SetText("|cffaaaaaa Waiting for combat...|r")
        _current = nil
        _urgency = nil
    end

    -- Slot 2: Secondary (Orange)
    if m2 and m2.abilityDef then
        f._icon2:SetTexture(m2.abilityDef.icon)
        table.insert(spellsToGlow, { spellName = m2.abilityDef.name, r = 1.0, g = 0.5, b = 0.0 })
    else
        f._icon2:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    end

    -- Slot 3: Third (Red)
    if m3 and m3.abilityDef then
        f._icon3:SetTexture(m3.abilityDef.icon)
        table.insert(spellsToGlow, { spellName = m3.abilityDef.name, r = 1.0, g = 0.0, b = 0.0 })
    else
        f._icon3:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    end

    -- Update Action Bar Glows
    UpdateActionBarGlows(spellsToGlow)

    -- Update accent color
    local ugc = UGC[_urgency] or UGC.low
    f._accentBar:SetGradientAlpha("HORIZONTAL",
        ugc.r, ugc.g, ugc.b, 0.0,
        ugc.r, ugc.g, ugc.b, 0.9)

    -- Set glow ring color
    f._glowRing:SetVertexColor(ugc.r, ugc.g, ugc.b)

    -- Cast arrow urgency
    if _urgency == "critical" then
        f._castArrow:SetText("|cffff2222⬇|r")
    elseif _urgency == "high" then
        f._castArrow:SetText("|cffff8800⬇|r")
    else
        f._castArrow:SetText("|cff44aaff⬇|r")
    end

    -- Also update the aura display highlight
    if m1 and CoAAT_AuraDisplay.SetHighlighted then
        CoAAT_AuraDisplay.SetHighlighted(m1.abilityId, m1.urgency)
    end
end

function CoAAT_RotationHelper.SetNextAbility(abilityId, urgency, abilityDef)
    if abilityId then
        CoAAT_RotationHelper.SetNextAbilities({
            abilityId = abilityId,
            urgency = urgency,
            abilityDef = abilityDef
        }, nil, nil)
    else
        CoAAT_RotationHelper.SetNextAbilities(nil, nil, nil)
    end
end

-- ─────────────────────────────────────────────
-- Proc triggered: flash the suggestion if relevant
-- ─────────────────────────────────────────────
function CoAAT_RotationHelper.OnProcTriggered(procName)
    if _frame and _frame._glowRing then
        _frame._glowRing:SetAlpha(0.9)
    end
end

-- ─────────────────────────────────────────────
-- Class changed
-- ─────────────────────────────────────────────
function CoAAT_RotationHelper.OnClassChanged(classId, specId)
    _current = nil
    _urgency = nil
    local f = _frame
    if not f then return end

    local specDef = CoAAT_Engine.GetSpecDef()
    local classDef = CoAAT_Engine.GetClassDef()

    if classDef and specDef then
        f._urgencyLabel:SetText("|cff00ccffG: Primary  O: Second  R: Next|r")
        f._abilityName:SetText("|cffFFD700Ready to help!|r")
        f._hintText:SetText("|cffaaaaaa Enter combat to see rotation suggestions|r")
        f._icon1:SetTexture("Interface\\Icons\\Ability_Warrior_Rampage")
        f._icon2:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        f._icon3:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    end
end

-- ─────────────────────────────────────────────
-- Combat state change
-- ─────────────────────────────────────────────
function CoAAT_RotationHelper.OnCombatChange(inCombat)
    -- Optionally auto-show/hide out of combat
    local setting = CoAAT_DB and CoAAT_DB.hideOutOfCombat
    if setting and _frame then
        if inCombat then _frame:Show()
        else
            -- Clear suggestion
            _current = nil
            CoAAT_RotationHelper.SetNextAbility(nil, nil, nil)
        end
    end
end

-- ─────────────────────────────────────────────
-- Animation ticker
-- ─────────────────────────────────────────────
function CoAAT_RotationHelper.AnimTick(f, dt)
    if not _current then return end

    local ugc = UGC[_urgency] or UGC.low
    local pulse = ugc.pulse

    local glowAlpha = math.abs(math.sin(_animPhase * pulse * 0.5)) * 0.7
    if _urgency == "critical" then
        -- Faster, brighter for critical
        glowAlpha = math.abs(math.sin(_animPhase * 5)) * 0.85
    end
    f._glowRing:SetAlpha(glowAlpha)

    -- Arrow bounce for high/critical
    if _urgency == "critical" or _urgency == "high" then
        local bounce = math.abs(math.sin(_animPhase * 4)) * 3
        f._castArrow:SetPoint("RIGHT", f, "RIGHT", -8 + bounce * -1, 0)
    end
end

function CoAAT_RotationHelper.Toggle()
    if _frame then
        if _frame:IsShown() then _frame:Hide() else _frame:Show() end
    end
end
