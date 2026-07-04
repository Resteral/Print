-- ============================================================
-- CoAAbilityTrainer - Rotation Helper (Full UI Overhaul)
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

        -- Gloss/Highlight overlay
        local gloss = parentFrame:CreateTexture(nil, "OVERLAY")
        gloss:SetSize(size, size)
        gloss:SetPoint("CENTER", border, "CENTER")
        gloss:SetTexture("Interface\\Buttons\\UI-Quickslot2")
        gloss:SetBlendMode("ADD")
        gloss:SetAlpha(0.4)

        return tex, border
    end

    -- Primary Icon (Center-Left, MASSIVE)
    f._icon1, f._border1 = createIconSlot(f, 72, 0.0, 1.0, 0.0)
    f._border1:SetPoint("CENTER", f, "CENTER", -50, 10)

    -- Pulsing glow ring around primary icon
    local glowRing = f:CreateTexture(nil, "OVERLAY")
    glowRing:SetSize(110, 110)
    glowRing:SetPoint("CENTER", f._icon1, "CENTER", 0, 0)
    glowRing:SetTexture("Interface\\Cooldown\\star4")
    glowRing:SetBlendMode("ADD")
    glowRing:SetAlpha(0)
    f._glowRing = glowRing

    -- Secondary Icon (Center-Right, Medium)
    f._icon2, f._border2 = createIconSlot(f, 48, 1.0, 0.5, 0.0)
    f._border2:SetPoint("LEFT", f._border1, "RIGHT", 15, -12)

    -- Tertiary Icon (Far Right, Small)
    f._icon3, f._border3 = createIconSlot(f, 36, 1.0, 0.0, 0.0)
    f._border3:SetPoint("LEFT", f._border2, "RIGHT", 10, -6)

    -- Ability name (large, prominent under primary)
    local abilityName = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    abilityName:SetPoint("TOP", f._border1, "BOTTOM", 0, -8)
    abilityName:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
    abilityName:SetText("")
    f._abilityName = abilityName

    -- Dynamic Teaching Hint (Under ability name)
    local hintText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    hintText:SetPoint("TOP", abilityName, "BOTTOM", 0, -4)
    hintText:SetWidth(250)
    hintText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    hintText:SetJustifyH("CENTER")
    hintText:SetText("|cffaaaaaa Waiting for combat...|r")
    f._hintText = hintText

    f:SetScript("OnUpdate", function(self, dt)
        _animPhase = _animPhase + dt
        CoAAT_RotationHelper.AnimTick(self, dt)
    end)

    _frame = f
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

    if m1 and m1.abilityDef then
        f._icon1:SetTexture(m1.abilityDef.icon)
        f._abilityName:SetText("|cff22ff22" .. m1.abilityDef.name .. "|r")
        f._hintText:SetText("|cffffd700" .. (m1.abilityDef.hint or m1.abilityDef.description or "Use immediately!") .. "|r")
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

    if m2 and m2.abilityDef then
        f._icon2:SetTexture(m2.abilityDef.icon)
        table.insert(spellsToGlow, { spellName = m2.abilityDef.name, r = 1.0, g = 0.5, b = 0.0 })
    else
        f._icon2:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    end

    if m3 and m3.abilityDef then
        f._icon3:SetTexture(m3.abilityDef.icon)
        table.insert(spellsToGlow, { spellName = m3.abilityDef.name, r = 1.0, g = 0.0, b = 0.0 })
    else
        f._icon3:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    end

    UpdateActionBarGlows(spellsToGlow)

    local ugc = UGC[_urgency] or UGC.low
    f._glowRing:SetVertexColor(ugc.r, ugc.g, ugc.b)

    if m1 and CoAAT_AuraDisplay.SetHighlighted then
        CoAAT_AuraDisplay.SetHighlighted(m1.abilityId, m1.urgency)
    end
end

function CoAAT_RotationHelper.SetNextAbility(abilityId, urgency, abilityDef)
    if abilityId then
        CoAAT_RotationHelper.SetNextAbilities({abilityId=abilityId, urgency=urgency, abilityDef=abilityDef}, nil, nil)
    else
        CoAAT_RotationHelper.SetNextAbilities(nil, nil, nil)
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

function CoAAT_RotationHelper.AnimTick(f, dt)
    if not _current then return end
    local ugc = UGC[_urgency] or UGC.low
    local pulse = ugc.pulse

    local glowAlpha = math.abs(math.sin(_animPhase * pulse * 0.5)) * 0.7
    if _urgency == "critical" then
        glowAlpha = math.abs(math.sin(_animPhase * 5)) * 0.95
    end
    f._glowRing:SetAlpha(glowAlpha)
end

function CoAAT_RotationHelper.Toggle()
    if _frame then
        if _frame:IsShown() then _frame:Hide() else _frame:Show() end
    end
end
