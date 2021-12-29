local Base = require("objs.entitys.base_obj")
local M = Util.extend_class(Base)

function M:_init(cfg)
    Base._init(cfg)
    self:add_component(require("objs.components.player_ctrl_justgo"), "ctrler")
end

return M