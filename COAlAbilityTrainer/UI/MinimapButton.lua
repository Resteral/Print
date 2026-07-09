-- ============================================================
-- COAlAbilityTrainer - Minimap Button
-- Custom glowing logo button with animated pulse ring
-- Left Click  → Toggle Settings
-- Right Click → Toggle Combat HUD
-- Drag        → Reposition around minimap
-- ============================================================

local BUTTON_SIZE = 36

CoAAT_MinimapButton = {}

-- ─────────────────────────────────────────────────────────────
-- Position helper
-- ─────────────────────────────────────────────────────────────
local function UpdatePosition(button)
    local angle  = math.rad(CoAAT_DB and CoAAT_DB.minimapAngle or 45)
    local radius = 90
    button:SetPoint("CENTER", Minimap, "CENTER",
        math.cos(angle) * radius,
        math.sin(angle) * radius)
end

-- ─────────────────────────────────────────────────────────────
-- Build
-- ─────────────────────────────────────────────────────────────
function CoAAT_MinimapButton.Create()
    local button = CreateFrame("Button", "COAlMinimapButton", Minimap)
    button:SetSize(BUTTON_SIZE, BUTTON_SIZE)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(9)
    button:SetClampedToScreen(true)

    -- ── 1. Dark circular background ──────────────────────────
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    bg:SetVertexColor(0.04, 0.04, 0.08, 0.92)

    -- ── 2. Gradient fill ring (gives the "logo disc" feel) ───
    local disc = button:CreateTexture(nil, "BORDER")
    disc:SetSize(BUTTON_SIZE - 4, BUTTON_SIZE - 4)
    disc:SetPoint("CENTER", button, "CENTER", 0, 0)
    disc:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    disc:SetVertexColor(0.28, 0.05, 0.45, 0.85)  -- deep violet

    -- ── 3. Outer glow ring (uses WoW's built-in sparkle) ─────
    local glow = button:CreateTexture(nil, "OVERLAY")
    glow:SetSize(BUTTON_SIZE + 22, BUTTON_SIZE + 22)
    glow:SetPoint("CENTER", button, "CENTER", 0, 0)
    glow:SetTexture("Interface\\SpellActivationOverlay\\IconAlert")
    glow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)
    glow:SetVertexColor(0.65, 0.15, 1.0, 0.0)   -- starts invisible
    glow:SetBlendMode("ADD")
    button._glow = glow

    -- ── 4. Circular border (WoW tracking border) ─────────────
    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetSize(BUTTON_SIZE + 16, BUTTON_SIZE + 16)
    border:SetPoint("CENTER", button, "CENTER", 0, 0)
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    border:SetVertexColor(0.75, 0.35, 1.0, 1.0)   -- purple tint

    -- ── 5. COAl logo text (⚔ symbol) ─────────────────────────
    local logo = button:CreateFontString(nil, "OVERLAY")
    logo:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
    logo:SetPoint("CENTER", button, "CENTER", 0, 1)
    logo:SetText("|cffcc88ff⚔|r")
    button._logo = logo

    -- ── 6. "COAl" sub-label beneath icon ─────────────────────
    local label = button:CreateFontString(nil, "OVERLAY")
    label:SetFont("Fonts\\FRIZQT__.TTF", 5, "OUTLINE")
    label:SetPoint("BOTTOM", button, "BOTTOM", 0, 3)
    label:SetText("|cffaa66ffCOAl|r")

    -- ── 7. Pulse animation ────────────────────────────────────
    local phase   = 0
    local hovered = false
    button:SetScript("OnUpdate", function(self, dt)
        phase = phase + dt * (hovered and 4.0 or 1.8)
        local pulse = 0.45 + 0.55 * math.abs(math.sin(phase))
        -- glow breathes purple when hovered, subtle when idle
        if hovered then
            glow:SetVertexColor(0.65, 0.15, 1.0, pulse * 0.85)
        else
            glow:SetVertexColor(0.5, 0.1, 0.8, pulse * 0.30)
        end
        -- border colour cycles subtly
        local br = 0.6 + 0.15 * math.sin(phase * 0.7)
        local bg2 = 0.2 + 0.10 * math.sin(phase * 0.9 + 1)
        border:SetVertexColor(br, bg2, 1.0, 1.0)
    end)

    -- ── 8. Hover highlight ────────────────────────────────────
    button:SetScript("OnEnter", function(self)
        hovered = true
        disc:SetVertexColor(0.40, 0.08, 0.62, 0.95)
        logo:SetText("|cffee99ff⚔|r")
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:ClearLines()
        GameTooltip:AddLine("|cffcc88ff⚔ COAl Ability Trainer|r")
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("|cff00ccff[Left Click]|r  Open Settings", 1, 1, 1)
        GameTooltip:AddLine("|cff00ccff[Right Click]|r Toggle Combat HUD", 1, 1, 1)
        GameTooltip:AddLine("|cffaaaaaa[Drag]|r  Reposition button", 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self)
        hovered = false
        disc:SetVertexColor(0.28, 0.05, 0.45, 0.85)
        logo:SetText("|cffcc88ff⚔|r")
        GameTooltip:Hide()
    end)

    -- ── 9. Dragging ───────────────────────────────────────────
    local dragging = false
    button:RegisterForDrag("LeftButton")
    button:SetScript("OnDragStart", function(self)
        dragging = true
        self:SetScript("OnUpdate", function(self2, dt)
            -- pulse still runs
            phase = phase + dt * (hovered and 4.0 or 1.8)
            local pulse = 0.45 + 0.55 * math.abs(math.sin(phase))
            glow:SetVertexColor(0.65, 0.15, 1.0, pulse * 0.6)

            if dragging then
                local mx, my = GetCursorPosition()
                local scale  = Minimap:GetEffectiveScale()
                local cx, cy = Minimap:GetCenter()
                local angle  = math.deg(math.atan2(
                    (my / scale) - cy,
                    (mx / scale) - cx))
                if CoAAT_DB then CoAAT_DB.minimapAngle = angle end
                UpdatePosition(self2)
            end
        end)
    end)
    button:SetScript("OnDragStop", function(self)
        dragging = false
        -- restore normal OnUpdate
        self:SetScript("OnUpdate", function(self2, dt)
            phase = phase + dt * (hovered and 4.0 or 1.8)
            local pulse = 0.45 + 0.55 * math.abs(math.sin(phase))
            if hovered then
                glow:SetVertexColor(0.65, 0.15, 1.0, pulse * 0.85)
            else
                glow:SetVertexColor(0.5, 0.1, 0.8, pulse * 0.30)
            end
            local br = 0.6 + 0.15 * math.sin(phase * 0.7)
            local bg3 = 0.2 + 0.10 * math.sin(phase * 0.9 + 1)
            border:SetVertexColor(br, bg3, 1.0, 1.0)
        end)
    end)

    -- ── 10. Click ─────────────────────────────────────────────
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetScript("OnClick", function(self, btn)
        if btn == "LeftButton" then
            CoAAT_SettingsFrame.Toggle()
        elseif btn == "RightButton" then
            if CoAAT_CombatHUD and CoAAT_CombatHUD.Toggle then
                CoAAT_CombatHUD.Toggle()
            end
        end
    end)

    UpdatePosition(button)
    CoAAT_MinimapButton._button = button
end
