local RaidNotes     = _G.LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceEvent-3.0")
local libDBIcon     = _G.LibStub("LibDBIcon-1.0")
local AceSerializer = _G.LibStub("AceSerializer-3.0")

function RaidNotes:OnInitialize()
    self.db = _G.LibStub("AceDB-3.0"):New(
        ADDON_NAME, {
            profile = { minimapButton = { hide = false } }
        })

    self:Print("Welcome to RaidNotesTBC")

    initEncounterNotes(self.db.char)

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
    if self.db.char.framePos then return self.db.char.framePos 
    else
        return {
            ["point"]  = "CENTER",
            ["xOfs"]   = -640,
            ["yOfs"]   = 0,
            ["width"]  = 400,
            ["height"] = 400
        }
    end
end

function RaidNotes:ENCOUNTER_START(encounterID, encounterName)
    debugPrint(string.format("ENCOUNTER_START - %s - %d", encounterName, encounterID))
    
    if not encountersDb[encounterID] then return end

    RaidNotes:DisplayEncounterNotes(encounterName, getEncounterNotes(encounterID))
    setCurrentEncounter(encounterID)
end

function RaidNotes:ENCOUNTER_END(encounterID, encounterName, _, _, success)
    debugPrint(string.format("ENCOUNTER_END - %s - %d - %s", encounterName, encounterID, tostring(success == 1)))

    if success == 0 then return end
    if not encountersDb[encounterID] then return end

    local nextEncounter = getNextEncounter(encounterID)

    if not nextEncounter then RaidNotes:DisplayEncounterNotes("Raid Complete!", {}) return end -- refactor?

    RaidNotes:DisplayEncounterNotes(nextEncounter.encounterName, getEncounterNotes(nextEncounter.encounterID))
    setCurrentEncounter(nextEncounter.encounterID)
end

function RaidNotes:PLAYER_TARGET_CHANGED()
    if UnitIsDead("target") then return end
    
    local target = UnitName("target")
    local encounterID = encounterNameLookup[target]

    if not encounterID then return end

    RaidNotes:DisplayEncounterNotes(target, getEncounterNotes(encounterID))
    setCurrentEncounter(encounterID)
end

local function updateNotesOnZoneChange(sourceEvent)
    local zone = GetZoneText()

    debugPrint(string.format("%s - %s", sourceEvent, zone))
    
    local instanceID = instanceNameLookup[zone]
    if not instanceID then RaidNotes:HideNotes() return end

    local currentEncounter = getCurrentEncounterByInstance(instanceID)

    if not currentEncounter then RaidNotes:DisplayEncounterNotes("Raid Complete!", {}) return end -- refactor this, used twice

    RaidNotes:DisplayEncounterNotes(currentEncounter.encounterName, getEncounterNotes(currentEncounter.encounterID))
end

function RaidNotes:ZONE_CHANGED()
    updateNotesOnZoneChange("ZONE_CHANGED")
end

function RaidNotes:ZONE_CHANGED_NEW_AREA()
    updateNotesOnZoneChange("ZONE_CHANGED_NEW_AREA")
end

function RaidNotes:ZONE_CHANGED_INDOORS()
    updateNotesOnZoneChange("ZONE_CHANGED_INDOORS")
end

function RaidNotes:PLAYER_ENTERING_WORLD()
    debugPrint("PLAYER_ENTERING_WORLD")
    updateCurrentEncounters()                                                                                               
end

function RaidNotes:PLAYER_LOGOUT()
    self.db.char.framePos = RaidNotes:GetNotesFramePosition()
    self.db.char.encounters = encounterNotes
end

function RaidNotes:ShouldDisplayNotes() return instanceNameLookup[GetZoneText()] end

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