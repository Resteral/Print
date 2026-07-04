-- TargetLootFrame.lua
-- Displays the dynamic loot table of the current target next to the TargetFrame

local _, addon = ...

local TargetLootFrame = CreateFrame("Frame", "CoALevelGuideTargetLootFrame", UIParent, "BasicFrameTemplateWithInset")
TargetLootFrame:SetSize(220, 150)
TargetLootFrame:SetPoint("TOPLEFT", TargetFrame, "BOTTOMRIGHT", -20, 20)
TargetLootFrame:Hide() -- Hide by default

-- Title
TargetLootFrame.title = TargetLootFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
TargetLootFrame.title:SetPoint("TOPLEFT", TargetLootFrame, "TOPLEFT", 10, -5)
TargetLootFrame.title:SetText("Known Drops")

-- Sample Size Indicator
TargetLootFrame.sampleSize = TargetLootFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
TargetLootFrame.sampleSize:SetPoint("TOPRIGHT", TargetLootFrame, "TOPRIGHT", -10, -7)
TargetLootFrame.sampleSize:SetTextColor(0.5, 0.5, 0.5)

-- Container for drop items
TargetLootFrame.itemFrames = {}

local function CreateItemFrame(index)
    local frame = CreateFrame("Frame", nil, TargetLootFrame)
    frame:SetSize(200, 24)
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
    text:SetJustifyH("LEFT")

    frame.icon = icon
    frame.text = text
    return frame
end

function TargetLootFrame.Refresh(npcID)
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
            -- Item not cached yet, show ID and standard icon
            itemFrame.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
            itemFrame.text:SetText("Item #" .. drop.id .. " (" .. percentage .. "%)")
        end
        
        itemFrame:Show()
    end
end

-- Event handling
TargetLootFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
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
    end
end)
