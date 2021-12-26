local M = {}

local player_car_name = "HeroCar"
local hero

local function setpos(gameobj, x, y, z)
    gameobj.transform.position = {x = x, y = y, z = z}
end

local function create_world()
    local hero_res = Util.load_prefab(player_car_name)
    local hero_obj = UnityGameObject.Instantiate(hero_res)

    hero = require("objs.entitys.hero_car"):new("一号", hero_obj)
    setpos(hero_obj, 0, 0, -1)
end


M.start = function()
    create_world()
end

M.update = function()
    hero:on_update()
end

M.fixed_update = function()
    hero:on_fixed_update()
end

return M