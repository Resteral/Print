-- ============================================================
-- COAlAbilityTrainer - PvP HUD System
--
-- A dynamic, premium real-time PvP tracker. Features:
--   1. Focus Castbar (for quick interrupts)
--   2. DR Tracker (Diminishing Returns on target/focus)
--   3. Trinket Tracker (Announces and tracks Medallion CD)
--   4. Incoming Dangerous Casts Alert (Flashes target casting)
-- ============================================================

CoAAT_PvPHUD = {}

local _frame = nil
local activeDRs = {}     -- [guid] = { [category] = { expires = GetTime() + 18, count = 1 } }
local trinketCDs = {}    -- [guid] = expiresTime
local incomingCasts = {} -- [guid] = spellName

-- Diminishing Return categories
local DR_CATEGORIES = {
    -- Stuns
    ["Kidney Shot"] = "stun", ["Cheap Shot"] = "stun", ["Hammer of Justice"] = "stun",
    ["Bash"] = "stun", ["Intercept"] = "stun", ["Shadowfury"] = "stun", ["Fel Stun"] = "stun",
    -- Fears
    ["Fear"] = "fear", ["Psychic Scream"] = "fear", ["Howl of Terror"] = "fear", ["Death Coil"] = "fear",
    -- Incapacitates / Poly
    ["Polymorph"] = "incap", ["Freezing Trap"] = "incap", ["Repentance"] = "incap", ["Gouge"] = "incap",
    -- Silences
    ["Silence"] = "silence", ["Counterspell"] = "silence", ["Spell Lock"] = "silence", ["Strangulate"] = "silence",
}

-- Dangerous PvP casts to alert
local DANGEROUS_SPELLS = {
    ["Polymorph"] = true, ["Fear"] = true, ["Cyclone"] = true,
    ["Chaos Bolt"] = true, ["Lava Burst"] = true, ["Aimed Shot"] = true,
    ["Pyroblast"] = true, ["Greater Heal"] = true, ["Divine Light"] = true,
    ["Penance"] = true, ["Hex"] = true, ["Vampiric Touch"] = true,
}

-- Trinket spells
local TRINKETS = {
    [59752] = "Every Man for Himself",
    [42292] = "Medallion of the Alliance",
    [59725] = "Medallion of the Horde",
    [7744]  = "Will of the Forsaken",
}

-- ─────────────────────────────────────────────────────────────
-- Init & Build
-- ─────────────────────────────────────────────────────────────
function CoAAT_PvPHUD.Build()
    if _frame then return end

    local f = CreateFrame("Frame", "CoAATPvPHUDFrame", UIParent)
    f:SetSize(280, 160)
    f:SetPoint("CENTER", UIParent, "CENTER", 180, 50)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local pt, _, _, x, y = self:GetPoint()
        if CoAAT_DB then
            CoAAT_DB.pvpHUDPos = { pt=pt, x=x, y=y }
        end
    end)

    if CoAAT_DB and CoAAT_DB.pvpHUDPos then
        local p = CoAAT_DB.pvpHUDPos
        f:SetPoint(p.pt or "CENTER", UIParent, p.pt or "CENTER", p.x or 180, p.y or 50)
    end

    -- Header / title (hideable)
    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    title:SetPoint("TOP", f, "TOP", 0, -4)
    title:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    title:SetText("|cff00ccff⚔ CoA PvP HUD ⚔|r")
    f._title = title

    -- Focus Castbar Container
    local fCast = CreateFrame("StatusBar", nil, f)
    fCast:SetSize(200, 16)
    fCast:SetPoint("TOP", f, "TOP", 0, -22)
    local fCastBG = fCast:CreateTexture(nil, "BACKGROUND")
    fCastBG:SetAllPoints()
    fCastBG:SetTexture(0.02, 0.02, 0.05, 0.8)
    local fCastTex = fCast:CreateTexture(nil, "ARTWORK")
    fCastTex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    fCast:SetStatusBarTexture(fCastTex)
    fCast:SetStatusBarColor(1, 0.5, 0, 0.85)

    local fCastLbl = fCast:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    fCastLbl:SetPoint("CENTER", fCast, "CENTER", 0, 0)
    fCastLbl:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    fCast:Hide()
    f._fCast = fCast
    f._fCastLbl = fCastLbl

    -- DR Display Row (left-aligned icon slots)
    local drFrames = {}
    for i = 1, 3 do
        local slot = CreateFrame("Frame", nil, f)
        slot:SetSize(28, 28)
        slot:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 12 + (i-1)*36, 12)
        local bg = slot:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        bg:SetTexture(0,0,0,0.5)
        local tex = slot:CreateTexture(nil, "ARTWORK")
        tex:SetAllPoints()
        tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        local lbl = slot:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        lbl:SetPoint("BOTTOM", slot, "BOTTOM", 0, -10)
        lbl:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")

        slot.tex = tex
        slot.lbl = lbl
        slot:Hide()
        drFrames[i] = slot
    end
    f._drFrames = drFrames

    -- Dangerous Cast Banner (Top Center floating)
    local alertBanner = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    alertBanner:SetPoint("BOTTOM", f, "TOP", 0, 16)
    alertBanner:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
    alertBanner:SetText("")
    f._alertBanner = alertBanner

    -- Border lines (soft purple accent)
    f._borderLines = {}
    local function MakeLine(p1, p2, w, h)
        local l = f:CreateTexture(nil, "OVERLAY")
        l:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
        l:SetVertexColor(0.5, 0.2, 0.9, 0.45)
        l:SetSize(w, h)
        l:SetPoint(p1, f, p2, 0, 0)
        table.insert(f._borderLines, l)
    end
    MakeLine("TOPLEFT", "TOPLEFT", 280, 1)
    MakeLine("BOTTOMLEFT", "BOTTOMLEFT", 280, 1)
    MakeLine("TOPLEFT", "TOPLEFT", 1, 160)
    MakeLine("TOPRIGHT", "TOPRIGHT", 1, 160)

    -- Auto-register for events
    f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    f:RegisterEvent("PLAYER_FOCUS_CHANGED")
    f:RegisterEvent("PLAYER_TARGET_CHANGED")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    f._manualToggle = false

    f:SetScript("OnEvent", function(self, event, ...)
        if event == "COMBAT_LOG_EVENT_UNFILTERED" then
            CoAAT_PvPHUD.OnCLEU(...)
        elseif event == "PLAYER_FOCUS_CHANGED" or event == "PLAYER_TARGET_CHANGED" then
            CoAAT_PvPHUD.UpdateFocusCast()
            CoAAT_PvPHUD.UpdateDRDisplay()
        elseif event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then
            local inInst, instType = IsInInstance()
            if inInst and (instType == "pvp" or instType == "arena") then
                self:Show()
                CoAAT_PvPHUD.UpdateDRDisplay()
            else
                if not self._manualToggle then
                    self:Hide()
                end
            end
        end
    end)

    f:SetScript("OnUpdate", function(self, elapsed)
        CoAAT_PvPHUD.OnUpdate(elapsed)
    end)

    f:Hide() -- hidden by default until BG/Arena or toggled
    _frame = f

    -- Sync class theme if active
    if CoAAT_Engine and CoAAT_Engine.ApplyClassTheme then
        CoAAT_Engine.ApplyClassTheme()
    end
end

-- ─────────────────────────────────────────────────────────────
-- Update Focus Castbar
-- ─────────────────────────────────────────────────────────────
function CoAAT_PvPHUD.UpdateFocusCast()
    local f = _frame
    if not f or not f:IsShown() then return end

    if UnitExists("focus") then
        local name, _, _, _, startTime, endTime, _, _, notInterruptible = UnitCastingInfo("focus")
        if name then
            local now = GetTime()
            f._fCast:SetMinMaxValues(startTime / 1000, endTime / 1000)
            f._fCast:SetValue(now)
            f._fCastLbl:SetText(string.format("Focus Casting: |cff00ffff%s|r", name))
            if notInterruptible then
                f._fCast:SetStatusBarColor(0.6, 0.6, 0.6, 0.85) -- grey if uninterruptible
            else
                f._fCast:SetStatusBarColor(1, 0.5, 0, 0.85) -- orange interruptible
            end
            f._fCast:Show()
            return
        end
    end
    f._fCast:Hide()
end

-- ─────────────────────────────────────────────────────────────
-- Event Handler: CLEU PvP triggers
-- ─────────────────────────────────────────────────────────────
function CoAAT_PvPHUD.OnCLEU(...)
    local ts, event, _, srcGUID, srcName, _, _, destGUID, destName, _, _, spellId, spellName = ...
    local now = GetTime()

    -- 1. CC Applied: track DR
    if event == "SPELL_AURA_APPLIED" and DR_CATEGORIES[spellName] then
        local cat = DR_CATEGORIES[spellName]
        if not activeDRs[destGUID] then activeDRs[destGUID] = {} end
        local dr = activeDRs[destGUID][cat] or { expires = 0, count = 0 }
        dr.count = math.min(3, dr.count + 1)
        dr.expires = now + 18 -- WotLK DR time is 18 seconds
        dr.spellName = spellName
        activeDRs[destGUID][cat] = dr

        if destGUID == UnitGUID("target") or destGUID == UnitGUID("focus") then
            CoAAT_PvPHUD.UpdateDRDisplay()
        end
    end

    -- 2. CC Removed: refresh display
    if event == "SPELL_AURA_REMOVED" and DR_CATEGORIES[spellName] then
        if destGUID == UnitGUID("target") or destGUID == UnitGUID("focus") then
            CoAAT_PvPHUD.UpdateDRDisplay()
        end
    end

    -- 3. Medallion/Trinket used
    if event == "SPELL_CAST_SUCCESS" and TRINKETS[spellId] then
        trinketCDs[srcGUID] = now + 120 -- PvP Medallion is 2min CD
        if _frame and _frame._alertBanner then
            _frame._alertBanner:SetText(string.format("|cffff2222★ PvP Medallion:|r %s used trinket!", srcName or "Enemy"))
            UIFrameFadeOut(_frame._alertBanner, 4.0, 1.0, 0)
        end
    end

    -- 4. Dangerous Cast Alerts
    if event == "SPELL_CAST_START" and DANGEROUS_SPELLS[spellName] then
        -- Alert if targeting you or a group member
        if destGUID == UnitGUID("player") or (destName and (UnitInParty(destName) or UnitInRaid(destName))) then
            if _frame and _frame._alertBanner then
                _frame._alertBanner:SetText(string.format("|cffffaa00⚡ INCOMING CC:|r %s casting |cff00ffff%s|r!", srcName or "Enemy", spellName))
                PlaySound("RaidWarning") -- Warn sound (WotLK safe format)
                UIFrameFadeOut(_frame._alertBanner, 3.0, 1.0, 0)
            end
        end
    end
end

-- ─────────────────────────────────────────────────────────────
-- Update DR Icon display
-- ─────────────────────────────────────────────────────────────
function CoAAT_PvPHUD.UpdateDRDisplay()
    local f = _frame
    if not f or not f:IsShown() then return end

    local targetGUID = UnitGUID("target")
    if not targetGUID then
        for i = 1, 3 do f._drFrames[i]:Hide() end
        return
    end

    local drs = activeDRs[targetGUID]
    local now = GetTime()
    local i = 0

    if drs then
        for cat, data in pairs(drs) do
            if now < data.expires then
                i = i + 1
                if i > 3 then break end
                local slot = f._drFrames[i]
                local rem = math.floor(data.expires - now)
                
                -- Set CC texture based on category
                local tex = "Interface\\Icons\\Spell_Nature_StunSelf"
                if cat == "fear" then tex = "Interface\\Icons\\Spell_Shadow_Possession"
                elseif cat == "incap" then tex = "Interface\\Icons\\Spell_Nature_Polymorph"
                elseif cat == "silence" then tex = "Interface\\Icons\\Spell_Shadow_Silence"
                end
                
                slot.tex:SetTexture(tex)
                local mult = (data.count == 1) and "1/2" or (data.count == 2 and "1/4" or "IMMUNE")
                slot.lbl:SetText(string.format("|cfffff000%ds (%s)|r", rem, mult))
                slot:Show()
            end
        end
    end

    -- Hide unused slots
    for j = i + 1, 3 do
        f._drFrames[j]:Hide()
    end
end

-- ─────────────────────────────────────────────────────────────
-- Tick Update
-- ─────────────────────────────────────────────────────────────
function CoAAT_PvPHUD.OnUpdate(dt)
    CoAAT_PvPHUD.UpdateFocusCast()

    -- Periodically update DR timers
    local now = GetTime()
    local targetGUID = UnitGUID("target")
    if targetGUID and activeDRs[targetGUID] then
        CoAAT_PvPHUD.UpdateDRDisplay()
    end
end

-- ─────────────────────────────────────────────────────────────
-- Toggle Visibility
-- ─────────────────────────────────────────────────────────────
function CoAAT_PvPHUD.Toggle()
    if not _frame then
        CoAAT_PvPHUD.Build()
    end
    if _frame:IsShown() then
        _frame:Hide()
        _frame._manualToggle = false
    else
        _frame:Show()
        _frame._manualToggle = true
        CoAAT_PvPHUD.UpdateDRDisplay()
        print("|cff00ccff[CoAAT] PvP HUD Frame shown. Move by dragging from the header.|r")
    end
end

-- ─────────────────────────────────────────────────────────────
-- Class theme styling relay
-- ─────────────────────────────────────────────────────────────
function CoAAT_PvPHUD.ApplyTheme(r, g, b, hex)
    local f = _frame
    if not f then return end
    if f._borderLines then
        for _, line in ipairs(f._borderLines) do
            line:SetVertexColor(r, g, b, 0.45)
        end
    end
end
