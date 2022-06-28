local RaidNotes     = _G.LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceEvent-3.0")
local libDBIcon     = _G.LibStub("LibDBIcon-1.0")
local AceSerializer = _G.LibStub("AceSerializer-3.0")

function RaidNotes:OnInitialize()
    self.db = _G.LibStub("AceDB-3.0"):New(
        ADDON_NAME, {
            profile = { minimapButton = { hide = false } }
        })

    self:Print("Welcome to RaidNotesTBC")

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

    initEncounterNotes(self.db.char)

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

function RaidNotes:PLAYER_LOGOUT()
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