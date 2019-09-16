
local Class = require "src/common/class"
local Property = require "src/Property"
local Vec = require "src/common/vec"

local Position = Class(Property)

local instantiated = false

local function random_position(scene_size, entity_size)
    local angle = math.random() * 2 * math.pi
    local r = (scene_size - entity_size) * math.sqrt(math.random())
    local position = Vec(r * math.cos(angle), r * math.sin(angle))

    return { point = position }
end

function Position:_init(default_value)
    assert(not instantiated,
           "Error: attempt to create another Position instance!")
    instantiated = true
    self:super(default_value)
end

function Position:add_entity(entity_id, position_data, scene_size, body)
    local position

    if position_data == nil then
        return
    elseif position_data.point == nil then
        local entity_size = body:get_size(entity_id)
        position = random_position(scene_size, entity_size)
    else
        position = position_data
    end

    Property.add_entity(self, entity_id, position)
end

function Position:draw(body)
    for id, position in pairs(self.entity_table) do
        if body.entity_table[id] ~= nil then
            body:draw(id, position.point)
        else
            love.graphics.setColor(0, 255, 0)
            love.graphics.circle("line", position.point.x, position.point.y,
                                 body.default_value.size)
        end
    end
end

return Position

