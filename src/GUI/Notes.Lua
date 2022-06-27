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

    self:CreateNotesLabel(f, "TitleHeader")
    self:CreateNotesLabelGroup(f, "Trash")
    self:CreateNotesLabelGroup(f, "Boss")
    
    _G["NotesMainFrame"] = f
end

function RaidNotes:CreateNotesLabelGroup(parent, name)
    local group = AceGUI:Create("SimpleGroup")
    group:SetRelativeWidth(1)

    RaidNotes:CreateNotesLabel(group, name.."Spacer", "\n")
    RaidNotes:CreateNotesLabel(group, name.."Header", name.." Notes:")
    RaidNotes:CreateNotesLabel(group, name.."Notes")

    _G["Notes"..name.."Group"] = group
    parent:AddChild(group)
end

function RaidNotes:CreateNotesLabel(parent, name, text)
    local label = AceGUI:Create("Label")
    label:SetFont("Fonts\\ARIALN.ttf", 16)
    label:SetRelativeWidth(1)

    if text then label:SetText(text) end

    _G["Notes"..name] = label

    parent:AddChild(label)
end

function RaidNotes:DisplayEncounterNotes(notes)
    if not f then self:InitNotes() end

    local function hideIfEmpty(groupName)
        -- these ids suck
        local text = _G[string.format("Notes%sNotes", groupName)].label:GetText()
        local group = _G[string.format("Notes%sGroup", groupName)].frame
        group:Show()

        if nullOrEmpty(text) then
            group:Hide()
        end
    end

    self:ShowNotes()

    debugPrint(string.format("Displaying notes for '%s'", notes.title))

    _G["NotesTitleHeader"]:SetText(notes.title or "")
    _G["NotesTrashNotes"]:SetText(notes.trash or "")
    _G["NotesBossNotes"]:SetText(notes.boss or "")

    f:DoLayout()

    hideIfEmpty("Trash")
    hideIfEmpty("Boss")
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