package.path = package.path .. ";../?.lua;../src/?.lua"

local runScript, Redis = require("redis-mock")()
require "busted"

-- Verbose mode
-- RedisLua_VERBOSE = true
-- RedisDb_VERBOSE = true

local r = nil
describe("RedisDb Keys", function()

  describe("exists", function()
    before_each(function()
      -- RedisDb Mock instance
      r = Redis()
    end)
    it("should return true when a key exist", function()
      -- Check
      assert.are.same(r.db:exists("myKey"), false)

      -- Setup
      r.db:set("myKey", "ok")

      -- Test
      assert.are.same(r.db:exists("myKey"), true)
    end)
  end)

  describe("expire", function()
    before_each(function()
      -- RedisDb Mock instance
      r = Redis()
    end)

    it("should return false if the key does not exist", function()
      assert.are.same(r.db:exists("myKey"), false)
      assert.are.same(r.db:expire("myKey", 10), false)
    end)

    it("should return false if the key does not exist", function()
      -- Check
      assert.are.same(r.db:exists("myKey"), false)

      -- Setup
      r.db:set("myKey", "ok")

      -- Test
      assert.are.same(r.db:expire("myKey", 10), true)
    end)
  end)

  describe("ttl", function()
    before_each(function()
      -- RedisDb Mock instance
      r = Redis()
    end)

    it("should return false if the key does not exist", function()
      assert.are.same(r.db:ttl("myKey"), false)
    end)

    it("should return false if the key does not have a timeout", function()
      -- Check
      assert.are.same(r.db:exists("myKey"), false)

      -- Setup
      r.db:set("myKey", "ok")

      -- Test
      assert.are.same(r.db:ttl("myKey"), false)
    end)

    it("should return TTL in seconds if the key have a timeout", function()
      -- Setup
      r.db:set("myKey", "ok")
      r.db:expire("myKey", 60) -- 1 min.

      assert.are.same(r.db:ttl("myKey"), 60)
    end)
  end)

  after_each(function()
    r = nil
  end)
end)