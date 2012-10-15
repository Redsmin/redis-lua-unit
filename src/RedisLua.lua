-- RedisLua.lua
-- Mock the "redis" object available from the LUA Script

-- Methods container
local _Redis = {}

-- Redis LUA methods
local call = function(self)
  return (function(cmd, ...)
    cmd = string.lower(cmd)

    local arg = {...}

    if(not self.db[cmd]) then
      print("[", cmd, "] Unimplemented, we accept pull-requests http://bit.ly/QGf8wB !")
      print("[", cmd, "] Unimplemented, returning true")
      return true
    end

    local ret = self.db[cmd](self.db, unpack(arg))

    if self.RedisLua_VERBOSE then
      print(cmd .. "( " .. table.concat(arg, " ") .. " ) === ".. tostring(ret))
    end

    return ret
  end)
end

local pcall = function(self)
  -- @todo better version
  return call(self)
end


local sha1hex = function(self)
  return (function(arg)
    -- @todo implement sha1hex
    return (args or "sha1hex")
  end)
end

local RedisDb  = require("/RedisDb")

-- Constructor
local function RedisLua()
  local obj = {}
  obj.db = RedisDb()
  obj.RedisLua_VERBOSE = false
  obj.call    = call(obj)
  obj.pcall   = pcall(obj)
  obj.sha1hex = sha1hex(obj)
  return obj
end

return RedisLua