package.path = package.path .. ";../?.lua;../src/?.lua"

require("redis-mock")
require "busted"

-- Verbose mode
RedisLua_VERBOSE = true
RedisDb_VERBOSE = true
local r = nil

function table_print (tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    local sb = {}
    for key, value in pairs (tt) do
      table.insert(sb, string.rep (" ", indent)) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        table.insert(sb, "{\n");
        table.insert(sb, table_print (value, indent + 2, done))
        table.insert(sb, string.rep (" ", indent)) -- indent it
        table.insert(sb, "}\n");
      elseif "number" == type(key) then
        table.insert(sb, string.format("\"%s\"\n", tostring(value)))
      else
        table.insert(sb, string.format(
            "%s = \"%s\"\n", tostring (key), tostring(value)))
       end
    end
    return table.concat(sb)
  else
    return tt .. "\n"
  end
end


describe("Zunion without range args", function()

  before_each(function()
    -- RedisDb Mock instance
    r = Redis()
  end)

  describe("should be awesome", function()
    it("should return the cached version when the sha1hex(keys) already exist", function()

      -- Keys
      KEYS = {"b:nm:1350247717260", "b:nm:1350247710000"}

      -- Setup
      r.db:set("zunion:sha1hex", "ok")
      spy.on(r.db, "exists")

      -- Run
      runScript {filename="redisScripts/zunion.lua", redis=r, KEYS=KEYS}

      -- Test
      assert.same(assert.spy(r.db.exists).payload.calls[3], "zunion:sha1hex")
    end)

    it("should compute the zunion otherwise", function()

      -- Keys
      KEYS = {"b:nm:1350247717260", "b:nm:1350248810000"}

      -- Setup
      -- r.db:zadd("b:nm:1350247717260", 10, "marc", 1, "paul", 9, "max", 3, "marie", 14, "jean")
      -- r.db:zadd("b:nm:1350248810000", 10, "silvia", 1, "manon", 9, "maxwell", 1, "marc")
      spy.on(r.db, "exists")

      -- Run
      runScript {filename="redisScripts/zunion.lua", redis=r, KEYS=KEYS}

      -- Test
      assert.same(assert.spy(r.db.exists).payload.calls[3], "zunion:sha1hex")
      -- assert.spy(r.db.exists).called_with(r.db, "zunion:sha1hex")
    end)

  end)

end)