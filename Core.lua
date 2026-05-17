CharacterExporter = {}

CharacterExporter.name = "CharacterExporter"
CharacterExporter.version = "1.0"

function CharacterExporter:Log(message)
    DEFAULT_CHAT_FRAME:AddMessage(
        "|cff00ffcc[" .. self.name .. "]|r " .. message
    )
end

SLASH_CHARACTEREXPORTER1 = "/cexport"

SlashCmdList["CHARACTEREXPORTER"] = function()
    CharacterExporter:ExportCharacter()
end