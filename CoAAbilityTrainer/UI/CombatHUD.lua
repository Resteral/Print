-- ============================================================
-- CoAAbilityTrainer - Combat HUD (Modular & Customizable Overhaul)
-- A completely transparent WeakAuras-style master container
-- ============================================================

CoAAT_CombatHUD = {}

local HUD_W = 400
local _hud = nil

-- ─────────────────────────────────────────────
-- Build the HUD container
-- ─────────────────────────────────────────────
function CoAAT_CombatHUD.Build()
    local hud = CreateFrame("Frame", "CoAATCombatHUD", UIParent)
    hud:SetSize(HUD_W, 340)
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
    dragBG:SetTexture(0, 0, 0, 0) -- Completely transparent background for a free floating look
    dragBG:SetAlpha(0)
    hud._dragBG = dragBG

    -- Transparent container frame for dragging
    local border = CreateFrame("Frame", nil, hud)
    border:SetAllPoints()
    hud._borderFrame = border

    -- Drag instructions (hidden in combat)
    local dragHint = hud:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dragHint:SetPoint("TOP", hud, "TOP", 0, -5)
    dragHint:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    dragHint:SetText("|cff00ccff[ CoA Trainer - Drag to Move ]|r")
    hud._dragHint = dragHint

    local function MakeSectionDraggable(section, name, labelText)
        section:EnableMouse(true)
        section:SetMovable(true)
        section:RegisterForDrag("LeftButton")
        
        -- Section floating drag label
        local border = CreateFrame("Frame", nil, section)
        border:SetAllPoints()
        section._dragBorder = border

        local lbl = border:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        lbl:SetPoint("CENTER", border, "CENTER", 0, 0)
        lbl:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        lbl:SetText("|cff00ccff[ Drag " .. labelText .. " ]|r")

        section:SetScript("OnDragStart", function(self)
            if not InCombatLockdown() then self:StartMoving() end
        end)
        section:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()
            local pt, _, relPt, x, y = self:GetPoint()
            if CoAAT_DB then
                if not CoAAT_DB.positions then CoAAT_DB.positions = {} end
                CoAAT_DB.positions[name] = { pt = pt, relPt = relPt, x = x, y = y }
            end
        end)
    end

    -- ── Section containers ──

    -- 0. Target Headbar (Top, 44px)
    local targetSection = CreateFrame("Frame", nil, hud)
    targetSection:SetSize(HUD_W, 44)
    MakeSectionDraggable(targetSection, "targetSection", "Target Headbar (Drag)")
    hud._targetSection = targetSection

    -- 00. Player Card (Below Target Headbar, 72px)
    local playerCardSection = CreateFrame("Frame", nil, hud)
    playerCardSection:SetSize(HUD_W, 72)
    MakeSectionDraggable(playerCardSection, "playerCardSection", "Player Card (Drag)")
    hud._playerCardSection = playerCardSection

    -- 1. Rotation Helper (Top suggested floating icon, 50px)
    local rotSection = CreateFrame("Frame", nil, hud)
    rotSection:SetSize(HUD_W, 50)
    MakeSectionDraggable(rotSection, "rotSection", "Rotation Helper (Drag)")
    hud._rotSection = rotSection

    -- 2. Aura grid (Main horizontal row, 34px)
    local auraSection = CreateFrame("Frame", nil, hud)
    auraSection:SetSize(HUD_W, 34)
    MakeSectionDraggable(auraSection, "auraSection", "Aura Tracker (Drag)")
    hud._auraSection = auraSection

    -- 3. Resource bar (Below Auras, 14px)
    local resSection = CreateFrame("Frame", nil, hud)
    resSection:SetSize(HUD_W, 14)
    MakeSectionDraggable(resSection, "resSection", "Resource Bar (Drag)")
    hud._resSection = resSection

    -- 4. Casting Bar (Below Resource, 20px)
    local castSection = CreateFrame("Frame", nil, hud)
    castSection:SetSize(HUD_W, 20)
    MakeSectionDraggable(castSection, "castSection", "Casting Bar (Drag)")
    hud._castSection = castSection

    -- 5. Cooldown strip (Bottom, 44px)
    local cdSection = CreateFrame("Frame", nil, hud)
    cdSection:SetSize(HUD_W, 44)
    MakeSectionDraggable(cdSection, "cdSection", "Cooldown Bar (Drag)")
    hud._cdSection = cdSection

    -- Build sub-panels inside their sections
    CoAAT_TargetHeadbar.Build(targetSection)
    CoAAT_PlayerCard.Build(playerCardSection)
    CoAAT_CursorHUD.Build(hud)
    CoAAT_RotationHelper.Build(rotSection)
    CoAAT_AuraDisplay.Build(auraSection)
    CoAAT_ResourceBar.Build(resSection, 0, -6)
    CoAAT_CastingBar.Build(castSection)
    CoAAT_CooldownTracker.Build(cdSection)
    CoAAT_ProcAlert.Build()  -- builds floating overlay
    CoAAT_NameplateHUD.Build()  -- inject mini-HUD onto all nameplates

    hud:SetScript("OnUpdate", function(self, dt)
        CoAAT_Engine.OnUpdate(dt)
        
        -- Hide drag backgrounds during combat
        local inCombat = CoAAT_Engine.IsInCombat()
        local hideBorder = (CoAAT_DB and CoAAT_DB.hideDragBorder) or inCombat

        if inCombat then
            self._dragBG:SetAlpha(0)
            self._dragHint:SetAlpha(0)
            if self._borderFrame then self._borderFrame:Hide() end
        else
            self._dragBG:SetAlpha(hideBorder and 0 or 1)
            self._dragHint:SetAlpha(hideBorder and 0 or 1)
            if self._borderFrame then
                if hideBorder then
                    self._borderFrame:Hide()
                else
                    self._borderFrame:Show()
                end
            end
        end

        if hideBorder then
            self:EnableMouse(false)
            if CoAAT_AuraDisplay and CoAAT_AuraDisplay.SetMouseEnabled then
                CoAAT_AuraDisplay.SetMouseEnabled(false)
            end
        else
            self:EnableMouse(true)
            if CoAAT_AuraDisplay and CoAAT_AuraDisplay.SetMouseEnabled then
                CoAAT_AuraDisplay.SetMouseEnabled(true)
            end
        end

        for _, section in ipairs({ self._targetSection, self._playerCardSection, self._rotSection, self._auraSection, self._resSection, self._castSection, self._cdSection }) do
            if section then
                if hideBorder then
                    if section._dragBorder then section._dragBorder:Hide() end
                    section:EnableMouse(false)
                else
                    if section._dragBorder then section._dragBorder:Show() end
                    section:EnableMouse(true)
                end
            end
        end
    end)

    _hud = hud
    CoAAT_CombatHUD._hud = hud

    -- Apply customization layouts
    CoAAT_CombatHUD.RefreshLayout()

    return hud
end

-- ─────────────────────────────────────────────
-- Dynamically show/hide sections, resize HUD, apply scale/alpha
-- ─────────────────────────────────────────────
function CoAAT_CombatHUD.RefreshLayout()
    local hud = _hud
    if not hud then return end

    local db = CoAAT_DB or {
        hudScale = 1.0,
        hudAlpha = 1.0,
        showAuras = true,
        showRotHelper = true,
        showResourceBar = true,
        showCooldowns = true
    }

    -- Apply Scale and Alpha
    hud:SetScale(db.hudScale or 1.0)
    hud:SetAlpha(db.hudAlpha or 1.0)

    -- Determine layout Y offsets dynamically (preventing blank gaps)
    local yOffset = -30

    local function AlignSection(section, name, defaultY)
        section:ClearAllPoints()
        if CoAAT_DB and CoAAT_DB.positions and CoAAT_DB.positions[name] then
            local pos = CoAAT_DB.positions[name]
            section:SetParent(UIParent)
            section:SetPoint(pos.pt, UIParent, pos.relPt, pos.x, pos.y)
            section:SetScale(db.hudScale or 1.0)
            section:SetAlpha(db.hudAlpha or 1.0)
        else
            section:SetParent(hud)
            section:SetPoint("TOP", hud, "TOP", 0, defaultY)
            section:SetScale(1.0)
            section:SetAlpha(1.0)
        end
    end

    -- 0. Target Headbar (Top target frame)
    if hud._targetSection then
        hud._targetSection:Show()
        AlignSection(hud._targetSection, "targetSection", yOffset)
        yOffset = yOffset - 44 - 4
    end

    -- 00. Player Card (Target Player frame)
    if hud._playerCardSection then
        hud._playerCardSection:Show()
        AlignSection(hud._playerCardSection, "playerCardSection", yOffset)
        yOffset = yOffset - 72 - 4
    end

    -- 1. Rotation Helper (Floating Suggested Action)
    if db.showRotHelper and hud._rotSection then
        hud._rotSection:Show()
        AlignSection(hud._rotSection, "rotSection", yOffset)
        yOffset = yOffset - 50 - 4
    else
        if hud._rotSection then hud._rotSection:Hide() end
    end

    -- 2. Aura Display (Main Row)
    if db.showAuras and hud._auraSection then
        hud._auraSection:Show()
        AlignSection(hud._auraSection, "auraSection", yOffset)
        yOffset = yOffset - 34 - 2
    else
        if hud._auraSection then hud._auraSection:Hide() end
    end

    -- 3. Resource Bar (Segmented)
    if db.showResourceBar and hud._resSection then
        hud._resSection:Show()
        AlignSection(hud._resSection, "resSection", yOffset)
        yOffset = yOffset - 14 - 4
    else
        if hud._resSection then hud._resSection:Hide() end
    end

    -- 4. Casting Bar (Cast/GCD tracker)
    if hud._castSection then
        hud._castSection:Show()
        AlignSection(hud._castSection, "castSection", yOffset)
        yOffset = yOffset - 20 - 4
    end

    -- 5. Cooldowns (Bottom Row)
    if db.showCooldowns and hud._cdSection then
        hud._cdSection:Show()
        AlignSection(hud._cdSection, "cdSection", yOffset)
        yOffset = yOffset - 44 - 4
    else
        if hud._cdSection then hud._cdSection:Hide() end
    end

    -- Set dynamic overall HUD container height
    local finalHeight = math.abs(yOffset)
    hud:SetHeight(finalHeight)
    if hud._borderFrame then
        hud._borderFrame:SetSize(HUD_W, finalHeight)
    end

    if CoAAT_CursorHUD and CoAAT_CursorHUD.Refresh then
        CoAAT_CursorHUD.Refresh()
    end

    if CoAAT_RotationHelper and CoAAT_RotationHelper.UpdateSizes then
        CoAAT_RotationHelper.UpdateSizes()
    end
    if CoAAT_CooldownTracker and CoAAT_CooldownTracker.UpdateSizes then
        CoAAT_CooldownTracker.UpdateSizes()
    end
    if CoAAT_ResourceBar and CoAAT_ResourceBar.UpdateSizes then
        CoAAT_ResourceBar.UpdateSizes()
    end
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
    -- Relay combat changes if modules need it
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
