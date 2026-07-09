-- ============================================================
-- COAlAbilityTrainer - Macro Builder & Aura Configurator
-- /coal macros   →  open this panel
--
-- Features:
--   • Class/spec picker auto-populates ability list
--   • Template modes: Basic | Modifier | Mouseover | Interrupt | Focus
--   • One-click macro creation via WoW CreateMacro() API
--   • Live preview of generated macro text
--   • WeakAura-style aura toggle per ability
--   • Export text box for manual copy-paste
-- ============================================================

CoAAT_MacroBuilder = {}

local _frame        = nil
local _selectedAbs  = {}   -- set of ability ids checked for generation
local _templateMode = "basic"
local _classId      = nil
local _specId       = nil
local _rows         = {}   -- UI row pool

-- ─────────────────────────────────────────────────────────────
-- Template generators
-- ─────────────────────────────────────────────────────────────
local TEMPLATES = {
    basic = {
        label = "Basic Cast",
        desc  = "/cast SpellName",
        build = function(ab)
            return string.format(
                "#showtooltip %s\n/cast %s",
                ab.name, ab.name)
        end,
    },
    stopcasting = {
        label = "Stop → Cast",
        desc  = "Cancels current cast then fires",
        build = function(ab)
            return string.format(
                "#showtooltip %s\n/stopcasting\n/cast %s",
                ab.name, ab.name)
        end,
    },
    modifier = {
        label = "Shift Modifier",
        desc  = "Shift = self, else target",
        build = function(ab)
            return string.format(
                "#showtooltip %s\n/cast [mod:shift,@player] %s; [exists,nodead] %s",
                ab.name, ab.name, ab.name)
        end,
    },
    mouseover = {
        label = "Mouseover",
        desc  = "Cast on mouseover → else target",
        build = function(ab)
            return string.format(
                "#showtooltip %s\n/cast [@mouseover,exists,nodead][@target,exists,nodead] %s",
                ab.name, ab.name)
        end,
    },
    interrupt = {
        label = "Interrupt",
        desc  = "stopcasting + cast (for kick/silence)",
        build = function(ab)
            return string.format(
                "#showtooltip %s\n/stopcasting\n/cast [@target,exists,nodead,casting] %s",
                ab.name, ab.name)
        end,
    },
    focus = {
        label = "Focus Target",
        desc  = "Cast on focus or target",
        build = function(ab)
            return string.format(
                "#showtooltip %s\n/cast [@focus,exists,nodead][@target,exists,nodead] %s",
                ab.name, ab.name)
        end,
    },
    toggle_aura = {
        label = "Toggle Buff",
        desc  = "Cancel aura if active, else cast",
        build = function(ab)
            return string.format(
                "#showtooltip %s\n/cancelaura %s\n/cast [nobuff:%s] %s",
                ab.name, ab.name, ab.name, ab.name)
        end,
    },
}

local TEMPLATE_ORDER = {
    "basic","stopcasting","modifier","mouseover",
    "interrupt","focus","toggle_aura"
}

-- ─────────────────────────────────────────────────────────────
-- Helpers
-- ─────────────────────────────────────────────────────────────
local function GetAbilities()
    if not (_classId and CoAAT_Abilities and CoAAT_Abilities[_classId]) then return {} end
    local cd = CoAAT_Abilities[_classId]
    if not _specId then
        -- first spec
        for sid, sdata in pairs(cd.specs or {}) do
            _specId = sid
            break
        end
    end
    local spec = cd.specs and cd.specs[_specId]
    return spec and spec.abilities or {}
end

local function MakeMacroText(ab)
    local t = TEMPLATES[_templateMode] or TEMPLATES.basic
    return t.build(ab)
end

local function CountMacros()
    local g, c = GetNumMacros()
    return g, c
end

local function TryCreateMacro(name, icon, body)
    local g, c = CountMacros()
    if g >= 120 then
        return false, "Macro limit reached (120 global macros)"
    end
    -- Check if macro with same name exists → edit it
    local idx = GetMacroIndexByName(name)
    if idx and idx > 0 then
        EditMacro(idx, name, icon, body)
        return true, "Updated existing macro: " .. name
    end
    CreateMacro(name, icon, body, nil)
    return true, "Created macro: " .. name
end

-- ─────────────────────────────────────────────────────────────
-- Preview box update
-- ─────────────────────────────────────────────────────────────
local function UpdatePreview()
    if not _frame then return end

    local lines   = {}
    local abs     = GetAbilities()
    local count   = 0

    for _, ab in ipairs(abs) do
        if _selectedAbs[ab.id] then
            count = count + 1
            table.insert(lines, "-- ⚔ " .. ab.name)
            table.insert(lines, MakeMacroText(ab))
            table.insert(lines, "")
        end
    end

    if count == 0 then
        _frame._preview:SetText("|cff888888Select abilities above to preview macros here.|r")
    else
        _frame._preview:SetText(table.concat(lines, "\n"))
    end
    _frame._createBtn:SetText(count > 0
        and ("|cff00ff88Create " .. count .. " Macro" .. (count>1 and "s" or "") .. "|r")
        or  "|cff666666Select abilities first|r")
end

-- ─────────────────────────────────────────────────────────────
-- Ability row pool
-- ─────────────────────────────────────────────────────────────
local function MakeRow(parent, ab, yOffset)
    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(320, 28)
    row:SetPoint("TOPLEFT", parent, "TOPLEFT", 6, yOffset)

    -- checkbox bg
    local cbBG = row:CreateTexture(nil, "BACKGROUND")
    cbBG:SetSize(16, 16)
    cbBG:SetPoint("LEFT", row, "LEFT", 2, 0)
    cbBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    cbBG:SetVertexColor(0.08, 0.08, 0.14, 0.95)

    -- checkbox tick
    local tick = row:CreateFontString(nil, "OVERLAY")
    tick:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    tick:SetPoint("CENTER", cbBG, "CENTER", 0, 0)
    tick:SetText("")

    -- ability icon
    local icon = row:CreateTexture(nil, "ARTWORK")
    icon:SetSize(20, 20)
    icon:SetPoint("LEFT", cbBG, "RIGHT", 6, 0)
    icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    if ab.icon then icon:SetTexture(ab.icon) end

    -- ability name
    local lbl = row:CreateFontString(nil, "OVERLAY")
    lbl:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    lbl:SetPoint("LEFT", icon, "RIGHT", 6, 0)
    lbl:SetWidth(160)
    lbl:SetJustifyH("LEFT")

    -- type badge
    local badge = row:CreateFontString(nil, "OVERLAY")
    badge:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE")
    badge:SetPoint("LEFT", lbl, "RIGHT", 4, 0)
    badge:SetWidth(56)
    badge:SetJustifyH("LEFT")

    -- aura toggle button (right side)
    local auraBG = row:CreateTexture(nil, "OVERLAY")
    auraBG:SetSize(50, 14)
    auraBG:SetPoint("RIGHT", row, "RIGHT", -4, 0)
    auraBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")

    local auraLbl = row:CreateFontString(nil, "OVERLAY")
    auraLbl:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE")
    auraLbl:SetPoint("CENTER", auraBG, "CENTER", 0, 0)

    -- hover bg
    local hoverBG = row:CreateTexture(nil, "BACKGROUND")
    hoverBG:SetAllPoints()
    hoverBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    hoverBG:SetVertexColor(1, 1, 1, 0)

    -- aura toggle state
    local auraOn = not (CoAAT_DB.auraDisabled and CoAAT_DB.auraDisabled[ab.id])

    local function RefreshRow()
        local sel = _selectedAbs[ab.id]
        if sel then
            tick:SetText("|cff00ff88✔|r")
            cbBG:SetVertexColor(0.15, 0.45, 0.20, 0.95)
            lbl:SetText("|cffffffff" .. ab.name .. "|r")
        else
            tick:SetText("")
            cbBG:SetVertexColor(0.08, 0.08, 0.14, 0.95)
            lbl:SetText("|cffaaaaaa" .. ab.name .. "|r")
        end

        -- type badge colour
        local TYPE_COLOR = {
            generator = {0.4,0.9,0.4},  spender  = {0.9,0.6,0.1},
            cooldown  = {0.4,0.7,1.0},  proc     = {1.0,0.3,0.9},
            buff      = {0.3,0.8,1.0},  debuff   = {1.0,0.4,0.4},
            filler    = {0.5,0.5,0.5},
        }
        local tc = TYPE_COLOR[ab.type] or {0.7,0.7,0.7}
        badge:SetText(string.format("|cff%02x%02x%02x%s|r",
            tc[1]*255, tc[2]*255, tc[3]*255,
            (ab.type or "?"):upper():sub(1,6)))

        -- aura badge
        if auraOn then
            auraBG:SetVertexColor(0.1, 0.4, 0.1, 0.9)
            auraLbl:SetText("|cff44ff44AURA ON|r")
        else
            auraBG:SetVertexColor(0.35, 0.08, 0.08, 0.9)
            auraLbl:SetText("|cffff4444AURA OFF|r")
        end
    end

    RefreshRow()

    -- click handling — left = checkbox, right = aura toggle
    row:EnableMouse(true)
    row:SetScript("OnMouseDown", function(self, btn)
        if btn == "LeftButton" then
            _selectedAbs[ab.id] = not _selectedAbs[ab.id] or nil
            RefreshRow()
            UpdatePreview()
        elseif btn == "RightButton" then
            auraOn = not auraOn
            if not CoAAT_DB.auraDisabled then CoAAT_DB.auraDisabled = {} end
            CoAAT_DB.auraDisabled[ab.id] = (not auraOn) or nil
            RefreshRow()
        end
    end)

    row:SetScript("OnEnter", function()
        hoverBG:SetVertexColor(1, 1, 1, 0.04)
        GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
        GameTooltip:ClearLines()
        GameTooltip:AddLine("|cffcc88ff" .. ab.name .. "|r")
        if ab.description then
            GameTooltip:AddLine(ab.description, 0.85, 0.85, 0.85, true)
        end
        if ab.hint then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("|cff00ccff" .. ab.hint .. "|r", 1, 1, 1, true)
        end
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("|cffaaaaaa[Left Click]|r  Toggle macro selection", 1,1,1)
        GameTooltip:AddLine("|cffaaaaaa[Right Click]|r Toggle aura display", 1,1,1)
        GameTooltip:Show()
    end)
    row:SetScript("OnLeave", function()
        hoverBG:SetVertexColor(1, 1, 1, 0)
        GameTooltip:Hide()
    end)

    return row
end

-- ─────────────────────────────────────────────────────────────
-- Populate ability list for current class/spec
-- ─────────────────────────────────────────────────────────────
local function PopulateAbilities()
    if not _frame then return end

    -- hide old rows
    for _, r in ipairs(_rows) do r:Hide() end
    _rows = {}
    _selectedAbs = {}

    local abs    = GetAbilities()
    local scroll = _frame._scroll
    local content = _frame._scrollContent

    local h = math.max(1, #abs * 30 + 10)
    content:SetHeight(h)

    for i, ab in ipairs(abs) do
        local yOff = -(i - 1) * 30 - 5
        local row  = MakeRow(content, ab, yOff)
        table.insert(_rows, row)
        row:Show()
    end

    UpdatePreview()
end

-- ─────────────────────────────────────────────────────────────
-- Build main frame
-- ─────────────────────────────────────────────────────────────
function CoAAT_MacroBuilder.Build()
    if _frame then return end

    local f = CreateFrame("Frame", "COAlMacroBuilder", UIParent)
    f:SetSize(680, 520)
    f:SetPoint("CENTER", UIParent, "CENTER", 80, 20)
    f:SetFrameStrata("HIGH")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop",  f.StopMovingOrSizing)
    f:Hide()

    -- Background
    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    bg:SetVertexColor(0.04, 0.04, 0.09, 0.97)

    -- Border accent lines
    for _, edge in ipairs({
        {"TOPLEFT","TOPRIGHT",2,0},{"BOTTOMLEFT","BOTTOMRIGHT",2,0},
        {"TOPLEFT","BOTTOMLEFT",0,2},{"TOPRIGHT","BOTTOMRIGHT",0,2}
    }) do
        local line = f:CreateTexture(nil,"OVERLAY")
        line:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
        line:SetVertexColor(0.6,0.2,1.0,0.8)
        if edge[3]==2 then
            line:SetHeight(edge[3])
            line:SetPoint("LEFT",f,edge[1],0,0)
            line:SetPoint("RIGHT",f,edge[2],0,0)
        else
            line:SetWidth(edge[4])
            line:SetPoint("TOP",f,edge[1],0,0)
            line:SetPoint("BOTTOM",f,edge[2],0,0)
        end
    end

    -- Title
    local title = f:CreateFontString(nil,"OVERLAY")
    title:SetFont("Fonts\\FRIZQT__.TTF",14,"OUTLINE")
    title:SetPoint("TOPLEFT",f,"TOPLEFT",14,-12)
    title:SetText("|cffcc88ff⚔ COAl|r |cff00ccffMacro Builder|r")

    local sub = f:CreateFontString(nil,"OVERLAY")
    sub:SetFont("Fonts\\FRIZQT__.TTF",8,"OUTLINE")
    sub:SetPoint("TOPLEFT",f,"TOPLEFT",14,-28)
    sub:SetText("|cffaaaaaa Left click = select for macro  •  Right click = toggle aura display|r")

    -- Close button
    local closeBtn = CreateFrame("Button", nil, f)
    closeBtn:SetSize(22,22)
    closeBtn:SetPoint("TOPRIGHT",f,"TOPRIGHT",-6,-6)
    local closeTex = closeBtn:CreateFontString(nil,"OVERLAY")
    closeTex:SetFont("Fonts\\FRIZQT__.TTF",14,"OUTLINE")
    closeTex:SetAllPoints()
    closeTex:SetText("|cffff4444✕|r")
    closeBtn:SetScript("OnClick", function() f:Hide() end)

    -- ── LEFT PANEL: Class/Spec + Ability List ─────────────────
    local leftW = 340

    -- Class label + dropdown area
    local classLbl = f:CreateFontString(nil,"OVERLAY")
    classLbl:SetFont("Fonts\\FRIZQT__.TTF",9,"OUTLINE")
    classLbl:SetPoint("TOPLEFT",f,"TOPLEFT",10,-46)
    classLbl:SetText("|cffcc88ffClass:|r")

    -- Class buttons (text buttons for each class)
    local CLASSES = {"felsworn","necromancer","witch_hunter","runemaster",
                     "reaper","spiritwalker","tinker","chronomancer"}
    local classBtns = {}
    local function SetClass(cid)
        _classId = cid
        _specId  = nil
        for _, b in ipairs(classBtns) do
            local isThis = (b._cid == cid)
            b._bg:SetVertexColor(
                isThis and 0.35 or 0.08,
                isThis and 0.10 or 0.08,
                isThis and 0.55 or 0.12,
                isThis and 0.95 or 0.7)
            b._lbl:SetText(isThis
                and ("|cffee99ff" .. b._cid:upper():sub(1,6) .. "|r")
                or  ("|cff666666" .. b._cid:upper():sub(1,6) .. "|r"))
        end
        -- populate spec buttons
        if CoAAT_Abilities and CoAAT_Abilities[cid] then
            local cd = CoAAT_Abilities[cid]
            local first = true
            for sid, sdata in pairs(cd.specs or {}) do
                if first then _specId = sid first = false end
            end
        end
        PopulateAbilities()
        f._specArea:Show()
        BuildSpecButtons()
    end

    local bW, bH, bCols = 76, 20, 4
    for i, cid in ipairs(CLASSES) do
        local col = (i-1) % bCols
        local row = math.floor((i-1) / bCols)
        local btn = CreateFrame("Button", nil, f)
        btn:SetSize(bW, bH)
        btn:SetPoint("TOPLEFT",f,"TOPLEFT", 10 + col*(bW+3), -60 - row*(bH+3))
        btn._cid = cid
        local bbg = btn:CreateTexture(nil,"BACKGROUND")
        bbg:SetAllPoints()
        bbg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
        bbg:SetVertexColor(0.08,0.08,0.12,0.7)
        btn._bg = bbg
        local blbl = btn:CreateFontString(nil,"OVERLAY")
        blbl:SetFont("Fonts\\FRIZQT__.TTF",7,"OUTLINE")
        blbl:SetAllPoints()
        blbl:SetJustifyH("CENTER")
        blbl:SetText("|cff666666" .. cid:upper():sub(1,6) .. "|r")
        btn._lbl = blbl
        btn:SetScript("OnClick", function() SetClass(cid) end)
        btn:SetScript("OnEnter", function() bbg:SetVertexColor(0.25,0.08,0.40,0.9) end)
        btn:SetScript("OnLeave", function()
            local isSel = (_classId == cid)
            bbg:SetVertexColor(isSel and 0.35 or 0.08, isSel and 0.10 or 0.08, isSel and 0.55 or 0.12, isSel and 0.95 or 0.7)
        end)
        table.insert(classBtns,btn)
    end

    -- Spec row
    local specArea = CreateFrame("Frame",nil,f)
    specArea:SetSize(leftW,20)
    specArea:SetPoint("TOPLEFT",f,"TOPLEFT",10,-108)
    specArea:Hide()
    f._specArea = specArea

    local specLbl = specArea:CreateFontString(nil,"OVERLAY")
    specLbl:SetFont("Fonts\\FRIZQT__.TTF",9,"OUTLINE")
    specLbl:SetPoint("LEFT",specArea,"LEFT",0,0)
    specLbl:SetText("|cffcc88ffSpec:|r")

    local specBtns = {}
    function BuildSpecButtons()
        for _, b in ipairs(specBtns) do b:Hide() end
        specBtns = {}
        if not (_classId and CoAAT_Abilities and CoAAT_Abilities[_classId]) then return end
        local cd   = CoAAT_Abilities[_classId]
        local idx  = 0
        for sid, sdata in pairs(cd.specs or {}) do
            local btn2 = CreateFrame("Button",nil,specArea)
            btn2:SetSize(72,18)
            btn2:SetPoint("LEFT",specArea,"LEFT",40+idx*76,0)
            local s2bg = btn2:CreateTexture(nil,"BACKGROUND")
            s2bg:SetAllPoints()
            s2bg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
            s2bg:SetVertexColor(0.08,0.08,0.12,0.7)
            local s2lbl = btn2:CreateFontString(nil,"OVERLAY")
            s2lbl:SetFont("Fonts\\FRIZQT__.TTF",7,"OUTLINE")
            s2lbl:SetAllPoints()
            s2lbl:SetJustifyH("CENTER")
            local isSel = (sid == _specId)
            s2bg:SetVertexColor(isSel and 0.2 or 0.08, isSel and 0.1 or 0.08, isSel and 0.4 or 0.12, 0.9)
            s2lbl:SetText(isSel
                and ("|cffee99ff" .. (sdata.name or sid):upper():sub(1,8) .. "|r")
                or  ("|cff666666" .. (sdata.name or sid):upper():sub(1,8) .. "|r"))
            btn2._sid = sid
            btn2:SetScript("OnClick", function()
                _specId = sid
                BuildSpecButtons()
                PopulateAbilities()
            end)
            table.insert(specBtns,btn2)
            btn2:Show()
            idx = idx + 1
        end
    end

    -- Select All / Deselect All buttons
    local selAllBtn = CreateFrame("Button",nil,f)
    selAllBtn:SetSize(80,16)
    selAllBtn:SetPoint("TOPLEFT",f,"TOPLEFT",10,-130)
    local saBG = selAllBtn:CreateTexture(nil,"BACKGROUND")
    saBG:SetAllPoints() saBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    saBG:SetVertexColor(0.1,0.3,0.1,0.8)
    local saLbl = selAllBtn:CreateFontString(nil,"OVERLAY")
    saLbl:SetFont("Fonts\\FRIZQT__.TTF",8,"OUTLINE")
    saLbl:SetAllPoints() saLbl:SetJustifyH("CENTER")
    saLbl:SetText("|cff44ff44Select All|r")
    selAllBtn:SetScript("OnClick", function()
        for _, ab in ipairs(GetAbilities()) do _selectedAbs[ab.id] = true end
        PopulateAbilities()
    end)

    local deselBtn = CreateFrame("Button",nil,f)
    deselBtn:SetSize(80,16)
    deselBtn:SetPoint("LEFT",selAllBtn,"RIGHT",4,0)
    local dsBG = deselBtn:CreateTexture(nil,"BACKGROUND")
    dsBG:SetAllPoints() dsBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    dsBG:SetVertexColor(0.3,0.08,0.08,0.8)
    local dsLbl = deselBtn:CreateFontString(nil,"OVERLAY")
    dsLbl:SetFont("Fonts\\FRIZQT__.TTF",8,"OUTLINE")
    dsLbl:SetAllPoints() dsLbl:SetJustifyH("CENTER")
    dsLbl:SetText("|cffff6666Clear All|r")
    deselBtn:SetScript("OnClick", function()
        _selectedAbs = {}
        PopulateAbilities()
    end)

    -- Scrollable ability list
    local scrollBG = f:CreateTexture(nil,"BACKGROUND")
    scrollBG:SetSize(leftW,290)
    scrollBG:SetPoint("TOPLEFT",f,"TOPLEFT",10,-150)
    scrollBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    scrollBG:SetVertexColor(0.02,0.02,0.05,0.8)

    local scroll = CreateFrame("ScrollFrame","COAlMBScroll",f,"UIPanelScrollFrameTemplate")
    scroll:SetSize(leftW-18,285)
    scroll:SetPoint("TOPLEFT",f,"TOPLEFT",10,-152)
    f._scroll = scroll

    local content = CreateFrame("Frame",nil,scroll)
    content:SetSize(leftW-20,1)
    scroll:SetScrollChild(content)
    f._scrollContent = content

    -- ── RIGHT PANEL: Template + Preview + Buttons ─────────────
    local rightX = leftW + 18

    local tmplLbl = f:CreateFontString(nil,"OVERLAY")
    tmplLbl:SetFont("Fonts\\FRIZQT__.TTF",9,"OUTLINE")
    tmplLbl:SetPoint("TOPLEFT",f,"TOPLEFT",rightX,-46)
    tmplLbl:SetText("|cffcc88ffMacro Template:|r")

    -- Template buttons
    local tmplBtns = {}
    local function SetTemplate(key)
        _templateMode = key
        for _, tb in ipairs(tmplBtns) do
            local isSel = (tb._key == key)
            tb._bg:SetVertexColor(isSel and 0.20 or 0.08, isSel and 0.08 or 0.08, isSel and 0.35 or 0.12, 0.9)
            tb._lbl:SetTextColor(isSel and 0.85 or 0.45, isSel and 0.55 or 0.45, isSel and 1.0 or 0.55)
        end
        UpdatePreview()
        -- update desc
        local t = TEMPLATES[key]
        f._tmplDesc:SetText("|cffaaaaaa" .. (t and t.desc or "") .. "|r")
    end

    for i, key in ipairs(TEMPLATE_ORDER) do
        local t   = TEMPLATES[key]
        local col = (i-1) % 2
        local row2 = math.floor((i-1) / 2)
        local btn3 = CreateFrame("Button",nil,f)
        btn3:SetSize(150,18)
        btn3:SetPoint("TOPLEFT",f,"TOPLEFT", rightX + col*154, -60 - row2*22)
        local tb3bg = btn3:CreateTexture(nil,"BACKGROUND")
        tb3bg:SetAllPoints() tb3bg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
        tb3bg:SetVertexColor(0.08,0.08,0.12,0.9)
        local tb3lbl = btn3:CreateFontString(nil,"OVERLAY")
        tb3lbl:SetFont("Fonts\\FRIZQT__.TTF",8,"OUTLINE")
        tb3lbl:SetAllPoints() tb3lbl:SetJustifyH("CENTER")
        tb3lbl:SetText(t.label)
        tb3lbl:SetTextColor(0.45,0.45,0.55)
        btn3._key = key
        btn3._bg  = tb3bg
        btn3._lbl = tb3lbl
        btn3:SetScript("OnClick", function() SetTemplate(key) end)
        btn3:SetScript("OnEnter", function() tb3bg:SetVertexColor(0.18,0.06,0.28,0.9) end)
        btn3:SetScript("OnLeave", function()
            local isSel = (_templateMode == key)
            tb3bg:SetVertexColor(isSel and 0.20 or 0.08, isSel and 0.08 or 0.08, isSel and 0.35 or 0.12, 0.9)
        end)
        table.insert(tmplBtns,btn3)
    end

    local tmplDescY = -60 - (math.ceil(#TEMPLATE_ORDER/2))*22 - 2
    local tmplDesc = f:CreateFontString(nil,"OVERLAY")
    tmplDesc:SetFont("Fonts\\FRIZQT__.TTF",7,"OUTLINE")
    tmplDesc:SetPoint("TOPLEFT",f,"TOPLEFT",rightX, tmplDescY)
    tmplDesc:SetWidth(310)
    tmplDesc:SetJustifyH("LEFT")
    tmplDesc:SetText("|cffaaaaaa" .. TEMPLATES.basic.desc .. "|r")
    f._tmplDesc = tmplDesc

    -- Preview box label
    local previewLblY = tmplDescY - 14
    local previewLbl = f:CreateFontString(nil,"OVERLAY")
    previewLbl:SetFont("Fonts\\FRIZQT__.TTF",9,"OUTLINE")
    previewLbl:SetPoint("TOPLEFT",f,"TOPLEFT",rightX, previewLblY)
    previewLbl:SetText("|cffcc88ffGenerated Macro Text:|r")

    -- Preview scroll
    local previewY = previewLblY - 14
    local previewBG = f:CreateTexture(nil,"BACKGROUND")
    previewBG:SetSize(312,200)
    previewBG:SetPoint("TOPLEFT",f,"TOPLEFT",rightX, previewY)
    previewBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    previewBG:SetVertexColor(0.02,0.02,0.06,0.9)

    local previewScroll = CreateFrame("ScrollFrame","COAlMBPreviewScroll",f,"UIPanelScrollFrameTemplate")
    previewScroll:SetSize(294,196)
    previewScroll:SetPoint("TOPLEFT",f,"TOPLEFT",rightX, previewY-2)

    local previewContent = CreateFrame("Frame",nil,previewScroll)
    previewContent:SetSize(290,1)
    previewScroll:SetScrollChild(previewContent)

    local previewTxt = previewContent:CreateFontString(nil,"OVERLAY")
    previewTxt:SetFont("Fonts\\FRIZQT__.TTF",8,"OUTLINE")
    previewTxt:SetPoint("TOPLEFT",previewContent,"TOPLEFT",4,-4)
    previewTxt:SetWidth(282)
    previewTxt:SetJustifyH("LEFT")
    previewTxt:SetText("|cff888888Select a class and abilities to preview macros here.|r")
    f._preview = previewTxt

    -- Create Macros button
    local createY = previewY - 202
    local createBtn = CreateFrame("Button",nil,f)
    createBtn:SetSize(150,26)
    createBtn:SetPoint("TOPLEFT",f,"TOPLEFT",rightX, createY)
    local crBG = createBtn:CreateTexture(nil,"BACKGROUND")
    crBG:SetAllPoints() crBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    crBG:SetVertexColor(0.10,0.35,0.10,0.95)
    local crLbl = createBtn:CreateFontString(nil,"OVERLAY")
    crLbl:SetFont("Fonts\\FRIZQT__.TTF",9,"OUTLINE")
    crLbl:SetAllPoints() crLbl:SetJustifyH("CENTER")
    crLbl:SetText("|cff666666Select abilities first|r")
    f._createBtn = createBtn

    createBtn:SetScript("OnClick", function()
        if InCombatLockdown() then
            DEFAULT_CHAT_FRAME:AddMessage("|cffFF4444[COAl]|r Cannot create macros in combat!")
            return
        end
        local abs   = GetAbilities()
        local made  = 0
        local errs  = {}
        for _, ab in ipairs(abs) do
            if _selectedAbs[ab.id] then
                local icon = ab.icon or "INV_Misc_QuestionMark"
                local body = MakeMacroText(ab)
                local ok, msg = TryCreateMacro(ab.name, icon, body)
                if ok then
                    made = made + 1
                else
                    table.insert(errs, msg)
                end
            end
        end
        if made > 0 then
            DEFAULT_CHAT_FRAME:AddMessage(
                "|cffcc88ff[COAl Macros]|r |cff00ff88Created/updated " ..
                made .. " macro" .. (made>1 and "s" or "") ..
                " — drag them from |cffFFD700General Macros|r tab!")
        end
        for _, e in ipairs(errs) do
            DEFAULT_CHAT_FRAME:AddMessage("|cffFF4444[COAl Macros]|r " .. e)
        end
    end)

    createBtn:SetScript("OnEnter", function() crBG:SetVertexColor(0.15,0.50,0.15,0.95) end)
    createBtn:SetScript("OnLeave", function() crBG:SetVertexColor(0.10,0.35,0.10,0.95) end)

    -- Open Macro Book button
    local macroBookBtn = CreateFrame("Button",nil,f)
    macroBookBtn:SetSize(150,26)
    macroBookBtn:SetPoint("LEFT",createBtn,"RIGHT",6,0)
    local mbBG = macroBookBtn:CreateTexture(nil,"BACKGROUND")
    mbBG:SetAllPoints() mbBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    mbBG:SetVertexColor(0.08,0.15,0.35,0.95)
    local mbLbl = macroBookBtn:CreateFontString(nil,"OVERLAY")
    mbLbl:SetFont("Fonts\\FRIZQT__.TTF",9,"OUTLINE")
    mbLbl:SetAllPoints() mbLbl:SetJustifyH("CENTER")
    mbLbl:SetText("|cff66aaff📖 Open Macro Book|r")
    macroBookBtn:SetScript("OnClick", function()
        if not InCombatLockdown() then
            if MacroFrame_OpenMacroBook then MacroFrame_OpenMacroBook() end
            if OpenMacroFrame then OpenMacroFrame() end
        end
    end)
    macroBookBtn:SetScript("OnEnter", function() mbBG:SetVertexColor(0.12,0.22,0.50,0.95) end)
    macroBookBtn:SetScript("OnLeave", function() mbBG:SetVertexColor(0.08,0.15,0.35,0.95) end)

    -- Status / tip line
    local statusLbl = f:CreateFontString(nil,"OVERLAY")
    statusLbl:SetFont("Fonts\\FRIZQT__.TTF",7,"OUTLINE")
    statusLbl:SetPoint("BOTTOMLEFT",f,"BOTTOMLEFT",10,8)
    statusLbl:SetWidth(660)
    statusLbl:SetJustifyH("LEFT")
    statusLbl:SetText("|cffaaaaaa⚔ Tip: After creating macros, open your Spellbook → General Macros to drag them to your action bars.|r")

    _frame = f

    -- Auto-load current class from engine
    local cid = CoAAT_Engine and CoAAT_Engine.GetClassId and CoAAT_Engine.GetClassId()
    if cid and CoAAT_Abilities and CoAAT_Abilities[cid] then
        SetClass(cid)
    end
    SetTemplate("basic")
end

-- ─────────────────────────────────────────────────────────────
-- Public API
-- ─────────────────────────────────────────────────────────────
function CoAAT_MacroBuilder.Open()
    if not _frame then CoAAT_MacroBuilder.Build() end
    _frame:Show()
    -- Refresh class from engine every time it's opened
    local cid = CoAAT_Engine and CoAAT_Engine.GetClassId and CoAAT_Engine.GetClassId()
    if cid and CoAAT_Abilities and CoAAT_Abilities[cid] and cid ~= _classId then
        -- trigger class set without the button loop
        _classId = cid
        _specId  = nil
        PopulateAbilities()
    end
end

function CoAAT_MacroBuilder.Close()
    if _frame then _frame:Hide() end
end

function CoAAT_MacroBuilder.Toggle()
    if not _frame then CoAAT_MacroBuilder.Build() end
    if _frame:IsShown() then _frame:Hide() else CoAAT_MacroBuilder.Open() end
end
