local RaidNotes     = _G.LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceEvent-3.0")
local libDBIcon     = _G.LibStub("LibDBIcon-1.0")
local AceSerializer = _G.LibStub("AceSerializer-3.0")

function RaidNotes:OnInitialize()
	self.db = _G.LibStub("AceDB-3.0"):New(
		ADDON_NAME, {
			profile = {minimapButton = {hide = false}}
		})

	self:Print("Welcome to RaidNotesTBC")

	self:RegisterEvent("ENCOUNTER_START")
	self:RegisterEvent("ENCOUNTER_END")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("ZONE_CHANGED")
	self:RegisterEvent("ZONE_CHANGED_INDOORS")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_LOGOUT")

	self:DrawMinimapIcon()
end

function RaidNotes:LoadFramePosition()
	local function LoadValueOrDefault(value, default)
		if not self.db.char["framePos"] then return default end
		if not self.db.char["framePos"][value] then return default end

		return self.db.char["framePos"][value]
	end

	local pos = {}
	pos.point   = LoadValueOrDefault("point", "CENTER")
	pos.xOfs    = LoadValueOrDefault("xOfs", -640)
	pos.yOfs    = LoadValueOrDefault("yOfs", 0)
	pos.width   = LoadValueOrDefault("width", 400)
	pos.height  = LoadValueOrDefault("height", 400)

	return pos
end

function RaidNotes:ENCOUNTER_START(_, encounterName)
	local zone = GetZoneText()

	if not BossExistsInRaid(zone, encounterName) then return end

	local data = RaidNotes:LoadNotes(zone, encounterName)

	if not data then return end
	
	RaidNotes:UpdateNotes(encounterName, data.trash, data.boss)
	SetCurrentEncounter(zone, encounterName)
end

function RaidNotes:ENCOUNTER_END(encounterID, encounterName, _, _, success)
	if not success or success == false then return end

	local zone = GetZoneText()

	if not currentEncounters[zone] then return end

	local index = currentEncounters[zone] + 1
	
	currentEncounters[zone] = index

	if index > #raids[zone] then
		RaidNotes:UpdateNotes(zone.." Complete!", nil, nil)
		return
	end

	local boss = raids[zone][index]
	local data = RaidNotes:LoadNotes(zone, boss)

	if not data then return end
	
	RaidNotes:UpdateNotes(boss, data.trash, data.boss)
end

function RaidNotes:PLAYER_TARGET_CHANGED()
	if UnitIsDead("target") then return end
	
	local zone = GetZoneText()
	local target = UnitName("target")

	if not BossExistsInRaid(zone, target) then return end

	local data = RaidNotes:LoadNotes(zone, target)

	if not data then return end
	
	RaidNotes:UpdateNotes(target, data.trash, data.boss)
	SetCurrentEncounter(zone, target)
end

local function UpdateNotesOnZoneChange()
	local zone = GetZoneText()
	
	if not currentEncounters[zone] then RaidNotes:HideNotes() return end

	local currentEncounter = currentEncounters[zone]

	if currentEncounter > #raids[zone] then
		RaidNotes:UpdateNotes(zone.." Complete!", nil, nil)
		return
	end
	
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
	UpdateCurrentEncounters()
	UpdateNotesOnZoneChange()
end

function RaidNotes:PLAYER_LOGOUT()
	if not self.db.char["framePos"] then self.db.char["framePos"] = {} end

	local notesFrame = _G["NotesMainFrame"]

	if not notesFrame then return end

	local point, _, _, xOfs, yOfs = notesFrame:GetPoint()
	local width = notesFrame.frame:GetWidth()
	local height = notesFrame.frame:GetHeight()

	self.db.char["framePos"]["point"]  = point
	self.db.char["framePos"]["xOfs"]   = xOfs
	self.db.char["framePos"]["yOfs"]   = yOfs
	self.db.char["framePos"]["width"]  = width
	self.db.char["framePos"]["height"] = height
end

function RaidNotes:ShouldDisplayNotes() return raids[GetZoneText()] end

function RaidNotes:SaveNotes(id, frameName, text)
	if not self.db.char[id] then self.db.char[id] = {} end

	self.db.char[id][frameName] = text or ""
end

function RaidNotes:LoadNotesByKey(key)
	local function LoadOrDefault(value, default)
		if not self.db.char[key] then return default end
		if not self.db.char[key][value] then return default end
		return self.db.char[key][value]
	end

	local t = {}
	t.trash = LoadOrDefault("Trash", "")
	t.boss = LoadOrDefault("Boss", "")

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
				icon = "interface/icons/INV_Misc_Head_Murloc_01",
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