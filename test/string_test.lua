local lfs    = require "lfs"

-- support relative path
package.path = package.path .. ";../?.lua;../src/?.lua"

require("redis-mock")
require "busted"

-- Verbose mode
-- RedisLua_VERBOSE = true

describe("RedisDb String", function()

  describe("should be awesome", function()
    it("should support set", function()
      -- RedisDb Mock instance
      r = Redis()

      assert.are.same(r.db:get("myKey"), false)
      -- Setup
      r.db:set("myKey", "ok")

      -- Test
      assert.are.same(r.db:get("myKey"), "ok")
    end)
  end)

  -- describe("should be awesome", function()
  --   it("should be easy to use", function()
  --     assert.truthy("Yup.")
  --   end)

  --   it("should have lots of features", function()
  --     -- deep check comparisons!
  --     assert.are.same({ table = "great"}, { table = "great" })

  --     -- or check by reference!
  --     assert.are_not.equal({ table = "great"}, { table = "great"})
  --     assert.falsy(nil)
  --     assert.has.error(function() error("Wat") end, "Wat")
  --   end)

  --   it("should provide some shortcuts to common functions", function()
  --     assert.are.unique({{ thing = 1 }, { thing = 2 }, { thing = 3 }})
  --   end)

  --   it("should have mocks and spies for functional tests", function()
  --     assert.falsy(nil)
  --   end)
  -- end)

end)