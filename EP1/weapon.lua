local Weapon = {}
Weapon.__index = Weapon

setmetatable(Weapon, {
    __call = function(cls, ...)
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

local physical = {sword = true, axe = true, lance = true, bow = true}
local magical = {wind = true, thunder = true, fire = true}

function Weapon:_init(name, attr_tbl)
    self.name = name
    self.mt = attr_tbl.mt
    self.hit = attr_tbl.hit
    self.crt = attr_tbl.crt
    self.wt = attr_tbl.wt
    self.kind = attr_tbl.kind
    self.eff = attr_tbl.eff

    if physical[self.kind] then
        self.dmgtype = "physical"
    elseif magical[self.kind] then
        self.dmgtype = "magical"
    end
end

return Weapon
