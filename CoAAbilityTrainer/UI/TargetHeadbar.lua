-- ============================================================
-- CoAAbilityTrainer - Target Headbar (Sleek 3D Animated Target Frame)
-- Shows rotating 3D animated mob head, health, classification
-- ============================================================

CoAAT_TargetHeadbar = {}

local _frame = nil
local _model = nil
local _healthBar = nil
local _healthText = nil
local _nameText = nil
local _classifText = nil

local function FindTargetNameplate()
    if not UnitExists("target") then return nil end
    local targetName = UnitName("target")
    if not targetName then return nil end

    local kids = { WorldFrame:GetChildren() }
    for _, frame in ipairs(kids) do
        if frame:IsShown() and not frame:GetName() then
            local regions = { frame:GetRegions() }
            for _, region in ipairs(regions) do
                if region:GetObjectType() == "FontString" and region:GetText() == targetName then
                    return frame
                end
            end
        end
    end
    return nil
end

function CoAAT_TargetHeadbar.Build(parent)
    local f = CreateFrame("Frame", nil, parent)
    f:SetSize(400, 44)
    f:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)

    -- Glassmorphic BG with horizontal fade out (near transparent to prevent box lines)
    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0.03, 0.05, 0.12, 0.05)
    if bg.SetGradientAlpha then
        bg:SetGradientAlpha("HORIZONTAL", 0.03, 0.05, 0.12, 0.05, 0.03, 0.05, 0.12, 0.0)
    end

    -- Accent side border (Left side)
    local border = f:CreateTexture(nil, "OVERLAY")
    border:SetSize(4, parent:GetHeight())
    border:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
    border:SetTexture(1.0, 0.2, 0.2, 0.8) -- Default Hostile Red
    f._border = border

    -- 3D Model frame
    local model = CreateFrame("PlayerModel", nil, f)
    model:SetSize(36, 36)
    model:SetPoint("LEFT", f, "LEFT", 10, 0)
    
    -- Model background border (fully transparent)
    local mb = model:CreateTexture(nil, "BACKGROUND")
    mb:SetAllPoints()
    mb:SetTexture(0.0, 0.0, 0.0, 0.0)

    -- Circular bezel ring overlay
    local ring = f:CreateTexture(nil, "OVERLAY")
    ring:SetSize(54, 54)
    ring:SetPoint("CENTER", model, "CENTER", 0, 0)
    ring:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

    _model = model

    -- Health bar (segmented style, anchored directly to f to prevent model scaling inheritance)
    local hpBar = CreateFrame("StatusBar", nil, f)
    hpBar:SetSize(parent:GetWidth() - 68, 14)
    hpBar:SetPoint("LEFT", f, "LEFT", 60, 4)
    hpBar:SetMinMaxValues(0, 100)
    hpBar:SetValue(100)

    local hpTex = hpBar:CreateTexture(nil, "ARTWORK")
    hpTex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground") -- premium flat texture
    hpBar:SetStatusBarTexture(hpTex)
    hpBar:SetStatusBarColor(0.2, 0.8, 0.4, 0.85)

    local hpBG = hpBar:CreateTexture(nil, "BACKGROUND")
    hpBG:SetAllPoints()
    hpBG:SetTexture(0.04, 0.04, 0.08, 0.6)

    _healthBar = hpBar

    -- Target Name
    local nameText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nameText:SetPoint("BOTTOMLEFT", hpBar, "TOPLEFT", 0, 2)
    nameText:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    nameText:SetTextColor(1, 1, 1, 0.95)
    _nameText = nameText

    -- Classification (Elite / Boss / Rare)
    local classifText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    classifText:SetPoint("LEFT", nameText, "RIGHT", 6, 0)
    classifText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    _classifText = classifText

    -- Health Text Overlay
    local healthText = hpBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    healthText:SetPoint("CENTER", hpBar, "CENTER", 0, 0)
    healthText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    _healthText = healthText

    -- Resource bar (Mana/Energy/Rage) below HP bar
    local mpBar = CreateFrame("StatusBar", nil, f)
    mpBar:SetSize(parent:GetWidth() - 68, 5)
    mpBar:SetPoint("TOPLEFT", hpBar, "BOTTOMLEFT", 0, -3)
    mpBar:SetMinMaxValues(0, 100)
    mpBar:SetValue(100)

    local mpTex = mpBar:CreateTexture(nil, "ARTWORK")
    mpTex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    mpBar:SetStatusBarTexture(mpTex)
    mpBar:SetStatusBarColor(0.2, 0.5, 1.0, 0.8)

    local mpBG = mpBar:CreateTexture(nil, "BACKGROUND")
    mpBG:SetAllPoints()
    mpBG:SetTexture(0.04, 0.04, 0.08, 0.6)

    f._mpBar = mpBar

    -- Create Buff and Debuff icons under the frame
    local buffFrames = {}
    local debuffFrames = {}
    for i = 1, 8 do
        -- Buffs
        local b = CreateFrame("Frame", nil, f)
        b:SetSize(15, 15)
        if i == 1 then
            b:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 10, -5)
        else
            b:SetPoint("LEFT", buffFrames[i-1], "RIGHT", 4, 0)
        end
        local bTex = b:CreateTexture(nil, "ARTWORK")
        bTex:SetAllPoints()
        b.tex = bTex
        local bCount = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        bCount:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 2, -2)
        bCount:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
        b.count = bCount
        b:Hide()
        buffFrames[i] = b

        -- Debuffs
        local d = CreateFrame("Frame", nil, f)
        d:SetSize(15, 15)
        if i == 1 then
            d:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 10, -22)
        else
            d:SetPoint("LEFT", debuffFrames[i-1], "RIGHT", 4, 0)
        end
        local dTex = d:CreateTexture(nil, "ARTWORK")
        dTex:SetAllPoints()
        d.tex = dTex
        local dCount = d:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        dCount:SetPoint("BOTTOMRIGHT", d, "BOTTOMRIGHT", 2, -2)
        dCount:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
        d.count = dCount
        d:Hide()
        debuffFrames[i] = d
    end
    f._buffs = buffFrames
    f._debuffs = debuffFrames

    _frame = f
    _frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    _frame:RegisterEvent("UNIT_HEALTH")
    _frame:RegisterEvent("UNIT_MAXHEALTH")
    _frame:RegisterEvent("UNIT_POWER")
    _frame:RegisterEvent("UNIT_MAXPOWER")
    _frame:RegisterEvent("UNIT_AURA")

    _frame:SetScript("OnEvent", function(self, event, unit, ...)
        if event == "PLAYER_TARGET_CHANGED" then
            CoAAT_TargetHeadbar.UpdateTarget()
        elseif unit == "target" then
            if event == "UNIT_AURA" then
                CoAAT_TargetHeadbar.UpdateAuras()
            else
                CoAAT_TargetHeadbar.UpdateStats()
            end
        end
    end)

    -- Animate the 3D model and handle nameplate snap attachment
    local rotPhase = 0
    local timeSinceLast = 0
    _frame:SetScript("OnUpdate", function(self, dt)
        if UnitExists("target") and _model then
            rotPhase = rotPhase + dt * 0.4
            _model:SetRotation(rotPhase)
        end

        -- Snap position next to 3D Nameplate if target exists and option is enabled
        timeSinceLast = timeSinceLast + dt
        if timeSinceLast >= 0.05 then
            timeSinceLast = 0
            if CoAAT_DB and CoAAT_DB.attachToNameplate ~= false then
                local np = FindTargetNameplate()
                if np then
                    self:ClearAllPoints()
                    self:SetPoint("LEFT", np, "RIGHT", 15, 0)
                else
                    self:ClearAllPoints()
                    self:SetAllPoints(parent)
                end
            else
                self:ClearAllPoints()
                self:SetAllPoints(parent)
            end
        end
    end)

    _frame:Hide()
    CoAAT_TargetHeadbar.UpdateTarget()
end

function CoAAT_TargetHeadbar.UpdateTarget()
    if not _frame then return end

    if not UnitExists("target") or UnitIsDead("target") then
        _frame:Hide()
        return
    end

    _frame:Show()

    -- Set 3D model unit target
    if _model then
        _model:ClearModel()
        _model:SetUnit("target")
        if _model.SetPortraitZoom then
            _model:SetPortraitZoom(0.85) -- zoom on head/shoulders
        end
        _model:SetPosition(0, 0, 0)
        _model:SetRotation(0)
    end

    -- Set Target Name
    local name = UnitName("target") or "Unknown"
    local level = UnitLevel("target") or 0
    if level == -1 then level = "??" end

    local borderR, borderG, borderB = 0, 0.75, 1.0
    if UnitIsPlayer("target") then
        local _, classFilename = UnitClass("target")
        local classColorHex = "ffffff"
        if classFilename and RAID_CLASS_COLORS[classFilename] then
            local c = RAID_CLASS_COLORS[classFilename]
            borderR, borderG, borderB = c.r, c.g, c.b
            classColorHex = c.colorStr
        end
        local race = UnitRace("target") or ""
        _nameText:SetText(string.format("%s |c%s[%s]|r (Lvl %s)", name, classColorHex, race, level))
    else
        local reaction = UnitReaction("target", "player")
        if reaction then
            if reaction <= 3 then
                borderR, borderG, borderB = 1.0, 0.2, 0.2
            elseif reaction == 4 then
                borderR, borderG, borderB = 1.0, 0.8, 0.0
            else
                borderR, borderG, borderB = 0.2, 0.8, 0.4
            end
        end
        _nameText:SetText(string.format("%s (Lvl %s)", name, level))
    end
    _frame._border:SetTexture(borderR, borderG, borderB, 0.8)

    -- Set Classification
    local classif = UnitClassification("target")
    if classif == "worldboss" then
        _classifText:SetText("|cffff0000[BOSS]|r")
    elseif classif == "elite" or classif == "rareelite" then
        _classifText:SetText("|cffffcc00[ELITE]|r")
    elseif classif == "rare" then
        _classifText:SetText("|cff00ffff[RARE]|r")
    else
        _classifText:SetText("")
    end

    CoAAT_TargetHeadbar.UpdateStats()
    CoAAT_TargetHeadbar.UpdateAuras()
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

function CoAAT_TargetHeadbar.UpdateStats()
    if not _frame or not UnitExists("target") then return end

    -- Health
    local hp = UnitHealth("target") or 0
    local maxHp = UnitHealthMax("target") or 1
    local hpPct = (hp / maxHp) * 100

    _healthBar:SetValue(hpPct)
    _healthText:SetText(string.format("%s / %s (%d%%)", FormatValue(hp), FormatValue(maxHp), math.ceil(hpPct)))

    -- Change color based on health status
    if hpPct > 50 then
        _healthBar:SetStatusBarColor(0.2, 0.8, 0.4, 0.85) -- Green
    elseif hpPct > 20 then
        _healthBar:SetStatusBarColor(1.0, 0.6, 0.0, 0.85) -- Orange
    else
        _healthBar:SetStatusBarColor(1.0, 0.2, 0.2, 0.85) -- Red
    end

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

function CoAAT_TargetHeadbar.UpdateAuras()
    if not _frame or not UnitExists("target") then return end

    -- Update Buffs
    for i = 1, 8 do
        local name, _, icon, count = UnitBuff("target", i)
        local frame = _frame._buffs[i]
        if name and frame then
            frame.tex:SetTexture(icon)
            if count and count > 1 then
                frame.count:SetText(count)
            else
                frame.count:SetText("")
            end
            frame:Show()
        elseif frame then
            frame:Hide()
        end
    end

    -- Update Debuffs
    for i = 1, 8 do
        local name, _, icon, count = UnitDebuff("target", i)
        local frame = _frame._debuffs[i]
        if name and frame then
            frame.tex:SetTexture(icon)
            if count and count > 1 then
                frame.count:SetText(count)
            else
                frame.count:SetText("")
            end
            frame:Show()
        elseif frame then
            frame:Hide()
        end
    end
end
