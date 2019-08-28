local AssetManager = require("src/AssetManager")

function love.load(arg)
    love.graphics.setColor(0, 0, 0)
    AssetManager.init(arg[1])
end

function love.update(dt)
    AssetManager.update()
end

function love.draw()
    AssetManager.draw()
end
