-- Modules/Talents.lua
-- This module scans the player's talent trees specifically for the WoW Classic/TBC API.

function CharacterExporter:GatherTalentData()
    local talentData = {
        treeString = "0/0/0",
        specName = "None",
        trees = {}
    }

    local numTabs = GetNumTalentTabs() or 3
    local highestPoints = -1
    local primaryTreeName = "None"
    local pointsTable = {}

    -- Iterate through the 3 class talent trees
    for i = 1, numTabs do
        local name, _, pointsSpent = GetTalentTabInfo(i)
        
        if name then
            -- Store raw structured data for each individual tree
            table.insert(talentData.trees, {
                name = name,
                points = pointsSpent or 0
            })
            
            -- Save points to a flat array to build the shorthand string later
            table.insert(pointsTable, pointsSpent or 0)

            -- Determine the primary specialization by finding the tree with the most points
            if (pointsSpent or 0) > highestPoints then
                highestPoints = pointsSpent or 0
                primaryTreeName = name
            end
        end
    end

    -- Build the shorthand theorycrafting string (e.g., "11/0/50")
    if #pointsTable > 0 then
        talentData.treeString = table.concat(pointsTable, "/")
    end

    -- Assign the spec name only if the player has actually spent at least one point
    if highestPoints > 0 then
        talentData.specName = primaryTreeName
    end

    return talentData
end