-- Modules/UI.lua

function CharacterExporter:InitializeUI()
    if self.UIFrame then return end

    -- 1. Base Frame 
    local frame = CreateFrame("Frame", "CharacterExporterMainFrame", UIParent, "UIPanelDialogTemplate")
    frame:SetSize(450, 480) 
    frame:SetPoint("CENTER", UIParent, "CENTER")
    
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    -- 2. Dynamic Title
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("TOP", frame, "TOP", 0, -15)
    frame.title:SetText("Character Export - " .. UnitName("player"))

    -- 3. Upper descriptive text
    frame.desc = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.desc:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -40)
    frame.desc:SetWidth(410) -- Keeps the text within borders
    frame.desc:SetJustifyH("LEFT") -- Left alignment
    frame.desc:SetText("Choose which character data to include. CharacterExport creates a text export you can copy, save, share, or use with external tools.")

    -- 4. Main Equipment box
    local equipCheck = CreateFrame("CheckButton", "CharacterExporterCheck_Equipment", frame, "ChatConfigCheckButtonTemplate")
    equipCheck:SetPoint("TOPLEFT", frame.desc, "BOTTOMLEFT", 10, -20)
    _G[equipCheck:GetName().."Text"]:SetText("Equipment")
    equipCheck:SetChecked(true) -- Checked by default

    -- 5. Detailed Stats
    local statsCheck = CreateFrame("CheckButton", "CharacterExporterCheck_DetailedStats", frame, "ChatConfigCheckButtonTemplate")
    statsCheck:SetPoint("TOPLEFT", equipCheck, "BOTTOMLEFT", 20, -5) 
    _G[statsCheck:GetName().."Text"]:SetText("Include Detailed Stats")
    statsCheck:SetChecked(false)

    -- 6. Talents Box
    local talentsCheck = CreateFrame("CheckButton", "CharacterExporterCheck_Talents", frame, "ChatConfigCheckButtonTemplate")
    talentsCheck:SetPoint("TOPLEFT", frame.desc, "BOTTOMLEFT", 220, -20) 
    _G[talentsCheck:GetName().."Text"]:SetText("Talents")
    talentsCheck:SetChecked(false)

    -- 7. Save references
    frame.checkboxes = {
        equipment = equipCheck,
        detailedStats = statsCheck,
        talents = talentsCheck
    }
    
    -- 8. Dropdown Menu for Format Selection
    local formatLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    formatLabel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 20, 60)
    formatLabel:SetText("Format:")

    local formatDropdown = CreateFrame("Frame", "CharacterExporterFormatDropdown", frame, "UIDropDownMenuTemplate")
    formatDropdown:SetPoint("LEFT", formatLabel, "RIGHT", -10, -3)
    -- Options (JSON, MD, Text) will be initialized via the template below
    UIDropDownMenu_SetWidth(formatDropdown, 120)
    UIDropDownMenu_SetText(formatDropdown, "Simple Text") 

    -- 9. Bottom Action Buttons
    local selectAllBtn = CreateFrame("Button", "CharacterExporterBtn_SelectAll", frame, "UIPanelButtonTemplate")
    selectAllBtn:SetSize(100, 25)
    selectAllBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 15, 15)
    selectAllBtn:SetText("Select All")

    local clearAllBtn = CreateFrame("Button", "CharacterExporterBtn_ClearAll", frame, "UIPanelButtonTemplate")
    clearAllBtn:SetSize(100, 25)
    clearAllBtn:SetPoint("LEFT", selectAllBtn, "RIGHT", 10, 0)
    clearAllBtn:SetText("Clear All")

    local exportBtn = CreateFrame("Button", "CharacterExporterBtn_Export", frame, "UIPanelButtonTemplate")
    exportBtn:SetSize(120, 25)
    exportBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -15, 15)
    exportBtn:SetText("Create Export")

    -- 10. Save references for the new elements
    frame.formatDropdown = formatDropdown
    frame.buttons = {
        selectAll = selectAllBtn,
        clearAll = clearAllBtn,
        export = exportBtn
    }

    -- 11. Logic for Select All and Clear All buttons
    frame.buttons.selectAll:SetScript("OnClick", function()
        -- Loop through all saved checkboxes and check them
        for _, checkbox in pairs(frame.checkboxes) do
            checkbox:SetChecked(true)
        end
    end)

    frame.buttons.clearAll:SetScript("OnClick", function()
        -- Loop through all saved checkboxes and uncheck them
        for _, checkbox in pairs(frame.checkboxes) do
            checkbox:SetChecked(false)
        end
    end)

    -- 12. Initialize Dropdown Options
    UIDropDownMenu_Initialize(frame.formatDropdown, function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo()
        
        -- Option 1: Simple Text
        info.text = "Simple Text"
        info.arg1 = "Simple Text"
        info.func = function(self, arg1)
            UIDropDownMenu_SetText(frame.formatDropdown, arg1)
        end
        UIDropDownMenu_AddButton(info)

        -- Option 2: JSON
        info.text = "JSON"
        info.arg1 = "JSON"
        info.func = function(self, arg1)
            UIDropDownMenu_SetText(frame.formatDropdown, arg1)
        end
        UIDropDownMenu_AddButton(info)

        -- Option 3: Markdown (MD)
        info.text = "Markdown"
        info.arg1 = "Markdown"
        info.func = function(self, arg1)
            UIDropDownMenu_SetText(frame.formatDropdown, arg1)
        end
        UIDropDownMenu_AddButton(info)
    end)

    -- 13. Logic for Create Export button
    frame.buttons.export:SetScript("OnClick", function()
        -- Read the dropdown format
        local selectedFormat = UIDropDownMenu_GetText(frame.formatDropdown)
        
        -- Read the checkboxes
        local includeEquipment = frame.checkboxes.equipment:GetChecked()
        local includeDetailed = frame.checkboxes.detailedStats:GetChecked() 
        
        -- Build the final string
        local finalOutput = "Format Selected: " .. (selectedFormat or "Simple Text") .. "\n\n"
        
        if includeEquipment then
            local data = CharacterExporter:BuildCharacterData()
            
            -- Decision Logic: Route data extraction based on format selection
            if selectedFormat == "JSON" then
                finalOutput = finalOutput .. CharacterExporter:ExportToJSON(data, includeDetailed)
            elseif selectedFormat == "Markdown" then
                finalOutput = finalOutput .. CharacterExporter:ExportToMD(data, includeDetailed)
            else
                finalOutput = finalOutput .. CharacterExporter:ExportToText(data, includeDetailed)
            end
            
        else
            finalOutput = finalOutput .. "No data selected for export. Please check a box."
        end
        
        -- Call the function to show the results window
        CharacterExporter:ShowResultsWindow(finalOutput)
    end)

    self.UIFrame = frame
    frame:Hide()
end 

-- Function to open the UI
function CharacterExporter:ShowExportUI()
    self:InitializeUI() -- Ensure the UI is built
    self.UIFrame:Show()
end

-- Function to build and show the Results Window
function CharacterExporter:ShowResultsWindow(textToDisplay)
    -- If the results frame doesn't exist yet, build it
    if not self.ResultsFrame then
        local resFrame = CreateFrame("Frame", "CharacterExporterResultsFrame", UIParent, "UIPanelDialogTemplate")
        resFrame:SetSize(400, 450)
        resFrame:SetPoint("CENTER", UIParent, "CENTER")
        
        resFrame:SetMovable(true)
        resFrame:EnableMouse(true)
        resFrame:RegisterForDrag("LeftButton")
        resFrame:SetScript("OnDragStart", resFrame.StartMoving)
        resFrame:SetScript("OnDragStop", resFrame.StopMovingOrSizing)

        resFrame.title = resFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        resFrame.title:SetPoint("TOP", resFrame, "TOP", 0, -15)
        resFrame.title:SetText("Export Results")

        -- ScrollFrame & EditBox (The copy-paste zone!)
        local scrollFrame = CreateFrame("ScrollFrame", "CharacterExporterResScroll", resFrame, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("TOPLEFT", resFrame, "TOPLEFT", 15, -40)
        scrollFrame:SetPoint("BOTTOMRIGHT", resFrame, "BOTTOMRIGHT", -35, 45)

        local editBox = CreateFrame("EditBox", "CharacterExporterResEditBox", scrollFrame)
        editBox:SetMultiLine(true)
        editBox:SetFontObject("ChatFontNormal")
        editBox:SetWidth(330)
        editBox:SetAutoFocus(false)
        
        -- Auto-select and navigation logic
        editBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
        editBox:SetScript("OnMouseUp", function(self) self:HighlightText() end)
        editBox:SetScript("OnEscapePressed", function() resFrame:Hide() end)
        
        scrollFrame:SetScrollChild(editBox)

        -- Back Button to return to the Main Menu
        local backBtn = CreateFrame("Button", "CharacterExporterBtn_Back", resFrame, "UIPanelButtonTemplate")
        backBtn:SetSize(120, 25)
        backBtn:SetPoint("BOTTOM", resFrame, "BOTTOM", 0, 15)
        backBtn:SetText("Back to Menu")
        backBtn:SetScript("OnClick", function()
            resFrame:Hide()
            CharacterExporter.UIFrame:Show()
        end)

        resFrame.editBox = editBox
        self.ResultsFrame = resFrame
    end

    -- Hide the Main Menu, inject the text, and show the Results Window
    if self.UIFrame then self.UIFrame:Hide() end
    self.ResultsFrame.editBox:SetText(textToDisplay)
    self.ResultsFrame:Show()
end