-- ============================================================
-- CoAAbilityTrainer - Proc Alert System
-- Full-screen flash + large icon when an ability procs
-- ============================================================

CoAAT_ProcAlert = {}

local alertFrame = nil
local alertQueue = {}
local currentAlert = nil
local ALERT_DURATION = 4.0  -- seconds before auto-dismiss
local FADE_TIME      = 0.4

-- ─────────────────────────────────────────────
-- Build the proc alert overlay (center-screen)
-- ─────────────────────────────────────────────
function CoAAT_ProcAlert.Build()
    local f = CreateFrame("Frame", "CoAATProcAlert", UIParent)
    f:SetSize(320, 100)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 160)
    f:SetFrameStrata("HIGH")
    f:SetAlpha(0)
    f:Hide()

    -- Glowing BG panel
    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0.0, 0.0, 0.05, 0.85)

    -- Animated edge glow
    local edgeGlow = f:CreateTexture(nil, "ARTWORK")
    edgeGlow:SetAllPoints()
    edgeGlow:SetTexture("Interface\\Cooldown\\star4")
    edgeGlow:SetBlendMode("ADD")
    edgeGlow:SetAlpha(0.0)
    f._edgeGlow = edgeGlow

    -- Large ability icon
    local icon = f:CreateTexture(nil, "ARTWORK")
    icon:SetSize(68, 68)
    icon:SetPoint("LEFT", f, "LEFT", 14, 0)
    icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    f._icon = icon

    -- Icon border ring
    local iconBorder = f:CreateTexture(nil, "OVERLAY")
    iconBorder:SetSize(76, 76)
    iconBorder:SetPoint("CENTER", icon, "CENTER", 0, 0)
    iconBorder:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    iconBorder:SetBlendMode("ADD")
    iconBorder:SetAlpha(0.6)
    f._iconBorder = iconBorder

    -- "PROC!" label
    local procLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    procLabel:SetPoint("TOPLEFT", f, "TOPLEFT", 96, -10)
    procLabel:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    procLabel:SetText("|cffFFD700⚡ PROC READY!|r")
    f._procLabel = procLabel

    -- Ability name (large)
    local abilityName = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    abilityName:SetPoint("TOPLEFT", f, "TOPLEFT", 96, -26)
    abilityName:SetFont("Fonts\\FRIZQT__.TTF", 17, "OUTLINE")
    abilityName:SetText("")
    f._abilityName = abilityName

    -- Hint text
    local hintText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    hintText:SetPoint("TOPLEFT", f, "TOPLEFT", 96, -50)
    hintText:SetWidth(210)
    hintText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    hintText:SetJustifyH("LEFT")
    hintText:SetText("")
    f._hintText = hintText

    -- Duration bar background
    local barBG = f:CreateTexture(nil, "OVERLAY")
    barBG:SetSize(214, 4)
    barBG:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 96, 8)
    barBG:SetTexture(0.1, 0.1, 0.2, 0.9)
    f._barBG = barBG

    -- Duration bar fill
    local barFill = f:CreateTexture(nil, "OVERLAY")
    barFill:SetSize(214, 4)
    barFill:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 96, 8)
    barFill:SetTexture(0.0, 0.9, 1.0, 0.9)
    f._barFill = barFill

    -- Animation state
    f._state     = "hidden"  -- "fadein", "show", "fadeout", "hidden"
    f._elapsed   = 0
    f._duration  = ALERT_DURATION
    f._barWidth  = 214

    f:SetScript("OnUpdate", function(self, dt)
        if self._state == "fadein" then
            self._elapsed = self._elapsed + dt
            local alpha = math.min(1.0, self._elapsed / FADE_TIME)
            self:SetAlpha(alpha)
            self._edgeGlow:SetAlpha(math.sin(self._elapsed * 6) * 0.3 + 0.2)
            if alpha >= 1.0 then
                self._state   = "show"
                self._elapsed = 0
            end

        elseif self._state == "show" then
            self._elapsed = self._elapsed + dt
            -- Pulse the edge glow
            self._edgeGlow:SetAlpha(math.abs(math.sin(self._elapsed * 3)) * 0.4)
            -- Update duration bar
            local pct = 1.0 - (self._elapsed / self._duration)
            self._barFill:SetWidth(math.max(0, self._barWidth * pct))
            if self._elapsed >= self._duration then
                self._state   = "fadeout"
                self._elapsed = 0
            end

        elseif self._state == "fadeout" then
            self._elapsed = self._elapsed + dt
            local alpha = 1.0 - math.min(1.0, self._elapsed / FADE_TIME)
            self:SetAlpha(alpha)
            if alpha <= 0 then
                self._state = "hidden"
                self:Hide()
                currentAlert = nil
                CoAAT_ProcAlert.ShowNext()
            end
        end
    end)

    alertFrame = f
end

-- ─────────────────────────────────────────────
-- Show the next queued proc
-- ─────────────────────────────────────────────
function CoAAT_ProcAlert.ShowNext()
    if currentAlert then return end  -- already showing
    if #alertQueue == 0 then return end

    currentAlert = table.remove(alertQueue, 1)
    local f = alertFrame
    if not f then return end

    local ab = CoAAT_Engine.GetAbilities()[currentAlert.abilityId]

    -- Set content
    f._icon:SetTexture(ab and ab.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
    f._abilityName:SetText(ab and ("|cff00ccff" .. ab.name .. "|r") or currentAlert.procName)
    f._hintText:SetText(ab and ("|cffaaaaaa" .. ab.hint .. "|r") or "")

    -- Color the proc label by urgency
    local labelColor = "|cffFFD700"
    if ab and ab.type == "proc" then
        labelColor = "|cffff9944"
    end
    f._procLabel:SetText(labelColor .. "⚡ PROC READY!|r")

    -- Color bar by ability color
    local c = ab and ab.color or { r=0.0, g=0.9, b=1.0 }
    f._barFill:SetTexture(c.r, c.g, c.b, 0.9)
    f._edgeGlow:SetVertexColor(c.r, c.g, c.b)

    -- Reset animation
    f._state   = "fadein"
    f._elapsed = 0
    f._duration = ALERT_DURATION
    f._barFill:SetWidth(f._barWidth)
    f:Show()
    f:SetAlpha(0)
end

-- ─────────────────────────────────────────────
-- Public API
-- ─────────────────────────────────────────────
function CoAAT_ProcAlert.OnProc(procName, duration)
    -- Find the ability this proc corresponds to
    local abilities = CoAAT_Engine.GetAbilities()
    local abilityId = nil
    for id, ab in pairs(abilities) do
        if ab.name == procName then abilityId = id break end
    end

    -- Queue the alert
    alertQueue[#alertQueue + 1] = {
        procName  = procName,
        abilityId = abilityId,
        duration  = duration or ALERT_DURATION,
    }
    CoAAT_ProcAlert.ShowNext()
end

function CoAAT_ProcAlert.OnProcExpired(procName)
    -- If this proc is currently showing, fade it out early
    if currentAlert and currentAlert.procName == procName and alertFrame then
        if alertFrame._state == "show" then
            alertFrame._state   = "fadeout"
            alertFrame._elapsed = 0
        end
    end
end

-- Dismiss current alert immediately
function CoAAT_ProcAlert.Dismiss()
    if alertFrame and alertFrame._state ~= "hidden" then
        alertFrame._state   = "fadeout"
        alertFrame._elapsed = 0
    end
end
