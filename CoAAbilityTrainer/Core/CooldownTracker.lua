-- ============================================================
-- CoAAbilityTrainer - Cooldown Tracker
-- Displays ability icons with countdown timers, glow on ready
-- ============================================================

CoAAT_CooldownTracker = {}

local icons = {}   -- { frame, icon, timerText, glowTex, abilityId }
local ICON_SIZE = 46
local ICON_PAD  = 6
local MAX_ICONS = 8

-- Glow animation state
local glowFrames = {}

-- Create a single icon widget
local function CreateIcon(parent, index)
    local x = (index - 1) * (ICON_SIZE + ICON_PAD)

    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(ICON_SIZE, ICON_SIZE)
    frame:SetPoint("LEFT", parent, "LEFT", x, 0)

    -- Dark BG
    local bg = frame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0.04, 0.04, 0.08, 0.92)

    -- Ability icon
    local icon = frame:CreateTexture(nil, "ARTWORK")
    icon:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
    icon:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
    icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

    -- Desaturated overlay (on cooldown)
    local desatOverlay = frame:CreateTexture(nil, "OVERLAY")
    desatOverlay:SetAllPoints()
    desatOverlay:SetTexture(0, 0, 0, 0.55)
    desatOverlay:Hide()

    -- Cooldown text (center)
    local timerText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    timerText:SetAllPoints()
    timerText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
    timerText:SetJustifyH("CENTER")
    timerText:SetJustifyV("MIDDLE")
    timerText:SetText("")

    -- "READY" glow border (animated)
    local glow = frame:CreateTexture(nil, "OVERLAY")
    glow:SetSize(ICON_SIZE + 10, ICON_SIZE + 10)
    glow:SetPoint("CENTER", frame, "CENTER", 0, 0)
    glow:SetTexture("Interface\\Cooldown\\star4")
    glow:SetBlendMode("ADD")
    glow:SetAlpha(0)

    -- Ability name below
    local nameText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    nameText:SetPoint("TOP", frame, "BOTTOM", 0, -2)
    nameText:SetWidth(ICON_SIZE + 10)
    nameText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    nameText:SetJustifyH("CENTER")
    nameText:SetText("")

    -- Thin colored border
    local border = frame:CreateTexture(nil, "OVERLAY")
    border:SetSize(ICON_SIZE + 4, ICON_SIZE + 4)
    border:SetPoint("CENTER", frame, "CENTER", 0, 0)
    border:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
    border:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    border:SetVertexColor(0.15, 0.45, 0.75, 0.7)

    frame._icon       = icon
    frame._timer      = timerText
    frame._glow       = glow
    frame._desatOvr   = desatOverlay
    frame._name       = nameText
    frame._border     = border
    frame._abilityId  = nil
    frame._onCooldown = false
    frame._glowPhase  = 0

    return frame
end

-- ─────────────────────────────────────────────
-- Build the tracker strip
-- ─────────────────────────────────────────────
function CoAAT_CooldownTracker.Build(parent)
    CoAAT_CooldownTracker._parent = parent
    icons = {}
    for i = 1, MAX_ICONS do
        icons[i] = CreateIcon(parent, i)
        icons[i]:Hide()
    end
end

-- ─────────────────────────────────────────────
-- Populate icons from active spec abilities
-- ─────────────────────────────────────────────
function CoAAT_CooldownTracker.OnClassChanged(classId, specId)
    -- Hide all first
    for _, ic in ipairs(icons) do ic:Hide() end

    local specDef = CoAAT_Engine.GetSpecDef()
    if not specDef then return end

    -- Only show abilities that have cooldowns or are buffs/debuffs
    local shown = {}
    for _, ab in ipairs(specDef.abilities) do
        if ab.type == "cooldown" or ab.type == "buff" or ab.type == "debuff" or ab.type == "generator" or ab.type == "spender" then
            shown[#shown + 1] = ab
        end
        if #shown >= MAX_ICONS then break end
    end

    for i, ab in ipairs(shown) do
        local ic = icons[i]
        ic._icon:SetTexture(ab.icon)
        ic._name:SetText(ab.name)
        ic._abilityId = ab.id
        ic._onCooldown = false
        ic._desatOvr:Hide()
        ic._timer:SetText("")
        ic._glowPhase = 0
        ic._glow:SetAlpha(0)

        -- Color border by ability type
        local c = ab.color or { r=0.2, g=0.5, b=0.8 }
        ic._border:SetVertexColor(c.r, c.g, c.b, 0.8)

        ic:Show()
    end
end

-- ─────────────────────────────────────────────
-- Called on cooldown start
-- ─────────────────────────────────────────────
function CoAAT_CooldownTracker.OnCooldownStart(abilityId, duration)
    for _, ic in ipairs(icons) do
        if ic._abilityId == abilityId then
            ic._onCooldown = true
            ic._desatOvr:Show()
            ic._glow:SetAlpha(0)
            ic._glowPhase = 0
            break
        end
    end
end

-- ─────────────────────────────────────────────
-- Tick: update all timers + glow animations
-- ─────────────────────────────────────────────
function CoAAT_CooldownTracker.Tick(cooldowns, abilities)
    local now = GetTime()

    for _, ic in ipairs(icons) do
        if ic:IsShown() and ic._abilityId then
            local id = ic._abilityId
            local cd = cooldowns[id]
            local ab = abilities and abilities[id]

            if cd then
                local elapsed  = now - cd.start
                local remaining = cd.duration - elapsed

                if remaining > 0 then
                    -- On cooldown: show timer
                    ic._onCooldown = true
                    ic._desatOvr:Show()
                    ic._glow:SetAlpha(0)

                    -- Format timer text
                    if remaining > 60 then
                        ic._timer:SetText("|cffff6644" .. math.ceil(remaining/60) .. "m|r")
                    elseif remaining > 5 then
                        ic._timer:SetText("|cffffcc00" .. string.format("%.0f", remaining) .. "|r")
                    else
                        ic._timer:SetText("|cffff4444" .. string.format("%.1f", remaining) .. "|r")
                    end
                else
                    -- Cooldown just came up: animate glow
                    if ic._onCooldown then
                        ic._onCooldown = false
                        ic._desatOvr:Hide()
                        ic._timer:SetText("")
                        ic._glowPhase = 0
                        -- Trigger ready flash
                        CoAAT_CooldownTracker.FlashReady(ic)
                    end
                end
            else
                -- No cooldown tracked: ready state
                ic._onCooldown = false
                ic._desatOvr:Hide()
                ic._timer:SetText("")
            end

            -- Animate glow pulse
            if ic._glowPhase and ic._glowPhase > 0 then
                ic._glowPhase = ic._glowPhase + 0.04
                local alpha = math.abs(math.sin(ic._glowPhase * math.pi)) * 0.7
                ic._glow:SetAlpha(alpha)
                if ic._glowPhase >= 2 then
                    ic._glow:SetAlpha(0)
                    ic._glowPhase = 0
                end
            end
        end
    end
end

-- Trigger a "ready" flash animation
function CoAAT_CooldownTracker.FlashReady(ic)
    ic._glowPhase = 0.01
    -- Also briefly scale the icon for pop effect
    -- (Using alpha since 3.3.5 doesn't have SetScale animation API)
    ic._glow:SetAlpha(0.7)
    ic._timer:SetText("|cff44ff44✓|r")
    C_Timer_After(1.5, function()
        if ic and ic._timer then
            ic._timer:SetText("")
        end
    end)
end

-- Simple C_Timer_After polyfill for 3.3.5a
if not C_Timer_After then
    C_Timer_After = function(delay, fn)
        local f = CreateFrame("Frame")
        local elapsed = 0
        f:SetScript("OnUpdate", function(self, dt)
            elapsed = elapsed + dt
            if elapsed >= delay then
                self:SetScript("OnUpdate", nil)
                fn()
            end
        end)
    end
end
