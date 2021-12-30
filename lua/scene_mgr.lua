local M = Util.create_class()

local tank_cfg = {
    name = "车车",
    res_path = "Tank",
    speed = 4,
    dirs = 4,
}

local man_cfg = {
    name = "坦克",
    res_path = "Tank",
    speed = 4,

    gun = {
        lock_gun = false,
        keycode = KeyCode.Space,
        max = 20,
        speed = 10,
        shoot_cd = 0.01,
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

function M:load_obj(path, luaobj)
    if not path then
        Log.Error("obj path is nil", debug.traceback())
    end
    local res = Util.load_prefab(path)
    if not res then
        Log.Error(path .. "资源不存在", debug.traceback())
        return
    end

    local obj = UnityGameObject.Instantiate(res)
    self.cid2obj[obj:GetInstanceID()] = luaobj;
    return obj
end

function M:delete_obj(obj)
    self.cid2obj[obj.gameobj:GetInstanceID()] = nil
    obj:on_destory()
end

function M:_init()
    self.cid2obj = {}
end

function M:game_start()
    Global.hero = self:create_hero()
    Global.hero:set_pos(0, 0)
    for i = 1, 5 do
        local tank = self:create_tank()        
        tank:set_pos(i, 4)
    end
end

function M:clear()
    Global.hero:die()
    Global.hero = nil
end

local CD = 0.1
local timer = 0

function M:update()
    Global.hero:on_update(TIME.deltaTime)
    timer = timer + TIME.deltaTime
    if timer > CD then
        timer = 0
        local tank = self:create_tank()
        tank:set_pos(math.random(-5,5), math.random(-5,5))
    end
end

function M:fixed_update()
    Global.hero:on_fixed_update()
end

function M:on_collide(a_cid, b_cid)
    local missile = self.cid2obj[a_cid]

    if not missile or not missile.is_missile then return end

    local other = self.cid2obj[b_cid]
    if not other then return end

    missile:attack(other)
end

return M