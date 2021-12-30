local M = Util.create_class()
local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode
local deg2rad = math.rad(1)
local rad2deg = math.deg(1)
local HALF_PI = math.pi / 2
local TIME = CS.UnityEngine.Time

function M.stop_missile(missile)
    missile.shouted = false
    missile.gameobj:SetActive(false)
end

function M:_init(entity, gun_cfg) 
    self.entity = entity

    -- cfgs
    self.key = gun_cfg.keycode or KeyCode.Space
    self.v_max_count = gun_cfg.max or 3
    self.v_shoot_cd = gun_cfg.shoot_cd or 0.05

    self.v_last_shoot_time = 0

    local missile_cfg = {
        name = "子弹",
        res_path = gun_cfg.path or "Missile",
        speed = gun_cfg.speed or 6,
        lock_dir = gun_cfg.lock_gun,
        max_live_time = 1,
        move_type = 2
    }

    self.v_missiles = {}
    for i = 1, self.v_max_count do
        self.v_missiles[i] = require("objs.entitys.missile"):new(missile_cfg, self.entity)
    end
end

function M:get_input()
    if Input.GetKey(self.key) and TIME.time - self.v_last_shoot_time > self.v_shoot_cd then
        self:shoot()
    end
end

function M:shoot()
    for i = 1, self.v_max_count do
        local missile = self.v_missiles[i]
        if not missile.shouted then
            missile:on_shot()
            self.v_last_shoot_time = TIME.time
            break
        end
    end
end

function M:on_update(dt)
    self:get_input()

    for _, missile in pairs(self.v_missiles) do
        missile:on_update(dt)
    end
end

function M:on_fixed_update()

end

function M:on_destory()
    for k, missile in pairs(self.v_missiles) do
        SceneMgr:delete_obj(missile)
        self.v_missiles[k] = nil
    end
end

return M