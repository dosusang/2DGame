local M = Util.create_class()
local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode
local deg2rad = math.rad(1)
local rad2deg = math.deg(1)
local HALF_PI = math.pi / 2
local TIME = CS.UnityEngine.Time

function M:_init(entity) 
    self.entity = entity

    -- cfgs
    self.key = KeyCode.Space
    local missile_gameobj = Util.load_prefab("Missile")
    self.v_max_count = 3
    self.v_missile_speed = 6
    self.v_last_shoot_time = 0
    self.v_shoot_cd = 0.05
    self.v_max_live_time = 0.5

    self.v_missiles = {}
    for i = 1, self.v_max_count do
        local missile = {}
        missile.gameobj = UnityGameObject.Instantiate(missile_gameobj)
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
            missile.live_time = 0
            missile.shouted = true

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
            pos.y = pos.y + self.v_missile_speed * 0.016
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

return M