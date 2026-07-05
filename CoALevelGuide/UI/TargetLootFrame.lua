-- TargetLootFrame.lua
-- Displays the dynamic loot table of the current target next to the TargetFrame

local _, addon = ...

local TargetLootFrame = CreateFrame("Frame", "CoALevelGuideTargetLootFrame", UIParent)
TargetLootFrame:SetSize(240, 150)
TargetLootFrame:SetPoint("TOPLEFT", TargetFrame, "BOTTOMRIGHT", -20, 20)
TargetLootFrame:Hide() -- Hide by default

-- Background (sleek dark tint)
local bg = TargetLootFrame:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints()
bg:SetTexture(0.02, 0.02, 0.05, 0.95)

-- Border
local function makeBorder()
    local t = TargetLootFrame:CreateTexture(nil, "OVERLAY")
    t:SetTexture(0.0, 0.5, 0.9, 0.45)
    return t
end
local bTop = makeBorder(); bTop:SetPoint("TOPLEFT"); bTop:SetPoint("TOPRIGHT"); bTop:SetHeight(1.5)
local bBottom = makeBorder(); bBottom:SetPoint("BOTTOMLEFT"); bBottom:SetPoint("BOTTOMRIGHT"); bBottom:SetHeight(1.5)
local bLeft = makeBorder(); bLeft:SetPoint("TOPLEFT"); bLeft:SetPoint("BOTTOMLEFT"); bLeft:SetWidth(1.5)
local bRight = makeBorder(); bRight:SetPoint("TOPRIGHT"); bRight:SetPoint("BOTTOMRIGHT"); bRight:SetWidth(1.5)

-- Title
TargetLootFrame.title = TargetLootFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
TargetLootFrame.title:SetPoint("TOPLEFT", TargetLootFrame, "TOPLEFT", 10, -5)
TargetLootFrame.title:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
TargetLootFrame.title:SetText("Known Drops")

-- Sample Size Indicator
TargetLootFrame.sampleSize = TargetLootFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
TargetLootFrame.sampleSize:SetPoint("TOPRIGHT", TargetLootFrame, "TOPRIGHT", -10, -7)
TargetLootFrame.sampleSize:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
TargetLootFrame.sampleSize:SetTextColor(0.6, 0.6, 0.6)

-- Container for drop items
TargetLootFrame.itemFrames = {}

local function CreateItemFrame(index)
    local frame = CreateFrame("Frame", nil, TargetLootFrame)
    frame:SetSize(220, 24)
    if index == 1 then
        frame:SetPoint("TOPLEFT", TargetLootFrame, "TOPLEFT", 10, -30)
    else
        frame:SetPoint("TOPLEFT", TargetLootFrame.itemFrames[index-1], "BOTTOMLEFT", 0, -5)
    end

    local icon = frame:CreateTexture(nil, "ARTWORK")
    icon:SetSize(20, 20)
    icon:SetPoint("LEFT", frame, "LEFT", 0, 0)
    
    local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    text:SetPoint("LEFT", icon, "RIGHT", 5, 0)
    text:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    text:SetJustifyH("LEFT")

    frame.icon = icon
    frame.text = text
    return frame
end

local currentTargetNPCID = nil

function TargetLootFrame.Refresh(npcID)
    currentTargetNPCID = npcID
    if not npcID or not CoALevelGuideLootDB then 
        TargetLootFrame:Hide()
        return 
    end

    local lootData = CoALevelGuideLootDB[npcID]
    
    -- Hide all existing item frames first
    for _, itemFrame in ipairs(TargetLootFrame.itemFrames) do
        itemFrame:Hide()
    end

    if not lootData or not lootData.drops then
        TargetLootFrame:Hide()
        return
    end

    -- Count total unique items
    local itemCount = 0
    local sortedDrops = {}
    for itemID, count in pairs(lootData.drops) do
        itemCount = itemCount + 1
        table.insert(sortedDrops, { id = itemID, count = count })
    end

    if itemCount == 0 then
        TargetLootFrame:Hide()
        return
    end
    
    -- Sort by highest drop chance
    table.sort(sortedDrops, function(a, b) return a.count > b.count end)

    -- Show and populate
    TargetLootFrame:Show()
    TargetLootFrame:SetHeight(40 + (itemCount * 29)) -- Dynamically resize based on items
    TargetLootFrame.sampleSize:SetText(lootData.kills .. " Kills")

    for i, drop in ipairs(sortedDrops) do
        if not TargetLootFrame.itemFrames[i] then
            TargetLootFrame.itemFrames[i] = CreateItemFrame(i)
        end
        
        local itemFrame = TargetLootFrame.itemFrames[i]
        local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(drop.id)
        
        -- Calculate accurate percentage
        local percentage = 0
        if lootData.kills > 0 then
            percentage = math.floor((drop.count / lootData.kills) * 100)
            if percentage > 100 then percentage = 100 end -- Cap at 100 for mock data imports
        else
            percentage = drop.count -- Fallback for mock initial imports which just stored percentage in count
        end
        
        if itemName then
            itemFrame.icon:SetTexture(itemTexture)
            itemFrame.text:SetText(itemLink .. " (" .. percentage .. "%)")
        else
            -- Item not cached yet, query and show fallback
            itemFrame.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
            itemFrame.text:SetText("Loading Link #" .. drop.id .. " (" .. percentage .. "%)")
        end
        
        itemFrame:Show()
    end
end

-- Event handling
TargetLootFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetLootFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
TargetLootFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_TARGET_CHANGED" then
        if UnitExists("target") and not UnitIsPlayer("target") then
            local guid = UnitGUID("target")
            if guid then
                -- WotLK GUID parsing for NPC ID
                local npcID = tonumber(string.sub(guid, 9, 12), 16)
                TargetLootFrame.Refresh(npcID)
            else
                TargetLootFrame:Hide()
            end
        else
            TargetLootFrame:Hide()
        end
    elseif event == "GET_ITEM_INFO_RECEIVED" then
        if TargetLootFrame:IsShown() and currentTargetNPCID then
            TargetLootFrame.Refresh(currentTargetNPCID)
        end
    end
end)
