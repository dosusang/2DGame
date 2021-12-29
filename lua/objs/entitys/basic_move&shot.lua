local Base = require("objs.entitys.base_obj")
local M = Util.extend_class(Base)

function M:_init(cfg)
    Base._init(self, cfg)

    self:add_component(require("objs.components.player_ctrl"), "ctrler")

    if cfg.gun then
        self:add_component(require("objs.components.gun"), "gun", cfg.gun)
    end
end

function M:die()
    Base.on_destory(self)
end

function M:get_face_vec2()
    return self.ctrler:get_face_vec2()
end

function M:get_face_rad()
    return self.ctrler:get_face_rad()
end

function M:get_face_deg()
    return self.ctrler:get_face_deg()
end

return M