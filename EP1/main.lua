--[[

local n, seed = 10, 1337900143

math.randomseed(seed)

for i = 1, n do
  print(i, math.random(100))
end

]]

input = require "input"

math.randomseed(input.seed)

local triangle_bonus = require "triangle_bonus"

for i, fight in ipairs(input.fights) do
    local atk_name, def_name = unpack(fight)

    local attacker = input.units[atk_name]
    local defender = input.units[def_name]
    
    print("Luta " .. i .. ": " .. atk_name .. " vs " .. def_name)

    -- attacker info
    local atk_weapon = input.weapons[attacker.weapon]
    local atk_hit = atk_weapon.hit
    local atk_skl = attacker.skl
    local atk_lck = attacker.lck
    local atk_kind = enum[atk_weapon.kind]
    local atk_spd = attacker.spd
    local atk_wt = atk_weapon.wt
    local atk_str = attacker.str
    local atk_atkspd = atk_spd - math.max(0, atk_wt - atk_str)

    -- defender info
    local def_weapon = input.weapons[defender.weapon]
    local def_lck = defender.lck
    local def_kind = enum[def_weapon.kind]
    local def_spd = defender.spd
    local def_wt = def_weapon.wt
    local def_str = defender.str
    local def_atkspd = def_spd - math.max(0, def_wt - def_str)

    -- triangle bonus
    local tri_bonus = triangle_bonus[atk_kind][def_kind]

    -- hit chance calculations
    local atk_acc = atk_hit + (2 * atk_skl) + (10 * tri_bonus)
    local def_avo = (2 * def_atkspd) + def_lck
    local hit_chance = math.max(0, math.min(100, atk_acc - def_avo))

    local r = (math.random(0, 100) + math.random(0, 100)) / 2

    print(hit_chance, r)

    -- damage and critical calculations
    local eff = 1
    if atk_weapon.trait == def_weapon.trait then
        eff = 2
    end

    local power = atk_weapon.mt + tri_bonus
    if kinds[atk_weapon] == "physical" then
        power = (power + atk_str) * eff
    else
        power = (power + attacker.mag) * eff
    end

    local crit_bonus = 1
    
    if r <= hit_chance then
        local crit_rate = atk_weapon.crt + (atk_skl/2)
        local crit_chance = math.max(0, math.min(100, crit_rate - def_lck))

        r = math.random(0, 100)

        if r <= crit_chance then
            crit_bonus = 3
        end

        local dmg = 0
        if kinds[atk_weapon] == "physical" then
            dmg = (power - defender.def) * crit_bonus
        else
            dmg = (power - defender.res) * crit_bonus
        end
        print("Damage from " .. atk_name .. " to " .. def_name .. " = " .. dmg)
    end

end

