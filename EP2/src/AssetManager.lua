local AssetManager = {}

local Sprite = require "src/Sprite"

local maps_path = "/maps/"
local map
local tileset
local tilelayers = {}
local sprites = {}

local function update_tileset_batch()
    tileset.batch:clear()

    for _, v in ipairs(tilelayers) do
        for x = 1, tileset.displaywidth do
            for y = 1, tileset.displayheight do
                local data_index = map.width * (y - 1) + x
                if v.data[data_index] > 0 then
                    tileset.batch:add(
                        tileset.quads[v.data[data_index]],
                        math.floor((x - y) * tileset.tilewidth / 2),
                        math.floor((x + y) * tileset.tileheight / 4 + v.offsety)
                    )
                end
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
            tileset.imageobj:getDimensions()
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

local function setup_sprites()
    for _, v in ipairs(map.layers) do
        if v.type == "objectgroup" then
            for _, v2 in ipairs(v.objects) do
                if v2.type == "sprite" then
                    local sprite = Sprite(v2.id, v2.name, v2.x, v2.y, v2.width,
                                          v2.height, v2.properties)
                    table.insert(sprites, sprite)
                end
            end
        end
    end
end

function AssetManager.init(map_name)
    local chunk = love.filesystem.load(maps_path .. map_name .. ".lua")
    map = chunk()
    tileset = map.tilesets[1]
    setup_tileset()
    setup_sprites()
    love.graphics.setBackgroundColor(unpack(map.backgroundcolor))
end

function AssetManager.update(dt)
    for _, v in ipairs(sprites) do
        v:update(dt)
    end
end

function AssetManager.draw()
    love.graphics.scale(0.5, 0.5)
    love.graphics.draw(tileset.batch, 800, 100)
    for _, v in ipairs(sprites) do
        v:draw()
    end
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 0)
    love.graphics.setColor(255, 255, 255)
end

return AssetManager
