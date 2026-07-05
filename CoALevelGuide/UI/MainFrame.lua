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
    border     = { r=0.0,  g=0.75, b=1.0,  a=0.20 },
    accent     = { r=0.0,  g=0.8,  b=1.0,  a=1.0  },
    gold       = { r=1.0,  g=0.84, b=0.0,  a=1.0  },
    tabactive  = { r=0.0,  g=0.6,  b=0.9,  a=0.9  },
    tabinact   = { r=0.08, g=0.10, b=0.18, a=0.40 },
    separator  = { r=0.0,  g=0.55, b=0.8,  a=0.15 },
    highlight  = { r=0.1,  g=0.2,  b=0.35, a=0.6  },
}

local tabs = { "Guide", "Classes", "Talents", "Dungeons", "Gear Guide", "PvP Guide" }
local activeTab = 1
local tabFrames = {}

local classThemes = {
    default = {
        border = { r=0.0,  g=0.75, b=1.0,  a=0.20 },
        accent = { r=0.0,  g=0.8,  b=1.0,  a=1.0  },
        logo   = "|cff00ccff⚔ CoA|r |cffFFD700Lvl Guide|r",
        textHex = "00ccff",
        bg = { r=0.03, g=0.05, b=0.12, a=0.97 }
    },
    felsworn = {
        border = { r=0.2,  g=0.9,  b=0.2,  a=0.20 },
        accent = { r=0.1,  g=1.0,  b=0.1,  a=1.0  },
        logo   = "|cff39e639⚔ Felsworn|r |cffFFD700Guide|r",
        textHex = "39e639",
        bg = { r=0.03, g=0.08, b=0.04, a=0.97 }
    },
    necromancer = {
        border = { r=0.0,  g=0.8,  b=0.8,  a=0.20 },
        accent = { r=0.2,  g=0.9,  b=1.0,  a=1.0  },
        logo   = "|cff4dff4d⚔ Necro|r |cffFFD700Guide|r",
        textHex = "4dff4d",
        bg = { r=0.02, g=0.08, b=0.08, a=0.97 }
    },
    reaper = {
        border = { r=0.7,  g=0.0,  b=0.8,  a=0.20 },
        accent = { r=0.8,  g=0.1,  b=1.0,  a=1.0  },
        logo   = "|cffb300b3⚔ Reaper|r |cffFFD700Guide|r",
        textHex = "b300b3",
        bg = { r=0.05, g=0.02, b=0.08, a=0.97 }
    },
    runemaster = {
        border = { r=0.9,  g=0.5,  b=0.1,  a=0.20 },
        accent = { r=1.0,  g=0.6,  b=0.0,  a=1.0  },
        logo   = "|cffff9900⚔ Runemaster|r |cffFFD700Guide|r",
        textHex = "ff9900",
        bg = { r=0.07, g=0.04, b=0.02, a=0.97 }
    },
    obsidian = {
        border = { r=0.9,  g=0.7,  b=0.2,  a=0.20 },
        accent = { r=1.0,  g=0.8,  b=0.1,  a=1.0  },
        logo   = "|cffffcc00⚔ Obsidian|r |cffFFD700Guide|r",
        textHex = "ffcc00",
        bg = { r=0.04, g=0.04, b=0.04, a=0.97 }
    },
    cyberpunk = {
        border = { r=1.0,  g=0.1,  b=0.6,  a=0.20 },
        accent = { r=1.0,  g=0.2,  b=0.8,  a=1.0  },
        logo   = "|cffff33aa⚔ Neon|r |cff00ffffGuide|r",
        textHex = "ff33aa",
        bg = { r=0.06, g=0.02, b=0.10, a=0.97 }
    },
    emerald = {
        border = { r=0.0,  g=0.9,  b=0.4,  a=0.20 },
        accent = { r=0.1,  g=1.0,  b=0.5,  a=1.0  },
        logo   = "|cff11ff77⚔ Emerald|r |cffFFD700Guide|r",
        textHex = "11ff77",
        bg = { r=0.02, g=0.07, b=0.03, a=0.97 }
    },
    frozen = {
        border = { r=0.2,  g=0.6,  b=1.0,  a=0.20 },
        accent = { r=0.3,  g=0.8,  b=1.0,  a=1.0  },
        logo   = "|cff55ccff⚔ Frozen|r |cffFFD700Guide|r",
        textHex = "55ccff",
        bg = { r=0.02, g=0.04, b=0.09, a=0.97 }
    },
    crimson = {
        border = { r=0.9,  g=0.1,  b=0.1,  a=0.20 },
        accent = { r=1.0,  g=0.2,  b=0.2,  a=1.0  },
        logo   = "|cffff3333⚔ Crimson|r |cffFFD700Guide|r",
        textHex = "ff3333",
        bg = { r=0.06, g=0.02, b=0.02, a=0.97 }
    }
}

local function GetActiveTheme()
    local theme = CoALevelGuideDB and CoALevelGuideDB.activeTheme or "default"
    if theme == "default" then
        local activeClass = CoALevelGuideDB and CoALevelGuideDB.activeClass
        if not activeClass or activeClass == "" or activeClass == "auto" then
            activeClass = CoALevelGuide_Utils.GetClass():lower()
        end
        return classThemes[activeClass] or classThemes.default
    end
    return classThemes[theme] or classThemes.default
end


-- ─────────────────────────────────────────────
-- Helper: create a colored texture background
-- ─────────────────────────────────────────────
local function SetBG(frame, r, g, b, a)
    local tex = frame:CreateTexture(nil, "BACKGROUND")
    tex:SetAllPoints()
    tex:SetTexture(r, g, b, a)
    if tex.SetGradientAlpha then
        tex:SetGradientAlpha("VERTICAL", r*0.4, g*0.4, b*0.4, a*1.02, r*1.3, g*1.3, b*1.3, a*0.93)
    end
    return tex
end

-- Helper: pixel border
local function AddBorder(frame, c, thickness)
    thickness = thickness or 1
    frame._borderLines = {}
    local function makeLine(parent, w, h, point, relPoint, offX, offY)
        local l = parent:CreateTexture(nil, "OVERLAY")
        l:SetSize(w, h)
        l:SetTexture(c.r, c.g, c.b, c.a)
        l:SetPoint(point, parent, relPoint, offX, offY)
        table.insert(frame._borderLines, l)
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
    f._bg = SetBG(f, C.bg.r, C.bg.g, C.bg.b, C.bg.a)
    AddBorder(f, C.border, 1)
    AddHeaderGradient(f)

    -- ── HEADER ──
    -- 3D Spinning Character bust logo icon
    local logoModel = CreateFrame("PlayerModel", nil, f)
    logoModel:SetSize(36, 36)
    logoModel:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -5)
    logoModel:SetUnit("player")
    logoModel:SetCamera(0)
    
    local rot = 0
    logoModel:SetScript("OnUpdate", function(self, elapsed)
        rot = rot + elapsed * 0.4
        self:SetRotation(rot)
    end)
    f._logoModel = logoModel

    local logo = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    logo:SetPoint("LEFT", logoModel, "RIGHT", 6, 0)
    logo:SetText("|cff00ccff⚔ CoA|r |cffFFD700Lvl Guide|r")
    logo:SetFont("Fonts\\FRIZQT__.TTF", 17, "OUTLINE")
    f._logoText = logo

    -- Class Selector Dropdown on Header
    local classDropdown = CreateFrame("Frame", "CoALevelGuideHeaderClassDropdown", f, "UIDropDownMenuTemplate")
    classDropdown:SetPoint("TOPRIGHT", f, "TOPRIGHT", -40, -8)
    UIDropDownMenu_SetWidth(classDropdown, 90)
    UIDropDownMenu_SetButtonWidth(classDropdown, 104)

    local function Dropdown_OnClick(self)
        UIDropDownMenu_SetSelectedValue(classDropdown, self.value)
        CoALevelGuideDB.activeClass = (self.value == "auto") and nil or self.value
        CoALevelGuide_MainFrame.UpdateTheme()
        if activeTab == 4 and CoALevelGuide_MainFrame.RefreshGear then
            CoALevelGuide_MainFrame.RefreshGear(CoALevelGuideDB.activeClass or CoALevelGuide_Utils.GetClass():lower())
        elseif activeTab == 5 and CoALevelGuide_MainFrame.RefreshPvP then
            CoALevelGuide_MainFrame.RefreshPvP()
        end
    end

    UIDropDownMenu_Initialize(classDropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        info.func = Dropdown_OnClick

        info.text = "Auto-Detect"
        info.value = "auto"
        info.checked = (CoALevelGuideDB.activeClass == nil)
        UIDropDownMenu_AddButton(info)

        info.text = "|cff39e639Felsworn|r"
        info.value = "felsworn"
        info.checked = (CoALevelGuideDB.activeClass == "felsworn")
        UIDropDownMenu_AddButton(info)

        info.text = "|cff4dff4dNecromancer|r"
        info.value = "necromancer"
        info.checked = (CoALevelGuideDB.activeClass == "necromancer")
        UIDropDownMenu_AddButton(info)

        info.text = "|cffb300b3Reaper|r"
        info.value = "reaper"
        info.checked = (CoALevelGuideDB.activeClass == "reaper")
        UIDropDownMenu_AddButton(info)

        info.text = "|cffff9900Runemaster|r"
        info.value = "runemaster"
        info.checked = (CoALevelGuideDB.activeClass == "runemaster")
        UIDropDownMenu_AddButton(info)
    end)

    local activeVal = CoALevelGuideDB.activeClass or "auto"
    UIDropDownMenu_SetSelectedValue(classDropdown, activeVal)
    local activeTexts = { auto = "Auto-Detect", felsworn = "Felsworn", necromancer = "Necromancer", reaper = "Reaper", runemaster = "Runemaster" }
    UIDropDownMenu_SetText(classDropdown, activeTexts[activeVal])
    f._headerDropdown = classDropdown

    -- Theme Selector Dropdown on Header
    local themeDropdown = CreateFrame("Frame", "CoALevelGuideHeaderThemeDropdown", f, "UIDropDownMenuTemplate")
    themeDropdown:SetPoint("TOPRIGHT", f, "TOPRIGHT", -150, -8)
    UIDropDownMenu_SetWidth(themeDropdown, 90)
    UIDropDownMenu_SetButtonWidth(themeDropdown, 104)

    local function ThemeDropdown_OnClick(self)
        UIDropDownMenu_SetSelectedValue(themeDropdown, self.value)
        CoALevelGuideDB.activeTheme = self.value
        CoALevelGuide_MainFrame.UpdateTheme()
        if CoAAT_CombatHUD and CoAAT_CombatHUD.RefreshLayout then
            CoAAT_CombatHUD.RefreshLayout()
        end
    end

    UIDropDownMenu_Initialize(themeDropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        info.func = ThemeDropdown_OnClick

        info.text = "Class Theme"
        info.value = "default"
        info.checked = (CoALevelGuideDB.activeTheme == "default" or CoALevelGuideDB.activeTheme == nil)
        UIDropDownMenu_AddButton(info)

        info.text = "|cffffcc00Obsidian|r"
        info.value = "obsidian"
        info.checked = (CoALevelGuideDB.activeTheme == "obsidian")
        UIDropDownMenu_AddButton(info)

        info.text = "|cffff33aaCyberpunk|r"
        info.value = "cyberpunk"
        info.checked = (CoALevelGuideDB.activeTheme == "cyberpunk")
        UIDropDownMenu_AddButton(info)

        info.text = "|cff11ff77Emerald|r"
        info.value = "emerald"
        info.checked = (CoALevelGuideDB.activeTheme == "emerald")
        UIDropDownMenu_AddButton(info)

        info.text = "|cff55ccffFrozen|r"
        info.value = "frozen"
        info.checked = (CoALevelGuideDB.activeTheme == "frozen")
        UIDropDownMenu_AddButton(info)

        info.text = "|cffff3333Crimson|r"
        info.value = "crimson"
        info.checked = (CoALevelGuideDB.activeTheme == "crimson")
        UIDropDownMenu_AddButton(info)
    end)

    local activeThemeVal = CoALevelGuideDB.activeTheme or "default"
    UIDropDownMenu_SetSelectedValue(themeDropdown, activeThemeVal)
    local themeTexts = {
        default = "Class Theme",
        obsidian = "Obsidian",
        cyberpunk = "Cyberpunk",
        emerald = "Emerald",
        frozen = "Frozen",
        crimson = "Crimson"
    }
    UIDropDownMenu_SetText(themeDropdown, themeTexts[activeThemeVal] or "Class Theme")
    f._themeDropdown = themeDropdown

    local level = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    level:SetPoint("LEFT", logo, "RIGHT", 14, 0)
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

    -- Talents panel
    local talentsPanel = CoALevelGuide_MainFrame.BuildTalentsPanel(content)
    f._talentsPanelFrame = talentsPanel

    -- Zone info panel (simple scroll)
    local zonePanel = CoALevelGuide_MainFrame.BuildZonePanel(content)
    f._zonePanelFrame = zonePanel

    -- Gear info panel (scrollable checklist)
    local gearPanel = CoALevelGuide_MainFrame.BuildGearPanel(content)
    f._gearPanelFrame = gearPanel

    -- PvP info panel
    local pvpPanel = CoALevelGuide_MainFrame.BuildPvPPanel(content)
    f._pvpPanelFrame = pvpPanel

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
function CoALevelGuide_MainFrame.UpdateTheme()
    local f = CoALevelGuide_MainFrame._frame
    if not f then return end

    local theme = GetActiveTheme()

    -- Update logo text
    if f._logoText then
        f._logoText:SetText(theme.logo)
    end

    -- Update background
    if f._bg then
        f._bg:SetTexture(theme.bg.r, theme.bg.g, theme.bg.b, theme.bg.a)
    end

    -- Update borders
    if f._borderLines then
        for _, line in ipairs(f._borderLines) do
            line:SetTexture(theme.border.r, theme.border.g, theme.border.b, theme.border.a)
        end
    end

    -- Update active tab underline
    if f._underline then
        f._underline:SetTexture(theme.accent.r, theme.accent.g, theme.accent.b, 1.0)
    end

    -- Refresh active tab styling
    CoALevelGuide_MainFrame.SwitchTab(activeTab or 1)
end

function CoALevelGuide_MainFrame.SwitchTab(idx)
    activeTab = idx
    local f = CoALevelGuide_MainFrame._frame
    if not f then return end

    local theme = GetActiveTheme()
    local tabWidth = math.floor(FRAME_W / #tabs)

    -- Update tab visuals
    for i, tb in ipairs(f._tabs) do
        if i == idx then
            tb._bg:SetTexture(theme.accent.r * 0.8, theme.accent.g * 0.8, theme.accent.b * 0.8, 0.9)
            tb._text:SetText("|cff" .. theme.textHex .. tabs[i] .. "|r")
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
    if f._talentsPanelFrame then
        if idx == 3 then
            f._talentsPanelFrame:Show()
            if CoALevelGuide_MainFrame.RefreshTalents then
                CoALevelGuide_MainFrame.RefreshTalents()
            end
        else
            f._talentsPanelFrame:Hide()
        end
    end
    if f._zonePanelFrame then
        if idx == 4 then f._zonePanelFrame:Show()
        else              f._zonePanelFrame:Hide() end
    end
    if f._gearPanelFrame then
        if idx == 5 then
            f._gearPanelFrame:Show()
            local activeClass = CoALevelGuideDB.activeClass or CoALevelGuide_Utils.GetClass():lower()
            if not CoALevelGuide_ClassBiS[activeClass] then
                activeClass = "felsworn"
            end
            if CoALevelGuide_MainFrame.RefreshGear then
                CoALevelGuide_MainFrame.RefreshGear(activeClass)
            end
        else
            f._gearPanelFrame:Hide()
        end
    end
    if f._pvpPanelFrame then
        if idx == 6 then
            f._pvpPanelFrame:Show()
            if CoALevelGuide_MainFrame.RefreshPvP then
                CoALevelGuide_MainFrame.RefreshPvP()
            end
        else
            f._pvpPanelFrame:Hide()
        end
    end
end

-- ─────────────────────────────────────────────
-- ─────────────────────────────────────────────
-- Dungeon Loot Dashboard Panel (Tab 4)
-- ─────────────────────────────────────────────
local dungeonLoot = {
    rfc = {
        name = "Ragefire Chasm", level = "15-21",
        drops = {
            { boss = "Oggleflint", item = "Oggleflint's Inspiration", type = "Staff", spec = "Necromancer", desc = "High intellect & spell power staff." },
            { boss = "Taragaman", item = "Subterranean Fel-Core", type = "Reagent", spec = "Felsworn", desc = "Required for forging early Felsworn armor." },
            { boss = "Taragaman", item = "Fiery Cord of the Underworld", type = "Belt", spec = "Felsworn", desc = "Increases Fire spell power and critical strike." }
        }
    },
    wc = {
        name = "Wailing Caverns", level = "17-24",
        drops = {
            { boss = "Verdan the Everliving", item = "Living Serpent-Scale Vest", type = "Chest", spec = "Reaper", desc = "High Agility S-tier armor for physical Reaper specs." },
            { boss = "Mutanus the Devourer", item = "Spore-Covered Stave", type = "Staff", spec = "Necromancer", desc = "Great early spell power/spirit leveling staff." },
            { boss = "Kresh", item = "Kresh's Backplate", type = "Shield", spec = "Felsworn", desc = "High armor shield for Felsworn tank specs." }
        }
    },
    sfk = {
        name = "Shadowfang Keep", level = "22-30",
        drops = {
            { boss = "Archmage Arugal", item = "Robes of Arugal", type = "Chest", spec = "Necromancer", desc = "S-tier leveling robes with high Intellect and Spell Power." },
            { boss = "Archmage Arugal", item = "Arugal's Gift", type = "Neck", spec = "Reaper / Necro", desc = "Spell power neck that scales well into level 40." },
            { boss = "Baron Silverlaine", item = "Baron Silverlaine's Seal", type = "Ring", spec = "PvP", desc = "Early PvP ring adding stamina and resilience." }
        }
    },
    bfd = {
        name = "Blackfathom Deeps", level = "24-32",
        drops = {
            { boss = "Aku'mai", item = "Strike of the Hydra", type = "2H Sword", spec = "Reaper", desc = "High physical damage with poison proc. Perfect for Reaper poison builds." },
            { boss = "Aku'mai", item = "Deepfathom Ring", type = "Ring", spec = "Necromancer", desc = "Intellect and shadow spell power." }
        }
    },
    gnomer = {
        name = "Gnomeregan", level = "28-36",
        drops = {
            { boss = "Mekgineer Thermoplugg", item = "Thermoplugg's Left Arm", type = "2H Axe", spec = "Felsworn", desc = "High strength/stamina two-handed axe." },
            { boss = "Crowd Pummel 9-60", item = "Manual Crowd Pummel", type = "2H Mace", spec = "Reaper", desc = "Haste proc, S-tier for physical attack speed." }
        }
    },
    sm = {
        name = "Scarlet Monastery", level = "32-44",
        drops = {
            { boss = "High Inquisitor Whitemane", item = "Whitemane's Chapeau", type = "Head", spec = "Necromancer", desc = "S-tier Intellect/Spirit headpiece." },
            { boss = "Scarlet Commander Mograine", item = "Mograine's Might", type = "2H Mace", spec = "Felsworn", desc = "High crit rating 2H mace." },
            { boss = "Herod", item = "Ravager", type = "2H Axe", spec = "Felsworn / Reaper", desc = "Spins the character in a whirlwind. Essential for leveling." },
            { boss = "Herod", item = "Herod's Shoulder", type = "Shoulder", spec = "Reaper", desc = "Strength and critical strike leather shoulders." }
        }
    },
    rfd = {
        name = "Razorfen Downs", level = "35-46",
        drops = {
            { boss = "Amnennar the Coldbringer", item = "Coldrage Dagger", type = "Dagger", spec = "Reaper", desc = "Frost damage proc, S-tier leveling offhand." },
            { boss = "Amnennar the Coldbringer", item = "Plaguebringer's Tunic", type = "Chest", spec = "Necromancer", desc = "High shadow spell power chestpiece." }
        }
    },
    zf = {
        name = "Zul'Farrak", level = "44-54",
        drops = {
            { boss = "Chief Sandscalp", item = "Sang'thraze the Deflector", type = "1H Sword", spec = "Felsworn / Reaper", desc = "Combine with Jang'thraze to forge Sul'thraze the Lasher." },
            { boss = "Antu'sul", item = "Jang'thraze the Protector", type = "1H Sword", spec = "Felsworn / Reaper", desc = "Combine with Sang'thraze to forge Sul'thraze the Lasher." },
            { boss = "Gahz'rilla", item = "Gahz'rilla Fang", type = "Dagger", spec = "Reaper", desc = "Very fast dagger with high critical rating." }
        }
    },
    mara = {
        name = "Maraudon", level = "46-55",
        drops = {
            { boss = "Princess Theradras", item = "Blackstone Ring", type = "Ring", spec = "Reaper", desc = "S-tier physical hit and attack power ring." },
            { boss = "Princess Theradras", item = "Princess Theradras' Scepter", type = "2H Mace", spec = "Felsworn", desc = "High strength block two-handed mace." }
        }
    },
    st = {
        name = "Sunken Temple", level = "50-60",
        drops = {
            { boss = "Avatar of Hakkar", item = "Spire of Hakkar", type = "Staff", spec = "Necromancer", desc = "Highest spell power leveling staff." },
            { boss = "Eranikus", item = "Dragon's Call", type = "1H Sword", spec = "Reaper", desc = "Proc summons a green dragon helper." }
        }
    },
    brd = {
        name = "Blackrock Depths", level = "52-60",
        drops = {
            { boss = "Emperor Dagran Thaurissan", item = "Ironfoe", type = "1H Mace", spec = "Reaper / Felsworn", desc = "Legendary proc for extra attacks. Elite physical BiS." },
            { boss = "General Angerforge", item = "Hand of Justice", type = "Trinket", spec = "Reaper / Felsworn", desc = "Proc grants an extra attack. S-tier physical trinket." },
            { boss = "Emperor Dagran Thaurissan", item = "Savage Gladiator Chain", type = "Chest", spec = "Reaper", desc = "S-tier physical crit/AP chain chest." }
        }
    },
    scholo = {
        name = "Scholomance", level = "58-60",
        drops = {
            { boss = "Darkmaster Gandling", item = "Darkmaster's Scourge Grimoire", type = "Offhand", spec = "Necromancer", desc = "Increases shadow minion damage and spell power." },
            { boss = "Darkmaster Gandling", item = "Headmaster's Charge", type = "Staff", spec = "Necromancer / Reaper", desc = "Intellect staff with group buff proc." }
        }
    },
    strat = {
        name = "Stratholme", level = "58-60",
        drops = {
            { boss = "Baron Rivendare", item = "Book of the Dead", type = "Offhand", spec = "Necromancer", desc = "Summons a skeletal minion to fight for you." },
            { boss = "Baron Rivendare", item = "Deathcharger's Reins", type = "Mount", spec = "Vanity", desc = "Ultra-rare skeletal warhorse mount." }
        }
    },
    dm = {
        name = "Dire Maul", level = "56-60",
        drops = {
            { boss = "King Gordok", item = "Barbarous Blade", type = "2H Sword", spec = "Felsworn / Reaper", desc = "High critical strike rating two-handed sword." },
            { boss = "Alzzin the Wildshaper", item = "Mindtap Talisman", type = "Trinket", spec = "Necromancer", desc = "Trinket restoring mana/felfury over time." }
        }
    }
}

function CoALevelGuide_MainFrame.BuildZonePanel(parent)
    -- Main outer container panel
    local panel = CreateFrame("Frame", nil, parent)
    panel:SetAllPoints(parent)

    -- Header Title
    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, -8)
    title:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    title:SetText("|cffFFD700Dungeon Loot Dashboard|r")

    -- Scroll area for cards list below dropdown
    local scrollFrame = CreateFrame("ScrollFrame", "CoALevelGuideDungeonScroll", panel, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", panel, "TOPLEFT", 8, -64)
    scrollFrame:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -26, 8)

    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetWidth(parent:GetWidth() - 36)
    scrollChild:SetHeight(1)
    scrollFrame:SetScrollChild(scrollChild)

    -- Dropdown Selector
    local dungeonDropdown = CreateFrame("Frame", "CoALevelGuideDungeonSelectDropdown", panel, "UIDropDownMenuTemplate")
    dungeonDropdown:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, -26)
    UIDropDownMenu_SetWidth(dungeonDropdown, 160)
    UIDropDownMenu_SetButtonWidth(dungeonDropdown, 174)

    local dungeonKeys = { "rfc", "wc", "sfk", "bfd", "gnomer", "sm", "rfd", "zf", "mara", "st", "brd", "scholo", "strat", "dm" }
    local activeDungeonKey = "rfc"

    local function RenderDungeonDrops()
        -- Clear scroll child
        for _, obj in ipairs({ scrollChild:GetChildren() }) do
            obj:Hide()
            obj:SetParent(nil)
        end
        for _, obj in ipairs({ scrollChild:GetRegions() }) do
            obj:Hide()
        end

        local dbEntry = dungeonLoot[activeDungeonKey]
        if not dbEntry then return end

        local yOff = -8

        for idx, drop in ipairs(dbEntry.drops) do
            -- Card frame container
            local card = CreateFrame("Frame", nil, scrollChild)
            card:SetSize(scrollChild:GetWidth() - 8, 54)
            card:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 4, yOff)

            -- Glassmorphic BG
            local cbg = card:CreateTexture(nil, "BACKGROUND")
            cbg:SetAllPoints()
            cbg:SetTexture(0.06, 0.08, 0.16, 0.45)

            -- Left border stripe matching recommended class/spec color
            local border = card:CreateTexture(nil, "OVERLAY")
            border:SetSize(3, 54)
            border:SetPoint("LEFT", card, "LEFT", 0, 0)
            
            local cR, cG, cB = 0.5, 0.5, 0.5
            if drop.spec:find("Necromancer") then
                cR, cG, cB = 0.2, 0.9, 1.0
            elseif drop.spec:find("Felsworn") then
                cR, cG, cB = 0.2, 0.9, 0.2
            elseif drop.spec:find("Reaper") then
                cR, cG, cB = 0.8, 0.1, 1.0
            end
            border:SetTexture(cR, cG, cB, 0.85)

            -- Boss & Item name info
            local mainTxt = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            mainTxt:SetPoint("TOPLEFT", card, "TOPLEFT", 10, -6)
            mainTxt:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            
            local epicColor = "|cffff8000" -- Epic orange for all notable drops
            mainTxt:SetText(string.format("|cffaaaaaaBoss: %s  •  |r%s%s|r |cffcccccc(%s)|r", drop.boss, epicColor, drop.item, drop.type))

            -- Spec suitability
            local specTxt = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            specTxt:SetPoint("TOPRIGHT", card, "TOPRIGHT", -10, -6)
            specTxt:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
            specTxt:SetTextColor(cR, cG, cB, 1)
            specTxt:SetText(drop.spec)

            -- Description text
            local descTxt = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            descTxt:SetPoint("TOPLEFT", mainTxt, "BOTTOMLEFT", 0, -4)
            descTxt:SetWidth(card:GetWidth() - 20)
            descTxt:SetJustifyH("LEFT")
            descTxt:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
            descTxt:SetTextColor(0.8, 0.8, 0.8, 0.9)
            descTxt:SetText(drop.desc)

            yOff = yOff - 60
        end

        scrollChild:SetHeight(math.abs(yOff) + 12)
    end

    local function Dropdown_OnClick(self)
        UIDropDownMenu_SetSelectedValue(dungeonDropdown, self.value)
        activeDungeonKey = self.value
        RenderDungeonDrops()
    end

    UIDropDownMenu_Initialize(dungeonDropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        info.func = Dropdown_OnClick

        for _, k in ipairs(dungeonKeys) do
            local entry = dungeonLoot[k]
            if entry then
                info.text = entry.name .. " (" .. entry.level .. ")"
                info.value = k
                info.checked = (activeDungeonKey == k)
                UIDropDownMenu_AddButton(info)
            end
        end
    end)

    UIDropDownMenu_SetSelectedValue(dungeonDropdown, activeDungeonKey)
    UIDropDownMenu_SetText(dungeonDropdown, dungeonLoot[activeDungeonKey].name)

    RenderDungeonDrops()

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
        CoALevelGuide_MainFrame.UpdateTheme()
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

    -- Header label at top
    local dropHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dropHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 8, -12)
    dropHeader:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    dropHeader:SetText("|cffFFD700Gearing Guide:|r")

    -- Detect player class
    local playerClassToken = CoALevelGuide_Utils.GetClass():lower()
    local selectedClassId = playerClassToken
    if not CoALevelGuide_ClassBiS[selectedClassId] then
        selectedClassId = "felsworn" -- default fallback
    end

    -- Re-render function
    local function RenderContent(classId)
        -- Clear old sub-panels from child
        for _, obj in ipairs({ child:GetChildren() }) do
            obj:Hide()
            obj:SetParent(nil)
        end
        for _, obj in ipairs({ child:GetRegions() }) do
            if obj ~= dropHeader then
                obj:Hide()
            end
        end

        local activeClassName = classId:gsub("_", " "):gsub("^%l", string.upper):gsub(" (%l)", function(c) return " " .. c:upper() end)
        dropHeader:SetText("|cffFFD700Gearing Guide for: |cff00ccff" .. activeClassName .. "|r")

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
        cardBorder:SetTexture(0.0, 0.8, 1.0, 0.25)

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
            sideBorder:SetTexture(0.0, 0.75, 1.0, 0.25)

            yOff = yOff - localFrameHeight - 14
        end

        -- ── SECTION DIVIDER ──
        local divider = child:CreateTexture(nil, "OVERLAY")
        divider:SetSize(child:GetWidth() - 8, 2)
        divider:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        divider:SetTexture(0.55, 0.0, 0.85, 0.20)
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
            sideBorder:SetTexture(0.55, 0.0, 0.85, 0.25)

            yOff = yOff - localFrameHeight - 16
        end

        -- ── SECTION DIVIDER ──
        local divider2 = child:CreateTexture(nil, "OVERLAY")
        divider2:SetSize(child:GetWidth() - 8, 2)
        divider2:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        divider2:SetTexture(0.0, 0.75, 1.0, 0.20)
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
            sideBorder:SetTexture(0.0, 0.75, 1.0, 0.25)

            yOff = yOff - localFrameHeight - 14
        end

        -- ── SECTION DIVIDER ──
        local divider3 = child:CreateTexture(nil, "OVERLAY")
        divider3:SetSize(child:GetWidth() - 8, 2)
        divider3:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        divider3:SetTexture(0.55, 0.0, 0.85, 0.20)
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
            sideBorder:SetTexture(0.55, 0.0, 0.85, 0.25)

            yOff = yOff - localFrameHeight - 14
        end

        child:SetHeight(math.abs(yOff) + 20)
    end

    CoALevelGuide_MainFrame.RefreshGear = RenderContent

    -- Initial render
    RenderContent(selectedClassId)

    panel:Hide()
    return panel
end

-- ─────────────────────────────────────────────
-- PvP Guides Panel (Tab 5)
-- ─────────────────────────────────────────────
function CoALevelGuide_MainFrame.BuildPvPPanel(parent)
    local panel = CreateFrame("ScrollFrame", "CoALevelGuidePvPScroll", parent, "UIPanelScrollFrameTemplate")
    panel:SetAllPoints(parent)

    local child = CreateFrame("Frame", nil, panel)
    child:SetWidth(parent:GetWidth() - 24)
    child:SetHeight(1) -- grows dynamically
    panel:SetScrollChild(child)

    local function RenderPvPContent()
        -- Clear old sub-panels from child
        for _, obj in ipairs({ child:GetChildren() }) do
            obj:Hide()
            obj:SetParent(nil)
        end
        for _, obj in ipairs({ child:GetRegions() }) do
            obj:Hide()
        end

        local yOff = -8

        -- Header
        local header = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        header:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        header:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
        header:SetText("|cffc544ffConquest of Azeroth PvP Guide|r")
        yOff = yOff - 24

        -- Subheader
        local sub = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        sub:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        sub:SetWidth(child:GetWidth() - 8)
        sub:SetJustifyH("LEFT")
        sub:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        sub:SetText("|cffaaaaaaLearn Battleground tactics, copy essential macros, and read optimal combat stats.|r")
        yOff = yOff - 28

        -- Section 1: Battleground Strategies
        local bgHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        bgHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        bgHeader:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
        bgHeader:SetText("|cffFFD700⚔ Battleground Strategy Cards|r")
        yOff = yOff - 18

        for _, bg in ipairs(CoALevelGuide_PvPGuides.battlegrounds) do
            local card = CreateFrame("Frame", nil, child)
            card:SetWidth(child:GetWidth() - 8)
            card:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)

            local title = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            title:SetPoint("TOPLEFT", card, "TOPLEFT", 8, -6)
            title:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
            title:SetText("|cff00ccff" .. bg.name .. "|r")

            local strat = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            strat:SetPoint("TOPLEFT", card, "TOPLEFT", 8, -20)
            strat:SetWidth(card:GetWidth() - 16)
            strat:SetJustifyH("LEFT")
            strat:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            strat:SetText("|cffffffffStrategy:|r " .. bg.strategy)

            local localY = -24 - strat:GetStringHeight()

            for _, tip in ipairs(bg.tips) do
                local tipText = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                tipText:SetPoint("TOPLEFT", card, "TOPLEFT", 16, localY)
                tipText:SetWidth(card:GetWidth() - 24)
                tipText:SetJustifyH("LEFT")
                tipText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
                tipText:SetText("|cff00ff88•|r |cffdddddd" .. tip .. "|r")
                localY = localY - (tipText:GetStringHeight() + 2)
            end

            local cardH = math.abs(localY) + 8
            card:SetHeight(cardH)

            -- Glassmorphic BG
            local bgTex = card:CreateTexture(nil, "BACKGROUND")
            bgTex:SetAllPoints()
            bgTex:SetTexture(0.04, 0.08, 0.18, 0.8)

            local cardBorder = card:CreateTexture(nil, "OVERLAY")
            cardBorder:SetSize(2, cardH)
            cardBorder:SetPoint("TOPLEFT", card, "TOPLEFT", 0, 0)
            cardBorder:SetTexture(0.77, 0.27, 1.0, 0.25) -- Softened violet border

            yOff = yOff - cardH - 12
        end

        -- Section 2: Copyable PvP Macros
        local macroHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        macroHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        macroHeader:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
        macroHeader:SetText("|cffFFD700📋 Essential PvP Macros (Click text area to Copy)|r")
        yOff = yOff - 18

        -- Compile macros list
        local list = {}
        for _, m in ipairs(CoALevelGuide_PvPGuides.macros) do
            table.insert(list, m)
        end
        local activeClass = CoALevelGuideDB.activeClass or CoALevelGuide_Utils.GetClass():lower()
        if CoALevelGuide_PvPGuides.classMacros[activeClass] then
            for _, m in ipairs(CoALevelGuide_PvPGuides.classMacros[activeClass]) do
                table.insert(list, m)
            end
        end

        for _, mac in ipairs(list) do
            local mFrame = CreateFrame("Frame", nil, child)
            mFrame:SetWidth(child:GetWidth() - 8)
            mFrame:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)

            local mTitle = mFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            mTitle:SetPoint("TOPLEFT", mFrame, "TOPLEFT", 8, -6)
            mTitle:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            mTitle:SetText("|cff00ff88" .. mac.name .. "|r  •  |cffaaaaaa" .. mac.desc .. "|r")

            -- EditBox for Copying (Ctrl+C)
            local eb = CreateFrame("EditBox", nil, mFrame)
            eb:SetSize(mFrame:GetWidth() - 140, 40)
            eb:SetPoint("TOPLEFT", mFrame, "TOPLEFT", 8, -20)
            eb:SetFontObject("GameFontHighlightSmall")
            eb:SetMultiLine(true)
            eb:SetMaxLetters(250)
            eb:SetAutoFocus(false)
            eb:EnableMouse(true)
            eb:SetText(mac.body)

            -- Prevent editing while allowing selection/copying (avoiding recursive overflow)
            local isResetting = false
            eb:SetScript("OnTextChanged", function(self)
                if isResetting then return end
                isResetting = true
                self:SetText(mac.body)
                isResetting = false
            end)

            eb:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
            eb:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)

            -- Auto-Create & Place Macro Button
            local btn = CreateFrame("Button", nil, mFrame, "UIPanelButtonTemplate")
            btn:SetSize(120, 24)
            btn:SetPoint("TOPRIGHT", mFrame, "TOPRIGHT", -8, -24)
            btn:SetText("⚡ Setup Macro")
            btn:SetScript("OnClick", function()
                if InCombatLockdown() then
                    print("|cffff2222[CoALvl] Error: Cannot create macro in combat!|r")
                    return
                end
                
                local macroName = mac.name:gsub("%s", ""):sub(1, 12)
                local macroBody = mac.body
                local macroIndex = GetMacroIndexByName(macroName)
                
                if not macroIndex or macroIndex == 0 then
                    local _, numChar = GetNumMacros()
                    if numChar < 18 then
                        macroIndex = CreateMacro(macroName, "INV_Misc_QuestionMark", macroBody, 1)
                    else
                        local numGlobal = GetNumMacros()
                        if numGlobal < 36 then
                            macroIndex = CreateMacro(macroName, "INV_Misc_QuestionMark", macroBody, nil)
                        else
                            print("|cffff2222[CoALvl] Error: Macro list is full! Please delete some macros.|r")
                            return
                        end
                    end
                else
                    EditMacro(macroIndex, nil, nil, macroBody)
                end
                
                if macroIndex and macroIndex > 0 then
                    local placed = false
                    for slot = 1, 120 do
                        if not HasAction(slot) then
                            PickupMacro(macroIndex)
                            PlaceAction(slot)
                            ClearCursor()
                            placed = true
                            print(string.format("|cff00ccff[CoALvl] Macro '%s' created and placed in action slot %d!|r", macroName, slot))
                            break
                        end
                    end
                    if not placed then
                        PickupMacro(macroIndex)
                        print(string.format("|cff00ccff[CoALvl] Macro '%s' created! Action bars are full, picked up on cursor.|r", macroName))
                    end
                end
            end)
            
            -- EditBox Background
            local ebBG = eb:CreateTexture(nil, "BACKGROUND")
            ebBG:SetAllPoints()
            ebBG:SetTexture(0.02, 0.02, 0.05, 0.9)

            local frameH = 26 + 40
            mFrame:SetHeight(frameH)

            local mBG = mFrame:CreateTexture(nil, "BACKGROUND")
            mBG:SetAllPoints()
            mBG:SetTexture(0.04, 0.06, 0.12, 0.7)

            local sideBorder = mFrame:CreateTexture(nil, "OVERLAY")
            sideBorder:SetSize(2, frameH)
            sideBorder:SetPoint("TOPLEFT", mFrame, "TOPLEFT", 0, 0)
            sideBorder:SetTexture(0.55, 0.0, 0.85, 0.25)

            yOff = yOff - frameH - 12
        end

        -- Section 3: General PvP Tips
        local tipsHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        tipsHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        tipsHeader:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
        tipsHeader:SetText("|cffFFD700💡 Advanced PvP Strategies & Tips|r")
        yOff = yOff - 18

        local tipsCard = CreateFrame("Frame", nil, child)
        tipsCard:SetWidth(child:GetWidth() - 8)
        tipsCard:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)

        local localY = -8
        for _, tip in ipairs(CoALevelGuide_PvPGuides.tips) do
            local tipText = tipsCard:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            tipText:SetPoint("TOPLEFT", tipsCard, "TOPLEFT", 12, localY)
            tipText:SetWidth(tipsCard:GetWidth() - 20)
            tipText:SetJustifyH("LEFT")
            tipText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            tipText:SetText("|cffc544ff•|r |cffdddddd" .. tip .. "|r")
            localY = localY - (tipText:GetStringHeight() + 6)
        end

        local tipsCardH = math.abs(localY) + 4
        tipsCard:SetHeight(tipsCardH)

        local tBG = tipsCard:CreateTexture(nil, "BACKGROUND")
        tBG:SetAllPoints()
        tBG:SetTexture(0.04, 0.08, 0.18, 0.6)

        local tBorder = tipsCard:CreateTexture(nil, "OVERLAY")
        tBorder:SetSize(2, tipsCardH)
        tBorder:SetPoint("TOPLEFT", tipsCard, "TOPLEFT", 0, 0)
        tBorder:SetTexture(0.77, 0.27, 1.0, 0.25)

        yOff = yOff - tipsCardH - 20

        child:SetHeight(math.abs(yOff) + 20)
    end

    CoALevelGuide_MainFrame.RefreshPvP = RenderPvPContent
    RenderPvPContent()

    panel:Hide()
    return panel
end

-- ─────────────────────────────────────────────
-- Talent Panel (Tab 3)
-- ─────────────────────────────────────────────
local function ImportCustomTalentString(customStr)
    if not customStr or customStr == "" then return end
    if InCombatLockdown() then
        print("|cffff2222[CoALvl] Error: Cannot learn talents in combat!|r")
        return
    end

    local unspent = GetUnspentTalentPoints()
    if not unspent or unspent <= 0 then
        print("|cff00ccff[CoALvl] You have no unspent talent points!|r")
        return
    end

    local spentAny = false
    for tab, idx, rank in customStr:gmatch("(%d+)%-(%d+):?(%d*)") do
        if unspent <= 0 then break end
        tab = tonumber(tab)
        idx = tonumber(idx)
        rank = tonumber(rank) or 1
        
        for r = 1, rank do
            if unspent <= 0 then break end
            local name, _, _, _, currentRank, maxRank = GetTalentInfo(tab, idx)
            if name and currentRank < maxRank then
                LearnTalent(tab, idx)
                unspent = unspent - 1
                spentAny = true
            end
        end
    end

    if spentAny then
        print("|cff00ccff[CoALvl] Custom talents successfully allocated!|r")
        if CoALevelGuide_MainFrame.RefreshTalents then
            CoALevelGuide_MainFrame.RefreshTalents()
        end
    else
        print("|cffaaaaaa[CoALvl] No talents were learned. Ensure you have unspent points and the talents aren't already maxed.|r")
    end
end

function CoALevelGuide_MainFrame.BuildTalentsPanel(parent)
    local panel = CreateFrame("ScrollFrame", "CoALevelGuideTalentsScroll", parent, "UIPanelScrollFrameTemplate")
    panel:SetAllPoints(parent)

    local child = CreateFrame("Frame", nil, panel)
    child:SetWidth(parent:GetWidth() - 24)
    child:SetHeight(1)
    panel:SetScrollChild(child)

    local function RenderTalentsContent()
        -- Clear existing child elements
        local children = { child:GetChildren() }
        for _, obj in ipairs(children) do
            obj:Hide()
            obj:SetParent(nil)
        end
        local regions = { child:GetRegions() }
        for _, obj in ipairs(regions) do
            obj:Hide()
        end

        local activeClass = CoALevelGuideDB.activeClass or CoALevelGuide_Utils.GetClass():lower()
        local activeTheme = GetActiveTheme()

        local yOff = -8
        local W = child:GetWidth()

        -- Header
        local header = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        header:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        header:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
        header:SetText("|cff00ccff⚡ Auto-Talent Learner & Import|r")
        yOff = yOff - 22

        local sub = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        sub:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        sub:SetWidth(W - 8)
        sub:SetJustifyH("LEFT")
        sub:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        sub:SetText("|cffaaaaaaSelect a spec build below to auto-spend your talent points, or import a custom build code directly.|r")
        yOff = yOff - 26

        -- Active class stats / points
        local points = GetUnspentTalentPoints() or 0
        local pointsText = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        pointsText:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        pointsText:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
        pointsText:SetText(string.format("Your Class: %s%s|r   •   Available Points: |cff00ff00%d|r", activeTheme.logo:sub(1,10), activeClass:gsub("^%a", string.upper), points))
        yOff = yOff - 20

        -- Divider
        local sep = child:CreateTexture(nil, "OVERLAY")
        sep:SetSize(W, 1)
        sep:SetPoint("TOPLEFT", child, "TOPLEFT", 0, yOff)
        sep:SetTexture(activeTheme.border.r, activeTheme.border.g, activeTheme.border.b, 0.3)
        yOff = yOff - 12

        -- Get recommended specs for active class
        local classTalents = CoALevelGuide_TalentPaths[activeClass]
        if classTalents then
            -- Section: Recommended Spec Builds
            local recHdr = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            recHdr:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
            recHdr:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
            recHdr:SetText("|cffFFD700Recommended Spec Builds:|r")
            yOff = yOff - 18

            for specName, specData in pairs(classTalents) do
                local specFrame = CreateFrame("Frame", nil, child)
                specFrame:SetWidth(W - 8)
                specFrame:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)

                local sTitle = specFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                sTitle:SetPoint("TOPLEFT", specFrame, "TOPLEFT", 8, -6)
                sTitle:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
                sTitle:SetText("|cff00ffaa" .. specName:gsub("^%a", string.upper) .. "|r")

                local sDesc = specFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                sDesc:SetPoint("TOPLEFT", specFrame, "TOPLEFT", 8, -20)
                sDesc:SetWidth(specFrame:GetWidth() - 140)
                sDesc:SetJustifyH("LEFT")
                sDesc:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
                sDesc:SetText("|cffcccccc" .. specData.desc .. "|r")

                -- Auto-learn button
                local learnBtn = CreateFrame("Button", nil, specFrame, "UIPanelButtonTemplate")
                learnBtn:SetSize(120, 24)
                learnBtn:SetPoint("TOPRIGHT", specFrame, "TOPRIGHT", -8, -12)
                learnBtn:SetText("⚡ Learn Spec")
                learnBtn:SetScript("OnClick", function()
                    if InCombatLockdown() then
                        print("|cffff2222[CoALvl] Error: Cannot allocate talents in combat!|r")
                        return
                    end
                    local unspent = GetUnspentTalentPoints()
                    if not unspent or unspent <= 0 then
                        print("|cff00ccff[CoALvl] No unspent talent points!|r")
                        return
                    end
                    local spentAny = false
                    for _, node in ipairs(specData.path) do
                        if unspent <= 0 then break end
                        local tab, index = node[1], node[2]
                        local name, _, _, _, currentRank, maxRank = GetTalentInfo(tab, index)
                        if name and currentRank < maxRank then
                            LearnTalent(tab, index)
                            unspent = unspent - 1
                            spentAny = true
                        end
                    end
                    if spentAny then
                        print("|cff00ccff[CoALvl] Talents allocated successfully!|r")
                        RenderTalentsContent()
                    else
                        print("|cffaaaaaa[CoALvl] Talents already match this spec path!|r")
                    end
                end)

                -- EditBox to view/copy import code
                local codeBox = CreateFrame("EditBox", nil, specFrame)
                codeBox:SetSize(specFrame:GetWidth() - 16, 20)
                codeBox:SetPoint("TOPLEFT", specFrame, "TOPLEFT", 8, -38)
                codeBox:SetFontObject("GameFontHighlightSmall")
                codeBox:SetAutoFocus(false)
                codeBox:EnableMouse(true)
                codeBox:SetText(specData.code)
                codeBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
                codeBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)

                -- Codebox background
                local cbBG = codeBox:CreateTexture(nil, "BACKGROUND")
                cbBG:SetAllPoints()
                cbBG:SetTexture(0, 0, 0, 0.3)

                local sFrameH = 64
                specFrame:SetHeight(sFrameH)

                local sfBG = specFrame:CreateTexture(nil, "BACKGROUND")
                sfBG:SetAllPoints()
                sfBG:SetTexture(0.04, 0.08, 0.18, 0.5)

                local sfBorder = specFrame:CreateTexture(nil, "OVERLAY")
                sfBorder:SetSize(2, sFrameH)
                sfBorder:SetPoint("TOPLEFT", specFrame, "TOPLEFT", 0, 0)
                sfBorder:SetTexture(activeTheme.border.r, activeTheme.border.g, activeTheme.border.b, 0.8)

                yOff = yOff - sFrameH - 12
            end
        else
            -- Notice for other classes
            local notice = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            notice:SetPoint("TOPLEFT", child, "TOPLEFT", 6, yOff)
            notice:SetWidth(W - 12)
            notice:SetJustifyH("LEFT")
            notice:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            notice:SetText("|cffaaaaaaCustom spec builds are defined for Necromancer, Felsworn, Reaper, and Runemaster. For other classes, you can use the Custom Import tool below.|r")
            yOff = yOff - 36
        end

        -- Section: Custom Talent String Import
        local impHdr = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        impHdr:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        impHdr:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
        impHdr:SetText("|cffFFD700📋 Import Custom Talent String:|r")
        yOff = yOff - 18

        local impDesc = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        impDesc:SetPoint("TOPLEFT", child, "TOPLEFT", 6, yOff)
        impDesc:SetWidth(W - 12)
        impDesc:SetJustifyH("LEFT")
        impDesc:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        impDesc:SetText("|cffaaaaaaPaste a talent path string (format: 'tab-index:points, tab-index:points') and click Import to spend points.|r")
        yOff = yOff - 26

        -- Paste EditBox
        local pasteBox = CreateFrame("EditBox", "CoALvlCustomTalentPaste", child)
        pasteBox:SetSize(W - 134, 30)
        pasteBox:SetPoint("TOPLEFT", child, "TOPLEFT", 4, yOff)
        pasteBox:SetFontObject("GameFontHighlightSmall")
        pasteBox:SetAutoFocus(false)
        pasteBox:EnableMouse(true)
        pasteBox:SetText("")
        pasteBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

        local pbBG = pasteBox:CreateTexture(nil, "BACKGROUND")
        pbBG:SetAllPoints()
        pbBG:SetTexture(0.02, 0.02, 0.05, 0.9)

        -- Import Button
        local impBtn = CreateFrame("Button", nil, child, "UIPanelButtonTemplate")
        impBtn:SetSize(120, 30)
        impBtn:SetPoint("TOPRIGHT", child, "TOPRIGHT", -4, yOff)
        impBtn:SetText("⚡ Import Build")
        impBtn:SetScript("OnClick", function()
            local customStr = pasteBox:GetText()
            if not customStr or customStr == "" then
                print("|cffff2222[CoALvl] Please paste a talent string first!|r")
                return
            end
            ImportCustomTalentString(customStr)
        end)

        yOff = yOff - 42

        child:SetHeight(math.abs(yOff) + 20)
    end

    CoALevelGuide_MainFrame.RefreshTalents = RenderTalentsContent
    RenderTalentsContent()

    panel:Hide()
    return panel
end
