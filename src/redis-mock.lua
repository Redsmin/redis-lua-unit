local lfs    = require "lfs"

-- package.path = package.path .. ";../?.lua;../src/?.lua"

Redis        = require("/RedisLua")

-- Runscript
runScript = function(arg)
  -- quick&dirty find a way to explain keys & redis in their own context
  KEYS = arg.KEYS
  redis = arg.redis
  local f = assert(loadfile(lfs.currentdir() .. "/" .. arg.filename))
  return f()
end
