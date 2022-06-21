instanceSavedNameLookup = {}
instanceNameLookup = {}
instanceProgress = {}

iterDict(instancesDb, function(instanceID, instance)
    instanceSavedNameLookup[instance.savedInstanceName] = instanceID
    instanceNameLookup[instance.instanceName] = instanceID
    instanceProgress[instanceID] = 1
end)

instanceEncountersLookup = groupBy(encountersDb, function(encounter) return encounter.instanceID end)
encounterNameLookup = collect(encountersDb, function(encounter)
    local targets = prepend(encounter.alternativeTargets, encounter.encounterName)
    return mapDict(targets, function(_,t) return t, encounter.encounterID end)
end)

function setCurrentEncounter(encounterID)
    local encounter = encountersDb[encounterID]

    debugPrint(string.format("Setting current encounter to '%d' for '%s'", encounter.encounterIndex, instancesDb[encounter.instanceID].instanceName))

    instanceProgress[encounter.instanceID] = encounter.encounterIndex
end

local function findByEncounterIndex(index)
    return findBy(encountersDb, function(e) return e.encounterIndex == index end)
end

function getCurrentEncounterByInstance(instanceID)
    local encounterIndex = instanceProgress[instanceID]
    local encounter = findByEncounterIndex(encounterIndex)

    debugPrint(string.format("Searching for encounter with index %d, found '%s'", encounterIndex, encounter and encounter.encounterName or tostring(nil)))

    return encounter
end

function getNextEncounter(encounterID)
    local encounter = encountersDb[encounterID]
    local nextEncounterIndex = encounter.encounterIndex + 1

    local nextEncounter = findByEncounterIndex(nextEncounterIndex)

    debugPrint(string.format("Searching for next encounter with index %d, found '%s'", nextEncounterIndex, nextEncounter.encounterName or tostring(nil)))

    return nextEncounter
end

-- "bug" in here that makes instances such as BT not function correctly because of boss skips
function updateCurrentEncounters()
    for i = 1, GetNumSavedInstances() do
        local savedInstanceName,_,_,_,_,_,_,_,_,_,_,encounterProgress = GetSavedInstanceInfo(i)
        local instance = instancesDb[instanceSavedNameLookup[savedInstanceName]]
        local currentIndex = encounterProgress + 1

        debugPrint(string.format("Setting current encounter to '%d' for '%s'", currentIndex, instance.instanceName))

        instanceProgress[instance.instanceID] = currentIndex
    end
end