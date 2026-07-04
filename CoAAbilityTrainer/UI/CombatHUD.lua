-- ============================================================
-- CoAAbilityTrainer - Combat HUD (Full Rotational Overhaul)
-- A completely transparent WeakAuras-style master container
-- ============================================================

CoAAT_CombatHUD = {}

-- Larger width to accommodate the massive rotational icons
local HUD_W = 400
local HUD_H = 340

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

    -- Restore saved position or default to Lower-Center
    if CoAAT_DB and CoAAT_DB.hudPos then
        local p = CoAAT_DB.hudPos
        hud:SetPoint(p.point or "CENTER", UIParent, p.point or "CENTER", p.x or 0, p.y or 0)
    else
        hud:SetPoint("CENTER", UIParent, "CENTER", 0, -150)
    end

    -- Transparent backdrop (Only visible when out of combat for dragging)
    local dragBG = hud:CreateTexture(nil, "BACKGROUND")
    dragBG:SetAllPoints()
    dragBG:SetTexture(0, 0, 0, 0.4)
    dragBG:SetAlpha(1)
    hud._dragBG = dragBG

    -- Drag instructions (hidden in combat)
    local dragHint = hud:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dragHint:SetPoint("TOP", hud, "TOP", 0, -5)
    dragHint:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    dragHint:SetText("|cff00ccffCoA Ability Trainer|r\n|cffaaaaaaDrag to move. Disappears in combat.|r")
    hud._dragHint = dragHint

    -- ── Section containers (Top to Bottom Flow) ──

    -- 1. Aura grid (Top, 100px)
    local auraSection = CreateFrame("Frame", nil, hud)
    auraSection:SetSize(HUD_W, 100)
    auraSection:SetPoint("TOP", hud, "TOP", 0, -35)
    hud._auraSection = auraSection

    -- 2. Rotation Helper (Centerpiece, 120px)
    local rotSection = CreateFrame("Frame", nil, hud)
    rotSection:SetSize(HUD_W, 120)
    rotSection:SetPoint("TOP", auraSection, "BOTTOM", 0, -5)
    hud._rotSection = rotSection

    -- 3. Resource bar (Below Rotation, 30px)
    local resSection = CreateFrame("Frame", nil, hud)
    resSection:SetSize(HUD_W, 30)
    resSection:SetPoint("TOP", rotSection, "BOTTOM", 0, -5)
    hud._resSection = resSection

    -- 4. Cooldown strip (Bottom, 40px)
    local cdSection = CreateFrame("Frame", nil, hud)
    cdSection:SetSize(HUD_W, 40)
    cdSection:SetPoint("TOP", resSection, "BOTTOM", 0, -5)
    hud._cdSection = cdSection

    -- Build sub-panels inside their sections
    CoAAT_AuraDisplay.Build(auraSection)
    CoAAT_RotationHelper.Build(rotSection)
    CoAAT_ResourceBar.Build(resSection, 0, 10)
    CoAAT_CooldownTracker.Build(cdSection)
    CoAAT_ProcAlert.Build()  -- builds floating overlay

    hud:SetScript("OnUpdate", function(self, dt)
        CoAAT_Engine.OnUpdate(dt)
        
        -- Hide drag backgrounds during combat
        if CoAAT_Engine.IsInCombat() then
            self._dragBG:SetAlpha(0)
            self._dragHint:SetAlpha(0)
        else
            self._dragBG:SetAlpha(1)
            self._dragHint:SetAlpha(1)
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

    CoAAT_AuraDisplay.OnClassChanged(classId, specId)
    CoAAT_CooldownTracker.OnClassChanged(classId, specId)
    CoAAT_ResourceBar.OnClassChanged(classId, specId)
    CoAAT_RotationHelper.OnClassChanged(classId, specId)
end

function CoAAT_CombatHUD.OnCombatChange(inCombat)
    -- Let sub-panels know if needed
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
