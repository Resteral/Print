-- ============================================================
-- CoAAbilityTrainer - Mob Info HUD
-- Appears above the targeted mob's nameplate showing:
--   • Estimated XP gain
--   • Active quest info (kill/item needed)
--   • High-tier notable drops
--   • Class-specific escape tips
-- ============================================================

CoAAT_MobInfoHUD = {}

local _frame     = nil
local _lastUnit  = nil
local UPDATE_FREQ = 0.25   -- seconds between full refreshes
local _elapsed   = 0

-- ─────────────────────────────────────────────────────────────
-- Notable Drop Database  (mob name lowercase → list of drops)
-- Add entries as CoA releases new content
-- ─────────────────────────────────────────────────────────────
local NOTABLE_DROPS = {
    -- Vault of the Inquisition
    ["inquisitor valdris"]    = { "|cffFF8C00[Valdris's Inquisitor Cowl]|r", "|cff1EFF00[Sigil of the Fallen Creed]|r" },
    ["warden of the vault"]   = { "|cff1EFF00[Vault Keeper's Chain]|r" },
    ["soul-bound acolyte"]    = { "|cffFFFFFF[Acolyte's Twisted Shard]|r" },
    -- Road to the Other Side
    ["deathmarch sergeant"]   = { "|cffFF8C00[Sergeant's Rotting Pauldrons]|r", "|cff1EFF00[March Token]|r" },
    ["void herald"]           = { "|cffA335EE[Herald's Void Mantle]|r" },
    ["rift stalker"]          = { "|cff1EFF00[Rift Stalker Fang]|r" },
    -- General world mobs (examples)
    ["fel ravager"]           = { "|cff1EFF00[Ravager Tusk]|r", "|cffFFFFFF[Felshard]|r" },
    ["bone golem"]            = { "|cff1EFF00[Ancient Bone Fragment]|r" },
    ["shadow wraith"]         = { "|cffA335EE[Wraith Essence]|r" },
}

-- ─────────────────────────────────────────────────────────────
-- Quest Kill/Item Database  (mob name lowercase → quest info)
-- ─────────────────────────────────────────────────────────────
local QUEST_MOBS = {
    ["inquisitor valdris"]  = "Quest: Silence the Inquisition (0/1 kills)",
    ["soul-bound acolyte"]  = "Quest: Cleanse the Vault (0/8 kills)",
    ["deathmarch sergeant"] = "Quest: Stop the March (0/10 kills)",
    ["void herald"]         = "Quest: Echoes of the Rift (0/5 kills)",
    ["fel ravager"]         = "Quest: Fel Culling (0/6 kills)",
}

-- ─────────────────────────────────────────────────────────────
-- Escape Tips per class
-- ─────────────────────────────────────────────────────────────
local ESCAPE_TIPS = {
    felsworn    = "|cffb048b5Felsworn:|r Use |cffFFD700Fel Hoof Charge|r to dash away, then mount up. Tyrants can pop |cffFFD700Idan's Guard|r to survive while fleeing.",
    necromancer = "|cff51c2c5Necromancer:|r Cast |cff51c2c5Death Coil|r to slow the mob, then run. Use |cff51c2c5Army of the Dead|r to block pursuit on elites.",
    witch_hunter= "|cff4a9153Witch Hunter:|r Stay at max range. Use |cff4a9153Shadow Tonic|r for burst, then disengage. Mark a clear escape path before pulling.",
    tinker      = "|cffffd700Tinker:|r Drop a |cffffd700Landmine|r behind you to deter pursuit, then mount. Deploy turret as a distraction and run.",
    runemaster  = "|cff2266ccRunemaster:|r Use |cff2266ccArcane Binding|r to silence and root the mob for 4s — plenty of time to mount and escape.",
    chronomancer= "|cff7b68eeChronomancer:|r Cast |cff7b68eeRewind|r if below 25% HP, then use |cff7b68eeTime Rupture|r DoT and run while it ticks.",
    spiritwalker= "|cff00ff7fSpiritwalkr:|r Drop |cff00ff7fEarthbind Totem|r to root the mob and buy escape time. Ghost Wolf form for speed while fleeing.",
    reaper      = "|cff9900ccReaper:|r Use |cff9900ccShadow Phase|r (Soul spec) to go untargetable for 4s. Harvest/Defiance: pop |cff9900ccSoul Barrier|r and sprint.",
}

-- ─────────────────────────────────────────────────────────────
-- XP Estimate
-- Rough formula: base XP = 45 * mobLevel, scaled by level diff
-- ─────────────────────────────────────────────────────────────
local function EstimateXP(playerLevel, mobLevel)
    if not playerLevel or not mobLevel or mobLevel <= 0 then return "?" end
    local base = 45 * mobLevel
    local diff = mobLevel - playerLevel
    local factor
    if diff >= 5 then
        factor = 1.2
    elseif diff >= 0 then
        factor = 1.0
    elseif diff >= -4 then
        factor = 1.0 - (math.abs(diff) * 0.1)
    else
        -- Grey mob — no XP
        return "|cff808080No XP (grey mob)|r"
    end
    local xp = math.floor(base * factor)
    local bonus = (diff >= 2) and " |cffFFD700(Bonus!)|r" or ""
    return xp .. " XP" .. bonus
end

-- ─────────────────────────────────────────────────────────────
-- Build the HUD frame
-- ─────────────────────────────────────────────────────────────
function CoAAT_MobInfoHUD.Build()
    local f = CreateFrame("Frame", "CoAATMobInfoHUD", UIParent)
    f:SetSize(230, 120)
    f:SetFrameStrata("TOOLTIP")
    f:SetToplevel(true)
    f:Hide()

    -- Background
    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0.03, 0.04, 0.10, 0.92)

    -- Top accent bar (purple)
    local accent = f:CreateTexture(nil, "ARTWORK")
    accent:SetSize(230, 3)
    accent:SetPoint("TOPLEFT")
    accent:SetTexture(0.68, 0.28, 1.0, 0.95)

    -- Border
    local function MakeBorder(w, h, pt, rpt, ox, oy)
        local t = f:CreateTexture(nil, "OVERLAY")
        t:SetSize(w, h)
        t:SetPoint(pt, f, rpt, ox, oy)
        t:SetTexture(0.4, 0.2, 0.8, 0.6)
    end
    MakeBorder(230, 1, "TOPLEFT",    "TOPLEFT",    0, 0)
    MakeBorder(230, 1, "BOTTOMLEFT", "BOTTOMLEFT", 0, 0)
    MakeBorder(1, 120, "TOPLEFT",    "TOPLEFT",    0, 0)
    MakeBorder(1, 120, "TOPRIGHT",   "TOPRIGHT",   0, 0)

    -- Mob Name / Level label
    local mobTitle = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    mobTitle:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -8)
    mobTitle:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    mobTitle:SetText("")
    f._mobTitle = mobTitle

    -- XP line
    local xpLine = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    xpLine:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -24)
    xpLine:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    xpLine:SetText("")
    f._xpLine = xpLine

    -- Quest line
    local questLine = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    questLine:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -38)
    questLine:SetSize(214, 0)
    questLine:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    questLine:SetJustifyH("LEFT")
    questLine:SetText("")
    f._questLine = questLine

    -- Drops label
    local dropsLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    dropsLabel:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -54)
    dropsLabel:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    dropsLabel:SetText("|cffFFD700Notable Drops:|r")
    f._dropsLabel = dropsLabel

    -- Drop lines (up to 2)
    local dropLines = {}
    for i = 1, 2 do
        local dl = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        dl:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -54 - (i * 12))
        dl:SetSize(210, 0)
        dl:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        dl:SetJustifyH("LEFT")
        dl:SetText("")
        dropLines[i] = dl
    end
    f._dropLines = dropLines

    -- Escape tip line
    local escapeLine = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    escapeLine:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 8, 6)
    escapeLine:SetSize(214, 0)
    escapeLine:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    escapeLine:SetJustifyH("LEFT")
    escapeLine:SetText("")
    f._escapeLine = escapeLine

    -- Pointer triangle (visual arrow pointing down toward mob)
    local arrow = f:CreateTexture(nil, "OVERLAY")
    arrow:SetSize(10, 6)
    arrow:SetPoint("BOTTOM", f, "BOTTOM", 0, -6)
    arrow:SetTexture(0.4, 0.2, 0.8, 0.7)
    f._arrow = arrow

    -- OnUpdate: position above mob nameplate, refresh data
    f:SetScript("OnUpdate", function(self, dt)
        _elapsed = _elapsed + dt
        if _elapsed < UPDATE_FREQ then return end
        _elapsed = 0

        CoAAT_MobInfoHUD.Refresh()
    end)

    _frame = f
end

-- ─────────────────────────────────────────────────────────────
-- Refresh HUD content and position
-- ─────────────────────────────────────────────────────────────
function CoAAT_MobInfoHUD.Refresh()
    if not _frame then return end

    local unit = "target"

    -- Only show for valid enemy targets
    if not UnitExists(unit) or UnitIsPlayer(unit) or UnitIsFriend("player", unit) then
        _frame:Hide()
        return
    end

    local mobName  = UnitName(unit) or "Unknown"
    local mobLevel = UnitLevel(unit) or 0
    local plrLevel = UnitLevel("player") or 1
    local mobKey   = mobName:lower()

    -- ── Mob name + level ──
    local levelColor = "|cffFFFFFF"
    local diff = mobLevel - plrLevel
    if diff >= 5 then
        levelColor = "|cffFF0000"      -- red (skull / very dangerous)
    elseif diff >= 2 then
        levelColor = "|cffFF8C00"      -- orange (tough)
    elseif diff >= -2 then
        levelColor = "|cffFFFF00"      -- yellow (even)
    else
        levelColor = "|cff808080"      -- grey (easy / no XP)
    end
    _frame._mobTitle:SetText(levelColor .. mobName .. " (Lvl " .. mobLevel .. ")|r")

    -- ── XP estimate ──
    local xpStr = EstimateXP(plrLevel, mobLevel)
    _frame._xpLine:SetText("|cff44ffaaXP:|r " .. xpStr)

    -- ── Quest info ──
    local questStr = QUEST_MOBS[mobKey]
    if questStr then
        _frame._questLine:SetText("|cffFFD700🗺 " .. questStr .. "|r")
    else
        _frame._questLine:SetText("|cff808080No active quest for this mob.|r")
    end

    -- ── Notable drops ──
    local drops = NOTABLE_DROPS[mobKey]
    if drops and #drops > 0 then
        _frame._dropsLabel:Show()
        for i = 1, 2 do
            if drops[i] then
                _frame._dropLines[i]:SetText("• " .. drops[i])
                _frame._dropLines[i]:Show()
            else
                _frame._dropLines[i]:SetText("")
                _frame._dropLines[i]:Hide()
            end
        end
    else
        _frame._dropsLabel:Hide()
        for i = 1, 2 do
            _frame._dropLines[i]:SetText("")
            _frame._dropLines[i]:Hide()
        end
    end

    -- ── Escape tip ──
    local classId  = CoAAT_Engine and CoAAT_Engine.GetClassId and CoAAT_Engine.GetClassId()
    local escapeTip = classId and ESCAPE_TIPS[classId] or "|cff808080Tip: Mount up and run if HP < 30%.|r"
    _frame._escapeLine:SetText("|cffFF4444🏃 " .. escapeTip)

    -- ── Position above mob nameplate ──
    -- Best approximation: use mouse position as mob is targeted by clicking.
    -- For a true nameplate attach, parse nameplate frames.
    local attached = false
    for _, np in pairs(C_NamePlate and C_NamePlate.GetNamePlates and C_NamePlate.GetNamePlates() or {}) do
        if np.namePlateUnitToken == unit or
           (np.UnitFrame and np.UnitFrame.unit == unit) then
            _frame:ClearAllPoints()
            _frame:SetPoint("BOTTOM", np, "TOP", 0, 10)
            attached = true
            break
        end
    end

    if not attached then
        -- Fallback: position near cursor
        local x, y = GetCursorPosition()
        local s    = UIParent:GetEffectiveScale()
        if s and s > 0 then
            _frame:ClearAllPoints()
            _frame:SetPoint("BOTTOM", UIParent, "BOTTOMLEFT", x / s, (y / s) + 80)
        end
    end

    _frame:Show()
end

-- ─────────────────────────────────────────────────────────────
-- Event wiring: show on TARGET_CHANGED, hide on target cleared
-- ─────────────────────────────────────────────────────────────
function CoAAT_MobInfoHUD.RegisterEvents()
    local ev = CreateFrame("Frame")
    ev:RegisterEvent("PLAYER_TARGET_CHANGED")
    ev:RegisterEvent("UNIT_HEALTH")
    ev:SetScript("OnEvent", function(self, event, unit)
        if event == "PLAYER_TARGET_CHANGED" then
            if UnitExists("target") and not UnitIsPlayer("target") and not UnitIsFriend("player", "target") then
                CoAAT_MobInfoHUD.Refresh()
            else
                if _frame then _frame:Hide() end
            end
        end
    end)
end
