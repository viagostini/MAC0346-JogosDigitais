local DataLoader = {}

local Unit = require "unit"

function DataLoader.load_file(filename)
    local path = debug.getinfo(1, 'S').source
    path = path:match(".*/"):sub(2)
    local chunk = assert(loadfile(path .. filename))
    setfenv(chunk, {})
    return chunk()
end

function DataLoader.load_units(input)
    local units = {}

    for k, v in pairs(input.units) do
        units[k] = Unit(k, v, input.weapons[v.weapon])
    end

    return units
end

return DataLoader
