local lfs       = require "lfs"
local Redis     = require("/RedisLua")

package.path = package.path .. ";../?.lua;../src/?.lua"

-- Runscript
local runScript = function(args)
  assert(type(args)       == "table",  "Call runScript with a table like this: runScript {filename=\"/my/script.lua\", redis=redis, KEYS=KEYS}")
  assert(type(args.redis) == "table", "A instance of Redis() is required")

  -- quick&dirty find a way to provide keys & redis inside their own context
  redis = args.redis
  KEYS = args.KEYS or {}
  ARGV = args.ARGV or {}
  local f = assert(loadfile(lfs.currentdir() .. "/" .. args.filename), "Couldn't load ".. lfs.currentdir() .. "/" .. args.filename)
  return f()
end

return (function()
  return runScript, Redis
end)