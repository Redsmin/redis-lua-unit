package.path = package.path .. ";../?.lua;../src/?.lua"
local runScript, Redis = require("redis-mock")()
require "busted"

local r = nil
describe("Zunion without range args", function()

  before_each(function()
    -- RedisDb Mock instance
    r = Redis()
  end)

  it("should return the cached version when the sha1hex(keys) already exist", function()
    -- Keys
    KEYS = {"b:nm:1350247717260", "b:nm:1350247710000"}

    -- Setup
    r.db:zadd("zunion:sha1hex", 2, "two", 1, "one" , 3, "three")
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
    r.db:zadd("b:nm:1350247717260", 10, "marc", 1, "paul", 9, "max", 3, "marie", 14, "jean")
    r.db:zadd("b:nm:1350248810000", 10, "silvia", 1, "manon", 9, "maxwell", 1, "marc")


    -- Run
    local ret = runScript {filename="redisScripts/zunion.lua", redis=r, KEYS=KEYS}

    -- Test
    assert.same(ret, {})
    -- assert.spy(r.db.exists).called_with(r.db, "zunion:sha1hex")
  end)

end)