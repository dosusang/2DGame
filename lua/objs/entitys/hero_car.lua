local Base = require("objs.entitys.base_obj")
local M = Util.extend_class(Base)

function M:_init(name, obj)
    Base:_init(name, obj)
    self:add_component("objs.components.player_ctrl_justgo", "ctrler")
    self:add_component("objs.components.gun", "gun")
end

return M