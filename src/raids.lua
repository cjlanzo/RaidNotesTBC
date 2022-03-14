local karazhan = {}
table.insert(karazhan, "Attumen the Huntsman")
table.insert(karazhan, "Moroes")
table.insert(karazhan, "Maiden of Virtue")
table.insert(karazhan, "Opera Hall")
table.insert(karazhan, "Nightbane")
table.insert(karazhan, "The Curator")
table.insert(karazhan, "Terestian Illhoof")
table.insert(karazhan, "Shade of Aran")
table.insert(karazhan, "Netherspite")
table.insert(karazhan, "Prince Malchezaar")

local gruulsLair = {}
table.insert(gruulsLair, "High King Maulgar")
table.insert(gruulsLair, "Gruul the Dragonkiller")

local magtheridonsLair = {}
table.insert(magtheridonsLair, "Magtheridon")

local ssc = {}
table.insert(ssc, "The Lurker Below")
table.insert(ssc, "Hydross the Unstable")
table.insert(ssc, "Leotheras the Blind")
table.insert(ssc, "Fathom-Lord Karathress")
table.insert(ssc, "Morogrim Tidewalker")
table.insert(ssc, "Lady Vashj")

local tk = {}
table.insert(tk, "High Astromancer Solarian")
table.insert(tk, "A'lar")
table.insert(tk, "Void Reaver")
table.insert(tk, "Kael'thas Sunstrider")

local hyjal = {}
table.insert(hyjal, "Rage Winterchill")
table.insert(hyjal, "Anetheron")
table.insert(hyjal, "Kaz'rogal")
table.insert(hyjal, "Azgalor")
table.insert(hyjal, "Archimonde")

local bt = {}
table.insert(bt, "High Warlord Naj'entus")
table.insert(bt, "Supremus")
table.insert(bt, "Shade of Akama")
table.insert(bt, "Teron Gorefiend")
table.insert(bt, "Reliquary of Souls")
table.insert(bt, "Gurtogg Bloodboil")
table.insert(bt, "Mother Shahraz")
table.insert(bt, "The Illidari Council")
table.insert(bt, "Illidan Stormrage")

local za = {}
table.insert(za, "Akil'zon")
table.insert(za, "Nalorakk")
table.insert(za, "Jan'alai")
table.insert(za, "Halazzi")
table.insert(za, "Hex Lord Malacrass")
table.insert(za, "Daakara")

local sunwell = {}
table.insert(sunwell, "Kalecgos")
table.insert(sunwell, "Brutallus")
table.insert(sunwell, "Felmyst")
table.insert(sunwell, "Eredar Twins")
table.insert(sunwell, "M'uru")
table.insert(sunwell, "Kil'jaeden")

local test = {}
table.insert(test, "High Overlord Saurfang")
table.insert(test, "Overlord Runthak")

raids = {}
raids["Karazhan"]             = karazhan
raids["Gruul's Lair"]         = gruulsLair
raids["Magtheridon's Lair"]   = magtheridonsLair
raids["Serpentshrine Cavern"] = ssc
raids["Tempest Keep"]         = tk
raids["Hyjal Summit"]         = hyjal
raids["Black Temple"]         = bt
raids["Zul'Aman"]             = za
raids["The Sunwell"]          = sunwell -- test this
-- raids["Orgrimmar"]            = test -- remove this

raidAliases = {}
raidAliases["The Eye"]                    = "Tempest Keep"
raidAliases["Sunwell Plateau"]            = "The Sunwell"
raidAliases["The Battle for Mount Hyjal"] = "Hyjal Summit"

currentEncounters = {}
for k,_ in pairs(raids) do
	currentEncounters[k] = 1
end

function BossExistsInRaid(zone, boss)
	if not raids[zone] then return end

	for _,v in ipairs(raids[zone]) do
		if v == boss then return true end
	end

	return false
end

function SetCurrentEncounter(zone, boss)
	if not raids[zone] then return end

	for i,v in pairs(raids[zone]) do
		if v == boss then currentEncounters[zone] = i end
	end
end

function UpdateCurrentEncounters(zone)
	local function MapEncounterToZone(encounterName)
		return raidAliases[encounterName] or encounterName
	end

	for i = 1, GetNumSavedInstances() do
		local name,_,_,_,_,_,_,_,_,_,_,encounterProgress = GetSavedInstanceInfo(i)
		local _,_,isKilled,_ = GetSavedInstanceEncounterInfo(i, encounterProgress) -- be weary of bug where havent cleared instance and this is wrong
		local zone = MapEncounterToZone(name)

		for k,_ in pairs(currentEncounters) do
			if k == zone then
				if isKilled then
					currentEncounters[k] = encounterProgress + 1
				else    
					currentEncounters[k] = encounterProgress
				end
			end
		end
	end
end