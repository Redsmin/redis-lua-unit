local lfs       = require "lfs"
local Redis     = require("/RedisLua")

package.path = package.path .. ";../?.lua;../src/?.lua"

-- Runscript
local runScript = function(args)
  assert(type(args) == "table",  "Call runScript with a table like this: runScript {filename=\"/my/script.lua\", redis=redis, KEYS=KEYS}")

  -- quick&dirty find a way to provide keys & redis inside their own context
  KEYS = args.KEYS
  redis = args.redis
  local f = assert(loadfile(lfs.currentdir() .. "/" .. args.filename), "Couldn't load ".. lfs.currentdir() .. "/" .. args.filename)
  return f()
end

return (function()
  return runScript, Redis
end)