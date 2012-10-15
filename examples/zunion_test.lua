local lfs    = require "lfs"

-- support relative path
package.path = package.path .. ";../?.lua;../src/?.lua"

require("redis-mock")
require "busted"

-- Verbose mode
RedisLua_VERBOSE = true

describe("Zunion without range args", function()

  describe("should be awesome", function()
    it("should return the cached version", function()

      -- RedisDb Mock instance
      r = Redis()

      -- Keys
      KEYS = {"b:nm:1350247717260", "b:nm:1350247710000"}

      -- Setup
      r.db:set("zunion:sha1hex", "ok")
      spy.on(r.db, "exists")

      -- Run
      runScript {filename="redisScripts/zunion.lua", redis=r, KEYS=KEYS}

      -- Test
      assert.spy(r.db.exists).was.called()
      -- assert.spy(r.db.exists).was.called_with("zunion:sha1hex")
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