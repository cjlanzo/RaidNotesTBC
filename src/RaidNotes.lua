local RaidNotes     = _G.LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceEvent-3.0")
local libDBIcon     = _G.LibStub("LibDBIcon-1.0")
local AceSerializer = _G.LibStub("AceSerializer-3.0")

function RaidNotes:OnInitialize()
    self.db = _G.LibStub("AceDB-3.0"):New(ADDON_NAME, {
        profile = { 
            minimapButton = { hide = false } 
        },
        char = {
            encounters = {},
            framePos = {
                ["point"]  = "CENTER",
                ["xOfs"]   = -640,
                ["yOfs"]   = 0,
                ["width"]  = 400,
                ["height"] = 400
            },
            raidOrder = {
                [533] = {
                    [1107] = 1,
                    [1110] = 2,
                    [1116] = 3,
                    [1118] = 4,
                    [1111] = 5,
                    [1108] = 6,
                    [1120] = 7,
                    [1117] = 8,
                    [1112] = 9,
                    [1115] = 10,
                    [1113] = 11,
                    [1109] = 12,
                    [1121] = 13,
                    [1119] = 14,
                    [1114] = 15,
                },
                [615] = {
                    [1090] = 1,
                },
                [616] = {
                    [1094] = 1
                },
                [603] = {
                    [744] = 1,
                    [746] = 2,
                    [745] = 3,
                    [747] = 4,
                    [748] = 5,
                    [757] = 6,
                    [749] = 7,
                    [750] = 8,
                    [751] = 9,
                    [752] = 10,
                    [753] = 11,
                    [754] = 12,
                    [755] = 13,
                    [756] = 14,
                }
            }
        }
    })

    self:Print("Welcome to RaidNotes")

    local options = {
        name = ADDON_NAME,
        handler = RaidNotes,
        type = "group",
        args = {
            toggleDebug = {
                type = "execute",
                name = "Toggle Debug",
                desc = "Toggles DEBUG_MODE on/off",
                func = "ToggleDebug"
            },
            runtests = {
                type = "execute",
                name = "Run Tests",
                desc = "Run addon tests",
                func = "RunTests"
            }
        }
    }

    LibStub("AceConfig-3.0"):RegisterOptionsTable(ADDON_NAME, options, { "raidnotes" })
    InitEncounterNotes(self.db.char)

    local eventMap = {
        ["ENCOUNTER_START"]       = mapEncounterStart,
        ["ENCOUNTER_END"]         = mapEncounterEnd,
        ["PLAYER_TARGET_CHANGED"] = mapPlayerTargetChanged,
        ["ZONE_CHANGED_NEW_AREA"] = mapZoneChanged,
        ["PLAYER_ENTERING_WORLD"] = mapZoneChanged,
    }
    
    iterDict(eventMap, function(event, mappingFn)
        self:RegisterEvent(event, RaidNotes:EventHandler(event, mappingFn))
    end)

    self:RegisterEvent("PLAYER_LOGOUT")
    self:DrawMinimapIcon()
end

function RaidNotes:EventHandler(event, mappingFn)
    return function(...)
        debugPrint(argsToString(...))
        local n = mappingFn(sliceArgs(2, ...))

        if n.action == "hide" then RaidNotes:HideNotes()
        elseif n.action == "show" then RaidNotes:DisplayNotes(n.value)
        end
    end
end

function RaidNotes:ToggleDebug()
    print(string.format("DEBUG_MODE set to '%s'", tostring(DEBUG_MODE)))
    DEBUG_MODE = not DEBUG_MODE
    print(string.format("Toggling DEBUG_MODE to '%s'", tostring(DEBUG_MODE)))
end

function RaidNotes:LoadFramePosition()
    return self.db.char.framePos
end

function RaidNotes:GetRaidOrder(instanceID)
    return self.db.char.raidOrder[instanceID]
end

function RaidNotes:SetRaidOrderForEncounter(instanceID, encounterID, value)
    self.db.char.raidOrder[instanceID][encounterID] = value
end

function RaidNotes:PLAYER_LOGOUT()
    self.db.char.framePos = RaidNotes:GetNotesFramePosition()
    self.db.char.encounters = EncounterNotes
end

function RaidNotes:ShouldDisplayNotes() return InstanceNameLookup[getZone()] end

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
                    tooltip:AddLine("RaidNotes - Left click to toggle")
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