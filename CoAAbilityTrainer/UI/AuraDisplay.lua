-- ============================================================
-- CoAAbilityTrainer - Aura Display (WeakAuras-style icon grid)
-- Shows ability icons with animated states:
--   • Active buffs/debuffs with timers
--   • Proc triggers with glow
--   • Cooldown-ready pings
-- ============================================================

CoAAT_AuraDisplay = {}

local AURA_SIZE  = 32
local AURA_PAD   = 1
local COLS       = 8
local auraIcons  = {}   -- array of icon widget tables
local _parent    = nil

-- Urgency → border color
local URGENCY_COLORS = {
    critical = { r=1.0, g=0.1, b=0.1 },
    high     = { r=1.0, g=0.6, b=0.0 },
    medium   = { r=0.2, g=0.8, b=1.0 },
    low      = { r=0.4, g=0.5, b=0.6 },
}

-- Type → background tint
local TYPE_TINT = {
    buff    = { r=0.04, g=0.16, b=0.04 },
    debuff  = { r=0.16, g=0.04, b=0.04 },
    proc    = { r=0.12, g=0.08, b=0.20 },
    cooldown= { r=0.04, g=0.08, b=0.20 },
    spender = { r=0.16, g=0.06, b=0.02 },
    generator={ r=0.04, g=0.04, b=0.12 },
    filler  = { r=0.06, g=0.06, b=0.08 },
}

-- ─────────────────────────────────────────────
-- Single aura icon
-- ─────────────────────────────────────────────
local function MakeAuraIcon(parent, col, row)
    local x = (col - 1) * (AURA_SIZE + AURA_PAD)
    local y = -(row - 1) * (AURA_SIZE + AURA_PAD + 16)

    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(AURA_SIZE, AURA_SIZE)
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    frame:EnableMouse(true)

    -- Dark BG
    local bg = frame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0.04, 0.06, 0.10, 0.90)
    frame._bg = bg

    -- Icon
    local icon = frame:CreateTexture(nil, "ARTWORK")
    icon:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -3)
    icon:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 3)
    icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    frame._icon = icon

    -- Desaturate mask (on cooldown / inactive)
    local mask = frame:CreateTexture(nil, "OVERLAY")
    mask:SetAllPoints()
    mask:SetTexture(0, 0, 0, 0.6)
    mask:Hide()
    frame._mask = mask

    -- Countdown timer text
    local timer = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    timer:SetAllPoints()
    timer:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
    timer:SetJustifyH("CENTER")
    timer:SetJustifyV("MIDDLE")
    timer:SetText("")
    frame._timer = timer

    -- Ability name below icon
    local name = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    name:SetPoint("TOP", frame, "BOTTOM", 0, -2)
    name:SetWidth(AURA_SIZE + 10)
    name:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    name:SetJustifyH("CENTER")
    name:SetText("")
    frame._nameText = name

    -- Type label (tiny, top-left corner)
    local typeBadge = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    typeBadge:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -1)
    typeBadge:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE")
    typeBadge:SetText("")
    frame._typeBadge = typeBadge

    -- Active/proc glow ring
    local glow = frame:CreateTexture(nil, "OVERLAY")
    glow:SetSize(AURA_SIZE + 14, AURA_SIZE + 14)
    glow:SetPoint("CENTER", frame, "CENTER", 0, 0)
    glow:SetTexture("Interface\\Cooldown\\star4")
    glow:SetBlendMode("ADD")
    glow:SetAlpha(0)
    frame._glow = glow

    -- Urgency border line (colored)
    local bLeft   = frame:CreateTexture(nil, "OVERLAY")
    local bRight  = frame:CreateTexture(nil, "OVERLAY")
    local bTop    = frame:CreateTexture(nil, "OVERLAY")
    local bBottom = frame:CreateTexture(nil, "OVERLAY")
    local bS = 1
    bTop:SetSize(AURA_SIZE, bS);    bTop:SetPoint("TOPLEFT",     frame, "TOPLEFT",     0, 0)
    bBottom:SetSize(AURA_SIZE, bS); bBottom:SetPoint("BOTTOMLEFT",frame, "BOTTOMLEFT",  0, 0)
    bLeft:SetSize(bS, AURA_SIZE);   bLeft:SetPoint("TOPLEFT",    frame, "TOPLEFT",      0, 0)
    bRight:SetSize(bS, AURA_SIZE);  bRight:SetPoint("TOPRIGHT",  frame, "TOPRIGHT",     0, 0)
    frame._borders = { bTop, bBottom, bLeft, bRight }

    local function setBorderColor(r, g, b, a)
        for _, b2 in ipairs(frame._borders) do
            b2:SetTexture(r, g, b, a or 0.7)
        end
    end
    frame.SetBorderColor = setBorderColor

    -- Tooltip
    frame:SetScript("OnEnter", function(self)
        local ab = self._abilityDef
        if not ab then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("|cff00ccff" .. ab.name .. "|r")
        GameTooltip:AddLine("|cffaaaaaa" .. (ab.description or "") .. "|r", 1, 1, 1, true)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("|cffFFD700Teaching:|r |cffdddddd" .. (ab.hint or "") .. "|r", 1, 1, 1, true)
        if ab.cooldown and ab.cooldown > 0 then
            GameTooltip:AddLine("|cffaaaaaa Cooldown: " .. ab.cooldown .. "s|r")
        end
        if ab.resourceCost then
            GameTooltip:AddLine("|cffaaaaaa Cost: " .. ab.resourceCost .. " " .. (CoAAT_Engine.GetClassDef() and CoAAT_Engine.GetClassDef().resource or "") .. "|r")
        end
        if ab.resourceGain then
            GameTooltip:AddLine("|cff44ff88Generates: " .. ab.resourceGain .. " " .. (CoAAT_Engine.GetClassDef() and CoAAT_Engine.GetClassDef().resource or "") .. "|r")
        end
        GameTooltip:Show()
    end)
    frame:SetScript("OnLeave", function() GameTooltip:Hide() end)

    frame._abilityDef  = nil
    frame._glowPhase   = 0
    frame._isActive    = false

    return frame
end

-- ─────────────────────────────────────────────
-- Build the aura display grid
-- ─────────────────────────────────────────────
function CoAAT_AuraDisplay.Build(parent)
    _parent = parent
    auraIcons = {}

    local maxAbilities = 8
    for i = 1, maxAbilities do
        local col = ((i - 1) % COLS) + 1
        local row = math.floor((i - 1) / COLS) + 1
        auraIcons[i] = MakeAuraIcon(parent, col, row)
        auraIcons[i]:Hide()
    end

    -- Start the animation ticker
    local ticker = CreateFrame("Frame")
    ticker:SetScript("OnUpdate", function(_, dt)
        CoAAT_AuraDisplay.AnimTick(dt)
    end)
    CoAAT_AuraDisplay._ticker = ticker
end

-- ─────────────────────────────────────────────
-- Populate from current class spec abilities
-- ─────────────────────────────────────────────
function CoAAT_AuraDisplay.OnClassChanged(classId, specId)
    for _, ic in ipairs(auraIcons) do ic:Hide() end

    local specDef = CoAAT_Engine.GetSpecDef()
    if not specDef then return end

    for i, ab in ipairs(specDef.abilities) do
        if i > #auraIcons then break end
        local ic = auraIcons[i]
        ic._abilityDef = ab

        -- Icon texture
        ic._icon:SetTexture(ab.icon)
        ic._nameText:SetText("") -- Hidden under icons for clean WeakAura look

        -- Type badge
        local typeShort = {
            generator = "GEN", spender = "USE", cooldown = "CD",
            proc = "PROC", buff = "BUFF", debuff = "DBFF", filler = "FILL"
        }
        local typeColors = {
            generator = "|cff44aaff", spender = "|cffff8844", cooldown = "|cffcc44ff",
            proc = "|cffffdd00", buff = "|cff44ff88", debuff = "|cffff4444", filler = "|cff888888"
        }
        local tc = typeColors[ab.type] or "|cffaaaaaa"
        ic._typeBadge:SetText(tc .. (typeShort[ab.type] or "?") .. "|r")

        -- BG tint by type
        local tint = TYPE_TINT[ab.type] or { r=0.04, g=0.04, b=0.08 }
        ic._bg:SetTexture(tint.r, tint.g, tint.b, 0.90)

        -- Default border by type urgency feel
        local bc = URGENCY_COLORS.low
        if ab.type == "buff" or ab.type == "debuff" then bc = URGENCY_COLORS.high end
        if ab.type == "proc"  then bc = URGENCY_COLORS.critical end
        ic:SetBorderColor(bc.r, bc.g, bc.b, 0.5)

        -- Initial state
        ic._mask:Show()   -- start grayed
        ic._glow:SetAlpha(0)
        ic._timer:SetText("")
        ic._isActive = false
        ic._glowPhase = 0

        ic:Show()
    end
end

-- ─────────────────────────────────────────────
-- Mark an ability as ACTIVE (buff applied etc.)
-- ─────────────────────────────────────────────
function CoAAT_AuraDisplay.SetActive(abilityId, active, remaining)
    for _, ic in ipairs(auraIcons) do
        if ic._abilityDef and ic._abilityDef.id == abilityId then
            ic._isActive = active
            if active then
                ic._mask:Hide()
                ic._glowPhase = 0.01
                if remaining and remaining > 0 then
                    ic._timer:SetText("|cff44ff44" .. string.format("%.0f", remaining) .. "|r")
                else
                    ic._timer:SetText("")
                end
            else
                ic._mask:Show()
                ic._glow:SetAlpha(0)
                ic._glowPhase = 0
                ic._timer:SetText("")
            end
            break
        end
    end
end

-- ─────────────────────────────────────────────
-- Mark an ability as highlighted (rotation suggestion)
-- ─────────────────────────────────────────────
function CoAAT_AuraDisplay.SetHighlighted(abilityId, urgency)
    for _, ic in ipairs(auraIcons) do
        if ic._abilityDef then
            if ic._abilityDef.id == abilityId then
                local uc = URGENCY_COLORS[urgency] or URGENCY_COLORS.medium
                ic:SetBorderColor(uc.r, uc.g, uc.b, 1.0)
                ic._glow:SetVertexColor(uc.r, uc.g, uc.b)
                if ic._glowPhase == 0 then ic._glowPhase = 0.01 end
            else
                -- Reset others to dim
                local ab = ic._abilityDef
                local bc = URGENCY_COLORS.low
                ic:SetBorderColor(bc.r, bc.g, bc.b, 0.3)
                if not ic._isActive then
                    ic._glow:SetAlpha(0)
                    ic._glowPhase = 0
                end
            end
        end
    end
end

-- ─────────────────────────────────────────────
-- Animation tick
-- ─────────────────────────────────────────────
function CoAAT_AuraDisplay.AnimTick(dt)
    for _, ic in ipairs(auraIcons) do
        if ic:IsShown() and ic._glowPhase and ic._glowPhase > 0 then
            ic._glowPhase = ic._glowPhase + dt * 2.5
            local alpha = math.abs(math.sin(ic._glowPhase * math.pi)) * 0.65
            ic._glow:SetAlpha(alpha)
            -- Loop indefinitely while active
            if ic._glowPhase >= 2 then
                if ic._isActive then
                    ic._glowPhase = 0.01  -- keep looping
                else
                    ic._glow:SetAlpha(0)
                    ic._glowPhase = 0
                end
            end
        end
    end
end

function CoAAT_AuraDisplay.SetMouseEnabled(enabled)
    if not auraIcons then return end
    for _, ic in ipairs(auraIcons) do
        ic:EnableMouse(enabled)
    end
end
