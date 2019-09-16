
local Class = require "src/common/class"
local Property = require "src/Property"

local Body = Class(Property)

local instantiated = false

function Body:_init(default_value)
    assert(not instantiated,
           "Error: attempt to create another Body instance!")
    instantiated = true
    self:super(default_value)
end

function Body:add_entity(entity_id, body_data)
    local body

    if body_data == nil then
        return
    elseif body_data.size == nil then
        body = self.default_value
    else
        body = body_data
    end

    Property.add_entity(self, entity_id, body)
end

function Body:get_size(entity_id)
    if self.entity_table[entity_id] ~= nil then
        return self.entity_table[entity_id].size
    else
        return self.default_value.size
    end
end

function Body:draw(entity_id, entity_position)
    love.graphics.setColor(0, 255, 0)
    love.graphics.circle("fill", entity_position.x, entity_position.y,
                         self.entity_table[entity_id].size)
end

return Body

