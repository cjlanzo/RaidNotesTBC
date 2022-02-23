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

function RaidNotes:ENCOUNTER_START()
	print("not yet implemented")
end

function RaidNotes:ENCOUNTER_END()
	print("not yet implemented")
end

function RaidNotes:PLAYER_TARGET_CHANGED()
	local zone = GetZoneText()
    
    if (raids[zone] ~= nil) then

        if (UnitIsDead("target")) then return end
        
        local target = UnitName("target")

		if not target then return end

		local data = RaidNotes:LoadNotes(zone.."\001"..target)

		if not data then return end
        
		RaidNotes:UpdateNotes(target, data.trash, data.boss)
		RaidNotes:ShowNotes()
        
        -- if (aura_env.bossLookups[target] ~= nil) then
        --     aura_env.currentEncounters[zone] = aura_env.bossLookups[target]
            
        --     return true
        -- end
    end
end

function RaidNotes:ZONE_CHANGED()
	print("not yet implemented")
end

function RaidNotes:ZONE_CHANGED_NEW_AREA()
	print("not yet implemented")
end

function RaidNotes:ZONE_CHANGED_INDOORS()
	print("not yet implemented")
end

function RaidNotes:PLAYER_ENTERING_WORLD()
	print("player_entering_world: not yet implemented")
end

function RaidNotes:SaveNotes(id, frameName, text)
	if not self.db.char[id] then self.db.char[id] = {} end

	self.db.char[id][frameName] = text
end

function RaidNotes:LoadNotes(key)
	if not self.db.char[key] then return nil end

	local t = {}
	t.trash = self.db.char[key]["Trash"] or ""
	t.boss = self.db.char[key]["Boss"] or ""

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