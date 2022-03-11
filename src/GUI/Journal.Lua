local RaidNotes = _G.LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)
local AceGUI = _G.LibStub("AceGUI-3.0")

local f

local function CreateTree()
	local r    = raids
	local tree = {}

	local function CreateBossTable(bossName)
		local t = {}
		t["text"]  = bossName
		t["value"] = bossName

		return t
	end

	local function CreateRaidTable(raidName, bosses)
		local t = {}
		t["text"]  = raidName
		t["value"] = raidName

		local children = {}
		for i,v in ipairs(bosses) do
			table.insert(children, CreateBossTable(v))
		end

		t["children"] = children

		return t
	end

	for k,v in pairs(r) do
		table.insert(tree, CreateRaidTable(k,v))
	end

	return tree
end

function RaidNotes:InitJournal()
	f = AceGUI:Create("Frame")
	f:Hide()
	f:SetWidth(860)
	f:SetHeight(500)
	f:SetLayout("Flow")
	f:EnableResize(false)
	f:SetTitle(ADDON_NAME)

	hooksecurefunc(f, "Hide", function(self) 
		if not RaidNotes:ShouldDisplayNotes() then RaidNotes:HideNotes() end
		RaidNotes:LockNotes() 
	end)

	_G[ADDON_NAME.."MainFrame"] = f
	table.insert(UISpecialFrames, ADDON_NAME.."MainFrame") -- close on escape

	local treeGroup = AceGUI:Create("TreeGroup")
	treeGroup:SetFullWidth(true)
	treeGroup:SetFullHeight(true)
	treeGroup:SetTree(CreateTree())

	local function LoadData(self, key)
		local t = RaidNotes:LoadNotesByKey(key)

		local trashText = ""
		local bossText  = ""

		if t then 
			trashText = t.trash
			bossText  = t.boss
		end

		_G["TrashEditBox"].editBox:SetText(trashText)
		_G["BossEditBox"].editBox:SetText(bossText)
	end

	hooksecurefunc(treeGroup, "SetSelected", LoadData)

	f:AddChild(treeGroup)

	RaidNotes:CreateNotesEdit(treeGroup, "Trash")
	RaidNotes:CreateNotesEdit(treeGroup, "Boss")
end

function RaidNotes:CreateNotesEdit(parent, name)
	editBox = AceGUI:Create("MultiLineEditBox")
	_G[name.."EditBox"] = editBox
	editBox:SetLabel(name)
	editBox:SetRelativeWidth(1)
	editBox:SetNumLines(11)
	parent:AddChild(editBox)

	-- figure out if we can replace this with a hooksecurefunc without having to duplicate the code
	editBox.button:SetScript("OnClick", function(self)
		self = self.obj
		self.editBox:ClearFocus()

		RaidNotes:SaveNotes(parent.localstatus.selected, self.label:GetText(), self:GetText())
		
		-- if we are editing the boss that is being displayed, update the notes immediately
		local bossName = Split(parent.localstatus.selected, "\001")[2]
		local currentTitle = _G["NotesTitleHeader"].label:GetText()

		if currentTitle and string.find(currentTitle, bossName) then
			RaidNotes:UpdateNotes(bossName, _G["TrashEditBox"].editBox:GetText(), _G["BossEditBox"].editBox:GetText())
		end

		if not self:Fire("OnEnterPressed", self.editBox:GetText()) then
			self.button:Disable()
		end
	end)
end

function RaidNotes:ShowJournal()
	if not f then self:InitJournal() end

	f:Show()
	RaidNotes:ShowNotes()
	RaidNotes:UnlockNotes()
end

function RaidNotes:HideJournal()
	if not RaidNotes:ShouldDisplayNotes() then RaidNotes:HideNotes() end
	RaidNotes:LockNotes()
	f:Hide() 
end

function RaidNotes:ToggleJournal()
	if f and f:IsShown() then
		self:HideJournal()
	else
		self:ShowJournal()
	end
end