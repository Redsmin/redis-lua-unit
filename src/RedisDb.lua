-- RedisDb.lua
-- Mock the "redis" database commands
-- Original version from https://github.com/catwell/cw-lua/tree/master/fakeredis by Pierre Chapuis

-- RedisDb mock
local db = {}

local methods = {
  RedisDb_VERBOSE = true
}

--- internal
require("internals")(methods)

-- keys
require("commands/keys")(methods)

-- strings
require("commands/string")(methods)

-- hashes
require("commands/hash")(methods)

-- sorted set
require("commands/zset")(methods)

-- connection
require("commands/connection")(methods)

-- server
require("commands/server")(methods)

local inspect = require("inspect")

print(inspect(methods))

-- Constructor
local function RedisDb()
  local obj = {}
  return setmetatable(obj,{__index = methods})
end

return RedisDb