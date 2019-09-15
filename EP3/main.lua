
local Scene = require "src/Scene"
local Vec = require "src/common/vec"

local scene

function love.load(arg)
    local scene_name = arg[1]
    scene = Scene(scene_name, Vec(0, 0), 1000)
end

function love.update(dt)
    scene:update(dt)
end

function love.draw()
    scene:draw()
end

