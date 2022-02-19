local PersonalRaidNotes = _G.LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)
local AceGUI = _G.LibStub("AceGUI-3.0")

local f, notesFrame

function PersonalRaidNotes:CreateGUI()
    f = AceGUI:Create("Frame")
    f:Hide()
    f:SetWidth(800)
    f:EnableResize(false)

    f:SetTitle(ADDON_NAME)
    _G[ADDON_NAME.."_MainFrame"] = f

end

function PersonalRaidNotes:CreateNotesFrame()
    notesFrame = AceGUI:Create("Frame")
    notesFrame:Hide()
    notesFrame:SetHeight(400)
    notesFrame:SetWidth(400)
    -- notesFrame:SetAlpha(0.1)
    
    notesFrame:SetTitle("Boss Notes")
    _G["BossNotes_MainFrame"] = notesFrame

end

function PersonalRaidNotes:Show()
    if not f then self:CreateGUI() end

    f:Show()
end

function PersonalRaidNotes:ShowNotes()
    if not notesFrame then self:CreateNotesFrame() end

    notesFrame:Show()
end

function PersonalRaidNotes:Hide() 
    f:Hide() 
end

function PersonalRaidNotes:Toggle()
    if f and f:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end