local RaidNotes =
	_G.LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceEvent-3.0")
local libDBIcon = _G.LibStub("LibDBIcon-1.0")
local AceSerializer = _G.LibStub("AceSerializer-3.0")

function RaidNotes:OnInitialize()
	self.db = _G.LibStub("AceDB-3.0"):New("RaidNotesTBC")

	self:Print("Welcome to RaidNotesTBC")

	self:DrawMinimapIcon()
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

function RaidNotes:DrawMinimapIcon()
	libDBIcon:Register(
		ADDON_NAME,
		_G.LibStub("LibDataBroker-1.1"):NewDataObject(ADDON_NAME, 
			{
				type = "data source",
				text = ADDON_NAME,
				icon = "interface/icons/ability_deathwing_bloodcorruption_death",
				OnClick = function(self, button)
					RaidNotes:Toggle_Journal()
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