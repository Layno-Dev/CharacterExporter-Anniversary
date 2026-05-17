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
        
        -- Save the structured info
        table.insert(characterData.equipment, {
            slotName = slotInfo.name,
            itemData = item 
        })
    end

    -- Inject scanned talent data from Phase 4 Step 1
    characterData.talents = self:GatherTalentData()

    return characterData
end

-- 2. SIMPLE TEXT EXPORT
function CharacterExporter:ExportToText(data, includeDetailed)
    local charName = data.info and data.info.name or UnitName("player") or "Unknown"
    local charLevel = data.info and data.info.level or UnitLevel("player") or 0
    local charClass = data.info and data.info.class or UnitClass("player") or "Unknown"
    local equipmentList = data.equipment or data

    local exportText = string.format("Character Export: %s (Level %s %s)\n-----------------------------\n", charName, charLevel, charClass)
    
    for _, slot in ipairs(equipmentList) do
        if slot.itemData and slot.itemData.name then
            exportText = exportText .. string.format("%s: %s", slot.slotName, slot.itemData.name)
            
            -- THE TOGGLE: Add metadata only if Detailed Stats is checked
            if includeDetailed then
                local rarityNum = slot.itemData.rarity
                local rarityName = rarityNum and self.RarityNames[rarityNum] or "Common"
                
                exportText = exportText .. string.format(" (ID: %s) [ilvl: %s | %s | %s]", 
                    slot.itemData.id or 0, 
                    slot.itemData.ilvl or 0, 
                    rarityName, 
                    slot.itemData.subclass or "Misc")
            end
            exportText = exportText .. "\n"
        else
            exportText = exportText .. string.format("%s: Empty\n", slot.slotName)
        end
    end
    
    return exportText
end

-- 3. JSON EXPORT
function CharacterExporter:ExportToJSON(data, includeDetailed)
    local json = "{\n"
    local equipmentList = data.equipment or data
    
    local charName = data.info and data.info.name or UnitName("player") or "Unknown"
    local charLevel = data.info and data.info.level or UnitLevel("player") or 0
    local charClass = data.info and data.info.class or UnitClass("player") or "Unknown"

    json = json .. '  "character": {\n'
    json = json .. '    "name": "' .. charName .. '",\n'
    json = json .. '    "level": ' .. charLevel .. ',\n'
    json = json .. '    "class": "' .. charClass .. '"\n'
    json = json .. '  },\n'
    
    json = json .. '  "equipment": [\n'
    
    for i, slot in ipairs(equipmentList) do
        json = json .. '    {\n'
        json = json .. '      "slot": "' .. (slot.slotName or "Unknown") .. '",\n'
        
        if slot.itemData and slot.itemData.name then
            json = json .. '      "name": "' .. slot.itemData.name .. '"'
            
            -- THE TOGGLE: Append extra fields if checked
            if includeDetailed then
                local rarityNum = slot.itemData.rarity
                local rarityName = rarityNum and self.RarityNames[rarityNum] or "Common"
                
                json = json .. ',\n      "id": ' .. (slot.itemData.id or 0) .. ',\n'
                json = json .. '      "ilvl": ' .. (slot.itemData.ilvl or 0) .. ',\n'
                json = json .. '      "rarity": "' .. rarityName .. '",\n'
                json = json .. '      "subclass": "' .. (slot.itemData.subclass or "") .. '"\n'
            else
                json = json .. '\n'
            end
        else
            json = json .. '      "isEmpty": true\n'
        end
        
        if i < #equipmentList then json = json .. '    },\n' else json = json .. '    }\n' end
    end
    
    json = json .. '  ]\n}'
    return json
end

-- 4. MARKDOWN EXPORT
function CharacterExporter:ExportToMD(data, includeDetailed)
    local charName = data.info and data.info.name or UnitName("player") or "Unknown"
    local equipmentList = data.equipment or data

    local md = "## Character Export: " .. charName .. "\n\n"
    
    -- THE TOGGLE: Adjust table headers
    if includeDetailed then
        md = md .. "| Slot | Item Name | Item ID | iLvl | Rarity | Type |\n"
        md = md .. "| :--- | :--- | :--- | :--- | :--- | :--- |\n"
    else
        md = md .. "| Slot | Item Name |\n"
        md = md .. "| :--- | :--- |\n"
    end
    
    for _, slot in ipairs(equipmentList) do
        if slot.itemData and slot.itemData.name then
            -- THE TOGGLE: Adjust table rows
            if includeDetailed then
                local rarityNum = slot.itemData.rarity
                local rarityName = rarityNum and self.RarityNames[rarityNum] or "Common"
                
                md = md .. "| **" .. (slot.slotName or "Unknown") .. "** | " .. slot.itemData.name .. " | " .. (slot.itemData.id or 0) .. " | " .. (slot.itemData.ilvl or 0) .. " | " .. rarityName .. " | " .. (slot.itemData.subclass or "-") .. " |\n"
            else
                md = md .. "| **" .. (slot.slotName or "Unknown") .. "** | " .. slot.itemData.name .. " |\n"
            end
        else
            if includeDetailed then
                md = md .. "| **" .. (slot.slotName or "Unknown") .. "** | *Empty* | - | - | - | - |\n"
            else
                md = md .. "| **" .. (slot.slotName or "Unknown") .. "** | *Empty* |\n"
            end
        end
    end
    
    return md
end

-- 5. Main function called via /cexport
function CharacterExporter:ExportCharacter()
    -- 1. Build the data (Back-End)
    local characterData = self:BuildCharacterData()
    
    -- 2. Convert to text (Back-End)
    local exportString = self:ExportToText(characterData, false) 
    
    -- 3. Temporary persistence 
    self.lastCharacterData = characterData
    self.lastExportText = exportString
    
    -- 4. STEP 4: Open the UI instead of printing to chat
    self:ShowExportUI()
end