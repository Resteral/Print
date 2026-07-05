-- ============================================================
-- CoAAbilityTrainer - Cursor HUD (Attach Health & Buffs to Cursor)
-- Sleek double-bracket vital bars and cast tracker framing the cursor
-- ============================================================

CoAAT_CursorHUD = {}

local _frame = nil
local _healthBar = nil
local _mpBar = nil
local _castBar = nil
local _buffs = {}

function CoAAT_CursorHUD.Build(parent)
    local f = CreateFrame("Frame", "CoAATCursorHUDFrame", UIParent)
    f:SetSize(40, 40)
    f:SetFrameStrata("TOOLTIP")

    -- Left Bracket: Health bar (Vertical)
    local hp = CreateFrame("StatusBar", nil, f)
    hp:SetSize(4, 30)
    hp:SetPoint("RIGHT", f, "CENTER", -16, 0)
    hp:SetOrientation("VERTICAL")
    hp:SetMinMaxValues(0, 100)
    hp:SetValue(100)

    local hpTex = hp:CreateTexture(nil, "ARTWORK")
    hpTex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    hp:SetStatusBarTexture(hpTex)
    hp:SetStatusBarColor(0.2, 0.8, 0.4, 0.9)

    local hpBG = hp:CreateTexture(nil, "BACKGROUND")
    hpBG:SetAllPoints()
    hpBG:SetTexture(0, 0, 0, 0.6)

    _healthBar = hp

    -- Right Bracket: Resource bar (Vertical)
    local mp = CreateFrame("StatusBar", nil, f)
    mp:SetSize(4, 30)
    mp:SetPoint("LEFT", f, "CENTER", 16, 0)
    mp:SetOrientation("VERTICAL")
    mp:SetMinMaxValues(0, 100)
    mp:SetValue(100)

    local mpTex = mp:CreateTexture(nil, "ARTWORK")
    mpTex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    mp:SetStatusBarTexture(mpTex)
    mp:SetStatusBarColor(0.2, 0.5, 1.0, 0.9)

    local mpBG = mp:CreateTexture(nil, "BACKGROUND")
    mpBG:SetAllPoints()
    mpBG:SetTexture(0, 0, 0, 0.6)

    _mpBar = mp

    -- Center Bottom: Cast Bar (Horizontal)
    local cast = CreateFrame("StatusBar", nil, f)
    cast:SetSize(30, 3)
    cast:SetPoint("TOP", f, "BOTTOM", 0, -10)
    cast:SetMinMaxValues(0, 100)
    cast:SetValue(0)
    cast:Hide()

    local castTex = cast:CreateTexture(nil, "ARTWORK")
    castTex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    cast:SetStatusBarTexture(castTex)
    cast:SetStatusBarColor(1.0, 0.7, 0.0, 0.95)

    local castBG = cast:CreateTexture(nil, "BACKGROUND")
    castBG:SetAllPoints()
    castBG:SetTexture(0, 0, 0, 0.7)

    _castBar = cast

    -- Buff icons (up to 3 small square icons below the cast bar position)
    for i = 1, 3 do
        local icon = f:CreateTexture(nil, "OVERLAY")
        icon:SetSize(8, 8)
        icon:SetPoint("BOTTOM", f, "TOP", (i - 2) * 10, 10)
        icon:SetTexture("Interface\\Icons\\Spell_Nature_Rejuvenation")
        icon:Hide()
        _buffs[i] = icon
    end

    _frame = f

    -- Events for casting
    _frame:RegisterEvent("UNIT_SPELLCAST_START")
    _frame:RegisterEvent("UNIT_SPELLCAST_STOP")
    _frame:RegisterEvent("UNIT_SPELLCAST_FAILED")
    _frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
    _frame:RegisterEvent("UNIT_SPELLCAST_DELAYED")
    _frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
    _frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
    _frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")

    local isCasting, isChanneling = false, false
    local castStart, castEnd = 0, 0

    _frame:SetScript("OnEvent", function(self, event, unit, ...)
        if unit ~= "player" then return end

        if event == "UNIT_SPELLCAST_START" then
            local _, _, _, startTime, endTime = UnitCastingInfo("player")
            if startTime and endTime then
                castStart = startTime / 1000
                castEnd = endTime / 1000
                isCasting = true
                isChanneling = false
                _castBar:SetMinMaxValues(0, castEnd - castStart)
                _castBar:Show()
            end
        elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
            local _, _, _, startTime, endTime = UnitChannelInfo("player")
            if startTime and endTime then
                castStart = startTime / 1000
                castEnd = endTime / 1000
                isCasting = false
                isChanneling = true
                _castBar:SetMinMaxValues(0, castEnd - castStart)
                _castBar:Show()
            end
        elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" then
            isCasting = false
            _castBar:Hide()
        elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" then
            isChanneling = false
            _castBar:Hide()
        elseif event == "UNIT_SPELLCAST_DELAYED" then
            local _, _, _, startTime, endTime = UnitCastingInfo("player")
            if startTime and endTime then
                castStart = startTime / 1000
                castEnd = endTime / 1000
            end
        elseif event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
            local _, _, _, startTime, endTime = UnitChannelInfo("player")
            if startTime and endTime then
                castStart = startTime / 1000
                castEnd = endTime / 1000
            end
        end
    end)

    -- Update loop
    _frame:SetScript("OnUpdate", function(self, dt)
        if not CoAAT_DB or not CoAAT_DB.showCursorHUD then
            self:Hide()
            return
        end

        -- Check if dead or out of combat (optional hide)
        if UnitIsDeadOrGhost("player") then
            self:SetAlpha(0)
            return
        else
            self:SetAlpha(1)
        end

        -- Attach to cursor (perfect centering)
        local x, y = GetCursorPosition()
        local scale = UIParent:GetEffectiveScale()
        if scale > 0 then
            self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale, y / scale)
        end

        -- Update stats
        local hpVal = UnitHealth("player") or 0
        local maxHp = UnitHealthMax("player") or 1
        _healthBar:SetValue((hpVal / maxHp) * 100)

        -- Change color based on health status
        local hpPct = (hpVal / maxHp) * 100
        if hpPct > 50 then
            _healthBar:SetStatusBarColor(0.2, 0.8, 0.4, 0.9) -- Green
        elseif hpPct > 20 then
            _healthBar:SetStatusBarColor(1.0, 0.6, 0.0, 0.9) -- Orange
        else
            _healthBar:SetStatusBarColor(1.0, 0.2, 0.2, 0.9) -- Red
        end

        local powerType = UnitPowerType("player") or 0
        local mpVal = UnitPower("player") or 0
        local maxMp = UnitPowerMax("player") or 1
        _mpBar:SetMinMaxValues(0, maxMp)
        _mpBar:SetValue(mpVal)

        -- Resource color
        if powerType == 1 then
            _mpBar:SetStatusBarColor(1.0, 0.2, 0.2, 0.9)
        elseif powerType == 3 then
            _mpBar:SetStatusBarColor(1.0, 0.8, 0.2, 0.9)
        elseif powerType == 6 then
            _mpBar:SetStatusBarColor(0.2, 0.8, 1.0, 0.9)
        else
            _mpBar:SetStatusBarColor(0.2, 0.5, 1.0, 0.9)
        end

        -- Update Cast Bar progress
        if isCasting then
            local remaining = castEnd - GetTime()
            local elapsed = (castEnd - castStart) - remaining
            _castBar:SetValue(elapsed)
        elseif isChanneling then
            local remaining = castEnd - GetTime()
            _castBar:SetValue(remaining)
        end

        -- Scan player buffs/procs to display
        local buffIndex = 1
        for i = 1, 3 do _buffs[i]:Hide() end

        for i = 1, 40 do
            local name, _, icon = UnitBuff("player", i)
            if not name then break end
            
            -- Show important buffs/procs
            if icon and (name:find("Felfury") or name:find("proc") or name:find("Glow") or name:find("Empower") or name:find("Surge") or name:find("Presence") or name:find("Frenzy")) then
                if _buffs[buffIndex] then
                    _buffs[buffIndex]:SetTexture(icon)
                    _buffs[buffIndex]:Show()
                    buffIndex = buffIndex + 1
                    if buffIndex > 3 then break end
                end
            end
        end
    end)

    f:Hide()
    CoAAT_CursorHUD.Refresh()
end

function CoAAT_CursorHUD.Refresh()
    if not _frame then return end
    if CoAAT_DB and CoAAT_DB.showCursorHUD then
        _frame:Show()
    else
        _frame:Hide()
    end
end
