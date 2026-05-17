-- Modules/UI.lua

function CharacterExporter:InitializeUI()
    if self.UIFrame then return end

    -- Base Frame
    local frame = CreateFrame("Frame", "CharacterExporterMainFrame", UIParent, "UIPanelDialogTemplate")
    frame:SetSize(400, 450)
    frame:SetPoint("CENTER", UIParent, "CENTER")
    
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("TOP", frame, "TOP", 0, -15)
    frame.title:SetText("Character Exporter - Pikabura")

    -- ScrollFrame & EditBox (The copy-paste zone)
    local scrollFrame = CreateFrame("ScrollFrame", "CharacterExporterScrollFrame", frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, -40)
    scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -35, 15)

    local editBox = CreateFrame("EditBox", "CharacterExporterEditBox", scrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetFontObject("ChatFontNormal")
    editBox:SetWidth(330)
    editBox:SetAutoFocus(false) -- Prevents the cursor from automatically jumping here
    editBox:SetScript("OnEscapePressed", function() frame:Hide() end) -- Close window with ESC

    editBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
    editBox:SetScript("OnMouseUp", function(self) self:HighlightText() end)
    
    scrollFrame:SetScrollChild(editBox)

    -- Save references
    frame.editBox = editBox
    self.UIFrame = frame

    -- Hide the frame by default!
    frame:Hide()
end

--  Function to open the UI and inject our stored data
function CharacterExporter:ShowExportUI()
    self:InitializeUI() -- Ensure the UI is built
    
    -- Inject the text we stored in Phase 2
    if self.lastExportText then
        self.UIFrame.editBox:SetText(self.lastExportText)
    else
        self.UIFrame.editBox:SetText("No character data found. Please run the export first.")
    end
    
    -- Show the window
    self.UIFrame:Show()
end