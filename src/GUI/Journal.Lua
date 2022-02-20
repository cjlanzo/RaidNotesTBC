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

    local sideBar = AceGUI:Create("InlineGroup")
    sideBar:SetWidth(220)
    sideBar:SetTitle("Raids")

    RaidNotes:CreateRaidButton(sideBar, "Testing")
    RaidNotes:CreateRaidButton(sideBar, "Karazhan")
    RaidNotes:CreateRaidButton(sideBar, "Serpentshrine Cavern")
    RaidNotes:CreateRaidButton(sideBar, "Gruul's Lair")
    RaidNotes:CreateRaidButton(sideBar, "Magtheridon's Lair")
    RaidNotes:CreateRaidButton(sideBar, "Tempest Keep")
    RaidNotes:CreateRaidButton(sideBar, "Mount Hyjal")
    RaidNotes:CreateRaidButton(sideBar, "Black Temple")
    RaidNotes:CreateRaidButton(sideBar, "The Sunwell")
    
    f:AddChild(sideBar)

    local notesPane = AceGUI:Create("InlineGroup")
    notesPane:SetWidth(600)
    notesPane:SetTitle("Notes")

    RaidNotes:CreateNotesEdit(notesPane, "Trash")
    RaidNotes:CreateNotesEdit(notesPane, "Boss")

    f:AddChild(notesPane)
end

function RaidNotes:CreateRaidButton(parent, raidName)
    btn = AceGUI:Create("Button")
    btn:SetRelativeWidth(1)
    btn:SetHeight(40)
    btn:SetText(raidName)
    parent:AddChild(btn)
end

function RaidNotes:CreateNotesEdit(parent, name)
    editBox = AceGUI:Create("MultiLineEditBox")
    editBox:SetLabel(name)
    editBox:SetRelativeWidth(1)
    editBox:SetNumLines(9)
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