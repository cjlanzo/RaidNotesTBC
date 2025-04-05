local RaidNotes = _G.LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)

InstanceSavedNameLookup = {}
InstanceNameLookup = {}

iterDict(InstancesDb, function(instanceID, instance)
    InstanceSavedNameLookup[instance.savedInstanceName] = instanceID
    InstanceNameLookup[instance.instanceName] = instanceID
end)

InstanceEncountersLookup = groupBy(EncountersDb, function(encounter) return encounter.instanceID end)
EncounterNameLookup = collect(EncountersDb, function(encounter)
    local targets = prepend(encounter.alternativeTargets, encounter.encounterName)
    return mapDict(targets, function(_,t) return t, encounter.encounterID end)
end)

function RaidNotes:FindByEncounterIndex(instanceID, index)
    for encounterID, encounterIndex in pairs(self.db.char.raidOrder[instanceID]) do
        if encounterIndex == index then
            return EncountersDb[encounterID]
        end
    end
end

-- "bug" in here that makes instances such as BT not function correctly because of boss skips
function RaidNotes:GetCurrentEncounterByInstance(instance)
    for _, savedInstanceName, encounterProgress in savedInstances() do
        if instance.savedInstanceName == savedInstanceName then
            return self:FindByEncounterIndex(instance.instanceID, encounterProgress + 1)
        end
    end

    return self:FindByEncounterIndex(instance.instanceID, 1)
end

function RaidNotes:GetNextEncounter(encounterID)
    local encounter = EncountersDb[encounterID]

    local nextEncounterIndex = self.db.char.raidOrder[encounter.instanceID][encounterID] + 1

    local nextEncounter = self:FindByEncounterIndex(encounter.instanceID, nextEncounterIndex)

    debugPrint(string.format("Searching for next encounter in instance %d with index %d, found '%s'", encounter.instanceID, nextEncounterIndex, nextEncounter and nextEncounter.encounterName or "nil"))

    return nextEncounter
end