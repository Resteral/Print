-- ============================================================
-- CoALevelGuide - Tooltip Helpers
-- Enhanced tooltips for steps and zones
-- ============================================================

CoALevelGuide_Tooltip = {}

-- Show a step tooltip
function CoALevelGuide_Tooltip.ShowStep(owner, step)
    if not step then return end
    GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()

    -- Title: step type + text
    local typeColor = CoALevelGuide_Utils.GetStepColor(step.type)
    local typeLabel = CoALevelGuide_Utils.GetStepLabel(step.type)
    GameTooltip:AddLine(typeColor .. "[" .. typeLabel .. "]|r " .. (step.text or ""), 1, 1, 1, true)

    -- Zone + coordinates
    if step.zone then
        GameTooltip:AddLine("|cffaaaaaa📍 Zone: |r|cfffff44" .. step.zone .. "|r")
    end
    if step.x and step.y then
        GameTooltip:AddLine("|cffaaaaaa   Coords: |r|cff88ccff(" .. step.x .. ", " .. step.y .. ")|r")
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("|cff44aaff[Right Click]|r to set waypoint", 1, 1, 1)
    end

    GameTooltip:AddLine(" ")
    GameTooltip:AddLine("|cff44ff44[Left Click]|r to mark complete/incomplete", 1, 1, 1)

    GameTooltip:Show()
end

-- Show a zone tooltip
function CoALevelGuide_Tooltip.ShowZone(owner, zone)
    if not zone then return end
    GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()

    GameTooltip:AddLine("|cffFFD700" .. zone.name .. "|r")
    GameTooltip:AddLine("|cffaaaaaa" .. zone.faction .. " | Levels " .. zone.minLevel .. "-" .. zone.maxLevel .. "|r")
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(zone.description, 0.8, 0.8, 0.8, true)

    if zone.tips and #zone.tips > 0 then
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("|cff00ccffQuick Tips:|r")
        for i, tip in ipairs(zone.tips) do
            if i <= 3 then -- cap at 3 in tooltip
                GameTooltip:AddLine("• " .. tip, 0.8, 0.9, 0.8, true)
            end
        end
    end

    GameTooltip:Show()
end

-- Hide tooltip
function CoALevelGuide_Tooltip.Hide()
    GameTooltip:Hide()
end
