-- ============================================================
-- CoALevelGuide - Main Frame
-- The primary window with tabs: Guide, Classes, Zone Info
-- ============================================================

CoALevelGuide_MainFrame = {}

local FRAME_W = 480
local FRAME_H = 560
local HEADER_H = 44
local TAB_H    = 28
local CONTENT_Y_START = -(HEADER_H + TAB_H + 8)

-- Color palette
local C = {
    bg         = { r=0.04, g=0.06, b=0.12, a=0.97 },
    border     = { r=0.0,  g=0.75, b=1.0,  a=0.8  },
    accent     = { r=0.0,  g=0.8,  b=1.0,  a=1.0  },
    gold       = { r=1.0,  g=0.84, b=0.0,  a=1.0  },
    tabactive  = { r=0.0,  g=0.6,  b=0.9,  a=0.9  },
    tabinact   = { r=0.08, g=0.10, b=0.18, a=0.85 },
    separator  = { r=0.0,  g=0.55, b=0.8,  a=0.5  },
    highlight  = { r=0.1,  g=0.2,  b=0.35, a=0.6  },
}

local tabs = { "Guide", "Classes", "Zone Info", "Endgame Gear" }
local activeTab = 1
local tabFrames = {}

-- ─────────────────────────────────────────────
-- Helper: create a colored texture background
-- ─────────────────────────────────────────────
local function SetBG(frame, r, g, b, a)
    local tex = frame:CreateTexture(nil, "BACKGROUND")
    tex:SetAllPoints()
    tex:SetTexture(r, g, b, a)
    return tex
end

-- Helper: pixel border
local function AddBorder(frame, c, thickness)
    thickness = thickness or 1
    local function makeLine(parent, w, h, point, relPoint, offX, offY)
        local l = parent:CreateTexture(nil, "OVERLAY")
        l:SetSize(w, h)
        l:SetTexture(c.r, c.g, c.b, c.a)
        l:SetPoint(point, parent, relPoint, offX, offY)
        return l
    end
    makeLine(frame, FRAME_W, thickness, "TOPLEFT",     "TOPLEFT",     0,  0)
    makeLine(frame, FRAME_W, thickness, "BOTTOMLEFT",  "BOTTOMLEFT",  0,  0)
    makeLine(frame, thickness, FRAME_H, "TOPLEFT",     "TOPLEFT",     0,  0)
    makeLine(frame, thickness, FRAME_H, "TOPRIGHT",    "TOPRIGHT",    0,  0)
end

-- Helper: gradient header texture
local function AddHeaderGradient(frame)
    local tex = frame:CreateTexture(nil, "ARTWORK")
    tex:SetSize(FRAME_W, HEADER_H)
    tex:SetPoint("TOPLEFT")
    tex:SetGradientAlpha("HORIZONTAL",
        0.0, 0.4, 0.8, 0.9,   -- left: rich blue
        0.0, 0.1, 0.25, 0.95  -- right: deep dark
    )
    return tex
end

-- ─────────────────────────────────────────────
-- Create main window
-- ─────────────────────────────────────────────
function CoALevelGuide_MainFrame.Create()
    local f = CreateFrame("Frame", "CoALevelGuideMainFrame", UIParent)
    f:SetSize(FRAME_W, FRAME_H)
    f:SetFrameStrata("HIGH")
    f:SetToplevel(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, _, x, y = self:GetPoint()
        CoALevelGuide_Progress.SaveWindowPos(point, x, y)
    end)

    -- Restore position
    local pos = CoALevelGuide_Progress.GetWindowPos()
    f:SetPoint(pos.point or "CENTER", UIParent, pos.point or "CENTER", pos.x or 0, pos.y or 0)

    -- Background
    SetBG(f, C.bg.r, C.bg.g, C.bg.b, C.bg.a)
    AddBorder(f, C.border, 1)
    AddHeaderGradient(f)

    -- ── HEADER ──
    local logo = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    logo:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -12)
    logo:SetText("|cff00ccff⚔ Conquest of Azeroth|r |cffFFD700Level Guide|r")
    logo:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")

    local level = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    level:SetPoint("TOPRIGHT", f, "TOPRIGHT", -40, -16)
    level:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    level:SetText("|cffaaaaaa" .. (UnitName("player") or "Hero") .. " — Lvl " .. UnitLevel("player") .. "|r")
    f._levelText = level

    -- Close button
    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", 2, 2)
    closeBtn:SetScript("OnClick", function() CoALevelGuide_MainFrame.Hide() end)

    -- ── TABS ──
    local tabGroup = CreateFrame("Frame", nil, f)
    tabGroup:SetSize(FRAME_W, TAB_H)
    tabGroup:SetPoint("TOPLEFT", f, "TOPLEFT", 0, -HEADER_H)

    local tabWidth = math.floor(FRAME_W / #tabs)
    f._tabs = {}
    for i, tabName in ipairs(tabs) do
        local tb = CreateFrame("Button", nil, tabGroup)
        tb:SetSize(tabWidth, TAB_H)
        tb:SetPoint("TOPLEFT", tabGroup, "TOPLEFT", (i-1) * tabWidth, 0)

        local tbBG = tb:CreateTexture(nil, "BACKGROUND")
        tbBG:SetAllPoints()
        if i == 1 then
            tbBG:SetTexture(C.tabactive.r, C.tabactive.g, C.tabactive.b, C.tabactive.a)
        else
            tbBG:SetTexture(C.tabinact.r, C.tabinact.g, C.tabinact.b, C.tabinact.a)
        end
        tb._bg = tbBG

        local tbText = tb:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        tbText:SetAllPoints()
        tbText:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
        if i == 1 then
            tbText:SetText("|cff00ccff" .. tabName .. "|r")
        else
            tbText:SetText("|cffaaaaaa" .. tabName .. "|r")
        end
        tb._text = tbText

        -- Separator line
        if i < #tabs then
            local sep = tabGroup:CreateTexture(nil, "OVERLAY")
            sep:SetSize(1, TAB_H)
            sep:SetTexture(C.separator.r, C.separator.g, C.separator.b, C.separator.a)
            sep:SetPoint("LEFT", tb, "RIGHT", 0, 0)
        end

        tb:SetScript("OnClick", function()
            PlaySound(856) -- Tab click sound
            activeTab = i
            CoALevelGuide_MainFrame.SwitchTab(i)
        end)

        f._tabs[i] = tb
    end

    -- Tab underline (active indicator)
    local underline = tabGroup:CreateTexture(nil, "OVERLAY")
    underline:SetSize(tabWidth, 2)
    underline:SetTexture(C.accent.r, C.accent.g, C.accent.b, 1.0)
    underline:SetPoint("BOTTOMLEFT", tabGroup, "BOTTOMLEFT", 0, 0)
    f._underline = underline

    -- ── CONTENT AREA ──
    local content = CreateFrame("Frame", nil, f)
    content:SetPoint("TOPLEFT",     f, "TOPLEFT",     6,  CONTENT_Y_START)
    content:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -6, 6)
    f._content = content

    -- ── BOTTOM STATUS BAR ──
    local statusBar = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    statusBar:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 10, 8)
    statusBar:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    statusBar:SetText("|cffaaaaaa/coalvl to toggle  •  Drag header to move|r")
    f._status = statusBar

    -- Store reference
    CoALevelGuide_MainFrame._frame = f

    -- Build tab content panels
    CoALevelGuide_StepList.Build(content)
    CoALevelGuide_ClassPanel.Build(content)

    -- Zone info panel (simple scroll)
    local zonePanel = CoALevelGuide_MainFrame.BuildZonePanel(content)
    f._zonePanelFrame = zonePanel

    -- Gear info panel (scrollable checklist)
    local gearPanel = CoALevelGuide_MainFrame.BuildGearPanel(content)
    f._gearPanelFrame = gearPanel

    -- Initial state: show Guide tab
    CoALevelGuide_MainFrame.SwitchTab(1)

    -- Auto-update level text on level up
    f:RegisterEvent("PLAYER_LEVEL_UP")
    f:SetScript("OnEvent", function(self, event, ...)
        if event == "PLAYER_LEVEL_UP" then
            local newLevel = ...
            level:SetText("|cffaaaaaa" .. (UnitName("player") or "Hero") .. " — Lvl " .. newLevel .. "|r")
            CoALevelGuide_MainFrame.Refresh()
        end
    end)

    f:Hide()
    return f
end

-- ─────────────────────────────────────────────
-- Switch active tab
-- ─────────────────────────────────────────────
function CoALevelGuide_MainFrame.SwitchTab(idx)
    activeTab = idx
    local f = CoALevelGuide_MainFrame._frame
    if not f then return end

    local tabWidth = math.floor(FRAME_W / #tabs)

    -- Update tab visuals
    for i, tb in ipairs(f._tabs) do
        if i == idx then
            tb._bg:SetTexture(C.tabactive.r, C.tabactive.g, C.tabactive.b, C.tabactive.a)
            tb._text:SetText("|cff00ccff" .. tabs[i] .. "|r")
        else
            tb._bg:SetTexture(C.tabinact.r, C.tabinact.g, C.tabinact.b, C.tabinact.a)
            tb._text:SetText("|cffaaaaaa" .. tabs[i] .. "|r")
        end
    end

    -- Move underline
    f._underline:SetPoint("BOTTOMLEFT", f._tabs[idx], "BOTTOMLEFT", 0, 0)

    -- Show/hide panels
    if CoALevelGuide_StepList._scrollFrame then
        if idx == 1 then CoALevelGuide_StepList._scrollFrame:Show()
        else              CoALevelGuide_StepList._scrollFrame:Hide() end
    end
    if CoALevelGuide_ClassPanel._frame then
        if idx == 2 then CoALevelGuide_ClassPanel._frame:Show()
        else              CoALevelGuide_ClassPanel._frame:Hide() end
    end
    if f._zonePanelFrame then
        if idx == 3 then f._zonePanelFrame:Show()
        else              f._zonePanelFrame:Hide() end
    end
    if f._gearPanelFrame then
        if idx == 4 then f._gearPanelFrame:Show()
        else              f._gearPanelFrame:Hide() end
    end
end

-- ─────────────────────────────────────────────
-- Zone Info Panel (Tab 3)
-- ─────────────────────────────────────────────
function CoALevelGuide_MainFrame.BuildZonePanel(parent)
    local panel = CreateFrame("ScrollFrame", "CoALevelGuideZoneScroll", parent, "UIPanelScrollFrameTemplate")
    panel:SetAllPoints(parent)

    local child = CreateFrame("Frame", nil, panel)
    child:SetWidth(parent:GetWidth() - 24)
    child:SetHeight(1) -- grows dynamically
    panel:SetScrollChild(child)

    local yOff = -8
    local faction = CoALevelGuide_Utils.GetFaction()

    -- Header
    local header = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    header:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
    header:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
    header:SetText("|cff00ccffLeveling Zones — 1 to 60|r")
    yOff = yOff - 28

    for _, zone in ipairs(CoALevelGuide_Zones) do
        if zone.faction == "Both" or zone.faction == faction then
            -- Zone header row
            local zRow = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            zRow:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
            zRow:SetWidth(child:GetWidth() - 8)
            zRow:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
            zRow:SetJustifyH("LEFT")
            local factionColor = (zone.faction == "Alliance") and "|cff5599ff" or
                                 (zone.faction == "Horde")    and "|cffff4444" or "|cffaaaaaa"
            zRow:SetText(factionColor .. "■|r |cffFFD700" .. zone.name .. "|r  |cffaaaaaa(Lvl " .. zone.minLevel .. "-" .. zone.maxLevel .. ")|r")
            yOff = yOff - 20

            -- Description
            local desc = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            desc:SetPoint("TOPLEFT", child, "TOPLEFT", 14, yOff)
            desc:SetWidth(child:GetWidth() - 18)
            desc:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            desc:SetJustifyH("LEFT")
            desc:SetText("|cffcccccc" .. zone.description .. "|r")
            yOff = yOff - (desc:GetStringHeight() + 4)

            -- Tips
            for _, tip in ipairs(zone.tips) do
                local tipText = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                tipText:SetPoint("TOPLEFT", child, "TOPLEFT", 20, yOff)
                tipText:SetWidth(child:GetWidth() - 24)
                tipText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
                tipText:SetJustifyH("LEFT")
                tipText:SetText("|cff44aaff•|r |cffdddddd" .. tip .. "|r")
                yOff = yOff - (tipText:GetStringHeight() + 2)
            end

            -- Hub / Flight info
            local info = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            info:SetPoint("TOPLEFT", child, "TOPLEFT", 14, yOff)
            info:SetWidth(child:GetWidth() - 18)
            info:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            info:SetJustifyH("LEFT")
            info:SetText("|cffaaaaaa✈ FP: |r|cffffd700" .. (zone.flightPath or "N/A") .. "|r  |cffaaaaaa🏠 Hub: |r|cff88ff88" .. (zone.mainTown or "N/A") .. "|r")
            yOff = yOff - 20

            -- Divider
            local div = child:CreateTexture(nil, "OVERLAY")
            div:SetSize(child:GetWidth() - 8, 1)
            div:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
            div:SetTexture(C.separator.r, C.separator.g, C.separator.b, C.separator.a)
            yOff = yOff - 10
        end
    end

    child:SetHeight(math.abs(yOff) + 20)
    panel:Hide()
    return panel
end

-- ─────────────────────────────────────────────
-- Public methods
-- ─────────────────────────────────────────────
function CoALevelGuide_MainFrame.Show()
    local f = CoALevelGuide_MainFrame._frame
    if f then
        PlaySound(829) -- Window open sound
        CoALevelGuide_Utils.FadeIn(f, 0.2)
    end
end

function CoALevelGuide_MainFrame.Hide()
    local f = CoALevelGuide_MainFrame._frame
    if f then
        PlaySound(830) -- Window close sound
        CoALevelGuide_Utils.FadeOut(f, 0.2)
    end
end

function CoALevelGuide_MainFrame.Toggle()
    local f = CoALevelGuide_MainFrame._frame
    if f then
        if f:IsShown() and f:GetAlpha() > 0.5 then
            CoALevelGuide_MainFrame.Hide()
        else
            CoALevelGuide_MainFrame.Show()
        end
    end
end

function CoALevelGuide_MainFrame.Refresh()
    if CoALevelGuide_StepList.Refresh then
        CoALevelGuide_StepList.Refresh()
    end
end

-- ─────────────────────────────────────────────
-- Endgame Gear Panel (Tab 4)
-- ─────────────────────────────────────────────
function CoALevelGuide_MainFrame.BuildGearPanel(parent)
    local panel = CreateFrame("ScrollFrame", "CoALevelGuideGearScroll", parent, "UIPanelScrollFrameTemplate")
    panel:SetAllPoints(parent)

    local child = CreateFrame("Frame", nil, panel)
    child:SetWidth(parent:GetWidth() - 24)
    child:SetHeight(1) -- grows dynamically
    panel:SetScrollChild(child)

    -- Dropdown container at top
    local dropHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dropHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 8, -12)
    dropHeader:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    dropHeader:SetText("|cffFFD700Select Class Gearing:|r")

    local classDropdown = CreateFrame("Frame", "CoALevelGuideGearClassDropdown", child, "UIDropDownMenuTemplate")
    classDropdown:SetPoint("TOPLEFT", child, "TOPLEFT", 120, -6)
    UIDropDownMenu_SetWidth(classDropdown, 160)

    -- Detect player class
    local playerClassToken = CoALevelGuide_Utils.GetClass():lower()
    local selectedClassId = playerClassToken
    if not CoALevelGuide_ClassBiS[selectedClassId] then
        selectedClassId = "felsworn" -- default fallback
    end

    -- Update display text initially
    local initialClassName = selectedClassId:gsub("^%l", string.upper)
    UIDropDownMenu_SetText(classDropdown, initialClassName)

    -- Re-render function
    local function RenderContent(classId)
        -- Clear old sub-panels from child (skip dropdown and dropdown header)
        for _, obj in ipairs({ child:GetChildren() }) do
            if obj ~= classDropdown then
                obj:Hide()
                obj:SetParent(nil)
            end
        end
        for _, obj in ipairs({ child:GetRegions() }) do
            if obj ~= dropHeader then
                obj:Hide()
            end
        end

        local yOff = -36

        -- BiS Summary Box (Glassmorphic Card)
        local bisCard = CreateFrame("Frame", nil, child)
        bisCard:SetWidth(child:GetWidth() - 8)
        bisCard:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)

        local bisDef = CoALevelGuide_ClassBiS[classId] or CoALevelGuide_ClassBiS.felsworn

        local cardTitle = bisCard:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        cardTitle:SetPoint("TOPLEFT", bisCard, "TOPLEFT", 8, -6)
        cardTitle:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        cardTitle:SetText("|cff00ccff★ Class Best-in-Slot (BiS) & Stats|r")

        local cardText = bisCard:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        cardText:SetPoint("TOPLEFT", bisCard, "TOPLEFT", 8, -22)
        cardText:SetWidth(bisCard:GetWidth() - 16)
        cardText:SetJustifyH("LEFT")
        cardText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        cardText:SetText(
            "|cffFFD700PvE Stats:|r " .. bisDef.pve_stats .. "\n" ..
            "|cffc544ffPvP Stats:|r " .. bisDef.pvp_stats .. "\n" ..
            "|cff00ff88BiS Weapon:|r |cffffffff" .. bisDef.bis_weapon .. "|r\n" ..
            "|cffaaaaaaDrop/Vendor Location:|r |cffdddddd" .. bisDef.drop_loc .. "|r"
        )

        local cardH = cardText:GetStringHeight() + 32
        bisCard:SetHeight(cardH)

        -- Card background
        local cardBG = bisCard:CreateTexture(nil, "BACKGROUND")
        cardBG:SetAllPoints()
        cardBG:SetTexture(0.04, 0.08, 0.18, 0.8)

        local cardBorder = bisCard:CreateTexture(nil, "OVERLAY")
        cardBorder:SetSize(2, cardH)
        cardBorder:SetPoint("TOPLEFT", bisCard, "TOPLEFT", 0, 0)
        cardBorder:SetTexture(0.0, 0.8, 1.0, 0.9)

        yOff = yOff - cardH - 12

        -- Header
        local header = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        header:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        header:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
        header:SetText("|cff00ccffEndgame Gearing Guide — Level 60|r")
        yOff = yOff - 22

        local subheader = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        subheader:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        subheader:SetWidth(child:GetWidth() - 8)
        subheader:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        subheader:SetJustifyH("LEFT")
        subheader:SetText("|cffaaaaaaProgress through the four gearing stages to prepare your character for high-end raids.|r")
        yOff = yOff - 22

        -- PvE steps
        for i, phase in ipairs(CoALevelGuide_GearSteps) do
            local phaseFrame = CreateFrame("Frame", nil, child)
            phaseFrame:SetWidth(child:GetWidth() - 8)
            phaseFrame:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)

            local pHeader = phaseFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            pHeader:SetPoint("TOPLEFT", phaseFrame, "TOPLEFT", 0, 0)
            pHeader:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
            pHeader:SetText("|cffFFD700" .. phase.title .. "|r")

            local pDesc = phaseFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            pDesc:SetPoint("TOPLEFT", phaseFrame, "TOPLEFT", 8, -16)
            pDesc:SetWidth(phaseFrame:GetWidth() - 16)
            pDesc:SetJustifyH("LEFT")
            pDesc:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            pDesc:SetText("|cffffffff" .. phase.desc .. "|r")

            local localY = -34

            for _, tip in ipairs(phase.tips) do
                local pTip = phaseFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                pTip:SetPoint("TOPLEFT", phaseFrame, "TOPLEFT", 16, localY)
                pTip:SetWidth(phaseFrame:GetWidth() - 24)
                pTip:SetJustifyH("LEFT")
                pTip:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
                pTip:SetText("|cff00ff88•|r |cffdddddd" .. tip .. "|r")
                localY = localY - (pTip:GetStringHeight() + 4)
            end

            localFrameHeight = math.abs(localY) + 12
            phaseFrame:SetHeight(localFrameHeight)

            local phaseBG = phaseFrame:CreateTexture(nil, "BACKGROUND")
            phaseBG:SetAllPoints()
            phaseBG:SetTexture(0.04, 0.06, 0.12, 0.7)

            local sideBorder = phaseFrame:CreateTexture(nil, "OVERLAY")
            sideBorder:SetSize(2, localFrameHeight)
            sideBorder:SetPoint("TOPLEFT", phaseFrame, "TOPLEFT", 0, 0)
            sideBorder:SetTexture(0.0, 0.75, 1.0, 0.8)

            yOff = yOff - localFrameHeight - 14
        end

        -- ── SECTION DIVIDER ──
        local divider = child:CreateTexture(nil, "OVERLAY")
        divider:SetSize(child:GetWidth() - 8, 2)
        divider:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        divider:SetTexture(0.55, 0.0, 0.85, 0.8)
        yOff = yOff - 12

        -- PvP Header
        local pvpHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        pvpHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        pvpHeader:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
        pvpHeader:SetText("|cffc544ffPlayer vs Player (PvP) Gearing|r")
        yOff = yOff - 22

        -- ── PVE VS PVP COMPARISON TABLE ──
        local tableTitle = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        tableTitle:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        tableTitle:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
        tableTitle:SetText("|cffFFD700PvE vs PvP Stat Comparison|r")
        yOff = yOff - 18

        -- Table Header Row
        local thFrame = CreateFrame("Frame", nil, child)
        thFrame:SetSize(child:GetWidth() - 8, 22)
        thFrame:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        local thBG = thFrame:CreateTexture(nil, "BACKGROUND")
        thBG:SetAllPoints()
        thBG:SetTexture(0.08, 0.04, 0.15, 0.8)

        local col1 = thFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        col1:SetPoint("LEFT", thFrame, "LEFT", 8, 0)
        col1:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        col1:SetText("|cffaaaaaaStat Slot|r")

        local col2 = thFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        col2:SetPoint("LEFT", thFrame, "LEFT", 120, 0)
        col2:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        col2:SetText("|cffc544ffPvP Value|r")

        local col3 = thFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        col3:SetPoint("LEFT", thFrame, "LEFT", 280, 0)
        col3:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        col3:SetText("|cff00ccffPvE Value|r")

        yOff = yOff - 24

        for _, row in ipairs(CoALevelGuide_PvPGear.comparison) do
            local trFrame = CreateFrame("Frame", nil, child)
            trFrame:SetSize(child:GetWidth() - 8, 20)
            trFrame:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
            local trBG = trFrame:CreateTexture(nil, "BACKGROUND")
            trBG:SetAllPoints()
            trBG:SetTexture(0.02, 0.02, 0.06, 0.6)

            local r1 = trFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            r1:SetPoint("LEFT", trFrame, "LEFT", 8, 0)
            r1:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
            r1:SetText("|cffffffff" .. row.stat .. "|r")

            local r2 = trFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            r2:SetPoint("LEFT", trFrame, "LEFT", 120, 0)
            r2:SetWidth(150)
            r2:SetJustifyH("LEFT")
            r2:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
            r2:SetText("|cffc544ff" .. row.pvp .. "|r")

            local r3 = trFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            r3:SetPoint("LEFT", trFrame, "LEFT", 280, 0)
            r3:SetWidth(150)
            r3:SetJustifyH("LEFT")
            r3:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
            r3:SetText("|cff00ccff" .. row.pve .. "|r")

            yOff = yOff - 22
        end
        yOff = yOff - 12

        -- PvP Steps
        for i, phase in ipairs(CoALevelGuide_PvPGear.phases) do
            local phaseFrame = CreateFrame("Frame", nil, child)
            phaseFrame:SetWidth(child:GetWidth() - 8)
            phaseFrame:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)

            local pHeader = phaseFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            pHeader:SetPoint("TOPLEFT", phaseFrame, "TOPLEFT", 0, 0)
            pHeader:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
            pHeader:SetText("|cffc544ff" .. phase.title .. "|r")

            local pDesc = phaseFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            pDesc:SetPoint("TOPLEFT", phaseFrame, "TOPLEFT", 8, -16)
            pDesc:SetWidth(phaseFrame:GetWidth() - 16)
            pDesc:SetJustifyH("LEFT")
            pDesc:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            pDesc:SetText("|cffffffff" .. phase.desc .. "|r")

            local localY = -34

            for _, tip in ipairs(phase.tips) do
                local pTip = phaseFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                pTip:SetPoint("TOPLEFT", phaseFrame, "TOPLEFT", 16, localY)
                pTip:SetWidth(phaseFrame:GetWidth() - 24)
                pTip:SetJustifyH("LEFT")
                pTip:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
                pTip:SetText("|cffc544ff•|r |cffdddddd" .. tip .. "|r")
                localY = localY - (pTip:GetStringHeight() + 4)
            end

            localFrameHeight = math.abs(localY) + 12
            phaseFrame:SetHeight(localFrameHeight)

            local phaseBG = phaseFrame:CreateTexture(nil, "BACKGROUND")
            phaseBG:SetAllPoints()
            phaseBG:SetTexture(0.06, 0.04, 0.12, 0.7)

            local sideBorder = phaseFrame:CreateTexture(nil, "OVERLAY")
            sideBorder:SetSize(2, localFrameHeight)
            sideBorder:SetPoint("TOPLEFT", phaseFrame, "TOPLEFT", 0, 0)
            sideBorder:SetTexture(0.55, 0.0, 0.85, 0.8)

            yOff = yOff - localFrameHeight - 16
        end

        -- ── SECTION DIVIDER ──
        local divider2 = child:CreateTexture(nil, "OVERLAY")
        divider2:SetSize(child:GetWidth() - 8, 2)
        divider2:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        divider2:SetTexture(0.0, 0.75, 1.0, 0.8)
        yOff = yOff - 12

        -- Lower Level BiS Header
        local lowHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        lowHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        lowHeader:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
        lowHeader:SetText("|cffFFD700🏆 Lower Level Best-in-Slot (Leveling BiS)|r")
        yOff = yOff - 22

        -- Lower Level Steps/Brackets
        for _, bracket in ipairs(CoALevelGuide_LowerLevelGear) do
            local phaseFrame = CreateFrame("Frame", nil, child)
            phaseFrame:SetWidth(child:GetWidth() - 8)
            phaseFrame:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)

            local pHeader = phaseFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            pHeader:SetPoint("TOPLEFT", phaseFrame, "TOPLEFT", 8, -6)
            pHeader:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
            pHeader:SetText("|cff00ccff" .. bracket.title .. "|r")

            local localY = -24

            for _, item in ipairs(bracket.items) do
                local pItem = phaseFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                pItem:SetPoint("TOPLEFT", phaseFrame, "TOPLEFT", 16, localY)
                pItem:SetWidth(phaseFrame:GetWidth() - 24)
                pItem:SetJustifyH("LEFT")
                pItem:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
                pItem:SetText("|cffFFD700•|r |cffdddddd" .. item .. "|r")
                localY = localY - (pItem:GetStringHeight() + 4)
            end

            localFrameHeight = math.abs(localY) + 8
            phaseFrame:SetHeight(localFrameHeight)

            local phaseBG = phaseFrame:CreateTexture(nil, "BACKGROUND")
            phaseBG:SetAllPoints()
            phaseBG:SetTexture(0.04, 0.08, 0.18, 0.6)

            local sideBorder = phaseFrame:CreateTexture(nil, "OVERLAY")
            sideBorder:SetSize(2, localFrameHeight)
            sideBorder:SetPoint("TOPLEFT", phaseFrame, "TOPLEFT", 0, 0)
            sideBorder:SetTexture(0.0, 0.75, 1.0, 0.8)

            yOff = yOff - localFrameHeight - 14
        end

        -- ── SECTION DIVIDER ──
        local divider3 = child:CreateTexture(nil, "OVERLAY")
        divider3:SetSize(child:GetWidth() - 8, 2)
        divider3:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        divider3:SetTexture(0.55, 0.0, 0.85, 0.8)
        yOff = yOff - 12

        -- Professions Header
        local profHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        profHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        profHeader:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
        profHeader:SetText("|cff00ccff🛠 Recommended Professions & Combat Bonuses|r")
        yOff = yOff - 22

        -- Professions List
        for _, prof in ipairs(CoALevelGuide_Professions) do
            local phaseFrame = CreateFrame("Frame", nil, child)
            phaseFrame:SetWidth(child:GetWidth() - 8)
            phaseFrame:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)

            local pHeader = phaseFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            pHeader:SetPoint("TOPLEFT", phaseFrame, "TOPLEFT", 8, -6)
            pHeader:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
            pHeader:SetText("|cffFFD700" .. prof.name .. "|r")

            local pDesc = phaseFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            pDesc:SetPoint("TOPLEFT", phaseFrame, "TOPLEFT", 12, -22)
            pDesc:SetWidth(phaseFrame:GetWidth() - 20)
            pDesc:SetJustifyH("LEFT")
            pDesc:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            pDesc:SetText("|cffffffff" .. prof.desc .. "\n|cff44ff88Bonus:|r " .. prof.bonus .. "|r")

            localFrameHeight = pDesc:GetStringHeight() + 32
            phaseFrame:SetHeight(localFrameHeight)

            local phaseBG = phaseFrame:CreateTexture(nil, "BACKGROUND")
            phaseBG:SetAllPoints()
            phaseBG:SetTexture(0.04, 0.06, 0.12, 0.7)

            local sideBorder = phaseFrame:CreateTexture(nil, "OVERLAY")
            sideBorder:SetSize(2, localFrameHeight)
            sideBorder:SetPoint("TOPLEFT", phaseFrame, "TOPLEFT", 0, 0)
            sideBorder:SetTexture(0.55, 0.0, 0.85, 0.8)

            yOff = yOff - localFrameHeight - 14
        end

        child:SetHeight(math.abs(yOff) + 20)
    end

    -- Initialize the dropdown picker options
    UIDropDownMenu_Initialize(classDropdown, function(self, level)
        -- Collect sorted keys
        local sortedClasses = {}
        for cid, _ in pairs(CoALevelGuide_ClassBiS) do
            table.insert(sortedClasses, cid)
        end
        table.sort(sortedClasses)

        for _, cid in ipairs(sortedClasses) do
            local info = UIDropDownMenu_CreateInfo()
            local displayName = cid:gsub("^%l", string.upper):gsub("_", " ")
            info.text = displayName
            info.value = cid
            info.func = function()
                UIDropDownMenu_SetText(classDropdown, displayName)
                RenderContent(cid)
            end
            UIDropDownMenu_AddButton(info)
        end
    end)

    -- Initial render
    RenderContent(selectedClassId)

    panel:Hide()
    return panel
end
