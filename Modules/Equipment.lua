CharacterExporter.EquipmentSlots = {
    Head = 1,
    Neck = 2,
    Shoulder = 3,
    Shirt = 4,
    Chest = 5,
    Waist = 6,
    Legs = 7,
    Feet = 8,
    Wrist = 9,
    Hands = 10,
    Finger1 = 11,
    Finger2 = 12,
    Trinket1 = 13,
    Trinket2 = 14,
    Back = 15,
    MainHand = 16,
    OffHand = 17,
    Ranged = 18
}

function CharacterExporter:GetEquippedItem(slotID)

    local itemLink = GetInventoryItemLink("player", slotID)

    if not itemLink then
        return nil
    end

    local itemID = string.match(itemLink, "item:(%d+)")
    local itemName = GetItemInfo(itemLink)

    return {
        id = itemID,
        name = itemName,
        link = itemLink
    }
end