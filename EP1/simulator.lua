local SIMULATOR = {}

local DataLoader = require "data_loader"
local Weapon = require "weapon"
local Unit = require "unit"

local triangle_bonus = DataLoader.load_file("triangle_bonus.lua")

local function get_fighters(fight, units)
    local attacker = units[fight[1]]
    local defender = units[fight[2]]
    return attacker, defender
end

local function set_output(input, units)
    local output = input

    for k, v in pairs(output.units) do
        output.units[k].HP = units[k].HP
    end

    return output
end

local function do_hit(attacker, defender, triangle_bonus)
    local acc = attacker.weapon.hit + 2 * attacker.skl + attacker.lck +
        10 * triangle_bonus[attacker.weapon.kind][defender.weapon.kind]
    local avo = 2 * attacker.atkspd + attacker.lck
    local hit_chance = math.max(0, math.min(100, acc - avo))
    local rand = math.floor((math.random(0, 100) + math.random(0, 100)) / 2)

    return rand <= hit_chance
end

local function calculate_critical_bonus(attacker, defender)
    local critical_rate = attacker.weapon.crt + math.floor(attacker.skl / 2)
    local dodge = defender.lck
    local critical_chance = math.max(0, math.min(100, critical_rate - dodge))
    local rand = math.random(0, 100)

    if rand <= critical_chance then return 3
    else return 1
    end
end

local function calculate_damage(attacker, defender, critical_bonus)
end

local function attack(attacker, defender, triangle_bonus)
    if do_hit(attacker, defender, triangle_bonus) then
        local critical_bonus = calculate_critical_bonus(attacker, defender)
        local damage = calculate_damage(attacker, defender, critical_bonus)
    end
end

local function init_fight(attacker, defender, triangle_bonus)
    attack(attacker, defender, triangle_bonus)
    attack(defender, attacker, triangle_bonus)

    if attacker.atkspd - defender.atkspd >= 4 then
        attack(attacker, defender, triangle_bonus)
    elseif defender.atkspd - attacker.atkspd >= 4 then
        attack(defender, attacker, triangle_bonus)
    end
end

function SIMULATOR.run(scenario_input)
    math.randomseed(scenario_input.seed)
    local units = DataLoader.load_units(scenario_input)

    for fight_nb, fight in ipairs(scenario_input.fights) do
        local attacker, defender = get_fighters(fight, units)
        init_fight(attacker, defender, triangle_bonus)
    end

    scenario_output = set_output(scenario_input, units)
    return scenario_output.units
end

return SIMULATOR
