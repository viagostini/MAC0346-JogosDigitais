local Vec = require "src/common/vec"
local Class = require "src/common/class"
local Property = require "src/Property"

local Movement = Class(Property)

local instantiated = false

function Movement:_init(default_value)
    assert(not instantiated,
            "Error: attempt to create another Movement instance!")
    instantiated = true
    self:super(default_value)
end

function Movement:add_entity(entity_id, movement_data)
    local movement

    if movement_data == nil then
        return
    elseif movement_data.motion == nil then
        movement = self.default_value
    else
        movement = movement_data
    end

    Property.add_entity(self, entity_id, movement)
end

return Movement

