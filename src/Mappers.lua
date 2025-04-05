local RaidNotes = _G.LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)

local function skip() return { ["action"] = "skip" } end
local function hide() return { ["action"] = "hide" } end
local function show(v) return { ["action"] = "show", ["value"] = v } end
local function skipIfNil(v) return not v and skip() or  show(v) end

function encounterAsNotes(encounter)
    if not encounter then return nil end

    local notes = GetEncounterNotes(encounter.encounterID)
    local s = ""

    if not nullOrEmpty(notes.trash) then s = s.."Trash:\n"..notes.trash.."\n\n" end
    if not nullOrEmpty(notes.boss) then s = s..encounter.encounterName..":\n"..notes.boss.."\n" end

    return s
end

function mapEncounterStart(encounterID)
    return skipIfNil(encounterAsNotes(EncountersDb[encounterID]))
end

function mapEncounterEnd(encounterID, _, _, _, success)
    if success == 0 then return skip() end
    if not EncountersDb[encounterID] then return skip() end

    local nextEncounter = RaidNotes:GetNextEncounter(encounterID)

    return nextEncounter 
        and show(encounterAsNotes(nextEncounter))
        or  show(string.format("%s Complete!", InstancesDb[EncountersDb[encounterID].instanceID].instanceName))
end

function mapPlayerTargetChanged(target)
    return skipIfNil(encounterAsNotes(EncountersDb[EncounterNameLookup[getTarget(target)]]))
end

function mapZoneChanged(zone)
    zone = getZone(zone)

    local instance = InstancesDb[InstanceNameLookup[zone]]
    if not instance then return hide() end

    local encounter = RaidNotes:GetCurrentEncounterByInstance(instance)

    return encounter 
        and show(encounterAsNotes(encounter))
        or  show(string.format("%s Complete!", instance.instanceName))
end