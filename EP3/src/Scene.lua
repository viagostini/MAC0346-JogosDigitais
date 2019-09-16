
local Body = require "src/Body"
local Class = require "src/common/class"
local Entity = require "src/Entity"
local Position = require "src/Position"
local Vec = require "src/common/vec"

local Scene = Class()

local instantiated = false
local entities_path = "assets/entity/"
local scenes_path = "assets/scene/"
local assets_extension = ".lua"

local function create_entity(self, id, type, entity_data)
    local entity = Entity(id, type)
    self.entities[id] = entity
    self.body:add_entity(id, entity_data.body)
    self.position:add_entity(id, entity_data.position, self.size, self.body)
end

local function init_entities(self, scene_data)
    self.entities = {}
    local id = 1

    for _, group in pairs(scene_data) do
        local filepath = entities_path .. group.entity .. assets_extension
        local entity_data = love.filesystem.load(filepath)()

        for _ = 1, tonumber(group.n) do
            create_entity(self, id, group.entity, entity_data)
            id = id + 1
        end
    end
end

local function init_properties(self, default_data)
    self.position = Position(default_data.position)
    self.body = Body(default_data.body)
end

function Scene:_init(name, center, size)
    assert(not instantiated,
           "Error: attempt to create another Scene instance!")
    instantiated = true

    self.center = center
    self.size = size
    local default_data = love.filesystem.load(entities_path .. "default.lua")
    init_properties(self, default_data())
    local filepath = scenes_path .. name .. assets_extension
    local scene_data = love.filesystem.load(filepath)
    init_entities(self, scene_data())
end

function Scene:draw()
    self.origin = Vec(love.graphics.getDimensions()) / 2
    love.graphics.translate(self.origin.x, self.origin.y)
    love.graphics.setColor(255, 255, 255)
    love.graphics.scale(0.4, 0.4)
    love.graphics.circle("line", self.center.x, self.center.y, self.size)
    self.position:draw(self.body)
end

return Scene

