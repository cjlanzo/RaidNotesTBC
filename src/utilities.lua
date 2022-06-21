-- Addon helpers
function debugPrint(msg)
    if not DEBUG_MODE then return end
    print("|cffffff00RaidNotesTBC: |r"..msg)
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

-- Arrays
function map(arr, fn)
    local t = {}
    
    for k,v in pairs(arr) do
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