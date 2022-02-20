local RaidNotes = _G.LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)
local AceGUI = _G.LibStub("AceGUI-3.0")

local f

function RaidNotes:Init_Journal()
    f = AceGUI:Create("Frame")
    f:Hide()
    f:SetWidth(860)
    f:SetHeight(500)
    f:SetLayout("Flow")
    f:EnableResize(false)

    f:SetTitle(ADDON_NAME)
    _G[ADDON_NAME.."_MainFrame"] = f

    local tree = {
        {
            value = "A",
            text = "Alpha",
            children = {
                {
                    value = "D",
                    text = "Delta"
                }
            }
        },
        {
            value = "B",
            text = "Bravo"
        }
    }

    local treeGroup = AceGUI:Create("TreeGroup")
    treeGroup:SetFullWidth(true)
    treeGroup:SetFullHeight(true)
    treeGroup:SetTree(tree)
    f:AddChild(treeGroup)

    RaidNotes:CreateNotesEdit(treeGroup, "Trash")
    RaidNotes:CreateNotesEdit(treeGroup, "Boss")
end

function RaidNotes:CreateNotesEdit(parent, name)
    editBox = AceGUI:Create("MultiLineEditBox")
    editBox:SetLabel(name)
    editBox:SetRelativeWidth(1)
    editBox:SetNumLines(11)
    parent:AddChild(editBox)
end

function RaidNotes:Show_Journal()
    if not f then self:Init_Journal() end

    f:Show()
end

function RaidNotes:Hide_Journal() 
    f:Hide() 
end

function RaidNotes:Toggle_Journal()
    if f and f:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end