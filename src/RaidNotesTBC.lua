local RaidNotes     = _G.LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceEvent-3.0")
local libDBIcon     = _G.LibStub("LibDBIcon-1.0")
local AceSerializer = _G.LibStub("AceSerializer-3.0")

function RaidNotes:OnInitialize()
	self.db = _G.LibStub("AceDB-3.0"):New("RaidNotesTBC")

	self:Print("Welcome to RaidNotesTBC")

	self:RegisterEvent("ENCOUNTER_START")
	self:RegisterEvent("ENCOUNTER_END")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("ZONE_CHANGED")
	self:RegisterEvent("ZONE_CHANGED_INDOORS")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	self:DrawMinimapIcon()
end

function RaidNotes:ENCOUNTER_START(_, encounterName)
	local zone = GetZoneText()
	local data = RaidNotes:LoadNotes(zone, encounterName)

	if not data then return end
	
	RaidNotes:UpdateNotes(encounterName, data.trash, data.boss)
	SetCurrentEncounter(zone, encounterName)
end

function RaidNotes:ENCOUNTER_END(encounterID, encounterName, _, _, success)
	if not success or success == false then return end

	local zone = GetZoneText()
	local index = currentEncounters[zone] + 1
	
	currentEncounters[zone] = index

	local boss = raids[zone][index]
	local data = RaidNotes:LoadNotes(zone, boss)

	if not data then return end
	
	RaidNotes:UpdateNotes(boss, data.trash, data.boss)
end

function RaidNotes:PLAYER_TARGET_CHANGED()
	if UnitIsDead("target") then return end
	
	local zone = GetZoneText()
	local target = UnitName("target")
	local data = RaidNotes:LoadNotes(zone, target)

	if not data then return end
	
	RaidNotes:UpdateNotes(target, data.trash, data.boss)
	SetCurrentEncounter(zone, target)
end

local function UpdateNotesOnZoneChange()
	local zone = GetZoneText()
	
	if not currentEncounters[zone] then return end

	local currentEncounter = currentEncounters[zone]
	local boss = raids[zone][currentEncounter]
	local data = RaidNotes:LoadNotes(zone, boss)

	if not data then return end
	
	RaidNotes:UpdateNotes(boss, data.trash, data.boss)
end

function RaidNotes:ZONE_CHANGED()
	UpdateNotesOnZoneChange()
end

function RaidNotes:ZONE_CHANGED_NEW_AREA()
	UpdateNotesOnZoneChange()
end

function RaidNotes:ZONE_CHANGED_INDOORS()
	UpdateNotesOnZoneChange()
end

function RaidNotes:PLAYER_ENTERING_WORLD()
	UpdateNotesOnZoneChange()
end

function RaidNotes:SaveNotes(id, frameName, text)
	if not self.db.char[id] then self.db.char[id] = {} end

	self.db.char[id][frameName] = text
end

function RaidNotes:LoadNotesByKey(key)
	if not self.db.char[key] then return nil end

	local t = {}
	t.trash = self.db.char[key]["Trash"] or ""
	t.boss = self.db.char[key]["Boss"] or ""

	return t
end

function RaidNotes:LoadNotes(zone, boss)
	if not zone or not boss then return nil end

	local key = zone.."\001"..boss

	return RaidNotes:LoadNotesByKey(key)
end

function RaidNotes:DrawMinimapIcon()
	libDBIcon:Register(
		ADDON_NAME,
		_G.LibStub("LibDataBroker-1.1"):NewDataObject(ADDON_NAME, 
			{
				type = "data source",
				text = ADDON_NAME,
				icon = "interface/icons/ability_deathwing_bloodcorruption_death",
				OnClick = function(self, button)
					RaidNotes:ToggleJournal()
				end,
				OnTooltipShow = function(tooltip)
					tooltip:AddLine("RaidNotesTBC - Left click to toggle")
				end
			}),
		self.db.profile.minimapButton
	)
end

function RaidNotes:ToggleMinimapButton()
	self.db.profile.minimapButton.hide = not self.db.profile.minimapButton.hide
	if self.db.profile.minimapButton.hide then
		libDBIcon:Hide(ADDON_NAME)
	else
		libDBIcon:Show(ADDON_NAME)
	end
end