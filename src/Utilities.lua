-- Addon helpers
function debugPrint(msg)
    if not DEBUG_MODE then return end
    print("|cffffff00RaidNotes: |r"..msg)
end

function getZone(zone) return zone and zone or GetZoneText() end

function getTarget(target) return target and target or (not UnitIsDead("target") and UnitName("target") or nil) end

function getSavedInstanceInfo(index)
    local savedInstanceName,_,_,_,_,_,_,_,_,_,_,encounterProgress = GetSavedInstanceInfo(index)
    return savedInstanceName, encounterProgress
end

function iterSavedInstances(_, i)
    i = i + 1
    local a,b = getSavedInstanceInfo(i)

    if a then return i, a, b end
end

function savedInstances()
    return iterSavedInstances, {}, 0
end

-- Strings
function split(s, delimiter)
    local result = {}

    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    
    return result
end

function nullOrEmpty(s) return not s or s == "" end

function contains(s, pattern) return string.find(s, pattern) ~= nil end

-- Arrays
function map(arr, fn)
    local t = {}
    
    for _,v in pairs(arr) do
        table.insert(t, fn(v))
    end
    
    return t
end

function setTo(arr, v)
    local t = {}

    for k,_ in pairs(arr) do
        t[k] = v
    end

    return t
end

function iter(arr, fn)
    for _,v in pairs(arr) do
        fn(v) 
    end
end

function groupBy(arr, fn)
    local t = {}

    for _,v in pairs(arr) do
        local groupKey = fn(v)
        if not t[groupKey] then t[groupKey] = {} end

        table.insert(t[groupKey], v)
    end

    return t
end

function findBy(arr, fn)
    for _,v in pairs(arr) do
        if fn(v) then return v end
    end

    return nil
end

function collect(arr, fn)
    local t = {}

    for _,av in pairs(arr) do
        for k,v in pairs(fn(av)) do
            t[k] = v
        end
    end

    return t
end

function prepend(arr, item)
    local t = {}
    table.insert(t, item)

    for _,v in pairs(arr) do
        table.insert(t, v)
    end

    return t
end

function sortBy(arr, fn)
    local s_arr = arr

    table.sort(s_arr, function(a,b)
        return fn(a) < fn(b)
    end)

    return s_arr
end

-- Dicts
function mapDict(dict, fn)
    local t = {}

    for k,v in pairs(dict) do
        local _k, _v = fn(k,v)
        t[_k] = _v
    end

    return t
end

function iterDict(dict, fn)
    for k,v in pairs(dict) do
        fn(k,v)
    end
end

function invert(dict, fn)
    local t = {}

    for k,v in pairs(dict) do
        t[fn(v)] = k
    end

    return t
end

function asArray(dict)
    local arr = {}

    for _,v in pairs(dict) do
        table.insert(arr, v)
    end

    return arr
end

function isEmpty(dict) return not next(dict) end

-- Args
function packTable(...)
    local t = { ... }
    t.n = #t

    return t
end

function unpackTable(t, start, stop)
    if not start then start = 1 end
    if not stop then stop = t.n end

    if start == stop then return t[start]
    else return t[start], unpackTable(t, start + 1, stop)
    end
end

function sliceArgs(index, ...)
    local t = {}
    local arg = packTable(...)

    if index > arg.n then return nil end

    for i = index, arg.n do
        t[i - index + 1] = arg[i]
    end

    t.n = arg.n - index + 1

    return unpackTable(t)
end

function argsToString(...)
    local t = {}
    local arg = packTable(...)

    for i = 1, arg.n do
        t[i] = tostring(arg[i])
    end

    return table.concat(t, " - ")
end