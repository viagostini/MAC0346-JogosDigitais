local Unit = {}
Unit.__index = Unit

local Weapon = require "weapon"

setmetatable(Unit, {
    __call = function(cls, ...)
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

function Unit:_init(name, attr_tbl, weapon_attr_tbl)
    self.name = name
    self.hp = attr_tbl.hp
    self.str = attr_tbl.str
    self.mag = attr_tbl.mag
    self.skl = attr_tbl.skl
    self.spd = attr_tbl.spd
    self.lck = attr_tbl.lck
    self.def = attr_tbl.def
    self.res = attr_tbl.res
    self.trait = attr_tbl.trait
    self.weapon = Weapon(attr_tbl.weapon, weapon_attr_tbl)
    self.atkspd = self.spd - math.max(0, self.weapon.wt - self.str)
end

return Unit
