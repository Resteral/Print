-- ============================================================
-- CoADpsAndMobTracker - UI Frame
-- Main Dashboard with tabs: DPS Meter, Mob Tracker
-- ============================================================

CoADpsAndMobTracker_UI = {}

local _frame = nil
local _detailFrame = nil
local activeTab = 1 -- 1 = DPS, 2 = Mobs
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
    f:SetSize(250, 260)
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
    makeLine(f, 250, 1, "TOPLEFT", "TOPLEFT", 0, 0)
    makeLine(f, 250, 1, "BOTTOMLEFT", "BOTTOMLEFT", 0, 0)
    makeLine(f, 1, 260, "TOPLEFT", "TOPLEFT", 0, 0)
    makeLine(f, 1, 260, "TOPRIGHT", "TOPRIGHT", 0, 0)

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
    scroll:SetPoint("TOPLEFT", f, "TOPLEFT", 6, -32)
    scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -26, 6)

    -- Scroll Child
    local child = CreateFrame("Frame", nil, scroll)
    child:SetSize(218, 1) -- auto height
    scroll:SetScrollChild(child)
    f._scrollChild = child

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
    local list = {}
    for guid, data in pairs(CoADpsAndMobTracker_Session.players) do
        table.insert(list, {
            name = data.name,
            damage = data.damage,
            dps = CoADpsAndMobTracker_Engine.GetPlayerDPS(guid)
        })
    end
    table.sort(list, function(a,b) return a.damage > b.damage end)

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

    SendChatMessage("=== CoA DPS Tracker ===", channel)
    for i = 1, math.min(3, #list) do
        local r = list[i]
        local dStr = CoADpsAndMobTracker_Engine.FormatNumber(r.damage)
        SendChatMessage(string.format("%d. %s — %s (%d DPS)", i, r.name, dStr, r.dps), channel)
    end
end

-- ─────────────────────────────────────────────
-- Render Detail Popout Frame
-- ─────────────────────────────────────────────
local function RenderDetail(guid)
    if not _detailFrame then CreateDetailFrame() end
    local d = _detailFrame
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
    for sName, data in pairs(pLog.spells) do
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

    -- Sync Tab visual headers
    if activeTab == 1 then
        _frame._dpsTab._text:SetText("|cff00ccff[⚔ DPS]|r")
        _frame._mobTab._text:SetText("|cffaaaaaa👾 Mobs|r")
    else
        _frame._dpsTab._text:SetText("|cffaaaaaa⚔ DPS|r")
        _frame._mobTab._text:SetText("|cff00ccff[👾 Mobs]|r")
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
        local list = {}
        local highestDmg = 0
        for guid, data in pairs(CoADpsAndMobTracker_Session.players) do
            table.insert(list, { guid = guid, name = data.name, damage = data.damage, class = data.class })
            if data.damage > highestDmg then highestDmg = data.damage end
        end
        table.sort(list, function(a,b) return a.damage > b.damage end)

        for i, row in ipairs(list) do
            local rFrame = CreateFrame("Button", nil, child)
            rFrame:SetSize(218, 22)
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
            local pct = highestDmg > 0 and (row.damage / highestDmg) or 0
            fill:SetWidth(218 * pct)
            local c = ClassColors[row.class] or { r=0.5, g=0.5, b=0.5 }
            fill:SetGradientAlpha("HORIZONTAL", c.r, c.g, c.b, 0.85, c.r * 0.4, c.g * 0.4, c.b * 0.4, 0.3)

            -- Label text: name and rank
            local nameStr = rFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            nameStr:SetPoint("LEFT", rFrame, "LEFT", 6, 0)
            nameStr:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            nameStr:SetText(string.format("%d. %s", i, row.name))

            -- Label text: damage / DPS
            local dps = CoADpsAndMobTracker_Engine.GetPlayerDPS(row.guid)
            local formattedVal = CoADpsAndMobTracker_Engine.FormatNumber(row.damage)
            local valueStr = rFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            valueStr:SetPoint("RIGHT", rFrame, "RIGHT", -6, 0)
            valueStr:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
            valueStr:SetText(string.format("%s (%d)", formattedVal, dps))

            -- Tooltip on hover
            rFrame:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
                GameTooltip:ClearLines()
                local hex = GetClassHexColor(row.class)
                GameTooltip:AddLine("|c" .. hex .. row.name .. "|r")
                GameTooltip:AddDoubleLine("Class:", "|c" .. hex .. row.class .. "|r")
                GameTooltip:AddDoubleLine("Total Damage:", CoADpsAndMobTracker_Engine.FormatNumber(row.damage) .. " (" .. row.damage .. ")")
                local dps = CoADpsAndMobTracker_Engine.GetPlayerDPS(row.guid)
                GameTooltip:AddDoubleLine("DPS:", tostring(dps))
                local share = highestDmg > 0 and (row.damage / highestDmg * 100) or 0
                GameTooltip:AddDoubleLine("Damage Share:", string.format("%.1f%%", share))
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("|cffFFD700Left-Click to toggle spell details|r")
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
            empty:SetText("|cffaaaaaa[No combat damage recorded]|r")
            yOff = -30
        end

    else
        -- ── MOBS MODE ──
        local list = {}
        for guid, mob in pairs(CoADpsAndMobTracker_ActiveMobs) do
            table.insert(list, mob)
        end
        table.sort(list, function(a,b) return (a.threat > b.threat) or (a.threat == b.threat and a.hp > b.hp) end)

        for _, mob in ipairs(list) do
            local rFrame = CreateFrame("Frame", nil, child)
            rFrame:SetSize(218, 26)
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
            fill:SetWidth((218 - 4) * hpPct)
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
