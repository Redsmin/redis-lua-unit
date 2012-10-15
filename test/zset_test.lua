-- support relative path
package.path = package.path .. ";../?.lua;../src/?.lua"

require "redis-mock"
require "busted"

-- Verbose mode
RedisLua_VERBOSE = true
RedisDb_VERBOSE = true

local r = nil

describe("RedisDb Sorted set", function()
  before_each(function()
    -- RedisDb Mock instance
    r = Redis()
  end)

  describe("zadd", function()
    it("should return the number elements added to the sorted sets, not including elements already existing for which the score was updated.", function()
      -- RedisDb Mock instance
      r = Redis()

      -- Check
      assert.are.same(r.db:exists("mySet"), false)

      -- Setup
      local r1 = r.db:zadd("b:nm:1350247717260", 10, "marc", 1, "paul", 9, "max", 3, "marie", 14, "jean")

      -- Test
      assert.are.same(r1, 5)
    end)
  end)

  describe("zrevrange", function()
    it("should return the number elements added to the sorted sets, not including elements already existing for which the score was updated.", function()
  end)
end)