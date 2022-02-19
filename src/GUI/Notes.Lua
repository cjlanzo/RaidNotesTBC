local RaidNotes = _G.LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)
local AceGUI = _G.LibStub("AceGUI-3.0")

local f

function RaidNotes:Init_Notes()
    f = AceGUI:Create("Frame")
    f:Hide()
    f:SetHeight(400)
    f:SetWidth(400)
    -- f:SetAlpha(0.1)
    
    f:SetTitle("Notes")
    _G["Notes_MainFrame"] = f
end

function RaidNotes:Show_Notes()
    if not f then self:Init_Notes() end

    f:Show()
end

function RaidNotes:Hide_Notes() 
    f:Hide() 
end

function RaidNotes:Toggle_Notes()
    if f and f:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end