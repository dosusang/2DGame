local M = Util.create_class()
local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode
local deg2rad = math.rad(1)
local rad2deg = math.deg(1)
local HALF_PI = math.pi / 2
local TIME = CS.UnityEngine.Time

function M:_init(entity) 
    self.v_gameobj = entity.gameobj
    self.transform = self.v_gameobj.transform
    self.entity = entity
    self.v_cam = UnityGameObject.Find("Main Camera")
    -- if entity.cfg.dirs == 4 then
    self.v_dir_obj = Util.get_4_dir_obj(self.v_gameobj) or  Util.get_dir_obj(self.v_gameobj)
    -- else
        -- self.v_dir_obj = Util.get_dir_obj(self.v_gameobj)
    -- end

    self.v_rb = Util.get_rb(self.v_gameobj)
    self.v_rb.gravityScale = 0

    self.v_cx = 0
    self.v_cy = 0
    self.v_move_dir_rad = 0
    self.v_speed = entity.cfg.speed or 2
end


local KEYMAP = {
    [KeyCode.W] = function (self)
        self.v_cy = 1
    end,

    [KeyCode.S] = function (self)
        self.v_cy = -1
    end,

    [KeyCode.A] = function (self)
        self.v_cx = -1
    end,

    [KeyCode.D] = function (self)
        self.v_cx = 1
    end,
}

function M:get_input()
    self.v_cx = 0
    self.v_cy = 0
    for k, func in pairs(KEYMAP) do
        if Input.GetKey(k) then
            func(self)
        end
    end
end

function M:move()
    local cur_deg = Util.get_angle2A(self.v_cx, self.v_cy)
    if not cur_deg then
        return
    end
    local dt = TIME.deltaTime

    local cur_move_dir = self.v_dir_obj.MoveDir
    local cur_show_dir = self.v_dir_obj.Dir
    self.v_dir_obj.Dir = Util.lerp_angle(cur_show_dir, cur_move_dir, 0.1) % 360

    self.v_move_dir_rad = cur_deg * deg2rad
    local pos = self.entity.pos
    pos.x, pos.y, _ = self.transform:GetPosA()
    
    local rad = self.v_move_dir_rad
    pos.x = pos.x + self.v_speed * math.cos(rad) * dt
    pos.y = pos.y + self.v_speed * math.sin(rad) * dt
    self.v_dir_obj.MoveDir = (self.v_move_dir_rad + HALF_PI) * rad2deg

    if TIME.frameCount%16 == 0 then
        pos.y = pos.y + 0.03
    elseif TIME.frameCount%16 == 8 then
        pos.y = pos.y - 0.03
    end
    
    self.entity:set_pos(pos.x, pos.y)
end

function M:on_update()
    self:get_input()
    self:move()
end

function M:on_fixed_update()

end

function M:get_face_vec2()
    local rad = self.v_move_dir_rad
    return math.cos(rad),  math.sin(rad)
end

function M:get_face_rad()
    return self.v_move_dir_rad
end

function M:get_face_deg()
    return self.v_move_dir_rad * rad2deg
end

return M