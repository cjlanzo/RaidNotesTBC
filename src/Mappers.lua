function encounterAsNotes(encounter)
    if not encounter then return nil end

    local notes = getEncounterNotes(encounter.encounterID)

    return {
        ["title"] = encounter.encounterName,
        ["boss"] = notes.boss,
        ["trash"] = notes.trash
    }
end

function mapEncounterStart(encounterID)
    local encounter = encountersDb[encounterID]
    return encounter and encounterAsNotes(encounter) or {}
end

function mapEncounterEnd(encounterID, _, _, _, success)
    if success == 0 then return {} end
    if not encountersDb[encounterID] then return {} end

    local nextEncounter = getNextEncounter(encounterID)

    return nextEncounter
        and encounterAsNotes(nextEncounter)
        or { ["title"] = string.format("%s Complete!", instancesDb[encountersDb[encounterID].instanceID].instanceName) }
end

function mapPlayerTargetChanged(target)
    target = getTarget(target)

    local encounter = encountersDb[encounterNameLookup[target]]
    return encounter and encounterAsNotes(encounter) or {}
end

function mapZoneChanged(zone)
    zone = getZone(zone)

    local instance = instancesDb[instanceNameLookup[zone]]
    if not instance then return nil end

    local encounter = getCurrentEncounterByInstance(instance)

    return encounter
        and encounterAsNotes(encounter)
        or { ["title"] = string.format("%s Complete!", instance.instanceName) }
end