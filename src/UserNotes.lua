encounterNotes = {}

function initEncounterNotes(dbProfile) encounterNotes = dbProfile.encounters or {} end

function getEncounterFromKey(key) return tonumber(split(key, "\001")[2]) end

function getEncounterNotes(encounterID) return encounterNotes[encounterID] or {} end

function setEncounterNotes(encounterID, notes)
    local existingNotes = getEncounterNotes(encounterID)

    encounterNotes[encounterID] = {
        ["trash"] = notes.trash or existingNotes.trash,
        ["boss"] = notes.boss or existingNotes.boss,
    }
end