
local Class = require "src/common/class"

local Property = Class()

function Property:_init(default_value)
    self.entity_table = {}
    self.default_value = default_value
end

function Property:add_entity(entity_id, property_values)
    assert(self.entity_table[entity_id] == nil,
           "Error: attempt to add an existing entity!")
    self.entity_table[entity_id] = property_values
end

return Property

