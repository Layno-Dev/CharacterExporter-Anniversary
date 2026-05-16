DEFAULT_CHAT_FRAME:AddMessage("Character.lua loaded!")

function CharacterExporter:ExportCharacter()

    local exportText = "Character Export:\n"

    for slotName, slotID in pairs(self.EquipmentSlots) do

        local item = self:GetEquippedItem(slotID)

        if item then

            exportText = exportText ..
                string.format(
                    "%s: %s (ID: %s)\n",
                    slotName,
                    item.name,
                    item.id
                )

        else

            exportText = exportText ..
                string.format(
                    "%s: Empty\n",
                    slotName
                )

        end

    end

    self:Log(exportText)

end