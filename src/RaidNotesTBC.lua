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
    updateCurrentEncounters()

    local eventMap = {
        ["ENCOUNTER_START"]       = "HandleEncounterStart",
        ["ENCOUNTER_END"]         = "HandleEncounterEnd",
        ["PLAYER_TARGET_CHANGED"] = "HandlePlayerTargetChanged",
        ["ZONE_CHANGED"]          = "HandleZoneChanged",
        ["ZONE_CHANGED_NEW_AREA"] = "HandleZoneChanged",
        ["ZONE_CHANGED_INDOORS"]  = "HandleZoneChanged",
        ["PLAYER_LOGOUT"]         = "HandlePlayerLogout",
    }

    iterDict(eventMap, function(event, handler) self:RegisterEvent(event, handler) end)

    self:DrawMinimapIcon()

    -- test code below here
    if not TEST_MODE then return end
    
    -- RaidNotes:HandleZoneChanged("ZONE_CHANGED")
    -- RaidNotes:HandleEncounterStart("ENCOUNTER_START", 725, "Brutallus")
    -- RaidNotes:HandleEncounterStart("ENCOUNTER_START", 1800, "nilmonster")
    -- RaidNotes:HandleEncounterEnd("ENCOUNTER_END", 725, "Brutallus", nil, nil, 1)
    -- RaidNotes:HandleEncounterEnd("ENCOUNTER_END", 729, "Kil'Jaeden", nil, nil, 1)
    -- RaidNotes:HandlePlayerTargetChanged("PLAYER_TARGET_CHANGED")
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

function RaidNotes:HandleEncounterStart(event, encounterID, encounterName)
    debugPrint(string.format("ENCOUNTER_START - %s - %d", encounterName, encounterID))
    
    if not encountersDb[encounterID] then return end

    RaidNotes:DisplayEncounterNotes(encounterName, getEncounterNotes(encounterID))
    setCurrentEncounter(encounterID)
end

function RaidNotes:HandleEncounterEnd(event, encounterID, encounterName, _, _, success)
    debugPrint(string.format("ENCOUNTER_END - %s - %d - %s", encounterName, encounterID, tostring(success == 1)))

    if not success or success == 0 then return end
    if not encountersDb[encounterID] then return end

    local nextEncounter = getNextEncounter(encounterID)

    if not nextEncounter then RaidNotes:DisplayEncounterNotes(string.format("%s Complete!", instancesDb[encountersDb[encounterID].instanceID].instanceName), {}) return end -- refactor?

    RaidNotes:DisplayEncounterNotes(nextEncounter.encounterName, getEncounterNotes(nextEncounter.encounterID))
    setCurrentEncounter(nextEncounter.encounterID)
end

function RaidNotes:HandlePlayerTargetChanged(event)
    local target = getTarget()
    local encounterID = encounterNameLookup[target]
    
    if not encounterID then return end
    
    local encounter = encountersDb[encounterID]
    
    RaidNotes:DisplayEncounterNotes(encounter.encounterName, getEncounterNotes(encounterID))
    setCurrentEncounter(encounterID)
end

function RaidNotes:HandleZoneChanged(event)
    local zone = getZone()

    debugPrint(string.format("%s - %s", event, zone))
    
    local instanceID = instanceNameLookup[zone]
    if not instanceID then RaidNotes:HideNotes() return end

    local currentEncounter = getCurrentEncounterByInstance(instanceID)

    if not currentEncounter then RaidNotes:DisplayEncounterNotes(string.format("%s Complete!", instancesDb[instanceID].instanceName), {}) return end -- refactor this, used twice

    RaidNotes:DisplayEncounterNotes(currentEncounter.encounterName, getEncounterNotes(currentEncounter.encounterID))
end

function RaidNotes:HandlePlayerLogout()
    self.db.char.framePos = RaidNotes:GetNotesFramePosition()
    self.db.char.encounters = encounterNotes
end

function RaidNotes:ShouldDisplayNotes() return instanceNameLookup[getZone()] end

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