local AssetManager = {}

local maps_path = "/maps/"
local map
local tileset_images = {}
local tileset_batches = {}
local tile_quads = {}

local function _setup_tilesets()
    for k, v in pairs(map.tilesets) do
        tileset_images[v.name] = love.graphics.newImage(maps_path .. v.image)
        tile_quads[v.name] = setmetatable({}, {__index = function(t, k)
            tile_quads[v.name][k] = love.graphics.newQuad(
            )
        end})
    end
end

function AssetManager.init(map_name)
    local chunk = love.filesystem.load(maps_path .. map_name .. ".lua")
    map = chunk()
    _setup_tilesets()
    love.graphics.setBackgroundColor(map.backgroundcolor[1],
                                     map.backgroundcolor[2],
                                     map.backgroundcolor[3])

end

return AssetManager
