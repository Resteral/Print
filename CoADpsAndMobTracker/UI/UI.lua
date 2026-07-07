-- ============================================================
-- CoADpsAndMobTracker - UI Frame
-- Main Dashboard with tabs: DPS Meter, Mob Tracker
-- Supports: segments (overall + last 10 boss fights), HPS,
--           group share, fight timer, and clean layouts.
-- ============================================================

CoADpsAndMobTracker_UI = {}

local _frame = nil
local _detailFrame = nil
local activeTab = 1 -- 1 = DPS, 2 = Mobs
local activeStat = "dps" -- "dps", "damage", "tanked", "healing"
local activeSegment = "overall" -- "overall" or index (1-10) in CoADpsAndMobTracker_Encounters
local selectedPlayerGUID = nil

-- Standard WoW Class Colors
local ClassColors = {
    DEATHKNIGHT = { r=0.77, g=0.12, b=0.23 },
    DRUID       = { r=1.00, g=0.49, b=0.04 },
    HUNTER      = { r=0.67, g=0.83, b=0.45 },
    MAGE        = { r=0.41, g=0.80, b=0.94 },
    PALADIN     = { r=0.96, g=0.55, b=0.73 },
    PRIEST      = { r=1.00, g=1.00, b=1.00 },
    ROGUE       = { r=1.00, g=0.96, b=0.41 },
    SHAMAN      = { r=0.00, g=0.44, b=0.87 },
    WARLOCK     = { r=0.58, g=0.51, b=0.79 },
    WARRIOR     = { r=0.78, g=0.61, b=0.43 },
}

local function GetClassHexColor(classToken)
    local c = ClassColors[classToken] or { r=0.5, g=0.5, b=0.5 }
    return string.format("ff%02x%02x%02x", c.r*255, c.g*255, c.b*255)
end

-- Threat Level Colors (0=Safe, 1=Volatile, 2=Pulling, 3=Aggro)
local ThreatColors = {
    [0] = { r=0.0, g=0.7, b=0.0, hex="|cff00ee00" }, -- Safe Green
    [1] = { r=0.8, g=0.6, b=0.0, hex="|cffeedd00" }, -- Volatile Yellow
    [2] = { r=0.9, g=0.4, b=0.0, hex="|cffff8800" }, -- Warning Orange
    [3] = { r=0.9, g=0.1, b=0.1, hex="|cffff2222" }, -- Aggro Red
}

-- ─────────────────────────────────────────────
-- Create UI Elements
-- ─────────────────────────────────────────────
local function CreateMainFrame()
    local f = CreateFrame("Frame", "CoADpsAndMobTrackerFrame", UIParent)
    f:SetSize(280, 270)
    f:SetPoint("CENTER", UIParent, "CENTER", 150, 0)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, _, x, y = self:GetPoint()
        if CoADpsAndMobTrackerDB then
            CoADpsAndMobTrackerDB.pos = { point = point, x = x, y = y }
        end
    end)

    -- Restore Position
    if CoADpsAndMobTrackerDB and CoADpsAndMobTrackerDB.pos then
        local p = CoADpsAndMobTrackerDB.pos
        f:SetPoint(p.point or "CENTER", UIParent, p.point or "CENTER", p.x or 150, p.y or 0)
    end

    -- Glassmorphic BG
    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0.04, 0.05, 0.10, 0.93)

    -- Border lines
    local function makeLine(parent, w, h, p, rp, ox, oy)
        local l = parent:CreateTexture(nil, "OVERLAY")
        l:SetSize(w, h)
        l:SetTexture(0.0, 0.6, 0.9, 0.20) -- Softened blue border
        l:SetPoint(p, parent, rp, ox, oy)
        return l
    end
    makeLine(f, 280, 1, "TOPLEFT", "TOPLEFT", 0, 0)
    makeLine(f, 280, 1, "BOTTOMLEFT", "BOTTOMLEFT", 0, 0)
    makeLine(f, 1, 270, "TOPLEFT", "TOPLEFT", 0, 0)
    makeLine(f, 1, 270, "TOPRIGHT", "TOPRIGHT", 0, 0)

    -- ── Tab Header Buttons ──
    local dpsTab = CreateFrame("Button", nil, f)
    dpsTab:SetSize(60, 22)
    dpsTab:SetPoint("TOPLEFT", f, "TOPLEFT", 6, -6)
    local dt = dpsTab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    dt:SetAllPoints()
    dt:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    dt:SetText("⚔ DPS")
    dpsTab._text = dt
    dpsTab:SetScript("OnClick", function()
        activeTab = 1
        PlaySound(856)
        CoADpsAndMobTracker_UI.Refresh()
    end)
    f._dpsTab = dpsTab

    local mobTab = CreateFrame("Button", nil, f)
    mobTab:SetSize(60, 22)
    mobTab:SetPoint("LEFT", dpsTab, "RIGHT", 4, 0)
    local mt = mobTab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    mt:SetAllPoints()
    mt:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    mt:SetText("👾 Mobs")
    mobTab._text = mt
    mobTab:SetScript("OnClick", function()
        activeTab = 2
        PlaySound(856)
        CoADpsAndMobTracker_UI.Refresh()
    end)
    f._mobTab = mobTab

    -- Fight Timer Text
    local timerText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    timerText:SetPoint("TOPRIGHT", f, "TOPRIGHT", -76, -10)
    timerText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    timerText:SetText("")
    f._timerText = timerText

    -- Reset button ↺
    local resetBtn = CreateFrame("Button", nil, f)
    resetBtn:SetSize(18, 18)
    resetBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -48, -8)
    local rt = resetBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    rt:SetAllPoints()
    rt:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    rt:SetText("↺")
    resetBtn:SetScript("OnClick", function()
        PlaySound(856)
        CoADpsAndMobTracker_Engine.ResetSession()
        activeSegment = "overall"
        CoADpsAndMobTracker_UI.Refresh()
    end)

    -- Report button 📢
    local reportBtn = CreateFrame("Button", nil, f)
    reportBtn:SetSize(18, 18)
    reportBtn:SetPoint("RIGHT", resetBtn, "LEFT", -8, 0)
    local rept = reportBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    rept:SetAllPoints()
    rept:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    rept:SetText("📢")
    reportBtn:SetScript("OnClick", function()
        CoADpsAndMobTracker_UI.ReportDPS()
    end)

    -- Close button x
    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", 2, 2)
    closeBtn:SetScript("OnClick", function()
        PlaySound(830)
        f:Hide()
    end)

    -- ── Scroll Container for Content Rows ──
    local scroll = CreateFrame("ScrollFrame", "CoADpsAndMobTrackerScroll", f, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", f, "TOPLEFT", 6, -58)
    scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -26, 6)
    f._scroll = scroll

    -- Scroll Child
    local child = CreateFrame("Frame", nil, scroll)
    child:SetSize(248, 1) -- auto height
    scroll:SetScrollChild(child)
    f._scrollChild = child

    -- Stat Selector Dropdown
    local statDropdown = CreateFrame("Frame", "CoADpsAndMobTrackerStatDropdown", f, "UIDropDownMenuTemplate")
    statDropdown:SetPoint("TOPLEFT", f, "TOPLEFT", -12, -28)
    UIDropDownMenu_SetWidth(statDropdown, 105)

    local function StatDropdown_OnClick(self)
        UIDropDownMenu_SetSelectedValue(statDropdown, self.value)
        activeStat = self.value
        UIDropDownMenu_SetText(statDropdown, self.text)
        CoADpsAndMobTracker_UI.Refresh()
    end

    UIDropDownMenu_Initialize(statDropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        
        info.text = "⚔ DPS"
        info.value = "dps"
        info.func = StatDropdown_OnClick
        info.checked = (activeStat == "dps")
        UIDropDownMenu_AddButton(info, level)

        info.text = "💥 Damage"
        info.value = "damage"
        info.func = StatDropdown_OnClick
        info.checked = (activeStat == "damage")
        UIDropDownMenu_AddButton(info, level)

        info.text = "🛡 Tanked"
        info.value = "tanked"
        info.func = StatDropdown_OnClick
        info.checked = (activeStat == "tanked")
        UIDropDownMenu_AddButton(info, level)

        info.text = "💚 Healing"
        info.value = "healing"
        info.func = StatDropdown_OnClick
        info.checked = (activeStat == "healing")
        UIDropDownMenu_AddButton(info, level)
    end)

    UIDropDownMenu_SetSelectedValue(statDropdown, "dps")
    UIDropDownMenu_SetText(statDropdown, "⚔ DPS")
    f._statDropdown = statDropdown

    -- Segment Selector Dropdown
    local segmentDropdown = CreateFrame("Frame", "CoADpsAndMobTrackerSegmentDropdown", f, "UIDropDownMenuTemplate")
    segmentDropdown:SetPoint("LEFT", statDropdown, "RIGHT", -22, 0)
    UIDropDownMenu_SetWidth(segmentDropdown, 105)

    local function SegmentDropdown_OnClick(self)
        UIDropDownMenu_SetSelectedValue(segmentDropdown, self.value)
        activeSegment = self.value
        UIDropDownMenu_SetText(segmentDropdown, self.text)
        CoADpsAndMobTracker_UI.Refresh()
    end

    UIDropDownMenu_Initialize(segmentDropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()

        info.text = "Overall Session"
        info.value = "overall"
        info.func = SegmentDropdown_OnClick
        info.checked = (activeSegment == "overall")
        UIDropDownMenu_AddButton(info, level)

        for i, enc in ipairs(CoADpsAndMobTracker_Encounters) do
            info.text = string.format("%d. %s", i, enc.bossName or "Boss")
            info.value = i
            info.func = SegmentDropdown_OnClick
            info.checked = (activeSegment == i)
            UIDropDownMenu_AddButton(info, level)
        end
    end)

    UIDropDownMenu_SetSelectedValue(segmentDropdown, "overall")
    UIDropDownMenu_SetText(segmentDropdown, "Overall Session")
    f._segmentDropdown = segmentDropdown

    _frame = f
end

-- ─────────────────────────────────────────────
-- Create Spell Breakdown Popout Frame
-- ─────────────────────────────────────────────
local function CreateDetailFrame()
    local d = CreateFrame("Frame", "CoADpsAndMobTrackerDetailFrame", UIParent)
    d:SetSize(230, 240)
    d:SetFrameStrata("HIGH")
    d:SetToplevel(true)
    d:Hide()

    -- BG
    local bg = d:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0.04, 0.05, 0.12, 0.95)

    -- Borders
    local function makeLine(parent, w, h, p, rp, ox, oy)
        local l = parent:CreateTexture(nil, "OVERLAY")
        l:SetSize(w, h)
        l:SetTexture(0.55, 0.0, 0.85, 0.20) -- Softened purple detail border
        l:SetPoint(p, parent, rp, ox, oy)
        return l
    end
    makeLine(d, 230, 1, "TOPLEFT", "TOPLEFT", 0, 0)
    makeLine(d, 230, 1, "BOTTOMLEFT", "BOTTOMLEFT", 0, 0)
    makeLine(d, 1, 240, "TOPLEFT", "TOPLEFT", 0, 0)
    makeLine(d, 1, 240, "TOPRIGHT", "TOPRIGHT", 0, 0)

    -- Title
    local title = d:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    title:SetPoint("TOPLEFT", d, "TOPLEFT", 8, -8)
    title:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    title:SetText("|cffFFD700Detailed Spell Breakdown|r")
    d._title = title

    -- Close detail button
    local closeBtn = CreateFrame("Button", nil, d, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", d, "TOPRIGHT", 2, 2)
    closeBtn:SetScript("OnClick", function() d:Hide() end)

    -- Scroll container
    local scroll = CreateFrame("ScrollFrame", "CoADpsAndMobTrackerDetailScroll", d, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", d, "TOPLEFT", 6, -26)
    scroll:SetPoint("BOTTOMRIGHT", d, "BOTTOMRIGHT", -26, 6)

    local child = CreateFrame("Frame", nil, scroll)
    child:SetSize(198, 1)
    scroll:SetScrollChild(child)
    d._scrollChild = child

    _detailFrame = d
end

-- ─────────────────────────────────────────────
-- Report Top DPS to chat
-- ─────────────────────────────────────────────
function CoADpsAndMobTracker_UI.ReportDPS()
    local playersSource = {}
    local duration = 1

    if activeSegment == "overall" then
        playersSource = CoADpsAndMobTracker_Session.players
        duration = CoADpsAndMobTracker_Engine.GetSessionDuration()
    else
        local enc = CoADpsAndMobTracker_Encounters[activeSegment]
        if enc then
            playersSource = enc.players
            duration = enc.duration or 1
        end
    end
    if duration <= 0.5 then duration = 0.5 end

    local list = {}
    for guid, data in pairs(playersSource) do
        local value = 0
        if activeStat == "dps" then
            value = activeSegment == "overall" and CoADpsAndMobTracker_Engine.GetPlayerDPS(guid) or math.floor((data.damage or 0) / duration)
        elseif activeStat == "damage" then
            value = data.damage or 0
        elseif activeStat == "tanked" then
            value = data.tanked or 0
        elseif activeStat == "healing" then
            value = data.healing or 0
        end

        if value > 0 then
            table.insert(list, {
                name = data.name,
                val = value,
                damage = data.damage or 0
            })
        end
    end
    table.sort(list, function(a,b) return a.val > b.val end)

    if #list == 0 then return end

    -- Determine chat channel
    local channel = "SAY"
    if UnitInRaid("player") then
        channel = "RAID"
    elseif UnitInParty("player") then
        channel = "PARTY"
    elseif IsInGuild() then
        channel = "GUILD"
    end

    local segmentLabel = activeSegment == "overall" and "Overall" or ("Boss Segment " .. activeSegment)
    local titleStr = string.format("=== CoA Tracker (%s - %s) ===", activeStat:upper(), segmentLabel)
    SendChatMessage(titleStr, channel)
    for i = 1, math.min(3, #list) do
        local r = list[i]
        local vStr = CoADpsAndMobTracker_Engine.FormatNumber(r.val)
        if activeStat == "dps" then
            local dStr = CoADpsAndMobTracker_Engine.FormatNumber(r.damage)
            SendChatMessage(string.format("%d. %s — %s (%d DPS)", i, r.name, dStr, r.val), channel)
        else
            local label = (activeStat == "damage" and "damage") or (activeStat == "tanked" and "tanked") or "healed"
            SendChatMessage(string.format("%d. %s — %s %s", i, r.name, vStr, label), channel)
        end
    end
end

-- ─────────────────────────────────────────────
-- Render Detail Popout Frame
-- ─────────────────────────────────────────────
local function RenderDetail(guid)
    if not _detailFrame then CreateDetailFrame() end
    local d = _detailFrame

    if activeSegment ~= "overall" then
        d._title:SetText("|cffFFD700Boss Segment Breakdown|r")
        d:SetPoint("TOPLEFT", _frame, "TOPRIGHT", 6, 0)
        d:Show()

        local child = d._scrollChild
        for _, childFrame in ipairs({ child:GetChildren() }) do
            childFrame:Hide()
            childFrame:SetParent(nil)
        end

        local notice = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        notice:SetPoint("TOPLEFT", child, "TOPLEFT", 6, -20)
        notice:SetSize(180, 0)
        notice:SetJustifyH("LEFT")
        notice:SetText("|cffaaaaaaSpell details are only saved for the live Overall Session to conserve memory.|r")
        child:SetHeight(80)
        return
    end

    local pLog = CoADpsAndMobTracker_Session.players[guid]
    if not pLog then
        d:Hide()
        return
    end

    d._title:SetText("|cffFFD700" .. pLog.name .. "'s Spells|r")
    d:SetPoint("TOPLEFT", _frame, "TOPRIGHT", 6, 0)
    d:Show()

    -- Clear previous rows
    local child = d._scrollChild
    for _, childFrame in ipairs({ child:GetChildren() }) do
        childFrame:Hide()
        childFrame:SetParent(nil)
    end

    local sortedSpells = {}
    for sName, data in pairs(pLog.spells or {}) do
        table.insert(sortedSpells, { name = sName, damage = data.damage, data = data })
    end
    table.sort(sortedSpells, function(a,b) return a.damage > b.damage end)

    local yOff = 0
    for i, item in ipairs(sortedSpells) do
        local rFrame = CreateFrame("Frame", nil, child)
        rFrame:SetSize(198, 38)
        rFrame:SetPoint("TOPLEFT", child, "TOPLEFT", 0, yOff)

        -- Progress bar BG
        local barBG = rFrame:CreateTexture(nil, "BACKGROUND")
        barBG:SetAllPoints()
        barBG:SetTexture(0.08, 0.08, 0.16, 0.5)

        -- Progress bar Fill (deep purple)
        local fill = rFrame:CreateTexture(nil, "ARTWORK")
        fill:SetPoint("LEFT", rFrame, "LEFT")
        fill:SetPoint("TOP", rFrame, "TOP")
        fill:SetPoint("BOTTOM", rFrame, "BOTTOM")
        local pct = pLog.damage > 0 and (item.damage / pLog.damage) or 0
        fill:SetWidth(198 * pct)
        fill:SetGradientAlpha("HORIZONTAL", 0.4, 0.2, 0.7, 0.85, 0.15, 0.05, 0.3, 0.3)

        -- Spell Name & details
        local nameStr = rFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        nameStr:SetPoint("TOPLEFT", rFrame, "TOPLEFT", 6, -4)
        nameStr:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        nameStr:SetText(item.name)

        local dVal = CoADpsAndMobTracker_Engine.FormatNumber(item.damage)
        local pctStr = string.format("%.1f%%", pct * 100)
        local dmgStr = rFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        dmgStr:SetPoint("TOPRIGHT", rFrame, "TOPRIGHT", -6, -4)
        dmgStr:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        dmgStr:SetText(dVal .. " (" .. pctStr .. ")")

        -- Hit/Crit counts
        local s = item.data
        local avg = s.hits > 0 and math.floor(s.damage / s.hits) or 0
        local critPct = s.hits > 0 and (s.crits / s.hits * 100) or 0

        local subStr = rFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        subStr:SetPoint("BOTTOMLEFT", rFrame, "BOTTOMLEFT", 6, -16)
        subStr:SetPoint("BOTTOMRIGHT", rFrame, "BOTTOMRIGHT", -6, -16)
        subStr:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
        subStr:SetJustifyH("LEFT")
        subStr:SetText(string.format("|cffaaaaaaHits: %d |cff00ffaaCrit: %.1f%% |cff88ccffAvg: %d|r", s.hits, critPct, avg))

        yOff = yOff - 42
    end

    child:SetHeight(math.abs(yOff))
end

-- ─────────────────────────────────────────────
-- Refresh HUD Data (DPS Meter or Mob Tracker lists)
-- ─────────────────────────────────────────────
function CoADpsAndMobTracker_UI.Refresh()
    if not _frame or not _frame:IsShown() then return end

    -- Sync Tab visual headers and dropdown visibility
    if activeTab == 1 then
        _frame._dpsTab._text:SetText("|cff00ccff[⚔ DPS]|r")
        _frame._mobTab._text:SetText("|cffaaaaaa👾 Mobs|r")
        if _frame._statDropdown then _frame._statDropdown:Show() end
        if _frame._segmentDropdown then _frame._segmentDropdown:Show() end
        _frame._scroll:SetPoint("TOPLEFT", _frame, "TOPLEFT", 6, -58)
    else
        _frame._dpsTab._text:SetText("|cffaaaaaa⚔ DPS|r")
        _frame._mobTab._text:SetText("|cff00ccff[👾 Mobs]|r")
        if _frame._statDropdown then _frame._statDropdown:Hide() end
        if _frame._segmentDropdown then _frame._segmentDropdown:Hide() end
        _frame._scroll:SetPoint("TOPLEFT", _frame, "TOPLEFT", 6, -32)
    end

    local child = _frame._scrollChild
    -- Clear previous rows
    for _, childFrame in ipairs({ child:GetChildren() }) do
        childFrame:Hide()
        childFrame:SetParent(nil)
    end

    local yOff = 0

    if activeTab == 1 then
        -- ── DPS MODE ──
        local playersSource = {}
        local duration = 0
        local totalGroupDamage = 0
        local totalGroupHealing = 0
        local totalGroupTanked = 0

        -- Load data based on selected segment
        if activeSegment == "overall" then
            playersSource = CoADpsAndMobTracker_Session.players
            duration = CoADpsAndMobTracker_Engine.GetSessionDuration()
            
            -- Calculate group totals
            for _, pData in pairs(playersSource) do
                totalGroupDamage = totalGroupDamage + (pData.damage or 0)
                totalGroupHealing = totalGroupHealing + (pData.healing or 0)
                totalGroupTanked = totalGroupTanked + (pData.tanked or 0)
            end
        else
            local enc = CoADpsAndMobTracker_Encounters[activeSegment]
            if enc then
                playersSource = enc.players
                duration = enc.duration or 1
                
                -- Calculate group totals
                for _, pData in pairs(playersSource) do
                    totalGroupDamage = totalGroupDamage + (pData.damage or 0)
                    totalGroupHealing = totalGroupHealing + (pData.healing or 0)
                    totalGroupTanked = totalGroupTanked + (pData.tanked or 0)
                end
            end
        end

        if duration <= 0.5 then duration = 0.5 end

        -- Update fight timer in header
        local timerStr = CoADpsAndMobTracker_Engine.FormatDuration(duration)
        _frame._timerText:SetText("|cffffd700⏱ " .. timerStr .. "|r")

        -- Map Segment Dropdown text
        if activeSegment == "overall" then
            UIDropDownMenu_SetText(_frame._segmentDropdown, "Overall")
        else
            local enc = CoADpsAndMobTracker_Encounters[activeSegment]
            if enc then
                UIDropDownMenu_SetText(_frame._segmentDropdown, string.format("Seg %d: %s", activeSegment, enc.bossName or "Boss"))
            end
        end

        local list = {}
        local highestVal = 0
        for guid, data in pairs(playersSource) do
            local value = 0
            local rawDps = 0
            local rawHps = 0

            if activeStat == "dps" then
                rawDps = activeSegment == "overall" and CoADpsAndMobTracker_Engine.GetPlayerDPS(guid) or math.floor((data.damage or 0) / duration)
                value = rawDps
            elseif activeStat == "damage" then
                value = data.damage or 0
            elseif activeStat == "tanked" then
                value = data.tanked or 0
            elseif activeStat == "healing" then
                rawHps = activeSegment == "overall" and CoADpsAndMobTracker_Engine.GetPlayerHPS(guid) or math.floor((data.healing or 0) / duration)
                value = rawHps
            end

            -- Only include players who have actual data for this stat
            if value > 0 or (data.damage or 0) > 0 or (data.healing or 0) > 0 then
                table.insert(list, {
                    guid = guid,
                    name = data.name,
                    val = value,
                    class = data.class,
                    rawData = data,
                    rawDps = activeSegment == "overall" and CoADpsAndMobTracker_Engine.GetPlayerDPS(guid) or math.floor((data.damage or 0) / duration),
                    rawHps = activeSegment == "overall" and CoADpsAndMobTracker_Engine.GetPlayerHPS(guid) or math.floor((data.healing or 0) / duration)
                })
                if value > highestVal then highestVal = value end
            end
        end
        table.sort(list, function(a,b) return a.val > b.val end)

        for i, row in ipairs(list) do
            local rFrame = CreateFrame("Button", nil, child)
            rFrame:SetSize(248, 22)
            rFrame:SetPoint("TOPLEFT", child, "TOPLEFT", 0, yOff)

            -- Progress bar row backdrop
            local rowBG = rFrame:CreateTexture(nil, "BACKGROUND", nil, -1)
            rowBG:SetAllPoints()
            rowBG:SetTexture(0, 0, 0, 0.2)

            -- Progress bar fill (class colored)
            local fill = rFrame:CreateTexture(nil, "BACKGROUND")
            fill:SetPoint("LEFT", rFrame, "LEFT")
            fill:SetPoint("TOP", rFrame, "TOP")
            fill:SetPoint("BOTTOM", rFrame, "BOTTOM")
            local pct = highestVal > 0 and (row.val / highestVal) or 0
            fill:SetWidth(248 * pct)
            local c = ClassColors[row.class] or { r=0.5, g=0.5, b=0.5 }
            fill:SetGradientAlpha("HORIZONTAL", c.r, c.g, c.b, 0.85, c.r * 0.4, c.g * 0.4, c.b * 0.4, 0.3)

            -- Label text: name and rank
            local nameStr = rFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            nameStr:SetPoint("LEFT", rFrame, "LEFT", 6, 0)
            nameStr:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            nameStr:SetText(string.format("%d. %s", i, row.name))

            -- Label text: value (shows total, dps/hps, and % share of the group)
            local valueStr = rFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            valueStr:SetPoint("RIGHT", rFrame, "RIGHT", -6, 0)
            valueStr:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")

            if activeStat == "dps" then
                local dmgShare = totalGroupDamage > 0 and ((row.rawData.damage or 0) / totalGroupDamage * 100) or 0
                local dmgStr = CoADpsAndMobTracker_Engine.FormatNumber(row.rawData.damage)
                valueStr:SetText(string.format("%s (%d dps, %.1f%%)", dmgStr, row.val, dmgShare))
            elseif activeStat == "healing" then
                local healShare = totalGroupHealing > 0 and ((row.rawData.healing or 0) / totalGroupHealing * 100) or 0
                local healStr = CoADpsAndMobTracker_Engine.FormatNumber(row.rawData.healing)
                valueStr:SetText(string.format("%s (%d hps, %.1f%%)", healStr, row.val, healShare))
            elseif activeStat == "damage" then
                local dmgShare = totalGroupDamage > 0 and ((row.rawData.damage or 0) / totalGroupDamage * 100) or 0
                local dmgStr = CoADpsAndMobTracker_Engine.FormatNumber(row.val)
                valueStr:SetText(string.format("%s (%.1f%%)", dmgStr, dmgShare))
            elseif activeStat == "tanked" then
                local tankShare = totalGroupTanked > 0 and ((row.rawData.tanked or 0) / totalGroupTanked * 100) or 0
                local tankStr = CoADpsAndMobTracker_Engine.FormatNumber(row.val)
                valueStr:SetText(string.format("%s (%.1f%%)", tankStr, tankShare))
            end

            -- Tooltip on hover
            rFrame:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
                GameTooltip:ClearLines()
                local hex = GetClassHexColor(row.class)
                GameTooltip:AddLine("|c" .. hex .. row.name .. "|r")
                GameTooltip:AddDoubleLine("Class:", "|c" .. hex .. row.class .. "|r")
                GameTooltip:AddDoubleLine("Total Damage:", CoADpsAndMobTracker_Engine.FormatNumber(row.rawData.damage or 0) .. " (" .. (row.rawData.damage or 0) .. ")")
                GameTooltip:AddDoubleLine("DPS:", tostring(row.rawDps))
                GameTooltip:AddDoubleLine("Damage Tanked:", CoADpsAndMobTracker_Engine.FormatNumber(row.rawData.tanked or 0))
                GameTooltip:AddDoubleLine("Total Healing:", CoADpsAndMobTracker_Engine.FormatNumber(row.rawData.healing or 0))
                GameTooltip:AddDoubleLine("HPS:", tostring(row.rawHps))
                
                local sharePct = 0
                if activeStat == "dps" or activeStat == "damage" then
                    sharePct = totalGroupDamage > 0 and ((row.rawData.damage or 0) / totalGroupDamage * 100) or 0
                elseif activeStat == "healing" then
                    sharePct = totalGroupHealing > 0 and ((row.rawData.healing or 0) / totalGroupHealing * 100) or 0
                elseif activeStat == "tanked" then
                    sharePct = totalGroupTanked > 0 and ((row.rawData.tanked or 0) / totalGroupTanked * 100) or 0
                end
                GameTooltip:AddDoubleLine("Group Share:", string.format("%.1f%%", sharePct))
                
                GameTooltip:AddLine(" ")
                if activeSegment == "overall" then
                    GameTooltip:AddLine("|cffFFD700Left-Click to toggle spell details|r")
                else
                    GameTooltip:AddLine("|cffaaaaaaClicking spell details disabled for boss segments|r")
                end
                GameTooltip:Show()
            end)
            rFrame:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)

            -- Open details popup on click
            rFrame:SetScript("OnClick", function()
                PlaySound(856)
                if selectedPlayerGUID == row.guid and _detailFrame and _detailFrame:IsShown() then
                    _detailFrame:Hide()
                    selectedPlayerGUID = nil
                else
                    selectedPlayerGUID = row.guid
                    RenderDetail(row.guid)
                end
            end)

            yOff = yOff - 24
        end

        if #list == 0 then
            local empty = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            empty:SetPoint("TOPLEFT", child, "TOPLEFT", 6, -10)
            empty:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            empty:SetText("|cffaaaaaa[No combat stats recorded]|r")
            yOff = -30
        end

    else
        -- ── MOBS MODE ──
        _frame._timerText:SetText("")
        local list = {}
        for guid, mob in pairs(CoADpsAndMobTracker_ActiveMobs) do
            table.insert(list, mob)
        end
        table.sort(list, function(a,b) return (a.threat > b.threat) or (a.threat == b.threat and a.hp > b.hp) end)

        for _, mob in ipairs(list) do
            local rFrame = CreateFrame("Frame", nil, child)
            rFrame:SetSize(248, 26)
            rFrame:SetPoint("TOPLEFT", child, "TOPLEFT", 0, yOff)

            -- Mob Bar Background
            local barBG = rFrame:CreateTexture(nil, "BACKGROUND")
            barBG:SetAllPoints()
            barBG:SetTexture(0.08, 0.08, 0.12, 0.8)

            -- Threat border indicators (aggro warning colors)
            local tc = ThreatColors[mob.threat] or ThreatColors[0]
            local sideBorder = rFrame:CreateTexture(nil, "OVERLAY")
            sideBorder:SetSize(4, 26)
            sideBorder:SetPoint("LEFT", rFrame, "LEFT")
            sideBorder:SetTexture(tc.r, tc.g, tc.b, 0.95)

            -- HP Bar Fill
            local fill = rFrame:CreateTexture(nil, "ARTWORK")
            fill:SetPoint("LEFT", rFrame, "LEFT", 4, 0)
            fill:SetPoint("TOP", rFrame, "TOP")
            fill:SetPoint("BOTTOM", rFrame, "BOTTOM")
            local hpPct = mob.maxHp > 0 and (mob.hp / mob.maxHp) or 0
            fill:SetWidth((248 - 4) * hpPct)
            -- HP color goes from green to red based on health percentage
            fill:SetGradientAlpha("HORIZONTAL", 1 - hpPct, hpPct, 0.0, 0.65, (1 - hpPct) * 0.4, hpPct * 0.4, 0.0, 0.2)

            -- Mob name and target overlay
            local nameStr = rFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            nameStr:SetPoint("TOPLEFT", rFrame, "TOPLEFT", 8, -2)
            nameStr:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
            nameStr:SetText(mob.name)

            local targetStr = rFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            targetStr:SetPoint("BOTTOMLEFT", rFrame, "BOTTOMLEFT", 8, -14)
            targetStr:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
            local targetText = mob.target == "None" and "No Target" or ("⚔ " .. mob.target)
            if mob.target == UnitName("player") then
                targetText = "|cffff2222★ Hitting You!|r"
            end
            targetStr:SetText(targetText)

            -- Mob HP text
            local hpStr = rFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            hpStr:SetPoint("RIGHT", rFrame, "RIGHT", -6, 0)
            hpStr:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
            local hpVal = CoADpsAndMobTracker_Engine.FormatNumber(mob.hp)
            local pctVal = string.format("%d%%", hpPct * 100)
            hpStr:SetText(tc.hex .. hpVal .. " (" .. pctVal .. ")|r")

            -- Tooltip on hover
            rFrame:EnableMouse(true)
            rFrame:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
                GameTooltip:ClearLines()
                GameTooltip:AddLine("|cffff2222" .. mob.name .. "|r")
                GameTooltip:AddDoubleLine("Health:", string.format("%d / %d (%d%%)", mob.hp, mob.maxHp, hpPct * 100))
                local tc = ThreatColors[mob.threat] or ThreatColors[0]
                local threatNames = {
                    [0] = "Safe (Aggro on Tank)",
                    [1] = "Volatile Threat Warning",
                    [2] = "Pulling Threat!",
                    [3] = "Active Aggro (Hitting You!)"
                }
                GameTooltip:AddDoubleLine("Threat Level:", tc.hex .. threatNames[mob.threat] .. "|r")
                GameTooltip:AddDoubleLine("Targeting:", (mob.target == UnitName("player") and "|cffff2222★ YOU ★|r" or mob.target))
                GameTooltip:Show()
            end)
            rFrame:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)

            yOff = yOff - 30
        end

        if #list == 0 then
            local empty = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            empty:SetPoint("TOPLEFT", child, "TOPLEFT", 6, -10)
            empty:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            empty:SetText("|cffaaaaaa[No active enemies tracked]|r")
            yOff = -30
        end
    end

    child:SetHeight(math.abs(yOff))

    -- Refresh spell detail breakdown if shown
    if _detailFrame and _detailFrame:IsShown() and selectedPlayerGUID then
        RenderDetail(selectedPlayerGUID)
    end
end

-- ─────────────────────────────────────────────
-- Addon toggle / Slash commands
-- ─────────────────────────────────────────────
SLASH_COADPM1 = "/dpm"
SLASH_COADPM2 = "/dpsmeter"
SlashCmdList["COADPM"] = function(msg)
    if not _frame then CreateMainFrame() end
    if _frame:IsShown() then
        PlaySound(830)
        _frame:Hide()
        if _detailFrame then _detailFrame:Hide() end
    else
        PlaySound(829)
        _frame:Show()
        CoADpsAndMobTracker_UI.Refresh()
    end
end

-- ─────────────────────────────────────────────
-- Create Minimap Button
-- ─────────────────────────────────────────────
function CoADpsAndMobTracker_UI.CreateMinimapButton()
    local button = CreateFrame("Button", "CoADpsAndMobTrackerMinimapButton", Minimap)
    button:SetSize(26, 26)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8)

    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon:SetAllPoints()
    icon:SetTexture("Interface\\Icons\\Spell_Lightning_LightningBolt01") -- DPS lightning bolt

    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    border:SetSize(47, 47)
    border:SetPoint("TOPLEFT", button, "TOPLEFT", -9, 9)

    local function UpdatePosition()
        local angle = math.rad(CoADpsAndMobTrackerDB and CoADpsAndMobTrackerDB.minimapAngle or -120)
        local radius = 80
        local x = math.cos(angle) * radius
        local y = math.sin(angle) * radius
        button:SetPoint("CENTER", Minimap, "CENTER", x, y)
    end

    local dragging = false
    button:RegisterForDrag("LeftButton")
    button:SetScript("OnDragStart", function()
        dragging = true
        button:SetScript("OnUpdate", function()
            if dragging then
                local mx, my = GetCursorPosition()
                local scale = Minimap:GetEffectiveScale()
                mx = mx / scale
                my = my / scale
                local cx, cy = Minimap:GetCenter()
                local angle = math.deg(math.atan2(my - cy, mx - cx))
                if CoADpsAndMobTrackerDB then
                    CoADpsAndMobTrackerDB.minimapAngle = angle
                end
                UpdatePosition()
            end
        end)
    end)
    button:SetScript("OnDragStop", function()
        dragging = false
        button:SetScript("OnUpdate", nil)
    end)

    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetScript("OnClick", function(self, btn)
        if btn == "LeftButton" then
            PlaySound(856)
            if _frame then
                if _frame:IsShown() then
                    _frame:Hide()
                    if _detailFrame then _detailFrame:Hide() end
                else
                    _frame:Show()
                    CoADpsAndMobTracker_UI.Refresh()
                end
            end
        elseif btn == "RightButton" then
            PlaySound(856)
            CoADpsAndMobTracker_Engine.ResetSession()
            activeSegment = "overall"
            if _frame then CoADpsAndMobTracker_UI.Refresh() end
            print("|cff00ccff[CoADpsAndMobTracker] Combat data reset!|r")
        end
    end)

    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("|cff00ccffCoA DPS & Mob Tracker|r")
        GameTooltip:AddLine("|cffddddddLeft-Click:|r Toggle Dashboard")
        GameTooltip:AddLine("|cffddddddRight-Click:|r Reset Combat Logs")
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    UpdatePosition()
end

-- Hook login build
local loginHook = CreateFrame("Frame")
loginHook:RegisterEvent("PLAYER_LOGIN")
loginHook:SetScript("OnEvent", function()
    CreateMainFrame()
    CoADpsAndMobTracker_UI.CreateMinimapButton()
    CoADpsAndMobTracker_UI.Refresh()
end)
