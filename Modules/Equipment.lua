-- Modules/Equipment.lua

CharacterExporter.EquipmentSlots = {
    { name = "Head", slot = 1 },
    { name = "Neck", slot = 2 },
    { name = "Shoulder", slot = 3 },
    { name = "Shirt", slot = 4 },
    { name = "Chest", slot = 5 },
    { name = "Waist", slot = 6 },
    { name = "Legs", slot = 7 },
    { name = "Feet", slot = 8 },
    { name = "Wrist", slot = 9 },
    { name = "Hands", slot = 10 },
    { name = "Finger1", slot = 11 },
    { name = "Finger2", slot = 12 },
    { name = "Trinket1", slot = 13 },
    { name = "Trinket2", slot = 14 },
    { name = "Back", slot = 15 },
    { name = "MainHand", slot = 16 },
    { name = "OffHand", slot = 17 },
    { name = "Ranged", slot = 18 }
}

-- WoW item quality mapping
CharacterExporter.RarityNames = {
    [0] = "|cff9d9d9dPoor|r",       -- Grey
    [1] = "|cffffffffCommon|r",     -- White
    [2] = "|cff1eff00Uncommon|r",   -- Green
    [3] = "|cff0070ddRare|r",       -- Blue
    [4] = "|cffa335eeEpic|r",       -- Purple
    [5] = "|cffff8000Legendary|r"   -- Orange
}

function CharacterExporter:GetEquippedItem(slotID)
    local itemLink = GetInventoryItemLink("player", slotID)

    if not itemLink then
        return nil
    end

    local itemID = string.match(itemLink, "item:(%d+)")
    
    -- GetItemInfo returns many values. We use '_' to ignore the ones we don't need for now
    local itemName, _, itemRarity, itemLevel, _, _, itemSubType = GetItemInfo(itemLink)

    return {
        id = itemID,
        name = itemName,
        link = itemLink,
        rarity = itemRarity,
        ilvl = itemLevel,
        subclass = itemSubType
    }
end