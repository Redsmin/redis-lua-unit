--- Original version from https://github.com/catwell/cw-lua/tree/master/fakeredis by Pierre Chapuis

-- RedisDb mock
local db = {}

RedisDb_VERBOSE = false

--- Helpers
local xgetr = function(self,k,ktype)
  if self[k] then
    assert(self[k].ktype == ktype)
    assert(self[k].value)
    return self[k].value
  else return {} end
end

local xgetw = function(self,k,ktype)
  if self[k] and self[k].value then
    assert(self[k].ktype == ktype)
  else
    self[k] = {ktype=ktype,value={}}
  end
  return self[k].value
end

local empty = function(self,k)
  return #self[k].value == 0
end

-- first parameter is the self, then the command name, then option arguments
-- last parameter is the returned value
-- printCmd(self, cmd, [optional arguments], returnValue)
local printCmd = function(self, cmd, ...)
  local args = {...}

  if(#args == 0) then
    args = {}
  end

  local returnValue = args[#args]

  if RedisDb_VERBOSE then
    print(cmd .. "(" .. table.concat(args, ", ", 1, #args-1) .. ") === " .. tostring(returnValue))
  end

  return returnValue
end

--- Commands

-- keys
local del = function(self,...)
  local arg = {...}
  assert(#arg > 0)
  local r = 0
  for i=1,#arg do
    if self[arg[i]] then r = r + 1 end
    self[arg[i]] = nil
  end
  return r
end

local exists = function(self,key)
  local returnValue = not not self[key]

  return printCmd(self, 'exists', key, returnValue)
end

local _type = function(self,k)
  return (self[k] and self[k].ktype) and self[k].ktype or "none"
end

local expire = function(self, key, seconds)
  if(not self.exists(self, key)) then return printCmd(self, 'expire', key, seconds, false) end

  self[key].expire = seconds
  return printCmd(self, 'expire', key, seconds, true)
end

-- Integer reply: TTL in seconds or -1 when key does not exist or does not have a timeout.
local ttl = function(self, key)
  if(not self.exists(self, key) or not self[key].expire) then return printCmd(self, 'ttl', key, false) end

  local returnValue = self[key].expire

  return printCmd(self, 'ttl', key, returnValue)
end

-- strings

local get = function(self,key)
  local x = xgetr(self, key, "string")
  local returnValue = x[1]
  print("returnValue", returnValue)
  return printCmd(self, 'get', key, returnValue or false)
end

local set = function(self, key, v)
  assert(type(v) == "string")
  self[key] = {ktype="string",value={v}}
  return printCmd(self, 'set', key, v, true)
end

local strlen = function(self,k)
  local x = xgetr(self,k,"string")
  return x[1] and #x[1] or 0
end

-- hashes

local hdel = function(self,k,...)
  local arg = {...}
  assert(#arg > 0)
  local r = 0
  local x = xgetw(self,k,"hash")
  for i=1,#arg do
    assert((type(arg[i]) == "string"))
    if x[arg[i]] then r = r + 1 end
    x[arg[i]] = nil
  end
  if empty(self,k) then self[k] = nil end
  return r
end

local hget
local hexists = function(self,k,k2)
  return not not hget(self,k,k2)
end

hget = function(self,k,k2)
  assert((type(k2) == "string"))
  local x = xgetr(self,k,"hash")
  return x[k2]
end

local hset = function(self,k,k2,v)
  assert((type(k2) == "string") and (type(v) == "string"))
  local x = xgetw(self,k,"hash")
  x[k2] = v
  return true
end

-- sorted set

local zadd = function(self, key, ...)
  local args = {...}
  assert(#args > 0)

  -- create the sorted set if it doesn't not exist
  if(not exists(self, key)) then
    self[key] = {ktype="zset",value={}}
  end

  local ret = 0

  for i=1,#args, 2 do
    local score = tonumber(args[i])
    local member = tostring(args[i+1])

    assert(type(score) == "number", "Score must be a number")
    assert(type(member) == "string", "Member must be a number")

    if(not self[key].value[member]) then
      self[key].value[member] = score
      ret = ret + 1
    else
      self[key].value[member] = score + self[key].value[member]
    end

    table.sort(self[key].value)
  end

  return ret
end

-- connection
local echo = function(self,v)
  assert(type(v) == "string")
  return v
end

local ping = function(self)
  return "PONG"
end

-- server

local flushdb = function(self)
  for k,_ in pairs(self) do self[k] = nil end
  return true
end

local methods = {
  -- keys
  del      = del,
  exists   = exists,
  expire   = expire,
  ttl      = ttl,
  ["type"] = _type,
  -- strings
  get      = get,
  set      = set,
  strlen   = strlen,
  -- hashes
  hdel     = hdel,
  hexists  = hexists,
  hget     = hget,
  hset     = hset,
  -- sorted set
  zadd     = zadd,
  -- connection
  echo     = echo,
  ping     = ping,
  -- server
  flushall = flushdb,
  flushdb  = flushdb
}

-- Constructor
local function RedisDb()
  local obj = {}
  return setmetatable(obj,{__index = methods})
end

return RedisDb