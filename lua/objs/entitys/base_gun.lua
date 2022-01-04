local Base = require("objs.entitys.base_obj")
local M = Util.extend_class(Base)
local deg2rad = math.deg(1)
local HALF_PI = math.pi / 2

function M:_init(cfg)
    Base._init(self, cfg)
    self:add_component(require("objs.components.gun"), "gun", cfg.gun)
    self.gun_obj = self.transform:GetChild(0).gameObject
    self.v_cur_rad = 0
    self.v_cur_deg = 0
end

function M:on_update(dt)
    Base.on_update(self, dt)

    if self:get_dist_sqrt(Global.hero) <= 20 then
        self.gun.just_shot = true
        local tar_rad = self:get_faceto_obj_rad(Global.hero)
        self.v_cur_rad = Util.lerp_rad(self.v_cur_rad, tar_rad, 0.05)
    else
        self.gun.just_shot = false
        self.v_cur_rad = Util.lerp_rad(self.v_cur_rad, -HALF_PI, 0.1)
    end
    
    self.v_cur_deg = deg2rad * self.v_cur_rad
    Util.set_eulerz(self.gun_obj, self.v_cur_deg + 90)
end


function M:get_face_vec2()
    return math.cos(self.v_cur_rad), math.sin(self.v_cur_rad)
end

function M:get_face_deg()
    return self.v_cur_deg
end

function M:get_face_rad()
    return self.v_cur_rad
end

return M