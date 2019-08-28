local TileManager = {}
TileManager.__index = TileManager

local instantiated = false

local function _init(cls)
    local self = setmetatable({}, cls)
    return self
end

setmetatable(TileManager, {
    __call = function(cls, ...)
        assert(not instantiated,
               "Error: attempt to create another TileManager instance!")
        instantiated = true
        return _init(cls)
    end,
})

return TileManager
