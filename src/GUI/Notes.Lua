local RaidNotes = _G.LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)
local AceGUI = _G.LibStub("AceGUI-3.0")

local f

function RaidNotes:LockNotes()
    f.frame:DisableDrawLayer("BACKGROUND")
    f.frame:DisableDrawLayer("BORDER")
    f.frame:SetResizable(false)
    f.frame:SetMovable(false)
    f.closebutton:Hide()
    f.sizer_se:Hide()
    f.sizer_e:Hide()
    f.sizer_s:Hide()
    f.title:Hide()
    f.titletext:Hide()
end

function RaidNotes:UnlockNotes()
    if not f then self:InitNotes() end
    
    f.frame:EnableDrawLayer("BACKGROUND")
    f.frame:EnableDrawLayer("BORDER")
    f.frame:SetResizable(true)
    f.frame:SetMovable(true)
    f.closebutton:Show()
    f.sizer_se:Show()
    f.sizer_e:Show()
    f.sizer_s:Show()
    f.title:Show()
    f.titletext:Show()
end

function RaidNotes:InitNotes()
    f = AceGUI:Create("Window")
    f:Hide()
    f:SetHeight(400)
    f:SetWidth(400)
    f:SetTitle("Drag me")
    f:SetLayout("Fill")
    f.frame:SetFrameStrata("BACKGROUND")
    f.frame:EnableMouse(false)

    local framePos = RaidNotes:LoadFramePosition()
    f:ClearAllPoints()
    f:SetPoint(framePos.point, framePos.xOfs, framePos.yOfs)

    RaidNotes:LockNotes()

    local label = AceGUI:Create("Label")
    _G["Notes_Label"] = label

    f:AddChild(label)
    
    _G["Notes_MainFrame"] = f
end

function RaidNotes:UpdateNotes(bossName, trashNotes, bossNotes)
    if not f then self:InitNotes() end
    
    local text = "-= "..bossName.." =-\n\n"
        
    if trashNotes then
        text = text.."Trash Notes:\n"..trashNotes.."\n\nBoss Notes:\n"
    end
    
    text = text..bossNotes

    _G["Notes_Label"]:SetText(text)
    _G["Notes_Label"]:SetFontObject(GameFontNormalLarge)

    self:ShowNotes()
end

function RaidNotes:ShowNotes()
    if not f then self:InitNotes() end

    f:Show()
end

function RaidNotes:HideNotes() 
    if f then f:Hide() end
end

function RaidNotes:ToggleNotes()
    if f and f:IsShown() then
        self:HideNotes()
    else
        self:ShowNotes()
    end
end