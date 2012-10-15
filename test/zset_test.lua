-- support relative path
package.path = package.path .. ";../?.lua;../src/?.lua"

local runScript, Redis = require("redis-mock")()
require "busted"

-- Verbose mode
-- RedisLua_VERBOSE = true
-- RedisDb_VERBOSE = true

local r = nil

describe("RedisDb Sorted set", function()
  describe("zadd", function()
    before_each(function()
      -- RedisDb Mock instance
      r = Redis()
    end)

    it("should return the number elements added to the sorted sets, not including elements already existing for which the score was updated.", function()
      -- Check
      assert.are.same(r.db:exists("myzset"), false)

      -- Setup
      local r1 = r.db:zadd("myzset", 10, "marc", 1, "paul", 9, "max", 3, "marie", 14, "jean")
      local ret = r.db:zrevrange("myzset", 0, -1, "WITHSCORES")

      -- Test
      assert.are.same(r1, 5)
      assert.are.same(ret, {{"jean" ,14},{"marc" ,10},{"max" ,9}, {"marie", 3},{"paul", 1}})
    end)
  end)

  describe("zrevrange", function()
    before_each(function()
      -- RedisDb Mock instance
      r = Redis()
    end)

    it("should return the specified range of elements (value) in the sorted set stored at key", function()
      -- Setup
      local r1 = r.db:zadd("myzset", 2, "two", 1, "one" , 10, "three")

      -- Test
      local ret = r.db:zrevrange("myzset", 0, -1)

      -- Check
      assert.are.same(ret, {"three", "two", "one"})
    end)

    it("should return the specified range of elements (key, value) in the sorted set stored at key", function()
      -- Setup
      local r1 = r.db:zadd("myzset", 2, "two", 1, "one" , 3, "three")

      -- Test
      local ret = r.db:zrevrange("myzset", 0, -1, 'WITHSCORES')

      -- Check
      assert.are.same(ret, {{"three", 3}, {"two", 2}, {"one", 1}})
    end)
  end)

  describe("zunionstore", function()
    before_each(function()
      -- RedisDb Mock instance
      r = Redis()
    end)

    it("should return the specified range of elements (value) in the sorted set stored at key", function()
      -- Setup
      r.db:zadd("myzset1", 10, "marc", 1, "paul", 8, "max", 3, "marie", 14, "jean")
      r.db:zadd("myzset2", 10, "silvia", 15, "manon", 9, "maxwell", 1, "marc")

      -- Test
      local ret = r.db:zunionstore("out", 2, "myzset1", "myzset2")
      local zset = r.db:zrevrange("out", 0, -1, 'WITHSCORES')

      -- Check
      assert.same(zset, { { "manon", 15 }, { "jean", 14 }, { "marc", 11 }, { "silvia", 10 }, { "maxwell", 9 }, { "max", 8 }, { "marie", 3 }, { "paul", 1 } })
    end)
  end)
end)