local UnityTime = CS.UnityEngine.Time

local M = {}

local _floor = math.floor

local SERVER_TO_CLIENT_OFFSET = 0    --- 服务器时间和客户端时间间隔
local SERVER_TO_UNITY_OFFSET = 0     --- 服务器时间和Unity时间间隔
local LAST_SYNC_TIME = 0             --- 上一次同步服务器时间
local SYNC_INTERVAL = 5              --- 同步时间间隔

local MINUTE_SEC = 60 
local HOUR_SEC = MINUTE_SEC * 60
local DAY_SEC =  HOUR_SEC * 24

local today = os.date("*t", os.time())
today.hour = 0
today.sec = 0
today.sec = 0

M.TODAY_SEC = os.time(today)
M.TODAY_DATE = today

local _os_date = os.date
local _os_time = os.time

function M.now()
	-- TODO: DIFF TIME
	return os.time()
end

function M.server_time()
    return os.time() + SERVER_TO_CLIENT_OFFSET
end

function M.adjust_server_time_offset(time)
	if time - LAST_SYNC_TIME < SYNC_INTERVAL then   --- 间隔5秒同步一下时间
		return
	end
	LAST_SYNC_TIME = time
    SERVER_TO_CLIENT_OFFSET = time - M.now()
    SERVER_TO_UNITY_OFFSET = M.server_time() - UnityTime.time
end

function M.ajust_server_latency(latency)
    SERVER_TO_CLIENT_OFFSET = SERVER_TO_CLIENT_OFFSET + latency
    SERVER_TO_UNITY_OFFSET = SERVER_TO_UNITY_OFFSET + latency
end

function M.standard_data(time)
	return os.date("%m-%d %H:%M" ,time)
end

function M.time()
    return Global.time 
end

function M.server_unity_time()
    return Global.time + SERVER_TO_UNITY_OFFSET
end

function M.delta_time()
    return Global.delta_time
end

function M.real_time()
	return Global.real_time
end

--在线状态文本
function M.to_offline_time_text(leave_time)
	if leave_time == 0 then
		return "在线"	
	end

	--[[
	local server_time = M.server_time()
	
	assert(server_time > leave_time)

	local now_date = os.date("*t", server_time)
	local leave_date = os.date("*t", leave_time)

	if now_date.year ~= leave_date.year then
		return "1年前"
	else now_date.month ~= leave_date.month then
		return "n月前"
	else 
	]]

	return "离线"
end

--剩余时间文本
function M.to_leave_cd_text()

end

function M.get_time_tbl()
	local server_time = math.floor(M.server_time())
	return os.date("*t", server_time)
end

function M.get_print_count_down(sec)
    if sec > HOUR_SEC then  
        return string.format("%02d:%02d:%02d", _floor(sec/HOUR_SEC), _floor((sec%HOUR_SEC)/MINUTE_SEC), _floor(sec%MINUTE_SEC))
    else
        return string.format("%02d:%02d", _floor(sec/MINUTE_SEC), _floor(sec%MINUTE_SEC))
    end
end

function M.get_long_count_down(sec)
        return string.format("%02d:%02d:%02d", _floor(sec/HOUR_SEC), _floor((sec%HOUR_SEC)/MINUTE_SEC), _floor(sec%MINUTE_SEC))
end

--[[
	create_time 创建时间戳
	duration 持续时间戳
	now_time 现在的时间戳
]]
function M.get_day_desc(create_time, duration, now_time)
	local end_time = create_time + duration
	local remain_time = end_time - now_time
	local day = math.modf(remain_time / DAY_SEC)
	return day
end

function M.get_time_desc(seconds, not_show_second)
	local day = math.modf(seconds/DAY_SEC)
	if day > 0 then 
		local hours = math.modf(math.fmod(seconds, DAY_SEC)/HOUR_SEC)
		return Util.format_str("{1}天{2}时", day, hours)
	end

	local hours = math.modf(seconds/HOUR_SEC)
	if hours > 0 then 
		local mins = math.modf(math.fmod(seconds, HOUR_SEC)/MINUTE_SEC)
		return Util.format_str("{1}时{2}分", hours, mins)
	end

	local mins = math.modf(seconds/MINUTE_SEC)
	local secs = math.modf(math.fmod(seconds, MINUTE_SEC))
	if not not_show_second then
		if mins > 0 then
			return Util.format_str("{1}分{2}秒", mins, secs)
		else
			return Util.format_str("{1}秒", secs)
		end
	else
		if mins > 0 then
			return Util.format_str("{1}分", mins)
		else
			return Util.format_str("1分")
		end
	end
	
end

-- 展示单位 分，时，天，月
function M.get_time_desc2(seconds)
	local day = math.modf(seconds/DAY_SEC)
	if day > 0 then 
		return Util.format_str("{1}天", day)
	end

	local hours = math.modf(seconds/HOUR_SEC)
	if hours > 0 then 
		return Util.format_str("{1}小时", hours)
	end

	local mins = math.modf(seconds/MINUTE_SEC)
	if mins > 0 then
		return Util.format_str("{1}分钟", mins)
	else
		return Util.format_str("1分钟")
	end
end

------ 返回 XX天xx时XX分
function M.get_time_formate_1(seconds)
	local day = math.modf(seconds/DAY_SEC)
	local hours = math.modf(math.fmod(seconds, DAY_SEC)/HOUR_SEC)
	local mins = math.modf(math.fmod(seconds, HOUR_SEC)/MINUTE_SEC)
	return Util.format_str("{1}天{2}时{3}分", day, hours,mins)
end

function M.get_next_month_time(now, day, hour)
    local t = _os_date("*t", now)

   	if t.day > day then
   		t.month = t.month + 1
   	elseif t.day == day then
   		if t.hour > hour then
   			t.month = t.month + 1
   		end
   	end  

   	t.day = day
    t.hour = hour
    t.min, t.sec = 0, 0

    return _os_time(t) 
end


return M

