local RaidNotes = _G.LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)
local AceGUI = _G.LibStub("AceGUI-3.0")

local f

function RaidNotes:InitNotes()
    f = AceGUI:Create("Frame")
    f:Hide()
    f:SetHeight(400)
    f:SetWidth(400)
    f:SetTitle("Notes")
    f:SetLayout("Fill")
    -- f:SetBackdropColor(0,0,0,0.2)

    local label = AceGUI:Create("Label")
    _G["Notes_Label"] = label

    f:AddChild(label)
    
    _G["Notes_MainFrame"] = f
end

function RaidNotes:UpdateNotes(bossName, trashNotes, bossNotes)
    if not f then self:InitNotes() end
    
    f:SetTitle(bossName.." Notes")
    
    local text = ""
        
    if trashNotes then
        text = text.."Trash Notes:\n"..trashNotes.."\n\nBoss Notes:\n"
    end
    
    text = text..bossNotes

    _G["Notes_Label"]:SetText(text)
end

function RaidNotes:ShowNotes()
    if not f then self:InitNotes() end

    f:Show()
end

function RaidNotes:HideNotes() 
    f:Hide() 
end

function RaidNotes:ToggleNotes()
    if f and f:IsShown() then
        self:HideNotes()
    else
        self:ShowNotes()
    end
end