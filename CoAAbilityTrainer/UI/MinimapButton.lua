-- ============================================================
-- CoAAbilityTrainer - Minimap Button
-- Draggable minimap button to toggle settings and HUD
-- ============================================================

local ADDON = "CoAAbilityTrainer"
local BUTTON_SIZE = 28

CoAAT_MinimapButton = {}

local function UpdatePosition(button)
    local angle = math.rad(CoAAT_DB and CoAAT_DB.minimapAngle or 30)
    local radius = 82
    local x = math.cos(angle) * radius
    local y = math.sin(angle) * radius
    button:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

function CoAAT_MinimapButton.Create()
    local button = CreateFrame("Button", ADDON .. "MinimapButton", Minimap)
    button:SetSize(BUTTON_SIZE, BUTTON_SIZE)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8)

    -- Texture (icon)
    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon:SetAllPoints()
    icon:SetTexture("Interface\\Icons\\Spell_Shadow_Metamorphosis")

    -- Circular border overlay
    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    border:SetSize(50, 50)
    border:SetPoint("TOPLEFT", button, "TOPLEFT", -10, 10)

    -- Dragging
    local dragging = false
    local function onUpdate()
        if dragging then
            local mx, my = GetCursorPosition()
            local scale  = Minimap:GetEffectiveScale()
            mx = mx / scale
            my = my / scale
            local cx, cy = Minimap:GetCenter()
            local angle  = math.deg(math.atan2(my - cy, mx - cx))
            if CoAAT_DB then
                CoAAT_DB.minimapAngle = angle
            end
            UpdatePosition(button)
        end
    end

    button:RegisterForDrag("LeftButton")
    button:SetScript("OnDragStart", function()
        dragging = true
        button:SetScript("OnUpdate", onUpdate)
    end)
    button:SetScript("OnDragStop", function()
        dragging = false
        button:SetScript("OnUpdate", nil)
    end)

    -- Click: toggle main window
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetScript("OnClick", function(self, btn)
        if btn == "LeftButton" then
            CoAAT_SettingsFrame.Toggle()
        elseif btn == "RightButton" then
            if CoAAT_CombatHUD.Toggle then
                CoAAT_CombatHUD.Toggle()
            end
        end
    end)

    -- Tooltip
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("|cffb048b5CoA Ability Trainer|r")
        GameTooltip:AddLine("|cffaaaaaa[Left Click]|r Toggle Settings", 1, 1, 1)
        GameTooltip:AddLine("|cffaaaaaa[Right Click]|r Toggle Combat HUD", 1, 1, 1)
        GameTooltip:AddLine("|cffaaaaaa[Drag]|r Move button", 1, 1, 1)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    UpdatePosition(button)
    CoAAT_MinimapButton._button = button
end
