
local Class = require "src/common/class"

local Entity = Class()

function Entity:_init(id, type)
    self.id = id
    self.type = type 
end

return Entity

