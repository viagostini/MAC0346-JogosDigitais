local SIMULATOR = {}

local DataLoader = require "data_loader"

local triangle_bonus = DataLoader.load_file("triangle_bonus.lua")

local function get_fighters(fight, units)
    local attacker = units[fight[1]]
    local defender = units[fight[2]]
    return attacker, defender
end

local function set_output(input, units)
    local output = input

    for k in pairs(output.units) do
        output.units[k].hp = units[k].hp
    end

    return output
end

local function do_hit(attacker, defender)
    local acc = attacker.weapon.hit + 2 * attacker.skl + attacker.lck +
        10 * triangle_bonus[attacker.weapon.kind][defender.weapon.kind]
    local avo = 2 * defender.atkspd + defender.lck
    local hit_chance = math.max(0, math.min(100, acc - avo))
    local r1 = math.random(100)
    local r2 = math.random(100)
    local rand = (r1 + r2) / 2
    print("\t\tr1=" .. r1 .. " r2=" .. r2 .. " rand=".. rand .. " hit_chance="
          .. hit_chance)

    return rand <= hit_chance
end

local function calculate_critical_bonus(attacker, defender)
    local critical_rate = attacker.weapon.crt + math.floor(attacker.skl / 2)
    local dodge = defender.lck
    local critical_chance = math.max(0, math.min(100, critical_rate - dodge))
    local rand = math.random(100)
    print("\t\trand=" .. rand .. " critical_chance=" .. critical_chance)

    if rand <= critical_chance then return 3
    else return 1
    end
end

local function calculate_damage(attacker, defender, critical_bonus)
    local eff_bonus = 1
    local attacker_attr = 0
    local defender_attr = 0

    if attacker.weapon.eff ~= nil and defender.trait ~= nil and
       attacker.weapon.eff == defender.trait then
        eff_bonus = 2
    end

    if attacker.weapon.dmgtype == "physical" then
        attacker_attr = attacker.str
        defender_attr = defender.def
    elseif attacker.weapon.dmgtype == "magical" then
        attacker_attr = attacker.mag
        defender_attr = defender.res
    end

    local power = attacker_attr + eff_bonus * (attacker.weapon.mt +
                  triangle_bonus[attacker.weapon.kind][defender.weapon.kind])
    local damage = critical_bonus * (power - defender_attr)

    return damage
end

local function attack(attacker, defender)
    print("\t" .. attacker.name .. " attacking " .. defender.name)

    if attacker.hp == 0 then
        return
    end

    if do_hit(attacker, defender) then
        local critical_bonus = calculate_critical_bonus(attacker, defender)
        local damage = calculate_damage(attacker, defender, critical_bonus)
        print("\t\tDamage dealt: " .. damage)
        defender.hp = math.max(0, defender.hp - damage)
    else
        print("\t\tAttack missed")
    end
end

local function init_fight(fight_nb, attacker, defender)
    print("Luta " .. fight_nb .. ": " .. attacker.name .. " vs " ..
          defender.name)

    attack(attacker, defender)
    attack(defender, attacker)

    if attacker.atkspd - defender.atkspd >= 4 then
        attack(attacker, defender)
    elseif defender.atkspd - attacker.atkspd >= 4 then
        attack(defender, attacker)
    end
end

function SIMULATOR.run(scenario_input)
    math.randomseed(scenario_input.seed)
    local units = DataLoader.load_units(scenario_input)

    for fight_nb, fight in ipairs(scenario_input.fights) do
        local attacker, defender = get_fighters(fight, units)
        init_fight(fight_nb, attacker, defender)
    end

    local scenario_output = set_output(scenario_input, units)
    return scenario_output.units
end

return SIMULATOR
