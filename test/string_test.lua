package.path = package.path .. ";../?.lua;../src/?.lua"

local runScript, Redis = require("redis-mock")()
require "busted"

-- Verbose mode
-- RedisLua_VERBOSE = true

local r = nil
describe("RedisDb String", function()
  before_each(function()
    -- RedisDb Mock instance
    r = Redis()
  end)

  it("should support set/get", function()
    assert.are.same(r.db:get("myKey"), false)
    -- Setup
    r.db:set("myKey", "ok")

    -- Test
    assert.are.same(r.db:get("myKey"), "ok")
  end)

  -- it("should support del", function()
  --   assert.are.same(r.db:get("myKey"), false)
  --   -- Setup
  --   r.db:set("myKey", "ok")
  --   r.db:del("myKey")

  --   -- Test
  --   assert.are.same(r.db:exist("myKey"), false)
  -- end)
end)