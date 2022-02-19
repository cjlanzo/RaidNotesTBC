local RaidNotes =
	_G.LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceEvent-3.0")
local libDBIcon = _G.LibStub("LibDBIcon-1.0")
local AceSerializer = _G.LibStub("AceSerializer-3.0")

function RaidNotes:OnInitialize()
	-- self:db = _G.LibStub("AceDB-3.0")

	self:Print("Welcome to RaidNotesTBC")
	RaidNotes:Show_Notes()

	-- self:DrawMinimapIcon()
end