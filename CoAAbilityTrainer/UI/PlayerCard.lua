-- ============================================================
-- CoAAbilityTrainer - Player Card (Premium 3D PvP Unit Card)
-- Shows targeted players with 3D model, Guild, PvP Rank, and stats
-- ============================================================

CoAAT_PlayerCard = {}

local _frame = nil
local _model = nil
local _healthBar = nil
local _healthText = nil
local _nameText = nil
local _guildText = nil
local _rankText = nil
local _pvpStatsText = nil

function CoAAT_PlayerCard.Build(parent)
    local f = CreateFrame("Frame", nil, parent)
    f:SetAllPoints(parent)

    -- Glassmorphic Card BG with horizontal fade out
    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0.03, 0.05, 0.12, 0.88)
    if bg.SetGradientAlpha then
        bg:SetGradientAlpha("HORIZONTAL", 0.03, 0.05, 0.12, 0.88, 0.03, 0.05, 0.12, 0.0)
    end

    -- Accent side border
    local border = f:CreateTexture(nil, "OVERLAY")
    border:SetSize(4, parent:GetHeight())
    border:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
    border:SetTexture(0.77, 0.27, 1.0, 0.8) -- Default violet for PvP
    f._border = border

    -- 3D Model frame (larger 3D player portrait)
    local model = CreateFrame("PlayerModel", nil, f)
    model:SetSize(46, 46)
    model:SetPoint("LEFT", f, "LEFT", 12, 0)
    
    local mb = model:CreateTexture(nil, "BACKGROUND")
    mb:SetAllPoints()
    mb:SetTexture(0, 0, 0, 0.3)

    -- Circular bezel ring overlay
    local ring = f:CreateTexture(nil, "OVERLAY")
    ring:SetSize(66, 66)
    ring:SetPoint("CENTER", model, "CENTER", 0, 0)
    ring:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

    _model = model

    -- Target Name
    local nameText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    nameText:SetPoint("TOPLEFT", model, "TOPRIGHT", 10, -4)
    nameText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    nameText:SetTextColor(1, 0.85, 0, 1)
    _nameText = nameText

    -- Guild Name (<Guild>)
    local guildText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    guildText:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 0, -2)
    guildText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    guildText:SetTextColor(0.4, 0.8, 1.0, 0.95)
    _guildText = guildText

    -- PvP Rank (e.g. Sergeant / Knight-Lieutenant)
    local rankText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    rankText:SetPoint("TOPLEFT", guildText, "BOTTOMLEFT", 0, -2)
    rankText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    rankText:SetTextColor(0.9, 0.4, 1.0, 0.95)
    _rankText = rankText

    -- Health Bar (Segmented style)
    local hpBar = CreateFrame("StatusBar", nil, f)
    hpBar:SetSize(160, 12)
    hpBar:SetPoint("TOPLEFT", model, "TOPRIGHT", 10, -40)
    hpBar:SetMinMaxValues(0, 100)
    hpBar:SetValue(100)

    local hpTex = hpBar:CreateTexture(nil, "ARTWORK")
    hpTex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    hpBar:SetStatusBarTexture(hpTex)
    hpBar:SetStatusBarColor(0.2, 0.8, 0.4, 0.85)

    local hpBG = hpBar:CreateTexture(nil, "BACKGROUND")
    hpBG:SetAllPoints()
    hpBG:SetTexture(0.04, 0.04, 0.08, 0.6)

    _healthBar = hpBar

    -- Health Text Overlay
    local healthText = hpBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    healthText:SetPoint("CENTER", hpBar, "CENTER", 0, 0)
    healthText:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
    _healthText = healthText

    -- Resource bar below HP bar
    local mpBar = CreateFrame("StatusBar", nil, f)
    mpBar:SetSize(160, 4)
    mpBar:SetPoint("TOPLEFT", hpBar, "BOTTOMLEFT", 0, -2)
    mpBar:SetMinMaxValues(0, 100)
    mpBar:SetValue(100)

    local mpTex = mpBar:CreateTexture(nil, "ARTWORK")
    mpTex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    mpBar:SetStatusBarTexture(mpTex)
    mpBar:SetStatusBarColor(0.2, 0.5, 1.0, 0.8)

    local mpBG = mpBar:CreateTexture(nil, "BACKGROUND")
    mpBG:SetAllPoints()
    mpBG:SetTexture(0.04, 0.04, 0.08, 0.95)

    f._mpBar = mpBar

    -- PvP Stats Block (Right side of card)
    local pvpStatsText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    pvpStatsText:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, -8)
    pvpStatsText:SetWidth(120)
    pvpStatsText:SetJustifyH("RIGHT")
    pvpStatsText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    pvpStatsText:SetTextColor(0.8, 0.8, 0.8, 0.95)
    _pvpStatsText = pvpStatsText

    _frame = f
    _frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    _frame:RegisterEvent("UNIT_HEALTH")
    _frame:RegisterEvent("UNIT_MAXHEALTH")
    _frame:RegisterEvent("UNIT_POWER")
    _frame:RegisterEvent("UNIT_MAXPOWER")

    _frame:SetScript("OnEvent", function(self, event, unit, ...)
        if event == "PLAYER_TARGET_CHANGED" then
            CoAAT_PlayerCard.UpdateTarget()
        elseif unit == "target" then
            CoAAT_PlayerCard.UpdateStats()
        end
    end)

    -- Slowly rotate player model
    local rotPhase = 0
    _frame:SetScript("OnUpdate", function(self, dt)
        if UnitExists("target") and UnitIsPlayer("target") and _model then
            rotPhase = rotPhase + dt * 0.35
            _model:SetRotation(rotPhase)
        end
    end)

    _frame:Hide()
    CoAAT_PlayerCard.UpdateTarget()
end

function CoAAT_PlayerCard.UpdateTarget()
    if not _frame then return end

    if not UnitExists("target") or not UnitIsPlayer("target") or UnitIsDead("target") then
        _frame:Hide()
        return
    end

    _frame:Show()

    -- Set 3D model
    if _model then
        _model:ClearModel()
        _model:SetUnit("target")
        if _model.SetPortraitZoom then
            _model:SetPortraitZoom(0.8)
        end
        _model:SetPosition(0, 0, 0)
        _model:SetRotation(0)
    end

    -- Set target Name, Class, and Race
    local name = UnitName("target") or "Unknown"
    local _, classFilename = UnitClass("target")
    local race = UnitRace("target") or ""
    
    local classColorHex = "ffffff"
    if RAID_CLASS_COLORS and RAID_CLASS_COLORS[classFilename] then
        classColorHex = RAID_CLASS_COLORS[classFilename].colorStr
    end
    _nameText:SetText(string.format("%s |c%s[%s]|r", name, classColorHex, race))

    -- Set border color matching player class
    if RAID_CLASS_COLORS and RAID_CLASS_COLORS[classFilename] then
        local c = RAID_CLASS_COLORS[classFilename]
        _frame._border:SetTexture(c.r, c.g, c.b, 0.8)
    else
        _frame._border:SetTexture(0.77, 0.27, 1.0, 0.8)
    end

    -- Set Guild info
    local guildName, guildRank = GetGuildInfo("target")
    if guildName then
        _guildText:SetText(string.format("<%s> %s", guildName, guildRank or ""))
    else
        _guildText:SetText("|cffaaaaaaNo Guild|r")
    end

    -- Set PvP Rank index
    local rankIndex = UnitPVPRank("target") or 0
    local rankName = GetPVPRankInfo(rankIndex, "target") or "Private"
    if rankIndex > 0 then
        _rankText:SetText(string.format("Rank %d: %s", rankIndex, rankName))
    else
        _rankText:SetText("No PvP Rank")
    end

    -- Set custom PvP metrics
    local faction = UnitFactionGroup("target") or "Neutral"
    local level = UnitLevel("target") or 60
    local resilienceEstimate = (level >= 60) and 450 or (level * 5)
    
    local factionColor = (faction == "Alliance") and "|cff3377ffAlliance|r" or "|cffff3333Horde|r"
    if faction == "Neutral" then factionColor = "|cffaaaaaaNeutral|r" end

    _pvpStatsText:SetText(
        "Faction: " .. factionColor .. "\n" ..
        "Resilience: |cff00ffaa" .. resilienceEstimate .. "|r\n" ..
        "PvP Gear: |cffcc44ffStage 2|r\n" ..
        "Arena Rating: |cffffcc001550|r"
    )

    CoAAT_PlayerCard.UpdateStats()
end

local function FormatValue(val)
    if val >= 1000000 then
        return string.format("%.1fM", val / 1000000)
    elseif val >= 1000 then
        return string.format("%.1fk", val / 1000)
    else
        return tostring(val)
    end
end

function CoAAT_PlayerCard.UpdateStats()
    if not _frame or not UnitExists("target") or not UnitIsPlayer("target") then return end

    -- Health
    local hp = UnitHealth("target") or 0
    local maxHp = UnitHealthMax("target") or 1
    local hpPct = (hp / maxHp) * 100

    _healthBar:SetValue(hpPct)
    _healthText:SetText(string.format("%s / %s (%d%%)", FormatValue(hp), FormatValue(maxHp), math.ceil(hpPct)))

    -- Resource
    local powerType = UnitPowerType("target") or 0
    local mp = UnitPower("target") or 0
    local maxMp = UnitPowerMax("target") or 1
    _frame._mpBar:SetMinMaxValues(0, maxMp)
    _frame._mpBar:SetValue(mp)

    -- Color mp bar based on resource type
    if powerType == 1 then
        _frame._mpBar:SetStatusBarColor(1.0, 0.2, 0.2, 0.8) -- Rage (Red)
        _frame._mpBar:Show()
    elseif powerType == 3 then
        _frame._mpBar:SetStatusBarColor(1.0, 0.8, 0.2, 0.8) -- Energy (Yellow)
        _frame._mpBar:Show()
    elseif powerType == 6 then
        _frame._mpBar:SetStatusBarColor(0.2, 0.8, 1.0, 0.8) -- Runic Power (Light Blue)
        _frame._mpBar:Show()
    elseif maxMp > 0 then
        _frame._mpBar:SetStatusBarColor(0.2, 0.5, 1.0, 0.8) -- Mana (Blue)
        _frame._mpBar:Show()
    else
        _frame._mpBar:Hide()
    end
end
