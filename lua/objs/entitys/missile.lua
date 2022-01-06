local Base = require("objs.entitys.base_obj")
local M = Util.extend_class(Base)

local MISSILE_MOVE_TYPE = {
    LINE = 1,
    BEZIER = 2,
}

local MISSILE_ON_SHOT = {
    [MISSILE_MOVE_TYPE.LINE] = function (missile)
        local move_params = missile.move_params
        move_params.move_x, move_params.move_y = missile.shoter:get_face_vec2()
    end,

    [MISSILE_MOVE_TYPE.BEZIER] = function (missile)
        local move_params = missile.move_params
        move_params.x0, move_params.y0 = missile.shoter:get_pos2()

        local x, y = missile.shoter:get_face_vec2()
        local rad = missile.shoter:get_face_rad()
        move_params.x1 = move_params.x0 + 2 * math.cos(rad - math.pi/2 * (math.random()-0.5) * 2)
        move_params.y1 = move_params.y0 + 2 * math.sin(rad - math.pi/2 * (math.random()-0.5) * 2)

        move_params.x2 = move_params.x0 + x * 10
        move_params.y2 = move_params.y0 + y * 10
    end
}

local MISSILE_ON_UPDATE = {
    [MISSILE_MOVE_TYPE.LINE] = function (missile, dt)
        local pos = missile.pos
        if missile.lock_dir then
            pos.y = pos.y + missile.v_missile_speed * dt
        else
            local params = missile.move_params
            pos.y = pos.y + missile.v_missile_speed * dt * params.move_y
            pos.x = pos.x + missile.v_missile_speed * dt * params.move_x
        end
        missile:set_pos(pos.x, pos.y)
    end,

    [MISSILE_MOVE_TYPE.BEZIER] = function (missile, dt)
        local params = missile.move_params
        local pos = missile.pos
        pos.x, pos.y = Util.bezier(params.x0, params.y0, params.x1, params.y1, params.x2, params.y2, missile.live_time / missile.max_live_time)
        missile:set_pos(pos.x, pos.y)
    end
}

function M:_init(cfg, shoter)
    Base._init(self, cfg)
    self.transform = self.gameobj.transform
    self:set_pos(0, 0)
    self.pos.z = self.pos.z - 1
    
    local collide2d = self.gameobj:GetComponent(typeof(UnityCollider2D))
    collide2d.isTrigger = true
    self.gameobj:SetActive(false)
    self.transform:SetParent(shoter.transform)
    self.shoter = shoter
    self.move_type = cfg.move_type or 1
    self.move_params = {}
    self.max_live_time = cfg.max_live_time or 1
    self.v_missile_speed = cfg.speed
end

function M:on_shot()
    self.gameobj:SetActive(true)
    local pos = self.shoter.pos
    self:set_pos(pos.x, pos.y)
    CompExtention.SetEulerZ(self.transform, self.shoter:get_face_deg())
    self.live_time = 0
    self.shouted = true

    MISSILE_ON_SHOT[self.move_type](self)
end

function M:on_update(dt)
    Base.on_update(self, dt)

    if not self.shouted then return end

    self.live_time = self.live_time + dt

    MISSILE_ON_UPDATE[self.move_type](self, dt)
    -- stop missile
    if self.live_time >= self.max_live_time then
        self:stop()
    end
end

function M:stop()
    self.shouted = false
    self.gameobj:SetActive(false)
end

function M:is_missile()

end

function M:attack(obj)
    --test
    if obj ~= self.shoter and not obj.is_missile then
        self:stop()
        
        if self.shoter.on_missile_hit then
            self.shoter.on_missile_hit()
        end

        if obj.on_beattack then
            obj:on_beattack()
        end
    end
end

function M:on_collide_wall()
    self:stop()
end

return M