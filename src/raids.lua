instanceSavedNameLookup = {}
instanceNameLookup = {}

iterDict(instancesDb, function(instanceID, instance)
    instanceSavedNameLookup[instance.savedInstanceName] = instanceID
    instanceNameLookup[instance.instanceName] = instanceID
end)

instanceEncountersLookup = groupBy(encountersDb, function(encounter) return encounter.instanceID end)
encounterNameLookup = collect(encountersDb, function(encounter)
    local targets = prepend(encounter.alternativeTargets, encounter.encounterName)
    return mapDict(targets, function(_,t) return t, encounter.encounterID end)
end)

local function findByEncounterIndex(instanceID, index)
    return findBy(instanceEncountersLookup[instanceID], function(e) return e.encounterIndex == index end)
end

-- "bug" in here that makes instances such as BT not function correctly because of boss skips
function getCurrentEncounterByInstance(instance)
    for _, savedInstanceName, encounterProgress in savedInstances() do
        if instance.savedInstanceName == savedInstanceName then
            return findByEncounterIndex(instance.instanceID, encounterProgress + 1)
        end
    end

    return findByEncounterIndex(instance.instanceID, 1)
end

function getNextEncounter(encounterID)
    local encounter = encountersDb[encounterID]
    local nextEncounterIndex = encounter.encounterIndex + 1

    local nextEncounter = findByEncounterIndex(encounter.instanceID, nextEncounterIndex)

    debugPrint(string.format("Searching for next encounter in instance %d with index %d, found '%s'", encounter.instanceID, nextEncounterIndex, nextEncounter and nextEncounter.encounterName or "nil"))

    return nextEncounter
end