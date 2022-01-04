local M = Util.create_class()
local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode
local deg2rad = math.rad(1)

function M:_init(entity) 
    self.v_gameobj = entity.gameobj
    self.entity = entity
    self.transform = self.v_gameobj.transform

    self.v_cam = UnityGameObject.Find("Main Camera")
    self.v_dir_obj = Util.get_4_dir_obj(self.v_gameobj) or Util.get_dir_obj(self.v_gameobj)


    self.v_rb = Util.get_rb(self.v_gameobj)
    self.v_rb.gravityScale = 0

    -- 移动方向
    self.v_move_dir = 0
    -- 转向
    self.v_trun = 0
    -- 推力
    self.v_push_pow = 0

    self.v_speed = 0
    -- 摩擦
    self.v_friction = 0
end


local KEYMAP = {
    [KeyCode.W] = function (self)
        self.v_push_pow = 1
    end,

    [KeyCode.S] = function (self)
        self.v_push_pow = -1
    end,

    [KeyCode.A] = function (self)
        self.v_trun = 1
    end,

    [KeyCode.D] = function (self)
        self.v_trun = -1
    end,
}

function M:get_input()
    self.v_push_pow = 0
    self.v_trun = 0
    for k, func in pairs(KEYMAP) do
        if Input.GetKey(k) then
            func(self)
        end
    end
end

function M:on_update()
    self:get_input()
end

local lerp = function(x, y, t)
    return x + t * (y - x)
end

local temp_pos = {}
function M:on_fixed_update()
    self.v_move_dir = (self.v_move_dir + self.v_trun * 10) % 360
    self.v_move_dir = lerp(self.v_move_dir, 45 * math.floor(self.v_move_dir / 45 + 0.5), 0.12)

    self.v_speed = math.min(self.v_speed + self.v_push_pow * 0.1, 3)
    if self.v_speed > 0 then
        self.v_speed = self.v_speed - 0.05
    elseif self.v_speed < 0 then
        self.v_speed = self.v_speed + 0.05
    end

    temp_pos.x, temp_pos.y = self.entity:get_pos2()
    local pos = temp_pos
    local deg = self.v_move_dir + 90
    pos.x = pos.x + self.v_speed * math.cos(deg * deg2rad) * 0.02
    pos.y = pos.y + self.v_speed * math.sin(deg * deg2rad) * 0.02
    self.v_dir_obj.Dir = self.v_move_dir + 180
    CompExtention.SetPosA(self.transform, pos.x, pos.y, pos.z)
end

return M