-- ============================================================
-- CoAAbilityTrainer - Combat HUD
-- Main container frame that anchors all sub-panels
-- Layout:
--   [Rotation Helper]       ← "cast this next" bar (top)
--   [Aura Icon Grid]        ← all abilities (middle)
--   [Cooldown Strip]        ← CD timers (below icons)
--   [Resource Bar]          ← Felfury / Runic Power / etc.
-- ============================================================

CoAAT_CombatHUD = {}

local HUD_W = 310
local HUD_H = 360

local _hud = nil

-- ─────────────────────────────────────────────
-- Build the HUD container
-- ─────────────────────────────────────────────
function CoAAT_CombatHUD.Build()
    local hud = CreateFrame("Frame", "CoAATCombatHUD", UIParent)
    hud:SetSize(HUD_W, HUD_H)
    hud:SetFrameStrata("MEDIUM")
    hud:SetToplevel(true)
    hud:SetMovable(true)
    hud:EnableMouse(true)
    hud:RegisterForDrag("LeftButton")
    hud:SetScript("OnDragStart", function(self) self:StartMoving() end)
    hud:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local pt, _, _, x, y = self:GetPoint()
        if CoAAT_DB then CoAAT_DB.hudPos = { point=pt, x=x, y=y } end
    end)

    -- Restore saved position
    if CoAAT_DB and CoAAT_DB.hudPos then
        local p = CoAAT_DB.hudPos
        hud:SetPoint(p.point or "CENTER", UIParent, p.point or "CENTER", p.x or 0, p.y or 0)
    else
        hud:SetPoint("RIGHT", UIParent, "RIGHT", -180, -60)
    end

    -- ── BG / border ──
    local bg = hud:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0.02, 0.03, 0.08, 0.88)

    -- Outer border glow
    local borderTex = hud:CreateTexture(nil, "ARTWORK")
    borderTex:SetSize(HUD_W + 4, HUD_H + 4)
    borderTex:SetPoint("CENTER", hud, "CENTER", 0, 0)
    borderTex:SetTexture(0.0, 0.5, 0.9, 0.25)
    hud._border = borderTex

    -- Gradient top strip (title bar)
    local titleBG = hud:CreateTexture(nil, "ARTWORK")
    titleBG:SetSize(HUD_W, 28)
    titleBG:SetPoint("TOPLEFT", hud, "TOPLEFT", 0, 0)
    titleBG:SetGradientAlpha("HORIZONTAL",
        0.0, 0.4, 0.8, 0.9,
        0.0, 0.1, 0.2, 0.9)

    local titleText = hud:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titleText:SetPoint("LEFT", titleBG, "LEFT", 8, 0)
    titleText:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    titleText:SetText("|cff00ccff⚔ CoA Ability Trainer|r")
    hud._titleText = titleText

    -- Class indicator (right of title)
    local classLabel = hud:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    classLabel:SetPoint("RIGHT", titleBG, "RIGHT", -30, 0)
    classLabel:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    classLabel:SetText("|cffaaaaaa[No Class]|r")
    hud._classLabel = classLabel

    -- Toggle/close button
    local closeBtn = CreateFrame("Button", nil, hud, "UIPanelCloseButton")
    closeBtn:SetSize(20, 20)
    closeBtn:SetPoint("TOPRIGHT", hud, "TOPRIGHT", 2, 2)
    closeBtn:SetScript("OnClick", function() hud:Hide() end)

    -- ── Section containers ──
    -- 1. Rotation Helper (top, 74px)
    local rotSection = CreateFrame("Frame", nil, hud)
    rotSection:SetSize(HUD_W - 8, 74)
    rotSection:SetPoint("TOPLEFT", hud, "TOPLEFT", 4, -28)
    hud._rotSection = rotSection

    -- Section label
    local rlabel = hud:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    rlabel:SetPoint("TOPLEFT", hud, "TOPLEFT", 6, -28)
    -- (hidden, section is self-explaining)

    -- 2. Aura grid (middle, ~130px)
    local auraSection = CreateFrame("Frame", nil, hud)
    auraSection:SetSize(HUD_W - 8, 130)
    auraSection:SetPoint("TOPLEFT", rotSection, "BOTTOMLEFT", 0, -6)
    hud._auraSection = auraSection

    -- Aura section header
    local auraHdr = hud:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    auraHdr:SetPoint("TOPLEFT", auraSection, "TOPLEFT", 2, 2)
    auraHdr:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    auraHdr:SetText("|cff446688ABILITIES  •  Hover for tips|r")

    -- 3. Cooldown strip (below aura grid, 56px)
    local cdSection = CreateFrame("Frame", nil, hud)
    cdSection:SetSize(HUD_W - 8, 56)
    cdSection:SetPoint("TOPLEFT", auraSection, "BOTTOMLEFT", 0, -4)
    hud._cdSection = cdSection

    local cdHdr = hud:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    cdHdr:SetPoint("TOPLEFT", cdSection, "TOPLEFT", 2, 2)
    cdHdr:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    cdHdr:SetText("|cff446688COOLDOWNS|r")

    -- 4. Resource bar (bottom)
    local resSection = CreateFrame("Frame", nil, hud)
    resSection:SetSize(HUD_W - 8, 40)
    resSection:SetPoint("TOPLEFT", cdSection, "BOTTOMLEFT", 0, -6)
    hud._resSection = resSection

    local resHdr = hud:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    resHdr:SetPoint("TOPLEFT", resSection, "TOPLEFT", 2, 2)
    resHdr:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    resHdr:SetText("|cff446688RESOURCE|r")

    -- Divider lines
    local function makeDivider(parent, anchor)
        local d = parent:CreateTexture(nil, "OVERLAY")
        d:SetSize(HUD_W - 8, 1)
        d:SetPoint("TOP", anchor, "TOP", 0, 0)
        d:SetTexture(0.0, 0.4, 0.7, 0.35)
        return d
    end
    makeDivider(hud, auraSection)
    makeDivider(hud, cdSection)
    makeDivider(hud, resSection)

    -- Out-of-combat dim indicator
    local dimOverlay = hud:CreateTexture(nil, "OVERLAY")
    dimOverlay:SetAllPoints()
    dimOverlay:SetTexture(0, 0, 0, 0.0)
    hud._dimOverlay = dimOverlay

    -- Drag hint (very faint bottom text)
    local dragHint = hud:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    dragHint:SetPoint("BOTTOM", hud, "BOTTOM", 0, 4)
    dragHint:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
    dragHint:SetText("|cff333355drag to move  •  /coaat to toggle|r")

    -- Build sub-panels inside their sections
    CoAAT_RotationHelper.Build(rotSection)
    CoAAT_AuraDisplay.Build(auraSection)
    CoAAT_CooldownTracker.Build(cdSection)
    CoAAT_ResourceBar.Build(resSection, 0, 10)
    CoAAT_ProcAlert.Build()  -- builds floating overlay

    hud:SetScript("OnUpdate", function(self, dt)
        CoAAT_Engine.OnUpdate(dt)
        -- Pulse border in combat
        if CoAAT_Engine.IsInCombat() then
            local pulse = math.abs(math.sin(GetTime() * 1.5)) * 0.2 + 0.15
            self._border:SetTexture(0.0, 0.6, 1.0, pulse)
            self._dimOverlay:SetTexture(0, 0, 0, 0)
        else
            self._border:SetTexture(0.0, 0.3, 0.6, 0.12)
            self._dimOverlay:SetTexture(0, 0, 0, 0.25)
        end
    end)

    _hud = hud
    CoAAT_CombatHUD._hud = hud
    return hud
end

-- ─────────────────────────────────────────────
-- Relay class change to all sub-panels
-- ─────────────────────────────────────────────
function CoAAT_CombatHUD.OnClassChanged(classId, specId)
    local hud = _hud
    if not hud then return end

    local cd  = CoAAT_Engine.GetClassDef()
    local sd  = CoAAT_Engine.GetSpecDef()

    if cd and sd then
        local colorHex = "|cff00ccff"
        hud._classLabel:SetText(colorHex .. cd.resource .. "|r |cffFFD700" .. sd.name .. "|r")
        hud._titleText:SetText("|cff00ccff⚔ CoA Trainer|r |cffaaaaaa—|r " ..
            colorHex .. classId:gsub("_", " "):gsub("(%a)([%a']*)", function(f,r) return f:upper()..r end) .. "|r")
    end

    CoAAT_AuraDisplay.OnClassChanged(classId, specId)
    CoAAT_CooldownTracker.OnClassChanged(classId, specId)
    CoAAT_ResourceBar.OnClassChanged(classId, specId)
    CoAAT_RotationHelper.OnClassChanged(classId, specId)
end

-- ─────────────────────────────────────────────
-- Combat state relay
-- ─────────────────────────────────────────────
function CoAAT_CombatHUD.OnCombatChange(inCombat)
    -- Let sub-panels know
end

function CoAAT_CombatHUD.Show()
    if _hud then _hud:Show() end
end

function CoAAT_CombatHUD.Hide()
    if _hud then _hud:Hide() end
end

function CoAAT_CombatHUD.Toggle()
    if _hud then
        if _hud:IsShown() then _hud:Hide() else _hud:Show() end
    end
end
