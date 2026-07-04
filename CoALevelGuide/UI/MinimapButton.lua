-- ============================================================
-- CoALevelGuide - Minimap Button
-- Draggable minimap button using LibDBIcon-style logic
-- ============================================================

local ADDON = "CoALevelGuide"
local BUTTON_SIZE = 28

CoALevelGuide_MinimapButton = {}

local function UpdatePosition(button)
    local angle = math.rad(CoALevelGuide_Progress.GetMinimapAngle())
    local radius = 82
    local x = math.cos(angle) * radius
    local y = math.sin(angle) * radius
    button:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

function CoALevelGuide_MinimapButton.Create()
    local button = CreateFrame("Button", ADDON .. "MinimapButton", Minimap)
    button:SetSize(BUTTON_SIZE, BUTTON_SIZE)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8)

    -- Texture (icon)
    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon:SetAllPoints()
    icon:SetTexture("Interface\\Icons\\Ability_Warrior_Rampage")

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
            CoALevelGuide_Progress.SaveMinimapAngle(angle)
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
            CoALevelGuide_MainFrame.Toggle()
        elseif btn == "RightButton" then
            -- Show mini context menu (reset/about)
            local menu = {
                { text = "|cff00ccffCoA Level Guide|r", isTitle = true, notCheckable = true },
                { text = "Open Guide",  notCheckable = true, func = function() CoALevelGuide_MainFrame.Show() end },
                { text = "Reset Progress", notCheckable = true, func = function()
                    StaticPopup_Show("COA_LEVEL_GUIDE_RESET_CONFIRM")
                end },
                { text = "Close", notCheckable = true, func = function() end },
            }
            EasyMenu(menu, CreateFrame("Frame", "CoALevelGuideDropdown", UIParent, "UIDropDownMenuTemplate"), "cursor", 0, 0, "MENU")
        end
    end)

    -- Tooltip
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("|cff00ccffConquest of Azeroth Level Guide|r")
        GameTooltip:AddLine("|cffaaaaaa[Left Click]|r Open / Close Guide", 1, 1, 1)
        GameTooltip:AddLine("|cffaaaaaa[Right Click]|r Options", 1, 1, 1)
        GameTooltip:AddLine("|cffaaaaaa[Drag]|r Move button", 1, 1, 1)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    UpdatePosition(button)
    CoALevelGuide_MinimapButton._button = button

    -- Confirmation popup for reset
    StaticPopupDialogs["COA_LEVEL_GUIDE_RESET_CONFIRM"] = {
        text = "Reset ALL CoA Level Guide progress? This cannot be undone.",
        button1 = "Reset",
        button2 = "Cancel",
        OnAccept = function()
            CoALevelGuide_Progress.ResetAll()
            if CoALevelGuide_MainFrame._frame then
                CoALevelGuide_MainFrame.Refresh()
            end
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }

    return button
end
