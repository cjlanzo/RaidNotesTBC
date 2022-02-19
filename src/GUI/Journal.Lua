local RaidNotes = _G.LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)
local AceGUI = _G.LibStub("AceGUI-3.0")

local f

function RaidNotes:Init_Journal()
    f = AceGUI:Create("Frame")
    f:Hide()
    f:SetWidth(800)
    f:EnableResize(false)

    f:SetTitle(ADDON_NAME)
    _G[ADDON_NAME.."_MainFrame"] = f
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