local M = {}

local hero

local hero_tank_cfg = {
    name = "一号车车",
    res_path = "Man",
    speed = 4,
    dirs = 4,

    gun = {
        lock_gun = false,
        keycode = KeyCode.Space,
        max = 10,
        speed = 10,
        shoot_cd = 0.05,
        live_time = 1,
        path = "MissileArrow"
    }
}

local function setpos(gameobj, x, y, z)
    gameobj.transform.position = {x = x, y = y, z = z}
end

local function create_world()
    hero = require("objs.entitys.basic_move&shot"):new(hero_tank_cfg)
end


M.start = function()
    create_world()
end

M.update = function()
    if hero then
        hero:on_update()
    end

    if Input.GetKeyDown(KeyCode.K) then
        hero:die()
        hero = nil
    end
end

M.fixed_update = function()
    if hero then
        hero:on_fixed_update()
    end
end

M.on_collide = function (a, b)

end

return M