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
    -- Generate the data and text
    local data = self:BuildCharacterData()
    local text = self:ExportToText(data)
    
    -- Priority 5: Temporal Persistence
    -- Save the latest data and text into the addon's global table
    self.lastCharacterData = data
    self.lastExportText = text
    
    -- Print the saved text to chat
    self:Log("\n" .. self.lastExportText)
end