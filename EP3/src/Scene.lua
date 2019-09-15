
local Class = require "src/common/class"
local Entity = require "src/Entity"
local Position = require "src/Position"
local Vec = require "src/common/vec"

local Scene = Class()

local instantiated = false
local entities_path = "assets/entity/"
local scenes_path = "assets/scene/"

local function create_entity(self, id, type, entity_data)
    local entity = Entity(id, type)
    self.entities[id] = entity
    self.position:add_entity(id, entity_data.position, self.size)
end

local function init_entities(self, scene_data)
    self.entities = {}
    local id = 1

    for _, v in pairs(scene_data) do
        local chunk = love.filesystem.load(entities_path .. v.entity .. ".lua")
        local entity_data = chunk()

        for i = 1, tonumber(v.n) do
            create_entity(self, id, v.entity, entity_data)
            id = id + 1
        end
    end
end

local function init_properties(self, default_values)
    self.position = Position(default_values.position)
end

function Scene:_init(name, center, size)
    assert(not instantiated,
           "Error: attempt to create another Scene instance!")
    instantiated = true

    self.center = center
    self.origin = Vec(love.graphics.getDimensions()) / 2
    self.size = size 
    local default_values = love.filesystem.load(entities_path .. "default.lua")
    init_properties(self, default_values())
    local scene_data = love.filesystem.load(scenes_path .. name .. ".lua")
    init_entities(self, scene_data())
end

function Scene:update(dt)
    self.position:update(dt)
end

function Scene:draw()
    love.graphics.translate(self.origin.x, self.origin.y)
    love.graphics.setColor(255, 255, 255)
    love.graphics.scale(0.25, 0.25)
    love.graphics.circle("line", self.center.x, self.center.y, self.size)
    self.position:draw()
end

return Scene

