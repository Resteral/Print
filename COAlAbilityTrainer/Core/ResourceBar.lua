-- ============================================================
-- CoAAbilityTrainer - Resource Bar
-- Animated resource bar (Felfury / Runic Power / Focus / etc.)
-- Displays as a sleek glowing bar with threshold marker
-- ============================================================

CoAAT_ResourceBar = {}

local BAR_W = 264
local BAR_H = 12
local _frame = nil

-- ─────────────────────────────────────────────
-- Build the resource bar frame
-- ─────────────────────────────────────────────
function CoAAT_ResourceBar.Build(parent, posX, posY)
    local f = CreateFrame("Frame", "CoAATResourceBar", parent)
    f:SetSize(BAR_W + 60, BAR_H + 24)
    f:SetPoint("CENTER", parent, "BOTTOM", posX or 0, (posY or 0) + 14)
    _frame = f

    -- Background track
    local trackBG = f:CreateTexture(nil, "BACKGROUND")
    trackBG:SetSize(BAR_W, BAR_H)
    trackBG:SetPoint("CENTER", f, "CENTER", 0, 4)
    trackBG:SetTexture(0.04, 0.04, 0.1, 0.95)
    f._trackBG = trackBG

    -- Subtle inner groove
    local groove = f:CreateTexture(nil, "ARTWORK")
    groove:SetSize(BAR_W - 4, BAR_H - 6)
    groove:SetPoint("CENTER", f, "CENTER", 0, 4)
    groove:SetTexture(0.02, 0.02, 0.06, 0.95)
    f._groove = groove

    -- Fill bar
    local fill = f:CreateTexture(nil, "ARTWORK")
    fill:SetSize(0, BAR_H - 4)
    fill:SetPoint("LEFT", groove, "LEFT", 2, 0)
    fill:SetTexture(0.0, 0.7, 1.0, 0.95)
    f._fill = fill
    f._fillMaxW = BAR_W - 4

    -- Shimmer overlay (animated)
    local shimmer = f:CreateTexture(nil, "OVERLAY")
    shimmer:SetSize(BAR_W - 4, (BAR_H - 4) / 2)
    shimmer:SetPoint("TOPLEFT", groove, "TOPLEFT", 2, -1)
    shimmer:SetTexture(1.0, 1.0, 1.0, 0.06)
    f._shimmer = shimmer

    -- Threshold marker line (e.g. "spend at 80%")
    local marker = f:CreateTexture(nil, "OVERLAY")
    marker:SetSize(2, BAR_H + 4)
    marker:SetPoint("LEFT", groove, "LEFT", 0, 0)
    marker:SetTexture(1.0, 1.0, 0.0, 0.85)
    f._marker = marker
    f._markerPos = 0.8  -- default: 80% threshold

    -- Left border / right border
    local lBorder = f:CreateTexture(nil, "OVERLAY")
    lBorder:SetSize(2, BAR_H + 4)
    lBorder:SetPoint("LEFT", trackBG, "LEFT", -1, 0)
    lBorder:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    lBorder:SetVertexColor(0.1, 0.4, 0.7, 0.8)
    f._lBorder = lBorder

    local rBorder = f:CreateTexture(nil, "OVERLAY")
    rBorder:SetSize(2, BAR_H + 4)
    rBorder:SetPoint("RIGHT", trackBG, "RIGHT", 1, 0)
    rBorder:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    rBorder:SetVertexColor(0.1, 0.4, 0.7, 0.8)
    f._rBorder = rBorder

    -- Resource label (left of bar)
    local resLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    resLabel:SetPoint("RIGHT", trackBG, "LEFT", -6, 0)
    resLabel:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    resLabel:SetText("|cffaaaaaa??|r")
    f._resLabel = resLabel

    -- Value text (inside bar)
    local valText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    valText:SetAllPoints(trackBG)
    valText:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    valText:SetJustifyH("CENTER")
    valText:SetJustifyV("MIDDLE")
    valText:SetText("0 / 100")
    f._valText = valText

    -- "SPEND NOW!" flash text (appears when above threshold)
    local spendFlash = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    spendFlash:SetPoint("RIGHT", trackBG, "RIGHT", 8, 0)
    spendFlash:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    spendFlash:SetText("")
    f._spendFlash = spendFlash
    f._spendPhase = 0

    -- Overflow flash when at max
    local overflowTex = f:CreateTexture(nil, "OVERLAY")
    overflowTex:SetAllPoints(trackBG)
    overflowTex:SetTexture(1.0, 0.5, 0.0, 0.0)
    overflowTex:SetBlendMode("ADD")
    f._overflow = overflowTex

    -- Chunk segments (visual black separator blocks for segmented look)
    f._segments = {}
    for i = 1, 5 do
        local seg = f:CreateTexture(nil, "OVERLAY")
        seg:SetSize(2, BAR_H)
        seg:SetPoint("LEFT", groove, "LEFT", math.floor((BAR_W - 4) * (i / 6)), 0)
        seg:SetTexture(0, 0, 0, 1)
        f._segments[i] = seg
    end

    -- Class skin crystals (WeakAuras-style collected soul shard nodes)
    f._crystals = {}
    local crystalW, crystalH = 26, 32
    local startOffset = -((5 - 1) * 28) / 2
    for i = 1, 5 do
        local cry = f:CreateTexture(nil, "OVERLAY")
        cry:SetSize(crystalW, crystalH)
        cry:SetPoint("BOTTOM", f, "TOP", startOffset + (i - 1) * 28, -2)
        cry:SetTexture("Interface\\AddOns\\COAlAbilityTrainer\\Icons\\Reapercrystal")
        cry:SetVertexColor(1, 1, 1, 1)
        cry:Hide()
        f._crystals[i] = cry
    end

    -- Animation tick
    f._animPhase = 0
    f:SetScript("OnUpdate", function(self, dt)
        self._animPhase = self._animPhase + dt

        -- Shimmer animation
        local shimAlpha = 0.04 + math.abs(math.sin(self._animPhase * 0.8)) * 0.04
        self._shimmer:SetAlpha(shimAlpha)

        -- Spend flash pulse
        if self._spendPhase > 0 then
            self._spendPhase = self._spendPhase + dt
            local flashAlpha = math.abs(math.sin(self._spendPhase * 4))
            self._spendFlash:SetAlpha(flashAlpha)
        end
    end)

    f:Hide()
    return f
end

-- ─────────────────────────────────────────────
-- Update bar values
-- ─────────────────────────────────────────────
function CoAAT_ResourceBar.Update(current, maxVal, color)
    local f = _frame
    if not f then return end

    f._lastCurrent = current
    f._lastMax = maxVal
    f._lastColor = color

    local pct = (maxVal > 0) and (current / maxVal) or 0
    local w   = math.max(0, math.floor(f._fillMaxW * pct))

    f._fill:SetWidth(w)

    local classId = CoAAT_Engine and CoAAT_Engine.GetClassId() or "general"
    local useCrystals = (classId == "reaper" or classId == "felsworn" or classId == "necromancer")

    if classId == "reaper" then
        f._fill:SetTexture("Interface\\AddOns\\COAlAbilityTrainer\\Icons\\Reaperbar")
        f._fill:SetVertexColor(1, 1, 1, 0.95)
        if color then
            f._spendFlash:SetTextColor(color.r, color.g, color.b)
        end
    elseif classId == "felsworn" then
        f._fill:SetTexture("Interface\\AddOns\\COAlAbilityTrainer\\Icons\\Felbar")
        f._fill:SetVertexColor(1, 1, 1, 0.95)
        if color then
            f._spendFlash:SetTextColor(color.r, color.g, color.b)
        end
    elseif classId == "necromancer" then
        f._fill:SetTexture("Interface\\AddOns\\COAlAbilityTrainer\\Icons\\Necrobar")
        f._fill:SetVertexColor(1, 1, 1, 0.95)
        if color then
            f._spendFlash:SetTextColor(color.r, color.g, color.b)
        end
    else
        if color then
            f._fill:SetTexture(color.r, color.g, color.b, 0.95)
            f._fill:SetVertexColor(1, 1, 1, 1)
            f._spendFlash:SetTextColor(color.r, color.g, color.b)
        end
    end

    -- Update floating crystals
    local activeCrystals = 0
    if maxVal > 0 then
        if maxVal <= 5 then
            activeCrystals = current
        else
            activeCrystals = math.floor(current / (maxVal / 5))
        end
    end

    for i = 1, 5 do
        local cry = f._crystals[i]
        if cry then
            if useCrystals then
                if classId == "reaper" then
                    cry:SetTexture("Interface\\AddOns\\COAlAbilityTrainer\\Icons\\Reapercrystal")
                elseif classId == "necromancer" then
                    cry:SetTexture("Interface\\AddOns\\COAlAbilityTrainer\\Icons\\Necrocrystal")
                else
                    cry:SetTexture("Interface\\AddOns\\COAlAbilityTrainer\\Icons\\Crystal")
                end

                if activeCrystals >= i then
                    cry:SetAlpha(1.0)
                    cry:SetVertexColor(1, 1, 1, 1)
                else
                    cry:SetAlpha(0.15)
                    cry:SetVertexColor(0.4, 0.4, 0.4, 0.3)
                end
                cry:Show()
            else
                cry:Hide()
            end
        end
    end

    -- Value text
    f._valText:SetText(math.floor(current) .. " / " .. maxVal)

    -- Overflow effect at max
    if current >= maxVal then
        f._overflow:SetAlpha(0.15 + math.abs(math.sin(f._animPhase * 6)) * 0.15)
    else
        f._overflow:SetAlpha(0)
    end

    -- Get spend threshold from class def
    local classDef = CoAAT_Engine.GetClassDef()
    local threshold = classDef and classDef.spendThreshold or 80
    local thresholdPct = threshold / maxVal

    -- Update marker position
    local markerX = math.floor((f._fillMaxW) * thresholdPct)
    f._marker:ClearAllPoints()
    f._marker:SetPoint("LEFT", f._groove, "LEFT", markerX, 0)
    f._markerPos = thresholdPct

    -- SPEND NOW flash
    if current >= threshold and threshold > 0 then
        if f._spendPhase == 0 then f._spendPhase = 0.01 end
        f._spendFlash:SetText("SPEND!")
    else
        f._spendPhase = 0
        f._spendFlash:SetText("")
        f._spendFlash:SetAlpha(1)
    end

    f:Show()
end

-- ─────────────────────────────────────────────
-- Set resource name label
-- ─────────────────────────────────────────────
function CoAAT_ResourceBar.SetResourceName(name, color)
    local f = _frame
    if not f then return end
    local c = color or { r=0.6, g=0.6, b=0.8 }
    local hex = string.format("|cff%02x%02x%02x", c.r*255, c.g*255, c.b*255)
    f._resLabel:SetText(hex .. (name or "Resource") .. "|r")
end

function CoAAT_ResourceBar.Show()
    if _frame then _frame:Show() end
end

function CoAAT_ResourceBar.Hide()
    if _frame then _frame:Hide() end
end

function CoAAT_ResourceBar.UpdateSizes()
    local f = _frame
    if not f then return end
    local db = CoAAT_DB
    local w = db and db.resBarWidth or 264

    f:SetWidth(w + 60)
    if f._trackBG then f._trackBG:SetWidth(w) end
    if f._groove then f._groove:SetWidth(w - 4) end
    if f._shimmer then f._shimmer:SetWidth(w - 4) end
    f._fillMaxW = w - 4

    -- Re-position segment dividers
    if f._segments then
        for i, seg in ipairs(f._segments) do
            seg:ClearAllPoints()
            seg:SetPoint("LEFT", f._groove, "LEFT", math.floor((w - 4) * (i / 6)), 0)
        end
    end

    -- Refresh values to resize filled area
    if f._lastCurrent then
        CoAAT_ResourceBar.Update(f._lastCurrent, f._lastMax or 100, f._lastColor)
    end
end

-- Update resource name when class changes
function CoAAT_ResourceBar.OnClassChanged(classId, specId)
    local cd = CoAAT_Engine.GetClassDef()
    if cd then
        CoAAT_ResourceBar.SetResourceName(cd.resource, cd.resourceColor)
        CoAAT_ResourceBar.Update(0, cd.resourceMax, cd.resourceColor)
    end
end

function CoAAT_ResourceBar.ApplyTheme(r, g, b, hex)
    local f = _frame
    if not f then return end
    if f._lBorder then f._lBorder:SetVertexColor(r, g, b, 0.8) end
    if f._rBorder then f._rBorder:SetVertexColor(r, g, b, 0.8) end
end

