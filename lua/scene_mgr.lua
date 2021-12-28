local M = Util.create_class()

local tank_cfg = {
    name = "车车",
    res_path = "Tank",
    speed = 4,
    dirs = 4,
    
}

local man_cfg = {
    name = "小人",
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



function M:create_hero()
    return require("objs.entitys.basic_move&shot"):new(man_cfg)
end

function M:create_tank()
    return require("objs.entitys.base_obj"):new(tank_cfg)
end

function M:load_prefab(path)
    local hero_res = Util.load_prefab(path)
    if not hero_res then
        Log.Error(path .. "资源不存在", debug.traceback())
        return
    end

    local obj = UnityGameObject.Instantiate(hero_res)
    self.cid2obj[obj:GetInstanceID()] = obj;
    return obj
end

function M:delete_gameobj(gameobj)
    UnityGameObject.Destroy(gameobj)
    self.cid2obj[obj:GetInstanceID()] = nil
end

function M:_init()
    self.cid2obj = {}
end

function M:game_start()
    Global.hero = self:create_hero()

    for i = 1, 5 do
        local tank = self:create_tank()        
        tank:set_pos(i, 4)
    end
end

function M:clear()
    Global.hero:die()
    Global.hero = nil
end

function M:update()
    Global.hero:on_update()
end

function M:fixed_update()
    Global.hero:on_fixed_update()
end

function M:on_collide(a, b)
    
end

return M