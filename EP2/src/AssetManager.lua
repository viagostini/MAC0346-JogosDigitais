local AssetManager = {}

local maps_path = "/maps/"
local map
local tileset
local tilelayers = {}

local function update_tileset_batch()
    tileset.batch:clear()

    for _, v in ipairs(tilelayers) do
        for x = 1, tileset.displaywidth do
            for y = 1, tileset.displayheight do
                local data_index = map.width * (y - 1) + x
                tileset.batch:add(
                    tileset.quads[v.data[data_index]],
                    math.floor((x - y) * tileset.tilewidth / 2),
                    math.floor((x + y) * tileset.tileheight / 4 + v.offsety)
                )
            end
        end
    end

    tileset.batch:flush()
end

local function setup_tileset()
    tileset.displaywidth = map.width
    tileset.displayheight = map.height
    tileset.imageobj = love.graphics.newImage(maps_path .. tileset.image)
    tileset.quads = setmetatable({}, {__index = function(t, k)
        t[k] = love.graphics.newQuad(
            (tonumber(k) - 1) % tileset.columns * tileset.tilewidth,
            math.floor((tonumber(k) - 1) / tileset.columns) * tileset.tileheight,
            tileset.tilewidth,
            tileset.tileheight,
            tileset.imageobj:getWidth(),
            tileset.imageobj:getHeight()
        )
        return t[k]
    end})
    tileset.batch = love.graphics.newSpriteBatch(
        tileset.imageobj,
        tileset.displaywidth * tileset.displayheight
    )

    for _, v in ipairs(map.layers) do
        if v.type == "tilelayer" then
            table.insert(tilelayers, v)
        end
    end

    update_tileset_batch()
end

function AssetManager.init(map_name)
    local chunk = love.filesystem.load(maps_path .. map_name .. ".lua")
    map = chunk()
    tileset = map.tilesets[1]
    setup_tileset()
    love.graphics.setBackgroundColor(unpack(map.backgroundcolor))
end

function AssetManager.update()
end

function AssetManager.draw()
    love.graphics.draw(tileset.batch, 1, 1)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 0)
    love.graphics.setColor(255, 255, 255)
end

return AssetManager
