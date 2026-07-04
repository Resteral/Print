-- ============================================================
-- CoALevelGuide - Class Panel (Tab 2: Classes)
-- Scrollable class browser with specs, tips, and stat priorities
-- ============================================================

CoALevelGuide_ClassPanel = {}

local CC = {
    specbg     = { r=0.05, g=0.08, b=0.18, a=0.8 },
    specsep    = { r=0.0,  g=0.5,  b=0.8,  a=0.4 },
    classbg    = { r=0.04, g=0.06, b=0.14, a=0.9 },
    classhdr   = { r=0.0,  g=0.4,  b=0.7,  a=0.9 },
    tipbg      = { r=0.04, g=0.10, b=0.06, a=0.8 },
    tankbg     = { r=0.10, g=0.06, b=0.02, a=0.8 },
    healbg     = { r=0.04, g=0.10, b=0.08, a=0.8 },
}

-- Role → color mapping
local function getRoleColor(role)
    if role:find("Tank")    then return "|cffff9944" end
    if role:find("Heal")    then return "|cff44ff88" end
    if role:find("DPS")     then return "|cffff4444" end
    if role:find("Support") then return "|cff88aaff" end
    return "|cffcccccc"
end

-- Difficulty stars
local function difficultyStars(d)
    local s = ""
    for i = 1, 3 do
        if i <= d then s = s .. "|cffFFD700★|r"
        else           s = s .. "|cff444444★|r" end
    end
    return s
end

function CoALevelGuide_ClassPanel.Build(parent)
    local panel = CreateFrame("ScrollFrame", "CoALevelGuideClassScroll", parent, "UIPanelScrollFrameTemplate")
    panel:SetAllPoints(parent)
    CoALevelGuide_ClassPanel._frame = panel

    local child = CreateFrame("Frame", nil, panel)
    child:SetWidth(parent:GetWidth() - 24)
    child:SetHeight(1)
    panel:SetScrollChild(child)

    local yOff = -6
    local W = child:GetWidth()

    -- Header
    local hdr = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    hdr:SetPoint("TOPLEFT", child, "TOPLEFT", 6, yOff)
    hdr:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
    hdr:SetText("|cff00ccff⚔ Conquest of Azeroth — Class Browser|r")
    yOff = yOff - 24

    local subhdr = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    subhdr:SetPoint("TOPLEFT", child, "TOPLEFT", 6, yOff)
    subhdr:SetWidth(W - 8)
    subhdr:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    subhdr:SetJustifyH("LEFT")
    subhdr:SetText("|cffaaaaaa21 custom classes with unique resources, specs, and mechanics. Click a class header to show details.|r")
    yOff = yOff - 22

    for _, cls in ipairs(CoALevelGuide_Classes) do
        -- ── Class Header Block ──
        local clsBlock = CreateFrame("Button", nil, child)
        clsBlock:SetSize(W, 36)
        clsBlock:SetPoint("TOPLEFT", child, "TOPLEFT", 0, yOff)

        local clsHdrTex = clsBlock:CreateTexture(nil, "BACKGROUND")
        clsHdrTex:SetAllPoints()
        clsHdrTex:SetGradientAlpha("HORIZONTAL",
            0.0, 0.25, 0.5, 0.95,
            0.02, 0.06, 0.14, 0.95)

        -- Class name
        local clsName = clsBlock:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        clsName:SetPoint("LEFT", clsBlock, "LEFT", 10, 4)
        clsName:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
        clsName:SetText(cls.color .. cls.name .. "|r")

        -- Role tag
        local roleTag = clsBlock:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        roleTag:SetPoint("LEFT", clsBlock, "LEFT", 10, -10)
        roleTag:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        roleTag:SetText(getRoleColor(cls.role) .. cls.role .. "|r  |cffaaaaaa[" .. cls.resource .. "]|r")

        -- Difficulty
        local diffLabel = clsBlock:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        diffLabel:SetPoint("RIGHT", clsBlock, "RIGHT", -10, 4)
        diffLabel:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        diffLabel:SetText(difficultyStars(cls.difficulty))

        local diffLabelSub = clsBlock:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        diffLabelSub:SetPoint("RIGHT", clsBlock, "RIGHT", -10, -10)
        diffLabelSub:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        diffLabelSub:SetText("|cffaaaaaararity|r")

        yOff = yOff - 36

        -- ── Expandable Detail Panel ──
        local detailFrame = CreateFrame("Frame", nil, child)
        detailFrame:SetWidth(W)
        detailFrame:SetPoint("TOPLEFT", child, "TOPLEFT", 0, yOff)

        local detailTex = detailFrame:CreateTexture(nil, "BACKGROUND")
        detailTex:SetAllPoints()
        detailTex:SetTexture(CC.classbg.r, CC.classbg.g, CC.classbg.b, CC.classbg.a)

        local dyOff = -6

        -- Description
        local descText = detailFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        descText:SetPoint("TOPLEFT", detailFrame, "TOPLEFT", 10, dyOff)
        descText:SetWidth(W - 14)
        descText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        descText:SetJustifyH("LEFT")
        descText:SetText("|cffcccccc" .. cls.description .. "|r")
        dyOff = dyOff - (descText:GetStringHeight() + 6)

        -- Specs header
        local specHdr = detailFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        specHdr:SetPoint("TOPLEFT", detailFrame, "TOPLEFT", 10, dyOff)
        specHdr:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
        specHdr:SetText("|cffFFD700Specializations:|r")
        dyOff = dyOff - 18

        -- Spec rows
        for _, spec in ipairs(cls.specs) do
            local specRow = CreateFrame("Frame", nil, detailFrame)
            specRow:SetSize(W - 12, 28)
            specRow:SetPoint("TOPLEFT", detailFrame, "TOPLEFT", 8, dyOff)

            local specBGTex = specRow:CreateTexture(nil, "BACKGROUND")
            specBGTex:SetAllPoints()
            specBGTex:SetTexture(CC.specbg.r, CC.specbg.g, CC.specbg.b, CC.specbg.a)

            local specName = specRow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            specName:SetPoint("LEFT", specRow, "LEFT", 6, 5)
            specName:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            specName:SetText("|cff00ccff" .. spec.name .. "|r  " .. getRoleColor(spec.role) .. "[" .. spec.role .. "]|r")

            local specDesc = specRow:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            specDesc:SetPoint("LEFT", specRow, "LEFT", 6, -8)
            specDesc:SetWidth(W - 28)
            specDesc:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
            specDesc:SetJustifyH("LEFT")
            specDesc:SetText("|cff999999" .. (spec.description or (spec.role .. " specialization.")) .. "|r")

            dyOff = dyOff - 30
        end

        dyOff = dyOff - 6

        -- Leveling Tips header
        local tipHdr = detailFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        tipHdr:SetPoint("TOPLEFT", detailFrame, "TOPLEFT", 10, dyOff)
        tipHdr:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
        tipHdr:SetText("|cff44ff88⚡ Leveling Tips:|r")
        dyOff = dyOff - 18

        -- Tip rows
        for _, tipStr in ipairs(cls.levelingTips) do
            local tipText = detailFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            tipText:SetPoint("TOPLEFT", detailFrame, "TOPLEFT", 14, dyOff)
            tipText:SetWidth(W - 20)
            tipText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            tipText:SetJustifyH("LEFT")
            tipText:SetText("|cff44aaff•|r |cffdddddd" .. tipStr .. "|r")
            dyOff = dyOff - (tipText:GetStringHeight() + 2)
        end

        -- Best Zones
        if cls.bestZones and #cls.bestZones > 0 then
            dyOff = dyOff - 4
            local zonesText = detailFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            zonesText:SetPoint("TOPLEFT", detailFrame, "TOPLEFT", 10, dyOff)
            zonesText:SetWidth(W - 14)
            zonesText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            zonesText:SetJustifyH("LEFT")
            zonesText:SetText("|cffFFD700✦ Best Leveling Zones:|r |cff88ff88" .. table.concat(cls.bestZones, " → ") .. "|r")
            dyOff = dyOff - 18
        end

        dyOff = dyOff - 6

        -- Separator
        local clsSep = detailFrame:CreateTexture(nil, "OVERLAY")
        clsSep:SetSize(W, 1)
        clsSep:SetPoint("TOPLEFT", detailFrame, "TOPLEFT", 0, dyOff)
        clsSep:SetTexture(CC.specsep.r, CC.specsep.g, CC.specsep.b, CC.specsep.a)

        local detailH = math.abs(dyOff) + 8
        detailFrame:SetHeight(detailH)

        -- Toggle detail on click
        local isExpanded = false
        detailFrame:Hide()
        clsBlock:SetScript("OnClick", function()
            isExpanded = not isExpanded
            if isExpanded then
                detailFrame:Show()
                -- Nudge yOff for subsequent items — we do a full rebuild approach
                -- by just showing/hiding (no dynamic reflow needed in classic Lua)
            else
                detailFrame:Hide()
            end
        end)

        -- Hover effect on class header
        clsBlock:SetScript("OnEnter", function(self)
            clsHdrTex:SetGradientAlpha("HORIZONTAL",
                0.0, 0.4, 0.7, 0.95,
                0.02, 0.1, 0.2, 0.95)
        end)
        clsBlock:SetScript("OnLeave", function(self)
            clsHdrTex:SetGradientAlpha("HORIZONTAL",
                0.0, 0.25, 0.5, 0.95,
                0.02, 0.06, 0.14, 0.95)
        end)

        -- Reserve space for the detail frame even when hidden (so scroll works)
        yOff = yOff - detailH - 4
    end

    child:SetHeight(math.abs(yOff) + 20)
    panel:Hide()
end
