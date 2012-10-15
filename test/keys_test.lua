-- support relative path
package.path = package.path .. ";../?.lua;../src/?.lua"

require "redis-mock"
require "busted"

-- Verbose mode
RedisLua_VERBOSE = true

describe("RedisDb Keys", function()

  describe("exists", function()
    it("should return true when a key exist", function()
      -- RedisDb Mock instance
      r = Redis()
      -- Check
      assert.are.same(r.db:exists("myKey"), false)

      -- Setup
      r.db:set("myKey", "ok")

      -- Test
      assert.are.same(r.db:exists("myKey"), true)
    end)
  end)

  describe("expire", function()
    it("should return false if the key does not exist", function()
      -- RedisDb Mock instance
      r = Redis()

      assert.are.same(r.db:exists("myKey"), false)
      assert.are.same(r.db:expire("myKey", 10), false)
    end)

    it("should return false if the key does not exist", function()
      -- RedisDb Mock instance
      r = Redis()

      -- Check
      assert.are.same(r.db:exists("myKey"), false)

      -- Setup
      r.db:set("myKey", "ok")

      -- Test
      assert.are.same(r.db:expire("myKey", 10), true)
    end)
  end)

  describe("ttl", function()
    it("should return false if the key does not exist", function()
      -- RedisDb Mock instance
      r = Redis()

      assert.are.same(r.db:ttl("myKey"), false)
    end)

    it("should return false if the key does not have a timeout", function()
      -- RedisDb Mock instance
      r = Redis()

      -- Check
      assert.are.same(r.db:exists("myKey"), false)

      -- Setup
      r.db:set("myKey", "ok")

      -- Test
      assert.are.same(r.db:ttl("myKey"), false)
    end)

    it("should return TTL in seconds if the key have a timeout", function()
      -- RedisDb Mock instance
      r = Redis()

      -- Setup
      r.db:set("myKey", "ok")
      r.db:expire("myKey", 60) -- 1 min.

      assert.are.same(r.db:ttl("myKey"), 60)
    end)
  end)
end)