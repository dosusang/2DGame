local Logger = require "utils.logger"

local l = Logger:new()
l.stack_level = l.stack_level + 1

local logging = {}

logging.NOLOG = l.NOLOG
logging.DEBUG = l.DEBUG
logging.INFO = l.INFO
logging.WARNING = l.WARNING
logging.ERROR = l.ERROR
logging.CRITICAL = l.CRITICAL
logging.FATAL = l.FATAL
-- 
-- public interface
--

function logging.DebugHero(char, ...)
    if char:is_hero() then
        logging.Debug(...)
    end
end

function logging.DebugMonster(char, ...)
    if char:is_monster() then
        logging.Debug(...)
    end
end

function logging.DebugPlayer(char, ...)
    if char:is_player() then
        logging.Debug(...)
    end
end

function logging.Debug(...)
	if UNITY_EDITOR then
		l:Debug(...) 
	end
end

function logging.Debugf(format, ...)
	if UNITY_EDITOR then
		l:Debugf(format, ...)
	end
end

function logging.Info(...)
    l:Info(...)
end
function logging.Infof(format, ...)
    l:Infof(format, ...)
end

function logging.Warning(...)
    l:Warning(...)
end
function logging.Warningf(format, ...)
    l:Warningf(format, ...)
end

function logging.Error(...)
    l:Error(...)
end
function logging.Errorf(format, ...)
    l:Errorf(format, ...)
end

function logging.Critical(...)
    l:Critical(...)
end
function logging.Criticalf(format, ...)
    l:Criticalf(format, ...)
end

function logging.Fatal(...)
    l:Fatal(...)
end

function logging.Fatalf(format, ...)
    l:Fatalf(format,...)
end

function logging.Assert(v, message)
    return l:Assert(v,message)
end

function logging.SError(message, level)
    level = level and level+1 or 2
    return l:SError(message, level) 
end

function logging.Tag(key, value)
    l:Tag(key,value)
end

function logging.Untag(key)
    l:Untag(key)
end

function logging.set_modname(name)
    l:set_modname(name)
end

function logging.config(t)
    l:config(t)
end



return logging

