local M = Util.create_class()
local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode
local deg2rad = math.rad(1)
local rad2deg = math.deg(1)
local HALF_PI = math.pi / 2
local TIME = CS.UnityEngine.Time

function M:_init(entity, gun_cfg) 
    self.entity = entity

    -- cfgs
    self.key = gun_cfg.keycode or KeyCode.Space
    self.v_max_count = gun_cfg.max or 3
    self.v_missile_speed = gun_cfg.speed or 6
    self.v_shoot_cd = gun_cfg.shoot_cd or 0.05
    self.v_max_live_time = gun_cfg.live_time or 0.5
    self.lock_gun = gun_cfg.lock_gun

    self.v_last_shoot_time = 0

    local path = gun_cfg.path or "Missile"
    self.v_missiles = {}
    for i = 1, self.v_max_count do
        local missile = {}
        missile.gameobj = SceneMgr:load_prefab(path)
        self.v_missiles[i] = missile

        missile.transform = missile.gameobj.transform
        missile.gameobj:SetActive(false)
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
            missile.gameobj:SetActive(true)
            missile.transform.position = self.entity.transform.position
            missile.transform.rotation = Quaternion.Euler(0, 0, self.entity:get_face_deg())
            missile.live_time = 0
            missile.shouted = true

            -- cfg
            missile.move_type = 1

            local move_params = {}
            missile.move_params = move_params
            if missile.move_type == 1 then
                move_params.move_x, move_params.move_y = self.entity:get_face_vec2()
            elseif missile.move_type == 2 then
                move_params.p0, move_params.p1 = self.entity:get_pos2()
            end


            self.v_last_shoot_time = TIME.time
            break
        end
    end
end

function M:on_update(dt)
    self:get_input()

    for _, missile in pairs(self.v_missiles) do
        if missile.shouted then
            -- update missile
            local pos = missile.transform.position
            if self.lock_gun then
                pos.y = pos.y + self.v_missile_speed * 0.016
            else
                pos.y = pos.y + self.v_missile_speed * 0.016 * missile.diry
                pos.x = pos.x + self.v_missile_speed * 0.016 * missile.dirx
            end
            missile.transform.position = pos

            missile.live_time = missile.live_time + 0.016

            -- stop missile
            if missile.live_time >= self.v_max_live_time then
                missile.shouted = false
                missile.gameobj:SetActive(false)
            end
        end
    end
end

function M:on_fixed_update()

end

function M:on_destory()
    for _, missile in pairs(self.v_missiles) do
        UnityGameObject.Destroy(missile.gameobj)
    end
end

return M