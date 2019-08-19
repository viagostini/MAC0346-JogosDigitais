local SIMULATOR = {}

local function get_fighter_data(name, input)
    local fighter = {}

    for k, v in pairs(input.units[name]) do
        fighter[k] = v
    end

    fighter.name = name
    local weapon_name = fighter.weapon
    fighter.weapon = {name = weapon_name}

    for k, v in pairs(input.weapons[weapon_name]) do
        fighter.weapon[k] = v
    end

    return fighter
end

local function get_fighters(fight, input)
    local fighters = {}

    for i, n in ipairs(fight) do
        fighters[i] = get_fighter_data(n, input)
    end

    return fighters[1], fighters[2]
end

local function set_atkspd(fighter)
    fighter.atkspd = fighter.spd - math.max(0, fighter.weapon.wt - fighter.str)
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
        defender.hp = defender.hp - damage
    end
end

local function init_fight(attacker, defender, triangle_bonus)
    set_atkspd(attacker)
    set_atkspd(defender)
    attack(attacker, defender, triangle_bonus)
    attack(defender, attacker, triangle_bonus)

    if attacker.atkspd - defender.atkspd >= 4 then
        attack(attacker, defender, triangle_bonus)
    elseif defender.atkspd - attacker.atkspd >= 4 then
        attack(defender, attacker, triangle_bonus)
end

function SIMULATOR.run(scenario_input)
    math.randomseed(scenario_input.seed)

    local triangle_bonus = require("triangle_bonus")

    for fight_nb, fight in ipairs(scenario_input.fights) do
        local attacker, defender = get_fighters(fight, scenario_input)
        init_fight(attacker, defender, triangle_bonus)
    end

    return scenario_input.units
end

return SIMULATOR
