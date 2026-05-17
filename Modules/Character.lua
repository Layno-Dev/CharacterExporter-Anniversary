-- Modules/Character.lua
DEFAULT_CHAT_FRAME:AddMessage("Character.lua loaded!")

-- 1. Data Model
function CharacterExporter:BuildCharacterData()
    local characterData = {
        info = {
            name = UnitName("player"),
            class = UnitClass("player"),
            level = UnitLevel("player")
        },
        equipment = {}
    }


    for _, slotInfo in ipairs(self.EquipmentSlots) do
        local item = self:GetEquippedItem(slotInfo.slot)
        
        -- save the estructured info
        table.insert(characterData.equipment, {
            slotName = slotInfo.name,
            itemData = item 
        })
    end

    return characterData
end


-- 2. Function to convert the data model into text
function CharacterExporter:ExportToText(data)
    local exportText = string.format("Character Export: %s (Level %s %s)\n", 
        data.info.name, data.info.level, data.info.class)
    
    exportText = exportText .. "-----------------------------\n"

    for _, gear in ipairs(data.equipment) do
        if gear.itemData then
            -- Basic data with cache validation
            local itemName = gear.itemData.name or "Loading..."
            
            -- New advanced data with default fallbacks
            local ilvl = gear.itemData.ilvl or "?"
            local subclass = gear.itemData.subclass or "?"
            local rarityNum = gear.itemData.rarity
            local rarityName = rarityNum and self.RarityNames[rarityNum] or "?"
            
            -- Expanded format output
            exportText = exportText .. string.format("%s: %s (ID: %s) [ilvl: %s | %s | %s]\n", 
                gear.slotName, itemName, gear.itemData.id, ilvl, rarityName, subclass)
        else
            exportText = exportText .. string.format("%s: Empty\n", gear.slotName)
        end
    end

    return exportText
end

-- 3. Main function called via /cexport
function CharacterExporter:ExportCharacter()
    -- 1. Build the data (Back-End)
    local characterData = self:BuildCharacterData()
    
    -- 2. Convert to text (Back-End)
    local exportString = self:ExportToText(characterData)
    
    -- 3. Temporary persistence 
    self.lastCharacterData = characterData
    self.lastExportText = exportString
    
    -- 4. STEP 4: Open the UI instead of printing to chat
    self:ShowExportUI()
end