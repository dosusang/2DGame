local assert = assert
local error  = error
local print = print
local tconcat = table.concat
local tinsert = table.insert
local srep = string.rep
local type = type
local pairs = pairs
local tostring = tostring
local next = next
local UnityLog = CS.UnityEngine.Debug.Log
local UnityWarning = CS.UnityEngine.Debug.LogWarning
local UnityError = CS.UnityEngine.Debug.LogError
local UnityTime = CS.UnityEngine.Time
local Date = require "utils.date"

local logger = {}

-- public field
logger.NOLOG = 0
logger.DEBUG = 10
logger.INFO = 20
logger.WARNING = 30
logger.ERROR = 40
logger.CRITICAL = 50
logger.FATAL = 60

local log_level_desc = {
    [0]     = "N",
    [10]    = "D",
    [20]    = "I",
    [30]    = "W",
    [40]    = "E",
    [50]    = "C",
    [60]    = "F",
}

local function log_to_disk(name, modename, level, timestamp, msg, src)
    local s     =   string.format("[%s %s *%s*]%s %s", timestamp
                                , log_level_desc[level]
                                , name, src, msg)
    if level < 30 then
        UnityLog(s)
    elseif level == 30 then
        UnityWarning(s)
    else
        UnityError(s)
    end
end

local function dump_log_to_disk(t)
    for i=1,#t do
		log_to_disk(table.unpack(t[i]))
    end
end

--
-- log helper fun
--

local function get_log_src(level)
    local info = debug.getinfo(level+1, "Sl")
    local src = info.source
    return src .. ":" .. info.currentline .. ":"
end

local starttime = Date.now()

local function log_timestamp(timestamp)
    timestamp = timestamp + starttime
    local sec = math.floor(timestamp )
	local ms  = math.floor((timestamp - sec) * 100)
	local f = os.date("%Y-%m-%d %H:%M:%S", sec)
	f = string.format("%s.%02d", f, ms)
	return f
end

local function tokey(key)
    if type(key) == "number" then 
        return string.format("[%s]", tostring(key))
    else 
        return string.format("%s", tostring(key))
    end
end

local function tovalue(v)
    if type(v) == "number" then 
        return string.format("%s", tostring(v))
    elseif type(v) == "boolean" then
        return string.format("%s", tostring(v))
    else
        return string.format("\"%s\"", tostring(v))
    end
end

local function table_serialize(root)
    local cache = {  [root] = "." }
    local function _dump(t,space,name)
        local temp = {}
        for k,v in pairs(t) do
			local key = tostring(k)

			if cache[v] then
				tinsert(temp,space .. key .. " {" .. cache[v].."}")

			elseif type(v) == "table" then
				local new_key = name .. "." .. key
				cache[v] = new_key

                local key_str = tokey(k) 

                tinsert(temp, space..key_str .. " = {")
                if next(v) then
                    tinsert(temp, _dump(v, space .. "    ", new_key))
                end
                tinsert(temp, space .. "},")
            else
                tinsert(temp, space .. tokey(k) .. " = " .. tovalue(v) .. ",")
            end
        end
        return tconcat(temp,"\n")
    end
	return "{\n" .. _dump(root, "    ","") .. "\n}"
end

local function log_format(level, ...)
    local t = {...}
    local out = nil

    local last_is_table = nil

    local v_str
    for _,v in pairs(t) do
        local is_table = (type(v) == "table")

        if is_table then
            v_str =  table_serialize(v)
        else
            v_str = tostring(v)
        end

        if out == nil then
            if not is_table then
                out = v_str
            else
                out = "\n"..v_str
            end
        else
            if last_is_table or is_table then
                out = string.format("%s\n%s", out, v_str)
            else
                out = string.format("%s   %s", out, v_str)
            end
        end

        last_is_table = is_table
    end
    return out
end

local function tag_table_to_tags(tag_table)
    if tag_table and next(tag_table) then
        local tags = {}
        for k,v in pairs(tag_table) do
            tags[#tags + 1] = k..":"..v
        end
        return tags
    end
end
--
-- end log helper fun
--

--
-- dump list mgr
--
local function _lnew(n)
    local l = {}
    l.tail = 1
    l.len = n
    return l
end

local function _lreset(l)
    l.tail = 1
    return l
end

local function _lpush(l,...)
    l[l.tail] = {...}
    l[l.tail - l.len] = nil
    l.tail = l.tail + 1
end

local function _lempty(l)
    return l.tail == 1
end

local function _lrange(l)
    if l.tail <= l.len then
        return 1, l.tail-1
    end

    return l.tail - l.len, l.tail-1
end

--
-- end dump list mgr
--

function logger:cache(...)
    _lpush(self.dump_list,...)
end

-- 构造符合 lualog 次序的 message, 由 pack_log_message 使用
function logger:get_log_message(level, timestamp, src, ...)
    local msg = log_format(level, ...)
    local modname = self.module_name or self.default_module_name
    local name = self.logger_name or modname
    timestamp = log_timestamp(timestamp)
    return name, modname, level, timestamp,msg, src
end

function logger:dump()
    if _lempty(self.dump_list) then
        return
    end

    local head, tail = _lrange(self.dump_list)

    local log_message_list = {}
    for i= head,tail do
        log_message_list[#log_message_list + 1] = {self:get_log_message(table.unpack(self.dump_list[i]))}
    end
    dump_log_to_disk(log_message_list)
    _lreset(self.dump_list)
end

function logger:log_i(...)
    log_to_disk(self:get_log_message(...))
end

function logger:log(level, ...)
    -- 过滤掉信息的条件：未设置dump_level，且level低于log_level
    if self.dump_level == logger.NOLOG and level < self.log_level then
        return
    end

    local timestamp = UnityTime.realtimeSinceStartup 
    local src = self.log_src and get_log_src(self.stack_level) or ''

    if level < self.log_level then  -- 低于记录级别, 缓存
        self:cache(level, timestamp, src, ...)
    else
        self:log_i(level, timestamp, src, ...) -- 低于dump级别，直接记录
        if self.dump_level ~= logger.NOLOG and level >= self.dump_level then -- dump缓存
            self:dump()
        end
    end
end

--
-- public interface
--
function logger:Debug(...)
    self:log(logger.DEBUG, ...)
end
function logger:Debugf(format, ...)
   self:log(logger.DEBUG, string.format(format, ...))
end

function logger:Info(...)
   self:log(logger.INFO, ...)
end
function logger:Infof(format, ...)
    self:log(logger.INFO, string.format(format, ...))
end

function logger:Warning(...)
    self:log(logger.WARNING, ...)
end
function logger:Warningf(format, ...)
    self:log(logger.WARNING, string.format(format,...))
end

function logger:Error(...)
    self:log(logger.ERROR, ...)
end
function logger:Errorf(format, ...)
    self:log(logger.ERROR, string.format(format,...))
end

function logger:Critical(...)
    self:log(logger.CRITICAL, ...)
end
function logger:Criticalf(format, ...)
    self:log(logger.CRITICAL, string.format(format,...))
end

function logger:Fatal(...)
    self:log(logger.FATAL, ...)
end

function logger:Fatalf(format, ...)
    self:log(logger.FATAL, string.format(format,...))
end

function logger:Assert(v, message)
    if not v then
        self:log(logger.ERROR, "assert:"..tostring(message))
    end
    return assert(v, message)
end

function logger:SError(message, level)
    level = level and level+1 or 2
    self:log(logger.CRITICAL, "error:" .. tostring(message))
    error(message, level)
end

function logger:Tag(key, value)
    self.tag_table[key] = value
    self.tags = tag_table_to_tags(self.tag_table)
end

function logger:Untag(key)
    self.tag_table[key]=nil
    self.tags = tag_table_to_tags(self.tag_table)
end

function logger:set_modname(name)
    self.module_name = name
end

function logger:config(t)
    if t["name"] ~= nil then
        self.logger_name = t["name"]
    end

    if t["module_name"] ~= nil then
        self.module_name = t["module_name"]
    end

    if t["to_screen"] ~= nil then
        self.to_screen = t["to_screen"]
    end

    if t["level"] ~= nil then
        self.log_level = t["level"]
    end

    if t["log_src"] ~= nil then
        self.log_src = t["log_src"]
    end

    if t["dump_level"] ~= nil then
        self.dump_level = t["dump_level"]
    end

    if self.dump_level ~= logger.NOLOG then
        assert(self.dump_level > self.log_level)
    end
end

function logger:new()
    -- private field
    local obj = {}
    obj.default_module_name = "mz"
    obj.logger_name = nil
    obj.module_name = nil
    obj.to_screen = true
    obj.log_level = logger.NOLOG
    obj.log_src = true
    obj.dump_level = logger.NOLOG
    obj.dump_num = 100
    self.dump_list = _lnew(obj.dump_num)
    obj.tag_table = {}
    obj.tags = nil
    obj.stack_level = 3

    setmetatable(obj, logger)
    logger.__index = logger
    return obj
end

return logger

