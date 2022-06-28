local RaidNotes = _G.LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)
local AceGUI = _G.LibStub("AceGUI-3.0")

local f

function RaidNotes:LockNotes()
    f.frame:DisableDrawLayer("BORDER")
    f.frame:SetResizable(false)
    f.frame:SetMovable(false)
    f.closebutton:Hide()
    f.sizer_se:Hide()
    f.sizer_e:Hide()
    f.sizer_s:Hide()
    f.title:Hide()
    f.titletext:Hide()
    f.titlebg:Hide()
end

function RaidNotes:UnlockNotes()
    if not f then self:InitNotes() end
    
    f.frame:EnableDrawLayer("BORDER")
    f.frame:SetResizable(true)
    f.frame:SetMovable(true)
    f.closebutton:Show()
    f.sizer_se:Show()
    f.sizer_e:Show()
    f.sizer_s:Show()
    f.title:Show()
    f.titletext:Show()
    f.titlebg:Show()
end

function RaidNotes:InitNotes()
    f = AceGUI:Create("NotesWidget")
    f:Hide()
    f:SetTitle("Drag me")
    f.frame:SetFrameStrata("BACKGROUND")
    f.frame:EnableMouse(false)
    f.dialogbg:SetAlpha(0.5)

    local framePos = RaidNotes:LoadFramePosition()
    f:ClearAllPoints()
    f:SetPoint(framePos.point, framePos.xOfs, framePos.yOfs)
    f:SetHeight(framePos.height)
    f:SetWidth(framePos.width)

    RaidNotes:LockNotes()

    local label = AceGUI:Create("Label")
    label:SetFont("Fonts\\ARIALN.ttf", 16)
    label:SetRelativeWidth(1)

    _G["NotesText"] = label
    f:AddChild(label)

    RaidNotes:DisplayNotes("Trash:\n- Sample trash\n\nBoss:\n- Sample boss\n\n")
end

function RaidNotes:DisplayNotes(str)
    if not f then self:InitNotes() end

    debugPrint("Called RaidNotes:DisplayNotes()")

    self:ShowNotes()
   _G["NotesText"]:SetText(str)
end

function RaidNotes:ShowNotes()
    if not f then self:InitNotes() end

    f:Show()
end

function RaidNotes:HideNotes() 
    if f then 
        debugPrint("Called RaidNotes:Hide()")
        f:Hide()
    end
end

function RaidNotes:ToggleNotes()
    if f and f:IsShown() then
        self:HideNotes()
    else
        self:ShowNotes()
    end
end

function RaidNotes:GetNotesFramePosition()
    if not f then self:InitNotes() end
    
    local point, _, _, xOfs, yOfs = f:GetPoint()
    local width = f.frame:GetWidth()
    local height = f.frame:GetHeight()

    return {
        ["point"]  = point,
        ["xOfs"]   = xOfs,
        ["yOfs"]   = yOfs,
        ["width"]  = width,
        ["height"] = height
    }
end