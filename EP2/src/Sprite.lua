local Class = require "src/Class"
local Sprite = Class()
local chars_path = "/chars/"

local function setup_frames(frames)
    local new_frames = {}

    for frame_token in frames:gmatch("%d+") do
        table.insert(new_frames, tonumber(frame_token))
    end

    return new_frames
end

local function setup_animation(name, width, height, properties)
    local animation = {}
    animation.current_time = 0
    animation.duration = #properties.frames / properties.fps
    animation.imageobj = love.graphics.newImage(chars_path .. name .. ".png")
    animation.quads = {}

    for _, v in pairs(properties.frames) do
        local x = (v - 1) % properties.columns * height
        local y = math.floor((v - 1) / properties.columns) * width
        local w, h = animation.imageobj:getDimensions()
        local quad = love.graphics.newQuad(x, y, width, height, w, h)
        table.insert(animation.quads, quad)
    end

    return animation
end

function Sprite:_init(id, name, x, y, width, height, properties)
    self.id = id
    self.name = name
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.properties = properties
    self.properties.frames = setup_frames(properties.frames)
    self.animation = setup_animation(name, width, height, properties)
end

function Sprite:update(dt)
    self.animation.current_time = self.animation.current_time + dt

    if self.animation.current_time >= self.animation.duration then
        self.animation.current_time = self.animation.current_time
                                    - self.animation.duration
    end
end

function Sprite:draw()
    local sprite_num = math.floor(self.animation.current_time
                                  / self.animation.duration
                                  * #self.animation.quads)
                     + 1
    love.graphics.draw(self.animation.imageobj,
                       self.animation.quads[sprite_num],
                       self.x,
                       self.y)
end

return Sprite
