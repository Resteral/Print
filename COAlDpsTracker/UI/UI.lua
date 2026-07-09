-- ============================================================
-- COAlDpsTracker - Enhanced Combat Log UI
-- Tabs: DPS Meter | Mob Tracker | Combat Log | Settings
-- ============================================================

CoADpsAndMobTracker_UI = {}

local _frame       = nil
local _detailFrame = nil
local _logFrame    = nil
local _settingsFrame = nil
local activeTab    = 1   -- 1=DPS 2=Mobs 3=Log 4=Settings
local activeStat   = "dps"
local activeSegment= "overall"
local selectedPlayerGUID = nil

-- ─────────────────────────────────────────────────────────────
-- Settings (with defaults)
-- ─────────────────────────────────────────────────────────────
local SETTINGS_DEFAULTS = {
    showDPS         = true,
    showHPS         = true,
    showDamageTaken = true,
    showMelee       = true,
    showSpells      = true,
    showPets        = true,
    showGroup       = true,
    showSelf        = true,
    filterMinDmg    = 0,      -- hide hits below this
    logMaxLines     = 200,
    logShowDamage   = true,
    logShowHealing  = true,
    logShowMisses   = true,
    logShowCrits    = true,
    logShowDeaths   = true,
    logShowKills    = true,
    logShowInterrupts = true,
    logShowCC       = true,
    logShowPvP      = true,
    logShowSelf     = true,
    logShowGroup    = true,
    logShowEnemies  = false,
    logAutoScroll   = true,
    chatEcho        = false,  -- echo kills/deaths to chat
    autoReset       = true,   -- reset on entering new zone
    windowScale     = 1.0,
    windowAlpha     = 0.93,
    barStyle        = "gradient",  -- "gradient" | "solid" | "glow"
    sortBy          = "dps",       -- "dps" | "damage" | "healing" | "tanked"
    showTimeline    = true,
    bossAlerts      = true,
    showMobHP       = true,
    showMobThreat   = true,
    combatTimer     = true,
}

local function GetSettings()
    if not CoADpsAndMobTrackerDB then
        CoADpsAndMobTrackerDB = {}
    end
    if not CoADpsAndMobTrackerDB.settings then
        CoADpsAndMobTrackerDB.settings = {}
    end
    local s = CoADpsAndMobTrackerDB.settings
    for k, v in pairs(SETTINGS_DEFAULTS) do
        if s[k] == nil then s[k] = v end
    end
    return s
end

-- Combat log buffer
local _combatLog = {}
local LOG_COLORS = {
    damage   = "|cffFF6666",
    heal     = "|cff44FF88",
    miss     = "|cff888888",
    crit     = "|cffFFCC00",
    death    = "|cffFF2222",
    kill     = "|cffFFD700",
    interrupt= "|cff00CCFF",
    cc       = "|cffAA44FF",
    pvp      = "|cffFF8800",
    default  = "|cffCCCCCC",
}

-- Class colors
local ClassColors = {
    DEATHKNIGHT={r=0.77,g=0.12,b=0.23}, DRUID={r=1.00,g=0.49,b=0.04},
    HUNTER={r=0.67,g=0.83,b=0.45},      MAGE={r=0.41,g=0.80,b=0.94},
    PALADIN={r=0.96,g=0.55,b=0.73},     PRIEST={r=1.00,g=1.00,b=1.00},
    ROGUE={r=1.00,g=0.96,b=0.41},       SHAMAN={r=0.00,g=0.44,b=0.87},
    WARLOCK={r=0.58,g=0.51,b=0.79},     WARRIOR={r=0.78,g=0.61,b=0.43},
    -- CoA classes
    FELSWORN={r=0.70,g=0.10,b=0.90},    NECROMANCER={r=0.20,g=0.80,b=0.40},
    WITCH_HUNTER={r=0.90,g=0.70,b=0.10},RUNEMASTER={r=0.30,g=0.70,b=1.00},
    REAPER={r=0.60,g=0.10,b=0.10},      SPIRITWALKER={r=0.20,g=0.90,b=0.70},
    TINKER={r=0.90,g=0.80,b=0.30},      CHRONOMANCER={r=0.70,g=0.40,b=1.00},
}

local ThreatColors = {
    [0]={r=0.0,g=0.7,b=0.0,hex="|cff00ee00"},
    [1]={r=0.8,g=0.6,b=0.0,hex="|cffeedd00"},
    [2]={r=0.9,g=0.4,b=0.0,hex="|cffff8800"},
    [3]={r=0.9,g=0.1,b=0.1,hex="|cffff2222"},
}

local function ClassHex(cls)
    local c = ClassColors[cls] or {r=0.5,g=0.5,b=0.5}
    return string.format("ff%02x%02x%02x",c.r*255,c.g*255,c.b*255)
end

-- ─────────────────────────────────────────────────────────────
-- Combat Log Ingestion
-- Hook into engine CLEU and store filtered entries
-- ─────────────────────────────────────────────────────────────
local _origOnCLEU = nil
local playerGUID_log = nil

local LOG_EVENTS = {
    SWING_DAMAGE=true, SWING_MISSED=true,
    SPELL_DAMAGE=true, SPELL_PERIODIC_DAMAGE=true, RANGE_DAMAGE=true,
    SPELL_MISSED=true, RANGE_MISSED=true,
    SPELL_HEAL=true, SPELL_PERIODIC_HEAL=true,
    UNIT_DIED=true,
    SPELL_INTERRUPT=true,
    SPELL_AURA_APPLIED=true,
    PARTY_KILL=true,
}

local CC_SPELLS = {
    ["Polymorph"]=true, ["Hex"]=true, ["Fear"]=true, ["Blind"]=true,
    ["Sap"]=true, ["Repentance"]=true, ["Hibernate"]=true,
    ["Wyvern Sting"]=true, ["Freezing Trap"]=true, ["Frost Nova"]=true,
    ["Deep Freeze"]=true, ["Chains of Ice"]=true, ["Gouge"]=true,
    ["Kidney Shot"]=true, ["Cheap Shot"]=true,
}

local function AddLogEntry(entry)
    local s = GetSettings()
    local max = s.logMaxLines or 200
    table.insert(_combatLog, 1, entry)
    if #_combatLog > max then
        table.remove(_combatLog)
    end
    -- echo to chat if enabled
    if s.chatEcho and entry.important then
        DEFAULT_CHAT_FRAME:AddMessage("|cffcc88ff[COAl Log]|r " .. entry.text)
    end
end

function CoADpsAndMobTracker_UI.IngestCLEU(...)
    local s = GetSettings()
    playerGUID_log = playerGUID_log or UnitGUID("player")
    local ts, event, _, srcGUID, srcName, srcFlags, _, destGUID, destName, destFlags = ...
    srcFlags = srcFlags or 0
    destFlags = destFlags or 0

    local isPlayer  = (srcGUID == playerGUID_log)
    local isPet     = bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PET) ~= 0 and
                      bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0
    local isGroup   = bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) ~= 0 or
                      bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) ~= 0
    local isDestPl  = (destGUID == playerGUID_log)
    local isEnemy   = bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0

    if not LOG_EVENTS[event] then return end

    -- Filter by settings
    if not s.logShowSelf    and (isPlayer or isPet) then return end
    if not s.logShowGroup   and isGroup             then return end
    if not s.logShowEnemies and isEnemy and not isDestPl then return end

    local now = GetTime()
    local timeStr = string.format("[%d:%02d]",
        math.floor((now % 3600) / 60), math.floor(now % 60))
    local entry = { time=now, timeStr=timeStr, text="", important=false }

    -- DAMAGE
    if event == "SWING_DAMAGE" or event == "SPELL_DAMAGE" or
       event == "SPELL_PERIODIC_DAMAGE" or event == "RANGE_DAMAGE" then
        if not s.logShowDamage then return end
        local spellName = (event ~= "SWING_DAMAGE") and (select(13,...) or select(10,...)) or "Melee"
        local amount, isCrit
        if event == "SWING_DAMAGE" then
            amount = select(12,...) or select(9,...)
            isCrit = select(18,...) or select(15,...)
        else
            amount = select(15,...) or select(12,...)
            isCrit = select(21,...) or select(18,...)
        end
        amount = tonumber(amount) or 0
        if amount < (s.filterMinDmg or 0) then return end
        if isCrit and not s.logShowCrits then return end

        if not s.logShowMelee and spellName == "Melee" then return end
        if not s.logShowSpells and spellName ~= "Melee" then return end

        local color = isCrit and LOG_COLORS.crit or LOG_COLORS.damage
        local critStr = isCrit and " |cffFFCC00✦CRIT|r" or ""
        entry.text = string.format("%s %s%s|r hits %s|cffFFFFFF%s|r for %s%s|r%s",
            timeStr,
            color, srcName or "?",
            color, destName or "?",
            color, CoADpsAndMobTracker_Engine.FormatNumber(amount),
            critStr)
        entry.dtype = isCrit and "crit" or "damage"

    -- HEALING
    elseif event == "SPELL_HEAL" or event == "SPELL_PERIODIC_HEAL" then
        if not s.logShowHealing then return end
        local spellName = select(13,...) or select(10,...) or "Heal"
        local amount = select(15,...) or select(12,...) or 0
        local overheal = select(16,...) or select(13,...) or 0
        local isCrit = select(18,...) or false
        amount = tonumber(amount) or 0
        overheal = tonumber(overheal) or 0
        local eff = amount - overheal
        if eff <= 0 then return end
        local critStr = isCrit and " |cffFFCC00✦CRIT|r" or ""
        local ohStr = overheal > 0 and string.format(" |cff888888(+%s OH)|r",
            CoADpsAndMobTracker_Engine.FormatNumber(overheal)) or ""
        entry.text = string.format("%s %s%s|r heals %s%s|r for %s%s|r%s%s",
            timeStr, LOG_COLORS.heal, srcName or "?",
            LOG_COLORS.heal, destName or "?",
            LOG_COLORS.heal, CoADpsAndMobTracker_Engine.FormatNumber(eff),
            critStr, ohStr)
        entry.dtype = "heal"

    -- MISSES
    elseif event == "SWING_MISSED" or event == "SPELL_MISSED" or event == "RANGE_MISSED" then
        if not s.logShowMisses then return end
        local missType = select(13,...) or select(10,...) or "Miss"
        entry.text = string.format("%s %s%s|r %s on %s|cffaaaaaa%s|r",
            timeStr, LOG_COLORS.miss, srcName or "?",
            missType:lower(), LOG_COLORS.miss, destName or "?")
        entry.dtype = "miss"

    -- DEATHS
    elseif event == "UNIT_DIED" then
        if not s.logShowDeaths then return end
        local isPlayerDeath = (destGUID == playerGUID_log)
        entry.text = string.format("%s %s☠ %s|r died",
            timeStr,
            isPlayerDeath and "|cffFF2222" or "|cffFF6666",
            destName or "?")
        entry.dtype = "death"
        entry.important = isPlayerDeath

    -- KILLS
    elseif event == "PARTY_KILL" then
        if not s.logShowKills then return end
        entry.text = string.format("%s %s⚔ %s|r killed %s|cffFFD700%s|r",
            timeStr, LOG_COLORS.kill, srcName or "?", LOG_COLORS.kill, destName or "?")
        entry.dtype = "kill"
        entry.important = true

    -- INTERRUPTS
    elseif event == "SPELL_INTERRUPT" then
        if not s.logShowInterrupts then return end
        local interruptedSpell = select(16,...) or select(13,...) or "spell"
        entry.text = string.format("%s %s⚡ %s|r interrupted %s%s|r's %s|cff00CCFF%s|r",
            timeStr, LOG_COLORS.interrupt, srcName or "?",
            LOG_COLORS.interrupt, destName or "?",
            LOG_COLORS.interrupt, interruptedSpell)
        entry.dtype = "interrupt"
        entry.important = true

    -- CC AURAS
    elseif event == "SPELL_AURA_APPLIED" then
        if not s.logShowCC then return end
        local spellName = select(13,...) or select(10,...) or ""
        if not CC_SPELLS[spellName] then return end
        entry.text = string.format("%s %s%s|r CC'd %s%s|r with %s%s|r",
            timeStr, LOG_COLORS.cc, srcName or "?",
            LOG_COLORS.cc, destName or "?",
            LOG_COLORS.cc, spellName)
        entry.dtype = "cc"
    else
        return
    end

    if entry.text ~= "" then
        AddLogEntry(entry)
        if CoADpsAndMobTracker_UI.RefreshLog then
            CoADpsAndMobTracker_UI.RefreshLog()
        end
    end
end

-- ─────────────────────────────────────────────────────────────
-- Utility: make a borderless button with coloured BG
-- ─────────────────────────────────────────────────────────────
local function MakeBtn(parent, w, h, r, g, b, label, font)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(w, h)
    local bg = btn:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    bg:SetVertexColor(r, g, b, 0.85)
    btn._bg = bg
    local lbl = btn:CreateFontString(nil, "OVERLAY")
    lbl:SetFont("Fonts\\FRIZQT__.TTF", font or 9, "OUTLINE")
    lbl:SetAllPoints()
    lbl:SetJustifyH("CENTER")
    lbl:SetText(label)
    btn._lbl = lbl
    btn:SetScript("OnEnter", function() bg:SetVertexColor(r*1.5, g*1.5, b*1.5, 0.95) end)
    btn:SetScript("OnLeave", function() bg:SetVertexColor(r, g, b, 0.85) end)
    return btn
end

-- ─────────────────────────────────────────────────────────────
-- Utility: toggle checkbox row
-- ─────────────────────────────────────────────────────────────
local function MakeCheckRow(parent, xOff, yOff, label, settingKey, onChange)
    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(240, 18)
    row:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, yOff)

    local cbBG = row:CreateTexture(nil, "BACKGROUND")
    cbBG:SetSize(14, 14)
    cbBG:SetPoint("LEFT", row, "LEFT", 0, 0)
    cbBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")

    local tick = row:CreateFontString(nil, "OVERLAY")
    tick:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    tick:SetPoint("CENTER", cbBG, "CENTER", 0, 0)

    local lbl = row:CreateFontString(nil, "OVERLAY")
    lbl:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    lbl:SetPoint("LEFT", cbBG, "RIGHT", 6, 0)
    lbl:SetText(label)

    local function Refresh()
        local s = GetSettings()
        local on = s[settingKey]
        cbBG:SetVertexColor(on and 0.1 or 0.08, on and 0.35 or 0.08, on and 0.1 or 0.12, 0.95)
        tick:SetText(on and "|cff44ff44✔|r" or "")
        lbl:SetTextColor(on and 1 or 0.5, on and 1 or 0.5, on and 1 or 0.55)
    end
    Refresh()

    row:EnableMouse(true)
    row:SetScript("OnMouseDown", function()
        local s = GetSettings()
        s[settingKey] = not s[settingKey]
        Refresh()
        if onChange then onChange(s[settingKey]) end
    end)
    return row
end

-- ─────────────────────────────────────────────────────────────
-- Settings Panel
-- ─────────────────────────────────────────────────────────────
local function BuildSettingsPanel(parent)
    local f = CreateFrame("Frame", nil, parent)
    f:SetAllPoints(parent)
    f:Hide()

    local scroll = CreateFrame("ScrollFrame", "COAlDpsSettingsScroll", f, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", f, "TOPLEFT", 4, -4)
    scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -22, 4)

    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(260, 700)
    scroll:SetScrollChild(content)

    local y = -4

    -- Section: DISPLAY
    local secDisp = content:CreateFontString(nil, "OVERLAY")
    secDisp:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    secDisp:SetPoint("TOPLEFT", content, "TOPLEFT", 4, y)
    secDisp:SetText("|cffcc88ff── DISPLAY ──────────────────────|r")
    y = y - 18

    MakeCheckRow(content, 4, y, "Show DPS column",          "showDPS",         nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show HPS column",          "showHPS",         nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show Damage Taken column", "showDamageTaken", nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show Pets",                "showPets",        nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show Group members",       "showGroup",       nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show Self",                "showSelf",        nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show Mob HP bars",         "showMobHP",       nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show Mob Threat colours",  "showMobThreat",   nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show Combat Timer",        "combatTimer",     nil) y = y - 18

    y = y - 6
    -- Section: SORT
    local secSort = content:CreateFontString(nil, "OVERLAY")
    secSort:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    secSort:SetPoint("TOPLEFT", content, "TOPLEFT", 4, y)
    secSort:SetText("|cffcc88ff── SORT BY ──────────────────────|r")
    y = y - 18

    local sortOptions = { {"DPS","dps"}, {"Total Damage","damage"}, {"Healing","healing"}, {"Tanked","tanked"} }
    for _, opt in ipairs(sortOptions) do
        local label, key = opt[1], opt[2]
        local row = CreateFrame("Frame", nil, content)
        row:SetSize(200, 16)
        row:SetPoint("TOPLEFT", content, "TOPLEFT", 4, y)

        local dot = row:CreateFontString(nil, "OVERLAY")
        dot:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        dot:SetPoint("LEFT", row, "LEFT", 0, 0)

        local lbl2 = row:CreateFontString(nil, "OVERLAY")
        lbl2:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        lbl2:SetPoint("LEFT", dot, "RIGHT", 6, 0)
        lbl2:SetText(label)

        local function RefSort()
            local s = GetSettings()
            local sel = (s.sortBy == key)
            dot:SetText(sel and "|cff00ff88●|r" or "|cff444444○|r")
            lbl2:SetTextColor(sel and 1 or 0.5, sel and 1 or 0.5, sel and 1 or 0.55)
        end
        RefSort()
        row:EnableMouse(true)
        row:SetScript("OnMouseDown", function()
            local s = GetSettings()
            s.sortBy = key
            activeStat = key
            RefSort()
            if CoADpsAndMobTracker_UI.Refresh then CoADpsAndMobTracker_UI.Refresh() end
        end)
        y = y - 18
    end

    y = y - 6
    -- Section: COMBAT LOG FILTERS
    local secLog = content:CreateFontString(nil, "OVERLAY")
    secLog:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    secLog:SetPoint("TOPLEFT", content, "TOPLEFT", 4, y)
    secLog:SetText("|cffcc88ff── COMBAT LOG ───────────────────|r")
    y = y - 18

    MakeCheckRow(content, 4, y, "Show Damage events",    "logShowDamage",    nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show Healing events",   "logShowHealing",   nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show Misses / Dodges",  "logShowMisses",    nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show Critical Strikes", "logShowCrits",     nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show Deaths",           "logShowDeaths",    nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show Kills",            "logShowKills",     nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show Interrupts",       "logShowInterrupts",nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show CC events",        "logShowCC",        nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show PvP events",       "logShowPvP",       nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show my actions",       "logShowSelf",      nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show group actions",    "logShowGroup",     nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show enemy actions",    "logShowEnemies",   nil) y = y - 18
    MakeCheckRow(content, 4, y, "Auto-scroll log",       "logAutoScroll",    nil) y = y - 18
    MakeCheckRow(content, 4, y, "Echo kills to chat",    "chatEcho",         nil) y = y - 18

    y = y - 6
    -- Section: ALERTS
    local secAlerts = content:CreateFontString(nil, "OVERLAY")
    secAlerts:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    secAlerts:SetPoint("TOPLEFT", content, "TOPLEFT", 4, y)
    secAlerts:SetText("|cffcc88ff── ALERTS ──────────────────────|r")
    y = y - 18

    MakeCheckRow(content, 4, y, "Boss kill alerts",      "bossAlerts",  nil) y = y - 18
    MakeCheckRow(content, 4, y, "Auto-reset on new zone","autoReset",   nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show melee swings",     "logShowMelee",nil) y = y - 18
    MakeCheckRow(content, 4, y, "Show spell damage",     "logShowSpells",nil) y = y - 18

    y = y - 6
    -- Min damage filter
    local minDmgLbl = content:CreateFontString(nil, "OVERLAY")
    minDmgLbl:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    minDmgLbl:SetPoint("TOPLEFT", content, "TOPLEFT", 4, y)
    minDmgLbl:SetText("|cffcc88ffMin Damage Filter: (click ▲/▼)|r")
    y = y - 16

    local minValLbl = content:CreateFontString(nil, "OVERLAY")
    minValLbl:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    minValLbl:SetPoint("TOPLEFT", content, "TOPLEFT", 4, y)
    local function RefMinDmg()
        local s = GetSettings()
        minValLbl:SetText("|cffFFD700" .. tostring(s.filterMinDmg) .. "|r damage minimum")
    end
    RefMinDmg()

    local upBtn = MakeBtn(content, 36, 16, 0.1, 0.35, 0.1, "|cff44ff44▲|r", 8)
    upBtn:SetPoint("LEFT", minValLbl, "RIGHT", 8, 0)
    upBtn:SetScript("OnClick", function()
        local s = GetSettings()
        s.filterMinDmg = math.min(999999, (s.filterMinDmg or 0) + 100)
        RefMinDmg()
    end)

    local downBtn = MakeBtn(content, 36, 16, 0.35, 0.1, 0.1, "|cffff6666▼|r", 8)
    downBtn:SetPoint("LEFT", upBtn, "RIGHT", 4, 0)
    downBtn:SetScript("OnClick", function()
        local s = GetSettings()
        s.filterMinDmg = math.max(0, (s.filterMinDmg or 0) - 100)
        RefMinDmg()
    end)

    content:SetHeight(math.abs(y) + 20)
    return f
end

-- ─────────────────────────────────────────────────────────────
-- Combat Log Panel
-- ─────────────────────────────────────────────────────────────
local _logLines = {}
local _logScroll = nil
local _logContent = nil

local function BuildLogPanel(parent)
    local f = CreateFrame("Frame", nil, parent)
    f:SetAllPoints(parent)
    f:Hide()

    -- Filter buttons row
    local filterY = -2
    local filters = {
        { label="DMG",  key="logShowDamage",    r=0.8, g=0.2, b=0.2 },
        { label="HEAL", key="logShowHealing",   r=0.2, g=0.8, b=0.4 },
        { label="MISS", key="logShowMisses",    r=0.5, g=0.5, b=0.5 },
        { label="CRIT", key="logShowCrits",     r=0.9, g=0.7, b=0.0 },
        { label="CC",   key="logShowCC",        r=0.6, g=0.2, b=0.9 },
        { label="INT",  key="logShowInterrupts",r=0.0, g=0.7, b=0.9 },
        { label="KILL", key="logShowKills",     r=0.9, g=0.7, b=0.0 },
    }
    local bX = 2
    for _, flt in ipairs(filters) do
        local btn = MakeBtn(f, 34, 16, flt.r*0.6, flt.g*0.6, flt.b*0.6, flt.label, 7)
        btn:SetPoint("TOPLEFT", f, "TOPLEFT", bX, filterY)
        bX = bX + 36
        local fkey = flt.key
        local fr, fg, fb = flt.r, flt.g, flt.b
        btn:SetScript("OnClick", function()
            local s = GetSettings()
            s[fkey] = not s[fkey]
            local on = s[fkey]
            btn._bg:SetVertexColor(
                on and fr or fr*0.35,
                on and fg or fg*0.35,
                on and fb or fb*0.35, 0.85)
            CoADpsAndMobTracker_UI.RefreshLog()
        end)
        -- init colour
        local s = GetSettings()
        local on = s[flt.key]
        btn._bg:SetVertexColor(
            on and flt.r or flt.r*0.35,
            on and flt.g or flt.g*0.35,
            on and flt.b or flt.b*0.35, 0.85)
    end

    -- Clear button
    local clearBtn = MakeBtn(f, 40, 16, 0.3, 0.08, 0.08, "|cffFF4444CLR|r", 7)
    clearBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, filterY)
    clearBtn:SetScript("OnClick", function()
        _combatLog = {}
        CoADpsAndMobTracker_UI.RefreshLog()
    end)

    -- Scroll area
    local scrollBG = f:CreateTexture(nil, "BACKGROUND")
    scrollBG:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -20)
    scrollBG:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -2, 2)
    scrollBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    scrollBG:SetVertexColor(0.02, 0.02, 0.05, 0.9)

    local scroll = CreateFrame("ScrollFrame", "COAlDpsLogScroll", f, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -20)
    scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -22, 2)
    _logScroll = scroll

    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(240, 1)
    scroll:SetScrollChild(content)
    _logContent = content

    return f
end

function CoADpsAndMobTracker_UI.RefreshLog()
    if not _logContent then return end
    -- hide old lines
    for _, ln in ipairs(_logLines) do ln:SetText("") end
    _logLines = {}

    local s = GetSettings()
    local lineH = 12
    local count = 0

    for _, entry in ipairs(_combatLog) do
        count = count + 1
        local fs = _logLines[count]
        if not fs then
            fs = _logContent:CreateFontString(nil, "OVERLAY")
            fs:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE")
            fs:SetPoint("TOPLEFT", _logContent, "TOPLEFT", 2, -(count-1)*lineH - 2)
            fs:SetWidth(230)
            fs:SetJustifyH("LEFT")
            _logLines[count] = fs
        end
        fs:SetText(entry.text)
    end

    _logContent:SetHeight(math.max(1, count * lineH + 4))

    -- auto-scroll to top (newest)
    if s.logAutoScroll then
        _logScroll:SetVerticalScroll(0)
    end
end

-- ─────────────────────────────────────────────────────────────
-- DPS / HPS Bar rows
-- ─────────────────────────────────────────────────────────────
local _dpsRows = {}

local function GetSortedPlayers()
    local s = GetSettings()
    local sortKey = s.sortBy or "dps"
    local players = {}
    for guid, pData in pairs(CoADpsAndMobTracker_Session.players) do
        local isPet = pData.name and pData.name:find("%(Pet%)")
        if (s.showPets or not isPet) and
           (s.showSelf or guid ~= UnitGUID("player")) and
           (s.showGroup or guid == UnitGUID("player")) then
            local val
            if sortKey == "dps" then
                val = CoADpsAndMobTracker_Engine.GetPlayerDPS(guid)
            elseif sortKey == "damage" then
                val = pData.damage or 0
            elseif sortKey == "healing" then
                val = pData.healing or 0
            elseif sortKey == "tanked" then
                val = pData.tanked or 0
            else
                val = CoADpsAndMobTracker_Engine.GetPlayerDPS(guid)
            end
            table.insert(players, { guid=guid, data=pData, sortVal=val })
        end
    end
    table.sort(players, function(a, b) return (a.sortVal or 0) > (b.sortVal or 0) end)
    return players
end

local function RefreshDPSRows(parent, players, totalDmg, duration)
    local s = GetSettings()
    local ROW_H = 22
    local maxVal = players[1] and players[1].sortVal or 1
    if maxVal <= 0 then maxVal = 1 end

    for i, entry in ipairs(players) do
        if i > 15 then break end
        local row = _dpsRows[i]
        if not row then
            row = {}
            -- bar bg
            row.bg = parent:CreateTexture(nil, "BACKGROUND")
            row.bg:SetHeight(ROW_H - 2)
            row.bg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
            row.bg:SetVertexColor(0.05, 0.05, 0.10, 0.85)
            -- bar fill
            row.fill = parent:CreateTexture(nil, "BORDER")
            row.fill:SetHeight(ROW_H - 4)
            row.fill:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
            -- name
            row.name = parent:CreateFontString(nil, "OVERLAY")
            row.name:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
            row.name:SetJustifyH("LEFT")
            -- value
            row.val = parent:CreateFontString(nil, "OVERLAY")
            row.val:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
            row.val:SetJustifyH("RIGHT")
            -- role
            row.role = parent:CreateFontString(nil, "OVERLAY")
            row.role:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE")
            row.role:SetJustifyH("LEFT")
            _dpsRows[i] = row
        end

        local yOff = -(i-1)*(ROW_H+2) - 2
        local W = parent:GetWidth() - 8

        row.bg:SetWidth(W)
        row.bg:SetPoint("TOPLEFT", parent, "TOPLEFT", 4, yOff)
        row.bg:Show()

        local frac = math.min(1.0, entry.sortVal / maxVal)
        row.fill:SetWidth(math.max(2, W * frac))
        row.fill:SetPoint("TOPLEFT", parent, "TOPLEFT", 4, yOff + 1)
        row.fill:Show()

        -- colour by class
        local cls = entry.data.class or "WARRIOR"
        local cc  = ClassColors[cls] or {r=0.5,g=0.5,b=0.5}
        row.fill:SetVertexColor(cc.r*0.6, cc.g*0.6, cc.b*0.6, 0.85)

        -- name + role
        local role = CoADpsAndMobTracker_Engine.GetPlayerRole(entry.guid)
        local roleIcon = role=="TANK" and "|cff6688ff⛛|r" or role=="HEALER" and "|cff44ff88✚|r" or "|cffff8844⚔|r"
        row.name:SetPoint("LEFT", parent, "LEFT", 8, yOff + (ROW_H/2) - 4)
        row.name:SetText(string.format("|c%s%s|r %s", ClassHex(cls),
            (entry.data.name or "?"):sub(1,12), roleIcon))
        row.name:Show()

        -- value label
        local s2 = GetSettings()
        local valStr = CoADpsAndMobTracker_Engine.FormatNumber(entry.sortVal)
        local suffix = (s2.sortBy == "dps" or s2.sortBy == nil) and " dps" or ""
        if s2.sortBy == "healing" then suffix = " hps" end

        -- extra columns
        local extras = ""
        if s2.showDPS and s2.sortBy ~= "dps" then
            extras = extras .. " |cffaaaaaa" ..
                CoADpsAndMobTracker_Engine.FormatNumber(CoADpsAndMobTracker_Engine.GetPlayerDPS(entry.guid)) .. "d|r"
        end
        if s2.showHPS and (entry.data.healing or 0) > 0 then
            extras = extras .. " |cff44ff88" ..
                CoADpsAndMobTracker_Engine.FormatNumber(CoADpsAndMobTracker_Engine.GetPlayerHPS(entry.guid)) .. "h|r"
        end
        if s2.showDamageTaken and (entry.data.tanked or 0) > 0 then
            extras = extras .. " |cffff6666" ..
                CoADpsAndMobTracker_Engine.FormatNumber(entry.data.tanked) .. "tk|r"
        end

        row.val:SetPoint("RIGHT", parent, "RIGHT", -4, yOff + (ROW_H/2) - 4)
        row.val:SetText(string.format("|cffFFD700%s%s|r%s", valStr, suffix, extras))
        row.val:Show()
    end

    -- hide unused rows
    for i = #players + 1, #_dpsRows do
        local row = _dpsRows[i]
        if row then
            row.bg:Hide()
            row.fill:Hide()
            row.name:Hide()
            row.val:Hide()
        end
    end
end

-- ─────────────────────────────────────────────────────────────
-- Build Main Frame
-- ─────────────────────────────────────────────────────────────
local function CreateMainFrame()
    local f = CreateFrame("Frame", "COAlDpsTrackerFrame", UIParent)
    f:SetSize(300, 340)
    f:SetFrameStrata("MEDIUM")

    -- Restore position
    if CoADpsAndMobTrackerDB and CoADpsAndMobTrackerDB.pos then
        local p = CoADpsAndMobTrackerDB.pos
        f:SetPoint(p.point or "CENTER", UIParent, p.point or "CENTER", p.x or 150, p.y or 0)
    else
        f:SetPoint("CENTER", UIParent, "CENTER", 150, 0)
    end

    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, _, x, y = self:GetPoint()
        if CoADpsAndMobTrackerDB then
            CoADpsAndMobTrackerDB.pos = { point=point, x=x, y=y }
        end
    end)

    -- Background
    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    bg:SetVertexColor(0.03, 0.03, 0.08, 0.95)

    -- Border lines
    for _, def in ipairs({
        {"TOPLEFT","TOPRIGHT","h"}, {"BOTTOMLEFT","BOTTOMRIGHT","h"},
        {"TOPLEFT","BOTTOMLEFT","v"}, {"TOPRIGHT","BOTTOMRIGHT","v"}
    }) do
        local line = f:CreateTexture(nil, "OVERLAY")
        line:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
        line:SetVertexColor(0.3, 0.1, 0.6, 0.9)
        if def[3] == "h" then
            line:SetHeight(1)
            line:SetPoint("LEFT", f, def[1], 0, 0)
            line:SetPoint("RIGHT", f, def[2], 0, 0)
        else
            line:SetWidth(1)
            line:SetPoint("TOP", f, def[1], 0, 0)
            line:SetPoint("BOTTOM", f, def[2], 0, 0)
        end
    end

    -- Title bar
    local titleBG = f:CreateTexture(nil, "BORDER")
    titleBG:SetHeight(22)
    titleBG:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -1)
    titleBG:SetPoint("TOPRIGHT", f, "TOPRIGHT", -1, -1)
    titleBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    titleBG:SetVertexColor(0.12, 0.04, 0.22, 0.97)

    local titleTxt = f:CreateFontString(nil, "OVERLAY")
    titleTxt:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    titleTxt:SetPoint("LEFT", f, "TOPLEFT", 8, -11)
    titleTxt:SetText("|cffcc88ff⚔ COAl|r |cff00ccffCombat Tracker|r")
    f._titleTxt = titleTxt

    -- Timer
    local timerTxt = f:CreateFontString(nil, "OVERLAY")
    timerTxt:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
    timerTxt:SetPoint("RIGHT", f, "TOPRIGHT", -30, -11)
    timerTxt:SetText("")
    f._timer = timerTxt

    -- Close button
    local closeBtn = MakeBtn(f, 20, 18, 0.35, 0.05, 0.05, "|cffff4444✕|r", 10)
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)
    closeBtn:SetScript("OnClick", function() f:Hide() end)

    -- ── TABS ────────────────────────────────────────────────
    local TAB_DEFS = {
        { label="|cffFF8844⚔ DPS|r",     id=1 },
        { label="|cffFF6666☠ Mobs|r",    id=2 },
        { label="|cff44CCFF📋 Log|r",    id=3 },
        { label="|cffcc88ff⚙ Settings|r",id=4 },
    }
    local tabBtns = {}
    for i, td in ipairs(TAB_DEFS) do
        local tb = MakeBtn(f, 66, 18, 0.08, 0.08, 0.14, td.label, 8)
        tb:SetPoint("TOPLEFT", f, "TOPLEFT", 2 + (i-1)*68, -24)
        tb._id = td.id
        table.insert(tabBtns, tb)
    end

    -- Tab separator
    local sep = f:CreateTexture(nil, "OVERLAY")
    sep:SetHeight(1)
    sep:SetPoint("TOPLEFT", f, "TOPLEFT", 0, -43)
    sep:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, -43)
    sep:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    sep:SetVertexColor(0.3, 0.1, 0.6, 0.7)

    -- Content area
    local contentArea = CreateFrame("Frame", nil, f)
    contentArea:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -45)
    contentArea:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -2, 20)

    -- ── TAB CONTENT AREAS ────────────────────────────────────

    -- DPS Tab content
    local dpsScroll = CreateFrame("ScrollFrame", "COAlDpsMeterScroll", contentArea, "UIPanelScrollFrameTemplate")
    dpsScroll:SetPoint("TOPLEFT", contentArea, "TOPLEFT", 0, 0)
    dpsScroll:SetPoint("BOTTOMRIGHT", contentArea, "BOTTOMRIGHT", -18, 0)
    local dpsContent = CreateFrame("Frame", nil, dpsScroll)
    dpsContent:SetSize(272, 400)
    dpsScroll:SetScrollChild(dpsContent)
    f._dpsContent = dpsContent
    f._dpsScroll  = dpsScroll

    -- Mobs Tab content
    local mobScroll = CreateFrame("ScrollFrame", "COAlMobScroll", contentArea, "UIPanelScrollFrameTemplate")
    mobScroll:SetPoint("TOPLEFT", contentArea, "TOPLEFT", 0, 0)
    mobScroll:SetPoint("BOTTOMRIGHT", contentArea, "BOTTOMRIGHT", -18, 0)
    local mobContent = CreateFrame("Frame", nil, mobScroll)
    mobContent:SetSize(272, 400)
    mobScroll:SetScrollChild(mobContent)
    f._mobContent = mobContent
    f._mobScroll  = mobScroll
    mobScroll:Hide()

    -- Log Tab
    local logPanel = BuildLogPanel(contentArea)
    f._logPanel = logPanel

    -- Settings Tab
    local settPanel = BuildSettingsPanel(contentArea)
    f._settPanel = settPanel

    -- Mob display rows
    local _mobRows = {}
    f._mobRows = _mobRows

    -- ── BOTTOM BAR ───────────────────────────────────────────
    local bottomBG = f:CreateTexture(nil, "BORDER")
    bottomBG:SetHeight(18)
    bottomBG:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 1, 1)
    bottomBG:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 1)
    bottomBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    bottomBG:SetVertexColor(0.08, 0.03, 0.16, 0.95)

    local totalLbl = f:CreateFontString(nil, "OVERLAY")
    totalLbl:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE")
    totalLbl:SetPoint("LEFT", f, "BOTTOMLEFT", 6, 9)
    totalLbl:SetText("")
    f._totalLbl = totalLbl

    local resetBtn = MakeBtn(f, 50, 14, 0.15, 0.05, 0.25, "|cffcc88ffRESET|r", 7)
    resetBtn:SetPoint("RIGHT", f, "BOTTOMRIGHT", -4, 9)
    resetBtn:SetScript("OnClick", function()
        CoADpsAndMobTracker_Engine.ResetSession()
        _combatLog = {}
        CoADpsAndMobTracker_UI.RefreshLog()
    end)

    -- Share to chat button
    local shareBtn = MakeBtn(f, 50, 14, 0.05, 0.15, 0.25, "|cff66aaffSHARE|r", 7)
    shareBtn:SetPoint("RIGHT", resetBtn, "LEFT", -2, 0)
    shareBtn:SetScript("OnClick", function()
        local players = GetSortedPlayers()
        DEFAULT_CHAT_FRAME:AddMessage("|cffcc88ff[COAl]|r Combat Summary:")
        for i, e in ipairs(players) do
            if i > 5 then break end
            DEFAULT_CHAT_FRAME:AddMessage(string.format(
                "  %d. |c%s%s|r — |cffFFD700%s|r dps  |cffaaaaaa%s dmg|r",
                i, ClassHex(e.data.class or "WARRIOR"),
                e.data.name or "?",
                CoADpsAndMobTracker_Engine.FormatNumber(CoADpsAndMobTracker_Engine.GetPlayerDPS(e.guid)),
                CoADpsAndMobTracker_Engine.FormatNumber(e.data.damage or 0)))
        end
    end)

    -- ── TAB SWITCHING ────────────────────────────────────────
    local function SwitchTab(id)
        activeTab = id
        dpsScroll:SetShown(id == 1)
        mobScroll:SetShown(id == 2)
        logPanel:SetShown(id == 3)
        settPanel:SetShown(id == 4)
        for _, tb in ipairs(tabBtns) do
            local sel = (tb._id == id)
            tb._bg:SetVertexColor(
                sel and 0.20 or 0.08,
                sel and 0.08 or 0.08,
                sel and 0.35 or 0.14, 0.9)
        end
        CoADpsAndMobTracker_UI.Refresh()
    end

    for _, tb in ipairs(tabBtns) do
        tb:SetScript("OnClick", function() SwitchTab(tb._id) end)
    end

    SwitchTab(1)

    -- Timer update
    f:SetScript("OnUpdate", function(self, elapsed)
        local s = GetSettings()
        if s.combatTimer then
            local dur = CoADpsAndMobTracker_Engine.GetSessionDuration()
            if dur > 0 then
                timerTxt:SetText("|cffaaaaaa" .. CoADpsAndMobTracker_Engine.FormatDuration(dur) .. "|r")
            else
                timerTxt:SetText("")
            end
        else
            timerTxt:SetText("")
        end
    end)

    f._switchTab = SwitchTab
    return f
end

-- ─────────────────────────────────────────────────────────────
-- Public Refresh
-- ─────────────────────────────────────────────────────────────
function CoADpsAndMobTracker_UI.Refresh()
    if not _frame or not _frame:IsShown() then return end

    local players  = GetSortedPlayers()
    local duration = CoADpsAndMobTracker_Engine.GetSessionDuration()
    local totalDmg = CoADpsAndMobTracker_Session.totalDamage or 0
    local s        = GetSettings()

    -- Bottom bar
    if _frame._totalLbl then
        _frame._totalLbl:SetText(string.format(
            "|cffaaaaaa%s total  %s|r",
            CoADpsAndMobTracker_Engine.FormatNumber(totalDmg),
            CoADpsAndMobTracker_Engine.FormatDuration(duration)))
    end

    if activeTab == 1 then
        -- DPS rows
        if _frame._dpsContent then
            _frame._dpsContent:SetWidth(_frame._dpsScroll:GetWidth())
            RefreshDPSRows(_frame._dpsContent, players, totalDmg, duration)
        end

    elseif activeTab == 2 then
        -- Mob tracker
        local content = _frame._mobContent
        if not content then return end
        content:SetWidth(_frame._mobScroll:GetWidth())

        local mobList = {}
        for guid, mob in pairs(CoADpsAndMobTracker_ActiveMobs) do
            table.insert(mobList, mob)
        end
        table.sort(mobList, function(a,b)
            return (a.threat or 0) > (b.threat or 0)
        end)

        local ROW_H = 26
        local rows  = _frame._mobRows
        for i, mob in ipairs(mobList) do
            if i > 12 then break end
            local row = rows[i]
            if not row then
                row = {}
                row.bg = content:CreateTexture(nil, "BACKGROUND")
                row.bg:SetHeight(ROW_H - 2)
                row.bg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
                row.hpFill = content:CreateTexture(nil, "BORDER")
                row.hpFill:SetHeight(4)
                row.hpFill:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
                row.name = content:CreateFontString(nil, "OVERLAY")
                row.name:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
                row.name:SetJustifyH("LEFT")
                row.hp = content:CreateFontString(nil, "OVERLAY")
                row.hp:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE")
                row.hp:SetJustifyH("RIGHT")
                row.threat = content:CreateFontString(nil, "OVERLAY")
                row.threat:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE")
                row.threat:SetJustifyH("LEFT")
                rows[i] = row
            end

            local yOff = -(i-1)*(ROW_H+2) - 2
            local W    = content:GetWidth() - 8

            local tc = ThreatColors[mob.threat or 0] or ThreatColors[0]

            row.bg:SetWidth(W)
            row.bg:SetPoint("TOPLEFT", content, "TOPLEFT", 4, yOff)
            row.bg:SetVertexColor(0.05,0.05,0.10,0.85)
            row.bg:Show()

            local hpPct = (mob.maxHp and mob.maxHp > 0)
                and math.max(0, math.min(1, mob.hp / mob.maxHp)) or 1

            if s.showMobHP then
                row.hpFill:SetWidth(math.max(2, W * hpPct))
                row.hpFill:SetPoint("BOTTOMLEFT", content, "BOTTOMLEFT", 4, -yOff - ROW_H + 1)
                local hr = hpPct > 0.6 and 0.15 or hpPct > 0.3 and 0.95 or 0.9
                local hg = hpPct > 0.6 and 0.85 or hpPct > 0.3 and 0.65 or 0.15
                row.hpFill:SetVertexColor(hr,hg,0.15,0.9)
                row.hpFill:Show()
            else
                row.hpFill:Hide()
            end

            row.name:SetPoint("LEFT", content, "LEFT", 8, yOff + (ROW_H/2) - 4)
            row.name:SetText(string.format("|cffFFFFFF%s|r", (mob.name or "?"):sub(1,18)))
            row.name:Show()

            local hpStr = string.format("|cffFFD700%d%%|r", math.ceil(hpPct * 100))
            local tgtStr = mob.target and mob.target ~= "None"
                and string.format(" → %s", mob.target:sub(1,10)) or ""
            row.hp:SetPoint("RIGHT", content, "RIGHT", -4, yOff + (ROW_H/2) - 4)
            row.hp:SetText(hpStr .. tgtStr)
            row.hp:Show()

            if s.showMobThreat then
                local THREAT_LABELS = { [0]="safe", [1]="volatile", [2]="pulling", [3]="AGGRO" }
                row.threat:SetPoint("LEFT", content, "LEFT", 8, yOff + 3)
                row.threat:SetText(tc.hex .. (THREAT_LABELS[mob.threat or 0] or "") .. "|r")
                row.threat:Show()
            else
                row.threat:SetText("")
            end
        end

        -- hide unused mob rows
        for i = #mobList + 1, #rows do
            local row = rows[i]
            if row then
                row.bg:Hide() row.hpFill:Hide()
                row.name:Hide() row.hp:Hide() row.threat:Hide()
            end
        end

    elseif activeTab == 3 then
        CoADpsAndMobTracker_UI.RefreshLog()

    elseif activeTab == 4 then
        -- Settings panel auto-refreshes via checkboxes
    end
end

-- ─────────────────────────────────────────────────────────────
-- Public API
-- ─────────────────────────────────────────────────────────────
function CoADpsAndMobTracker_UI.Build()
    if _frame then return end
    _frame = CreateMainFrame()

    -- Wire CLEU into log system
    local origEngine = CoADpsAndMobTracker_Engine.OnCLEU
    CoADpsAndMobTracker_Engine.OnCLEU = function(...)
        if origEngine then origEngine(...) end
        CoADpsAndMobTracker_UI.IngestCLEU(...)
    end

    local s = GetSettings()
    if s then
        _frame:SetAlpha(s.windowAlpha or 0.93)
        _frame:SetScale(s.windowScale or 1.0)
    end

    _frame:Show()
end

function CoADpsAndMobTracker_UI.Toggle()
    if not _frame then CoADpsAndMobTracker_UI.Build() return end
    if _frame:IsShown() then _frame:Hide() else _frame:Show() end
end

function CoADpsAndMobTracker_UI.Show()
    if not _frame then CoADpsAndMobTracker_UI.Build() return end
    _frame:Show()
end
