local TileManager = {}
TileManager.__index = TileManager

local instantiated = false

setmetatable(TileManager, {
    __call = function(cls, ...)
        assert(not instantiated,
               "Error: attempt to create another TileManager instance!")
        instantiated = true
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

function TileManager:_init()
end

return TileManager
