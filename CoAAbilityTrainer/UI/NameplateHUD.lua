-- ============================================================
-- CoAAbilityTrainer - Nameplate HUD
-- Injects a sleek mini-HUD onto every visible enemy nameplate:
--   · Colored HP bar overlay with % text
--   · Debuff icons (your casts only) anchored above the bar
--   · Target highlight glow ring
--   · Aggro / threat skull indicator
-- ============================================================

CoAAT_NameplateHUD = {}

-- Pool of injected nameplate overlays keyed by nameplate frame
local _injected   = {}   -- [nameplateFrame] = overlayTable
local _ticker     = 0
local _TICK       = 0.08  -- refresh interval in seconds
local _controller = nil   -- the OnUpdate host frame

-- ─────────────────────────────────────────────────────────
-- Colour helpers
-- ─────────────────────────────────────────────────────────
local function HpColor(pct)
    if pct > 0.6 then
        return 0.15, 0.85, 0.35   -- green
    elseif pct > 0.3 then
        return 1.0, 0.65, 0.05    -- orange
    else
        return 0.95, 0.15, 0.15   -- red
    end
end

-- ─────────────────────────────────────────────────────────
-- Detect all unnamed WorldFrame children that look like
-- nameplates (have a StatusBar child or a "Nameplate" texture)
-- ─────────────────────────────────────────────────────────
local function IsNameplate(frame)
    if not frame or frame:GetName() then return false end
    -- Quick structural check: nameplates always have a StatusBar child
    local children = { frame:GetChildren() }
    for _, c in ipairs(children) do
        if c:GetObjectType() == "StatusBar" then return true end
    end
    return false
end

local function GetNameplateHP(frame)
    local children = { frame:GetChildren() }
    for _, c in ipairs(children) do
        if c:GetObjectType() == "StatusBar" then
            return c  -- first StatusBar is always the HP bar
        end
    end
    return nil
end

local function GetNameplateName(frame)
    local regions = { frame:GetRegions() }
    for _, r in ipairs(regions) do
        if r:GetObjectType() == "FontString" then
            local t = r:GetText()
            if t and t ~= "" then return t end
        end
    end
    return nil
end

-- ─────────────────────────────────────────────────────────
-- Build a reusable overlay table attached to one nameplate
-- ─────────────────────────────────────────────────────────
local function BuildOverlay(np)
    local hpBar = GetNameplateHP(np)
    if not hpBar then return nil end

    local ov = {}

    -- ── HP bar colour overlay (drawn on top of the native bar fill) ──
    local barW, barH = hpBar:GetSize()
    if barW == 0 then barW = 80 end
    if barH == 0 then barH = 8  end

    -- Thin accent line above the nameplate bar (1 px rule)
    local accentLine = np:CreateTexture(nil, "OVERLAY", nil, 7)
    accentLine:SetHeight(2)
    accentLine:SetPoint("BOTTOMLEFT",  hpBar, "TOPLEFT",  0,  1)
    accentLine:SetPoint("BOTTOMRIGHT", hpBar, "TOPRIGHT", 0,  1)
    accentLine:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    accentLine:SetVertexColor(0.2, 0.8, 1.0, 0.9)
    ov.accentLine = accentLine

    -- HP percentage text (right-aligned inside bar)
    local hpText = np:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    hpText:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE")
    hpText:SetPoint("RIGHT", hpBar, "RIGHT", -2, 0)
    hpText:SetTextColor(1, 1, 1, 0.92)
    ov.hpText = hpText

    -- Target highlight ring (hidden by default, shown when this np == target)
    local ring = np:CreateTexture(nil, "OVERLAY", nil, 6)
    ring:SetSize(barW + 20, barH + 20)
    ring:SetPoint("CENTER", hpBar, "CENTER", 0, 0)
    ring:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    ring:SetVertexColor(1.0, 0.8, 0.1, 0.0)  -- starts invisible
    ring:SetAlpha(0)
    ov.ring = ring

    -- Aggro / skull indicator (shown left of bar when player is the threat leader)
    local skull = np:CreateTexture(nil, "OVERLAY", nil, 7)
    skull:SetSize(12, 12)
    skull:SetPoint("RIGHT", hpBar, "LEFT", -3, 0)
    skull:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Skull")
    skull:SetAlpha(0)
    ov.skull = skull

    -- Debuff icon strip — 6 slots anchored above the HP bar
    local debuffs = {}
    for i = 1, 6 do
        local slot = CreateFrame("Frame", nil, np)
        slot:SetSize(13, 13)
        if i == 1 then
            slot:SetPoint("BOTTOMLEFT", hpBar, "TOPLEFT", 0, 4)
        else
            slot:SetPoint("LEFT", debuffs[i-1], "RIGHT", 2, 0)
        end

        local icon = slot:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints()
        icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        slot.icon = icon

        -- Thin dark border around debuff
        local border = slot:CreateTexture(nil, "OVERLAY")
        border:SetAllPoints()
        border:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
        border:SetVertexColor(0, 0, 0, 0.7)
        border:SetAlpha(0)   -- used as a border trick via inset
        slot.border = border

        -- Stack count
        local cnt = slot:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        cnt:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE")
        cnt:SetPoint("BOTTOMRIGHT", slot, "BOTTOMRIGHT", 2, -1)
        cnt:SetTextColor(1, 1, 1, 1)
        slot.cnt = cnt

        slot:Hide()
        debuffs[i] = slot
    end
    ov.debuffs = debuffs

    ov.hpBar    = hpBar
    ov.np       = np
    ov.pulse    = 0    -- ring pulse phase

    return ov
end

-- ─────────────────────────────────────────────────────────
-- Refresh the overlay for one nameplate
-- ─────────────────────────────────────────────────────────
local function RefreshOverlay(ov, isTarget, dt)
    local np    = ov.np
    local hpBar = ov.hpBar

    -- Get raw min/max/current from the native HP bar
    local curVal, minVal, maxVal = hpBar:GetValue(), hpBar:GetMinMaxValues()
    local range = (maxVal or 1) - (minVal or 0)
    local pct   = (range > 0) and ((curVal - minVal) / range) or 1.0
    pct = math.max(0, math.min(1, pct))

    -- HP percentage text
    if ov.hpText then
        ov.hpText:SetText(string.format("%d%%", math.ceil(pct * 100)))
    end

    -- Accent line colour follows HP
    if ov.accentLine then
        local r, g, b = HpColor(pct)
        ov.accentLine:SetVertexColor(r, g, b, 0.85)
    end

    -- Target ring pulse
    if ov.ring then
        if isTarget then
            ov.pulse = (ov.pulse or 0) + (dt or 0) * 3.5
            local alpha = 0.55 + 0.4 * math.sin(ov.pulse)
            ov.ring:SetAlpha(alpha)
            ov.ring:SetVertexColor(1.0, 0.85, 0.1, 1.0)
        else
            ov.ring:SetAlpha(0)
            ov.pulse = 0
        end
    end

    -- Skull / aggro indicator — show when this np is the player's target
    if ov.skull then
        if isTarget then
            ov.skull:SetAlpha(0.9)
        else
            ov.skull:SetAlpha(0)
        end
    end

    -- Debuffs YOU applied — scan UnitDebuff on "target" when this is target,
    -- otherwise hide (we can't read arbitrary unit debuffs without GUID unit tokens)
    if ov.debuffs then
        local anyShown = false
        if isTarget then
            for i = 1, 6 do
                local slot = ov.debuffs[i]
                local name, _, icon, count, _, _, _, caster = UnitDebuff("target", i)
                if name and icon and (caster == "player" or caster == nil) then
                    slot.icon:SetTexture(icon)
                    slot.cnt:SetText((count and count > 1) and tostring(count) or "")
                    slot:Show()
                    anyShown = true
                else
                    slot:Hide()
                end
            end
        else
            for i = 1, 6 do
                ov.debuffs[i]:Hide()
            end
        end
    end
end

-- ─────────────────────────────────────────────────────────
-- Main scan: walk WorldFrame children, inject or refresh
-- ─────────────────────────────────────────────────────────
local function ScanNameplates(dt)
    if not (CoAAT_DB and CoAAT_DB.nameplateHUD ~= false) then
        -- Feature disabled — hide all overlays
        for np, ov in pairs(_injected) do
            if ov.accentLine then ov.accentLine:Hide() end
            if ov.hpText     then ov.hpText:Hide()     end
            if ov.ring       then ov.ring:SetAlpha(0)  end
            if ov.skull      then ov.skull:SetAlpha(0) end
        end
        return
    end

    local targetName = UnitExists("target") and UnitName("target") or nil

    local kids = { WorldFrame:GetChildren() }
    local seen  = {}

    for _, frame in ipairs(kids) do
        if frame:IsShown() and not frame:GetName() then
            if IsNameplate(frame) then
                seen[frame] = true

                -- Inject overlay if not done yet
                if not _injected[frame] then
                    local ov = BuildOverlay(frame)
                    if ov then
                        _injected[frame] = ov
                    end
                end

                local ov = _injected[frame]
                if ov then
                    -- Show overlay elements
                    if ov.accentLine then ov.accentLine:Show() end
                    if ov.hpText     then ov.hpText:Show()     end

                    local npName    = GetNameplateName(frame)
                    local isTarget  = (targetName and npName == targetName) and true or false
                    RefreshOverlay(ov, isTarget, dt)
                end
            end
        end
    end

    -- Prune overlays for nameplates that are gone
    for np, ov in pairs(_injected) do
        if not seen[np] then
            -- Frame was recycled/hidden — clear reference, textures persist but are hidden
            if ov.accentLine then ov.accentLine:Hide() end
            if ov.hpText     then ov.hpText:Hide()     end
            if ov.ring       then ov.ring:SetAlpha(0)  end
            if ov.skull      then ov.skull:SetAlpha(0) end
            for i = 1, 6 do if ov.debuffs[i] then ov.debuffs[i]:Hide() end end
            _injected[np] = nil
        end
    end
end

-- ─────────────────────────────────────────────────────────
-- Public API
-- ─────────────────────────────────────────────────────────
function CoAAT_NameplateHUD.Build()
    if _controller then return end  -- already built

    _controller = CreateFrame("Frame", "CoAATNameplateHUD", UIParent)
    _controller:SetAllPoints(WorldFrame)
    _controller:SetFrameStrata("TOOLTIP")   -- render above nameplates
    _controller:SetAlpha(1)

    _controller:SetScript("OnUpdate", function(self, dt)
        _ticker = _ticker + dt
        if _ticker >= _TICK then
            ScanNameplates(_ticker)
            _ticker = 0
        end
    end)

    -- Re-scan on target change for instant ring reaction
    _controller:RegisterEvent("PLAYER_TARGET_CHANGED")
    _controller:SetScript("OnEvent", function(self, event)
        if event == "PLAYER_TARGET_CHANGED" then
            ScanNameplates(0)
        end
    end)
end

function CoAAT_NameplateHUD.Enable()
    if CoAAT_DB then CoAAT_DB.nameplateHUD = true end
    if _controller then _controller:Show() end
end

function CoAAT_NameplateHUD.Disable()
    if CoAAT_DB then CoAAT_DB.nameplateHUD = false end
    -- overlays will hide on next ScanNameplates
end

function CoAAT_NameplateHUD.Toggle()
    local enabled = not (CoAAT_DB and CoAAT_DB.nameplateHUD == false)
    if enabled then
        CoAAT_NameplateHUD.Disable()
    else
        CoAAT_NameplateHUD.Enable()
    end
end
