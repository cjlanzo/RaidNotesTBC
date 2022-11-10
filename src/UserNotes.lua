EncounterNotes = {}

function InitEncounterNotes(dbProfile) EncounterNotes = dbProfile.encounters or {} end

function SplitKey(key) 
    local keyArr = split(key, "\001")
    return tonumber(keyArr[1]), tonumber(keyArr[2])
end

function GetEncounterNotes(encounterID) return EncounterNotes[encounterID] or {} end

function SetEncounterNotes(encounterID, notes)
    local existingNotes = GetEncounterNotes(encounterID)

    EncounterNotes[encounterID] = {
        ["trash"] = notes.trash or existingNotes.trash,
        ["boss"] = notes.boss or existingNotes.boss,
    }
end