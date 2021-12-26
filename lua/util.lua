local M = {}
local rad2deg = math.deg(1)

local function basic_new_funciton(class, ...)
    local obj = setmetatable({}, class)
    obj:_init(...)
    return obj
end

local function basic_delete_func(obj)
    
end

M.create_class = function()
    local class = {}
    class.__index = class
    class.new = basic_new_funciton
    return class
end

M.extend_class = function(base)
   local child = setmetatable({}, base)
   child.__index = child
   return child
end

M.get_rb = function (gameobj)
    return gameobj:GetComponent(typeof(UnityRb2D))
end

M.get_dir_obj = function (gameobj)
    return gameobj:GetComponent(typeof(UnityDirObj))
end

M.get_angle2A = function(x, y)
    if x == 0 and y == 0 then
        return 
    end

    local l = x*x + y*y
    x = x/l
    y = y/l
    return math.atan(y, x) * rad2deg
end

function M.lerp_angle(a1, a2, p)
	if p > 1 then
		p = 1
	end

	return a1 + ((a2 - a1 + 180) % 360 - 180) * p
end

return M