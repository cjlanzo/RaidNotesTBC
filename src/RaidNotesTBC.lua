local RaidNotes =
	_G.LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceEvent-3.0")
local libDBIcon = _G.LibStub("LibDBIcon-1.0")
local AceSerializer = _G.LibStub("AceSerializer-3.0")

function RaidNotes:OnInitialize()
	self.db = _G.LibStub("AceDB-3.0"):New("RaidNotesTBC")

	self:Print("Welcome to RaidNotesTBC")
	RaidNotes:Show_Journal()

	-- self:DrawMinimapIcon()
end

function RaidNotes:SaveNotes(id, frameName, text)
	if not self.db.char[id] then self.db.char[id] = {} end

	self.db.char[id][frameName] = text
end

function RaidNotes:LoadNotes(key)
	local t = {}
	if self.db.char[key] then
		t.trash = self.db.char[key]["Trash"] or ""
		t.boss = self.db.char[key]["Boss"] or ""
	else
		t.trash = ""
		t.boss = ""
	end

	return t
end