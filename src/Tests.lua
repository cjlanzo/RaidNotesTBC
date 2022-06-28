local RaidNotes = _G.LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)

function RaidNotes:RunTests()
    local debugStatus = DEBUG_MODE
    DEBUG_MODE = true
    
    local encounterStart = RaidNotes:EventHandler("ENCOUNTER_START", mapEncounterStart)
    local encounterEnd = RaidNotes:EventHandler("ENCOUNTER_END", mapEncounterEnd)
    local playerTargetChanged = RaidNotes:EventHandler("PLAYER_TARGET_CHANGED", mapPlayerTargetChanged)
    local zoneChanged = RaidNotes:EventHandler("ZONE_CHANGED_NEW_AREA", mapZoneChanged)
    
    -- ENCOUNTER_START tests
    encounterStart("ENCOUNTER_START", 724)
    encounterStart("ENCOUNTER_START", nil)
    encounterStart("ENCOUNTER_START", -1)
    encounterStart("ENCOUNTER_START", 1800)

    -- ENCOUNTER_END tests
    encounterEnd("ENCOUNTER_END", 725, nil, nil, nil, 0)
    encounterEnd("ENCOUNTER_END", 725, nil, nil, nil, 1)
    encounterEnd("ENCOUNTER_END", nil, nil, nil, nil, 0)
    encounterEnd("ENCOUNTER_END", nil, nil, nil, nil, 1)
    encounterEnd("ENCOUNTER_END", -1, nil, nil, nil, 0)
    encounterEnd("ENCOUNTER_END", -1, nil, nil, nil, 1)
    encounterEnd("ENCOUNTER_END", 1800, nil, nil, nil, 0)
    encounterEnd("ENCOUNTER_END", 1800, nil, nil, nil, 1)

    -- PLAYER_TARGET_CHANGED tests
    playerTargetChanged("PLAYER_TARGET_CHANGED", "Lady Sacrolash")
    playerTargetChanged("PLAYER_TARGET_CHANGED", "Fake Target")
    playerTargetChanged("PLAYER_TARGET_CHANGED", nil)
    playerTargetChanged("PLAYER_TARGET_CHANGED", "M'uru")

    -- ZONE_CHANGED tests
    zoneChanged("ZONE_CHANGED_NEW_AREA", "Sunwell Plateau")
    zoneChanged("ZONE_CHANGED_NEW_AREA", "The Sunwell")
    zoneChanged("ZONE_CHANGED_NEW_AREA", "Fake Zone")
    zoneChanged("ZONE_CHANGED_NEW_AREA", "Orgrimmar")
    zoneChanged("ZONE_CHANGED_NEW_AREA", nil)
    zoneChanged("ZONE_CHANGED_NEW_AREA", "Black Temple")

    -- realistic flow
    zoneChanged("ZONE_CHANGED_NEW_AREA", "Sunwell Plateau")
    playerTargetChanged("PLAYER_TARGET_CHANGED", "Kalecgos")
    encounterStart("ENCOUNTER_START", 724)
    encounterEnd("ENCOUNTER_END", 724, "Kalecgos", nil, nil, 1)
    encounterStart("ENCOUNTER_START", 725)
    encounterEnd("ENCOUNTER_END", 725, "Brutallus", nil, nil, 0)
    playerTargetChanged("PLAYER_TARGET_CHANGED", "Brutallus")
    encounterStart("ENCOUNTER_START", 725)
    encounterEnd("ENCOUNTER_END", 725, "Brutallus", nil, nil, 1)
    playerTargetChanged("PLAYER_TARGET_CHANGED", "Hand of the Deceiver")
    encounterStart("ENCOUNTER_START", 729)
    encounterEnd("ENCOUNTER_END", 729, "Kil'jaeden", nil, nil, 1)

    DEBUG_MODE = debugStatus
end