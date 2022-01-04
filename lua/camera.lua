local M = Util.create_class()
M.cam_range_x = {-2.6, 2.6}
M.cam_range_y = {-37, 37}

function M:_init()
    self.cam_obj = UnityGameObject.Find("Main Camera")
    self.pos_x = 0
    self.pos_y = 0
end

function M:on_update()
    if Global.hero and not Global.hero.is_destroyed then
        local posx, posy =  Global.hero:get_pos2()
        self.pos_x = Util.lerp(self.pos_x, posx, 0.05)
        self.pos_y = Util.lerp(self.pos_y, posy, 0.05)
        self:set_cam_pos()
    end
end

function M:set_cam_pos()
    self.pos_x = Util.clamp(self.pos_x, M.cam_range_x[1], M.cam_range_x[2])
    self.pos_y = Util.clamp(self.pos_y, M.cam_range_y[1], M.cam_range_y[2])
    self.cam_obj.transform.position = {x = self.pos_x, y = self.pos_y, z = -10}
end

return M