-- LootTracker.lua
-- Listens for LOOT_OPENED to dynamically build the CoALevelGuideLootDB

local _, addon = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("LOOT_OPENED")

-- We need a way to track what NPC we just killed.
-- The most reliable way in standard WoW API for this context is to check the current target
-- when LOOT_OPENED fires. Usually, players click the corpse they are looting, making it the target.
-- Alternatively, we can track combat log for unit deaths. 
-- For simplicity, if we have a dead target when LOOT_OPENED fires, we attribute loot to it.

local function InitializeDB()
    if not CoALevelGuideLootDB then
        CoALevelGuideLootDB = {}
    end
    
    -- Merge mock data as a baseline if it exists and hasn't been merged
    if CoALevelGuide_LootTables and not CoALevelGuideLootDB._mockMerged then
        for npcID, drops in pairs(CoALevelGuide_LootTables) do
            if not CoALevelGuideLootDB[npcID] then
                CoALevelGuideLootDB[npcID] = { kills = 100, drops = {} }
                for _, d in ipairs(drops) do
                    CoALevelGuideLootDB[npcID].drops[d.id] = d.chance -- treating baseline chance as raw count out of 100
                end
            end
        end
        CoALevelGuideLootDB._mockMerged = true
    end
end

f:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "CoALevelGuide" then
            InitializeDB()
        end
    elseif event == "LOOT_OPENED" then
        if not CoALevelGuideLootDB then return end
        
        -- Try to get the NPC ID of the corpse being looted
        if UnitExists("target") and UnitIsDead("target") and not UnitIsPlayer("target") then
            local guid = UnitGUID("target")
            if guid then
                local npcID = tonumber(string.sub(guid, 9, 12), 16)
                if npcID then
                    if not CoALevelGuideLootDB[npcID] then
                        CoALevelGuideLootDB[npcID] = { kills = 0, drops = {} }
                    end
                    
                    -- Increment kill/loot count
                    CoALevelGuideLootDB[npcID].kills = CoALevelGuideLootDB[npcID].kills + 1
                    
                    -- Scan loot window
                    local numItems = GetNumLootItems()
                    for i = 1, numItems do
                        local lootIcon, lootName, lootQuantity, currencyID, lootQuality, locked, isQuestItem, questId, isActive = GetLootSlotInfo(i)
                        local link = GetLootSlotLink(i)
                        if link then
                            -- Extract item ID from link
                            local itemID = tonumber(string.match(link, "item:(%d+)"))
                            if itemID then
                                CoALevelGuideLootDB[npcID].drops[itemID] = (CoALevelGuideLootDB[npcID].drops[itemID] or 0) + 1
                            end
                        end
                    end
                    
                    -- Refresh UI if it's open
                    if CoALevelGuideTargetLootFrame and CoALevelGuideTargetLootFrame:IsShown() then
                        CoALevelGuideTargetLootFrame.Refresh(npcID)
                    end
                end
            end
        end
    end
end)
