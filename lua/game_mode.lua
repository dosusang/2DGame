local M = {}

local ground_ball_name = "BasicGround"
local player_car_name = "HeroCar"


local HeroClass = require("objs.player_car")

local hero

local LoadRes = function (name)
    return ResLoader.LoadRes(Path.GetPath(name .. ".prefab"), typeof(UnityGameObject))
end

local function setpos(gameobj, x, y, z)
    gameobj.transform.position = {x = x, y = y, z = z}
end

local function create_world()
    -- local ball_res = LoadRes(ground_ball_name)
    -- local root = UnityGameObject("BallRoot")
    -- for i = -100, 100, 3 do
    --     for j = -100, 100, 3 do
    --         local ball = UnityGameObject.Instantiate(ball_res)
    --         setpos(ball, i, j, 0)
    --         ball.transform:SetParent(root.transform)
    --         ball:GetComponent(typeof(CS.UnityEngine.SpriteRenderer)).color = {r = math.random(), g = math.random(), b = math.random(), a = 1}
    --     end
    -- end

    local hero_res = LoadRes(player_car_name)
    local hero_obj = UnityGameObject.Instantiate(hero_res)

    hero = HeroClass:new("一号", hero_obj)
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