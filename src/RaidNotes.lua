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
                [409] = {
                    [663] = 1,
                    [664] = 2,
                    [665] = 3,
                    [666] = 4,
                    [668] = 5,
                    [667] = 6,
                    [669] = 7,
                    [670] = 8,
                    [671] = 9,
                    [672] = 10,
                },
                [469] = {
                    [610] = 1,
                    [611] = 2,
                    [612] = 3,
                    [613] = 4,
                    [614] = 5,
                    [615] = 6,
                    [616] = 7,
                    [617] = 8,
                },
                [531] = {
                    [709] = 1,
                    [710] = 2,
                    [711] = 3,
                    [712] = 4,
                    [713] = 5,
                    [714] = 6,
                    [715] = 7,
                    [716] = 8,
                    [717] = 9,
                },
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
            }
        }
    })

    local options = {
        name = ADDON_NAME,
        handler = RaidNotes,
        type = "group",
        args = {
            toggleMinimap = {
                type = "execute",
                name = "Toggle Minimap",
                desc = "Toggles the minimap icon",
                func = "ToggleMinimapButton"
            },
            edit = {
                type = "execute",
                name = "Open Journal",
                desc = "Opens the journal",
                func = "ToggleJournal"
            },
            show = {
                type = "execute",
                name = "Show Notes",
                desc = "Displays the notes",
                func = "ShowNotes",
            },
            hide = {
                type = "execute",
                name = "Hide Notes",
                desc = "Hides the notes",
                func = "HideNotes",
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