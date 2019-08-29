local AssetManager = require "src/AssetManager"

function love.load(arg)
    AssetManager.init(arg[1])
end

function love.update(dt)
    AssetManager.update()
end

function love.draw()
    AssetManager.draw()
end
