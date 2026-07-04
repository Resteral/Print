-- ============================================================
-- CoALevelGuide - Step List Panel (Tab 1: Guide)
-- Scrollable checklist of guide steps with progress bar
-- ============================================================

CoALevelGuide_StepList = {}

local STEP_H   = 38
local CHECK_SZ = 18
local PAD      = 8

-- Color palette (shared style)
local SC = {
    done   = { r=0.02, g=0.20, b=0.05, a=0.65 }, -- emerald glass
    undone = { r=0.02, g=0.03, b=0.08, a=0.80 }, -- obsidian glass
    hover  = { r=0.05, g=0.15, b=0.35, a=0.85 }, -- sapphire glass
    tip    = { r=0.03, g=0.05, b=0.10, a=0.65 }, 
    dungeon= { r=0.12, g=0.03, b=0.20, a=0.65 }, -- amethyst glass
    check_done   = { r=0.0,  g=1.0,  b=0.5,  a=1.0 },
    check_undone = { r=0.2,  g=0.4,  b=0.6,  a=0.8 },
    progress_bg  = { r=0.02, g=0.03, b=0.06, a=0.9 },
    progress_fill= { r=0.0,  g=0.75, b=1.0,  a=0.9 },
}

-- ─────────────────────────────────────────────
-- Build the entire Guide panel
-- ─────────────────────────────────────────────
function CoALevelGuide_StepList.Build(parent)
    -- Main scroll frame
    local sf = CreateFrame("ScrollFrame", "CoALevelGuideStepScroll", parent, "UIPanelScrollFrameTemplate")
    sf:SetAllPoints(parent)
    CoALevelGuide_StepList._scrollFrame = sf

    local child = CreateFrame("Frame", nil, sf)
    child:SetWidth(parent:GetWidth() - 24)
    child:SetHeight(1)
    sf:SetScrollChild(child)
    CoALevelGuide_StepList._child = child

    CoALevelGuide_StepList.Refresh()
end

-- ─────────────────────────────────────────────
-- Refresh / rebuild all step rows
-- ─────────────────────────────────────────────
function CoALevelGuide_StepList.Refresh()
    local child = CoALevelGuide_StepList._child
    if not child then return end

    -- Clear old children
    for _, obj in ipairs({ child:GetChildren() }) do
        obj:Hide()
        obj:SetParent(nil)
    end
    -- Clear old textures and font strings too
    for _, obj in ipairs({ child:GetRegions() }) do
        obj:Hide()
    end

    local yOff = -6
    local faction = CoALevelGuide_Utils.GetFaction()
    local level   = CoALevelGuide_Utils.GetLevel()

    -- Find relevant phases
    local phasesShown = 0
    for phaseIdx, phase in ipairs(CoALevelGuide_Steps) do
        if phase.faction == "Both" or phase.faction == faction then
            phasesShown = phasesShown + 1

            -- ── Phase Header ──
            local phBG = CreateFrame("Frame", nil, child)
            phBG:SetSize(child:GetWidth(), 26)
            phBG:SetPoint("TOPLEFT", child, "TOPLEFT", 0, yOff)

            local phBGTex = phBG:CreateTexture(nil, "BACKGROUND")
            phBGTex:SetAllPoints()
            phBGTex:SetGradientAlpha("HORIZONTAL",
                0.0, 0.35, 0.6, 0.85,
                0.0, 0.1,  0.2, 0.85)

            local phText = phBG:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            phText:SetPoint("LEFT", phBG, "LEFT", 8, 0)
            phText:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
            local isCurrentPhase = (level >= phase.minLevel and level <= phase.maxLevel)
            local phLabel = phase.title
            if isCurrentPhase then
                phLabel = "|cff00ff88► |r" .. phLabel .. " |cff00ff88◄|r"
            end
            phText:SetText("|cff00ccff" .. phLabel .. "|r")

            -- Progress count
            local done, total = CoALevelGuide_Progress.GetPhaseProgress(phaseIdx, phase)
            local progText = phBG:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            progText:SetPoint("RIGHT", phBG, "RIGHT", -28, 0)
            progText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            progText:SetText("|cffaaaaaa" .. done .. "/" .. total .. "|r")

            yOff = yOff - 26

            -- ── Progress Bar ──
            local barBG = child:CreateTexture(nil, "BACKGROUND")
            barBG:SetSize(child:GetWidth(), 4)
            barBG:SetPoint("TOPLEFT", child, "TOPLEFT", 0, yOff)
            barBG:SetTexture(SC.progress_bg.r, SC.progress_bg.g, SC.progress_bg.b, SC.progress_bg.a)

            local pct = (total > 0) and (done / total) or 0
            local barFill = child:CreateTexture(nil, "ARTWORK")
            barFill:SetSize(math.max(2, child:GetWidth() * pct), 4)
            barFill:SetPoint("TOPLEFT", child, "TOPLEFT", 0, yOff)
            barFill:SetTexture(SC.progress_fill.r, SC.progress_fill.g, SC.progress_fill.b, SC.progress_fill.a)

            yOff = yOff - 6

            -- ── Steps ──
            for _, step in ipairs(phase.steps) do
                local isDone     = CoALevelGuide_Progress.IsComplete(phaseIdx, step.id)
                local isDungeon  = (step.type == "dungeon")
                local isTip      = (step.type == "tip")

                -- Row background
                local rowFrame = CreateFrame("Button", nil, child)
                rowFrame:SetSize(child:GetWidth(), STEP_H)
                rowFrame:SetPoint("TOPLEFT", child, "TOPLEFT", 0, yOff)

                local rowBG = rowFrame:CreateTexture(nil, "BACKGROUND")
                rowBG:SetAllPoints()
                if isDone then
                    rowBG:SetTexture(SC.done.r, SC.done.g, SC.done.b, SC.done.a)
                elseif isDungeon then
                    rowBG:SetTexture(SC.dungeon.r, SC.dungeon.g, SC.dungeon.b, SC.dungeon.a)
                elseif isTip then
                    rowBG:SetTexture(SC.tip.r, SC.tip.g, SC.tip.b, SC.tip.a)
                else
                    rowBG:SetTexture(SC.undone.r, SC.undone.g, SC.undone.b, SC.undone.a)
                end
                rowFrame._bg = rowBG

                -- Hover effect
                rowFrame:SetScript("OnEnter", function(self)
                    if not CoALevelGuide_Progress.IsComplete(phaseIdx, step.id) then
                        rowBG:SetTexture(SC.hover.r, SC.hover.g, SC.hover.b, SC.hover.a)
                    end
                    -- Show waypoint hint in tooltip if available
                    if step.x and step.y then
                        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                        GameTooltip:AddLine("|cff00ccffWaypoint Available|r")
                        GameTooltip:AddLine("|cffaaaaaa" .. (step.zone or "") .. " (" .. step.x .. ", " .. step.y .. ")|r")
                        GameTooltip:AddLine("|cff44aaff[Right Click]|r to set waypoint", 1, 1, 1)
                        GameTooltip:Show()
                    end
                end)
                rowFrame:SetScript("OnLeave", function()
                    local done2 = CoALevelGuide_Progress.IsComplete(phaseIdx, step.id)
                    if done2 then
                        rowBG:SetTexture(SC.done.r, SC.done.g, SC.done.b, SC.done.a)
                    elseif isDungeon then
                        rowBG:SetTexture(SC.dungeon.r, SC.dungeon.g, SC.dungeon.b, SC.dungeon.a)
                    elseif isTip then
                        rowBG:SetTexture(SC.tip.r, SC.tip.g, SC.tip.b, SC.tip.a)
                    else
                        rowBG:SetTexture(SC.undone.r, SC.undone.g, SC.undone.b, SC.undone.a)
                    end
                    GameTooltip:Hide()
                end)

                -- Left click: toggle complete
                rowFrame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
                rowFrame:SetScript("OnClick", function(self, btn)
                    if btn == "LeftButton" then
                        local nowDone = CoALevelGuide_Progress.Toggle(phaseIdx, step.id)
                        if nowDone then
                            PlaySound(857) -- Checkmark ticking sound
                            rowBG:SetTexture(SC.done.r, SC.done.g, SC.done.b, SC.done.a)
                        else
                            PlaySound(856) -- Uncheck sound
                            if isDungeon then
                                rowBG:SetTexture(SC.dungeon.r, SC.dungeon.g, SC.dungeon.b, SC.dungeon.a)
                            elseif isTip then
                                rowBG:SetTexture(SC.tip.r, SC.tip.g, SC.tip.b, SC.tip.a)
                            else
                                rowBG:SetTexture(SC.undone.r, SC.undone.g, SC.undone.b, SC.undone.a)
                            end
                        end
                        self._checkMark:SetText(nowDone and "|cff00ff88✔|r" or "|cff335577□|r")
                    elseif btn == "RightButton" then
                        PlaySound(856)
                        CoALevelGuide_Waypoints.SetFromStep(step)
                    end
                end)

                -- Step number
                local numText = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                numText:SetPoint("LEFT", rowFrame, "LEFT", PAD, 0)
                numText:SetSize(22, STEP_H)
                numText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
                numText:SetText("|cff777777" .. step.id .. ".|r")

                local check = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                check:SetPoint("LEFT", numText, "RIGHT", 2, 0)
                check:SetSize(CHECK_SZ, STEP_H)
                check:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
                check:SetText(isDone and "|cff00ff88✔|r" or "|cff335577□|r")
                rowFrame._checkMark = check

                -- Step type icon+label
                local typeLabel = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                typeLabel:SetPoint("TOPLEFT", rowFrame, "TOPLEFT", PAD + 38, -4)
                typeLabel:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
                local typeColor = CoALevelGuide_Utils.GetStepColor(step.type)
                local typeStr   = CoALevelGuide_Utils.GetStepLabel(step.type)
                local typeIcon  = CoALevelGuide_Utils.GetStepIcon(step.type)
                typeLabel:SetText(typeIcon .. " " .. typeColor .. typeStr .. "|r")

                -- Step description text
                local stepText = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                stepText:SetPoint("TOPLEFT", rowFrame, "TOPLEFT", PAD + 38, -16)
                stepText:SetWidth(child:GetWidth() - (PAD + 38) - 8)
                stepText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
                stepText:SetJustifyH("LEFT")
                local textColor = isDone and "|cff667766" or "|cffdddddd"
                stepText:SetText(textColor .. step.text .. "|r")

                -- Waypoint indicator (if has coords)
                if step.x and step.y then
                    local wpIcon = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                    wpIcon:SetPoint("RIGHT", rowFrame, "RIGHT", -4, 0)
                    wpIcon:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
                    wpIcon:SetText("|cff44aaff📍|r")
                end

                -- Thin separator line at bottom
                local sep = child:CreateTexture(nil, "OVERLAY")
                sep:SetSize(child:GetWidth(), 1)
                sep:SetPoint("TOPLEFT", child, "TOPLEFT", 0, yOff - STEP_H + 1)
                sep:SetTexture(0.0, 0.3, 0.5, 0.3)

                yOff = yOff - STEP_H
            end

            yOff = yOff - 12 -- spacer between phases
        end
    end

    if phasesShown == 0 then
        local noData = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        noData:SetPoint("TOPLEFT", child, "TOPLEFT", PAD, yOff)
        noData:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        noData:SetText("|cffaaaaaa No guide data found for your faction / level.|r")
        yOff = yOff - 30
    end

    child:SetHeight(math.abs(yOff) + 20)
end
