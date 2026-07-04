-- ============================================================
-- CoALevelGuide - Waypoint System
-- Integrates with TomTom if available, falls back to /way chat
-- ============================================================

CoALevelGuide_Waypoints = {}

-- Try to set a waypoint using TomTom (if installed) or fall back to chat
function CoALevelGuide_Waypoints.SetWaypoint(x, y, zoneName, label)
    if not x or not y then
        CoALevelGuide_Utils.Print("No waypoint coordinates for this step.")
        return
    end

    -- Attempt TomTom integration
    if TomTom and TomTom.AddWaypoint then
        -- TomTom uses mapID or zone name; try zone name approach
        local success = pcall(function()
            -- TomTom 3.3.5a API: AddZWaypoint(c, z, x, y, desc)
            -- We'll use the simpler AddWaypoint with zone name
            TomTom:AddWaypoint(nil, nil, x / 100, y / 100, { title = label or "CoA Guide" })
        end)
        if success then
            CoALevelGuide_Utils.Print("Waypoint set via TomTom: " .. (zoneName or "") .. " (" .. x .. ", " .. y .. ")")
            return
        end
    end

    -- Fallback: copy a /way command to chat frame and print instructions
    local wayCmd = string.format("/way %s %.1f %.1f", zoneName or GetRealZoneText() or "", x, y)
    CoALevelGuide_Utils.Print("Set waypoint: " .. wayCmd)
    if ChatEdit_InsertLink then
        ChatEdit_InsertLink(wayCmd)
    end
end

-- Clear all waypoints
function CoALevelGuide_Waypoints.ClearWaypoints()
    if TomTom then
        pcall(function() TomTom:RemoveAllWaypoints() end)
        CoALevelGuide_Utils.Print("All TomTom waypoints cleared.")
    else
        CoALevelGuide_Utils.Print("TomTom not found. Install TomTom for full waypoint support.")
    end
end

-- Set waypoint from a step object
function CoALevelGuide_Waypoints.SetFromStep(step)
    if step and step.x and step.y then
        CoALevelGuide_Waypoints.SetWaypoint(step.x, step.y, step.zone, step.text)
    else
        CoALevelGuide_Utils.Print("This step has no waypoint coordinates.")
    end
end
