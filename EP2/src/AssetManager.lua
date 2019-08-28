local AssetManager = {}

local maps_path = "/maps/"
local map
local tilesets

local function setup_tilesets()
    tilesets = map.tilesets

    for _, v in ipairs(tilesets) do
        v.displaywidth = math.floor(love.graphics.getWidth() / map.width)
        v.displayheight = math.floor(love.graphics.getHeight() / map.height)
        v.imageobj = love.graphics.newImage(maps_path .. v.image)
        v.quads = setmetatable({}, {__index = function(t, k)
            t[k] = love.graphics.newQuad(
            )
        end})
        v.batch = love.graphics.newSpriteBatch(
            v.imageobj,
            v.displaywidth * v.displayheight
        )
    end
end

function AssetManager.init(map_name)
    local chunk = love.filesystem.load(maps_path .. map_name .. ".lua")
    map = chunk()
    setup_tilesets()
    love.graphics.setBackgroundColor(map.backgroundcolor[1],
                                     map.backgroundcolor[2],
                                     map.backgroundcolor[3])
end

function AssetManager.draw()
    for _, v in ipairs(tilesets) do
        love.graphics.draw(v.batch, v.tilewidth, v.tileheight, 0, 0, 0)
    end
    love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 0)
end

return AssetManager
