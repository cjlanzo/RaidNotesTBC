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
	f:SetTitle("Drag me")
	f.frame:SetFrameStrata("BACKGROUND")
	f.frame:EnableMouse(false)

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
	label:SetFontObject(GameFontNormalLarge)
	label:SetRelativeWidth(1)

	if text then label:SetText(text) end

	_G["Notes"..name] = label

	parent:AddChild(label)
end

function RaidNotes:UpdateNotes(bossName, trashNotes, bossNotes)
	if not f then self:InitNotes() end

	local function HideIfEmpty(groupName)
		local text = _G["Notes"..groupName.."Notes"].label:GetText()
		local group = _G["Notes"..groupName.."Group"].frame
		group:Show()

		if not text or text == "" then
			group:Hide()
		end
	end

	self:ShowNotes()

	_G["NotesTitleHeader"]:SetText("-= "..bossName.." =-")
	_G["NotesTrashNotes"]:SetText(trashNotes)
	_G["NotesBossNotes"]:SetText(bossNotes)

	f:DoLayout()

	HideIfEmpty("Trash")
	HideIfEmpty("Boss")
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