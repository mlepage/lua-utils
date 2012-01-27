-- Miscellaneous Lua Utilities
-- Copyright (C) 2012 Marc Lepage

----------------------------------------------------------------------

-- Ordered iterator
function orderedPairs(t)
    local keys, i = {}, 0
    for k, v in pairs(t) do
        keys[#keys+1] = k
    end
    table.sort(keys)
    return function()
        i = i + 1
        local k = keys[i]
        if k then
            return k, t[k]
        end
    end
end

-- fill table with multiples of 9
t = {}
for n = 9, 99, 9 do
    t[n] = n
end

-- unordered iteration
io.write('unordered: ')
for k, v in pairs(t) do
    io.write(tostring(k), ',')
end
print()

-- ordered iteration
io.write('ordered: ')
for k, v in orderedPairs(t) do
    io.write(tostring(k), ',')
end
print()

----------------------------------------------------------------------

-- Depth first iteration over table elements, where children are
-- indexed 1 to N.
function elements(root)
    local keys, values
    return function()
        -- Initial value
        if keys == nil then
            keys, values = {}, {root}
            return keys, root
        end

        -- Descend depth first if possible
        local depth = #keys + 1
        local child = values[depth][1]
        if child then
            keys[depth], values[depth+1] = 1, child
            return keys, child
        end

        while 1 < depth do
            -- Backtrack
            depth = depth - 1
            -- Try next sibling
            local key = keys[depth] + 1
            child = values[depth][key]
            if child then
                keys[depth], values[depth+1] = key, child
                return keys, child
            end
            keys[depth] = nil
        end
    end
end

t =
{ name='root',
    { name='a',
        { name='b' },
        { name='c' }
    },
    { name='d',
        { name='e' }
    }
}
for k, v in elements(t) do
    print(string.rep('  ', #k) .. v.name)
end

----------------------------------------------------------------------

-- Create a table with n1 to n2 zero values
function tcreate(n1, n2)
    local t = {}
    for i = n1, n2 do t[i] = 0 end
    return t
end

-- Copies a table's array values by reference
local function tcopy(t)
    local tc = {}
    for i, v in ipairs(t) do tc[i] = v end
    return tc
end
