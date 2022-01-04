local Base = require("objs.entitys.base_obj")
local M = Util.extend_class(Base)

function M:_init(cfg)
    Base._init(self, cfg)
end 

function M:on_beattack()
    local good = self.transform:Find("HouseGood")
    good.gameObject:SetActive(false)
end

return M