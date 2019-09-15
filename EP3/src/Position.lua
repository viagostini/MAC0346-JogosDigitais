
local Class = require "src/common/class"
local Vec = require "src/common/vec"
local Property = require "src/Property"

local Position = Class(Property)

local instantiated = false

function Position:_init(default_value)
    assert(not instantiated,
           "Error: attempt to create another Position instance!")
    instantiated = true
    self:super(default_value)
end

function Position:add_entity(entity_id, position, scene_size)
    if position.point == nil then
        local angle = math.random() * 2 * math.pi
        local r = scene_size * math.sqrt(math.random())
        local x = r * math.cos(angle)
        local y = r * math.sin(angle)
        Property.add_entity(self, entity_id, { point = Vec(x, y) })
    end
end

function Position:update(dt)
end

function Position:draw()
    love.graphics.setColor(0, 255, 0)

    for _, v in pairs(self.entity_table) do
        love.graphics.circle("line", v.point.x, v.point.y, 8)
    end
end

return Position

