-- ============================================================
-- CoALevelGuide - Progress Tracking
-- Saves and loads completed steps using SavedVariables
-- ============================================================

CoALevelGuide_Progress = {}

-- Initialize the saved data structure
function CoALevelGuide_Progress.Init()
    if not CoALevelGuideDB then
        CoALevelGuideDB = {}
    end
    if not CoALevelGuideDB.completed then
        CoALevelGuideDB.completed = {}
    end
    if not CoALevelGuideDB.currentPhase then
        CoALevelGuideDB.currentPhase = 1
    end
    if not CoALevelGuideDB.currentStep then
        CoALevelGuideDB.currentStep = 1
    end
    if not CoALevelGuideDB.minimap then
        CoALevelGuideDB.minimap = { angle = 200, hide = false }
    end
    if not CoALevelGuideDB.windowPos then
        CoALevelGuideDB.windowPos = { point = "CENTER", x = 0, y = 0 }
    end
    if not CoALevelGuideDB.activeClass then
        CoALevelGuideDB.activeClass = nil
    end
end

-- Check if a step is complete
function CoALevelGuide_Progress.IsComplete(phaseIdx, stepId)
    local key = phaseIdx .. "_" .. stepId
    return CoALevelGuideDB.completed[key] == true
end

-- Mark a step as complete
function CoALevelGuide_Progress.Complete(phaseIdx, stepId)
    local key = phaseIdx .. "_" .. stepId
    CoALevelGuideDB.completed[key] = true
end

-- Unmark a step (toggle)
function CoALevelGuide_Progress.Uncomplete(phaseIdx, stepId)
    local key = phaseIdx .. "_" .. stepId
    CoALevelGuideDB.completed[key] = nil
end

-- Toggle step completion state
function CoALevelGuide_Progress.Toggle(phaseIdx, stepId)
    if CoALevelGuide_Progress.IsComplete(phaseIdx, stepId) then
        CoALevelGuide_Progress.Uncomplete(phaseIdx, stepId)
        return false
    else
        CoALevelGuide_Progress.Complete(phaseIdx, stepId)
        return true
    end
end

-- Get count of completed steps in a phase
function CoALevelGuide_Progress.GetPhaseProgress(phaseIdx, phase)
    local total = #phase.steps
    local done  = 0
    for _, step in ipairs(phase.steps) do
        if CoALevelGuide_Progress.IsComplete(phaseIdx, step.id) then
            done = done + 1
        end
    end
    return done, total
end

-- Reset all progress (with confirmation)
function CoALevelGuide_Progress.ResetAll()
    CoALevelGuideDB.completed = {}
    CoALevelGuideDB.currentPhase = 1
    CoALevelGuideDB.currentStep = 1
    CoALevelGuide_Utils.Print("All progress has been reset.")
end

-- Auto-advance to next incomplete step in a phase
function CoALevelGuide_Progress.GetNextStep(phaseIdx, phase)
    for _, step in ipairs(phase.steps) do
        if not CoALevelGuide_Progress.IsComplete(phaseIdx, step.id) then
            return step
        end
    end
    return nil -- all done
end

-- Save minimap button angle
function CoALevelGuide_Progress.SaveMinimapAngle(angle)
    CoALevelGuideDB.minimap.angle = angle
end

-- Get minimap angle
function CoALevelGuide_Progress.GetMinimapAngle()
    return CoALevelGuideDB.minimap.angle or 200
end

-- Save window position
function CoALevelGuide_Progress.SaveWindowPos(point, x, y)
    CoALevelGuideDB.windowPos = { point = point, x = x, y = y }
end

-- Get window position
function CoALevelGuide_Progress.GetWindowPos()
    return CoALevelGuideDB.windowPos or { point = "CENTER", x = 0, y = 0 }
end
