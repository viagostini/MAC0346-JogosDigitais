local AssetManager = {}

local maps_path = "/maps/"
local map
local tileset
local layers

local function setup_tileset()
    tileset.displaywidth = math.floor(
        love.graphics.getWidth() / tileset.tilewidth
    )
    tileset.displayheight = math.floor(
        love.graphics.getHeight() / tileset.tileheight
    )
    tileset.imageobj = love.graphics.newImage(maps_path .. tileset.image)
    tileset.quads = setmetatable({}, {__index = function(t, k)
        t[k] = love.graphics.newQuad(
        )
    end})
    tileset.batch = love.graphics.newSpriteBatch(
        tileset.imageobj,
        tileset.displaywidth * tileset.displayheight
    )
end

local function update_tileset_batch()
end

function AssetManager.init(map_name)
    local chunk = love.filesystem.load(maps_path .. map_name .. ".lua")
    map = chunk()
    tileset = map.tilesets[1]
    layers = map.layers
    setup_tileset()
    love.graphics.setBackgroundColor(map.backgroundcolor[1],
                                     map.backgroundcolor[2],
                                     map.backgroundcolor[3])
end

function AssetManager.update()
    update_tileset_batch()
end

function AssetManager.draw()
    love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 0)
end

return AssetManager
