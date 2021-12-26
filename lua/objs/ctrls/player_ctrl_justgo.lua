local M = Util.create_class()
local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode
local deg2rad = math.rad(1)
local rad2deg = math.deg(1)
local HALF_PI = math.pi / 2
local TIME = CS.UnityEngine.Time

function M:_init(name, obj) 
    self.v_name = name
    self.v_gameobj = obj
    self.transform = obj.transform

    self.v_cam = UnityGameObject.Find("Main Camera")
    self.v_dir_obj = Util.get_dir_obj(obj)

    self.v_rb = Util.get_rb(obj)
    self.v_rb.gravityScale = 0

    self.v_cx = 0
    self.v_cy = 0
    self.v_move_dir_rad = 0
    self.v_speed = 5
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
    local pos = self.transform.position
    local rad = self.v_move_dir_rad
    pos.x = pos.x + self.v_speed * math.cos(rad) * dt
    pos.y = pos.y + self.v_speed * math.sin(rad) * dt
    self.v_dir_obj.MoveDir = (self.v_move_dir_rad + HALF_PI) * rad2deg

    if TIME.frameCount%16 == 0 then
        pos.y = pos.y + 0.05
    elseif TIME.frameCount%16 == 8 then
        pos.y = pos.y - 0.05
    end
  
    self.transform.position = pos
end

function M:on_update()

    self:get_input()
    self:move()
end

local lerp = function(x, y, t)
    return x + t * (y - x)
end

function M:on_fixed_update()

end

return M