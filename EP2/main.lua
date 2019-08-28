local AssetManager = require("src/AssetManager")

function love.load(arg)
    love.graphics.setColor(0, 0, 0)
    AssetManager.init(arg[2])
end

function love.update(dt)
end

function love.draw()
    AssetManager.draw()
end
