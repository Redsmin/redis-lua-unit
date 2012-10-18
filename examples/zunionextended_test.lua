package.path = package.path .. ";../?.lua;../src/?.lua"
local runScript, Redis = require("redis-mock")()
require "busted"

local r = nil
describe("Zunion v2 with range args", function()

  before_each(function()
    -- RedisDb Mock instance
    r = Redis()
  end)

  it("should return REVRANGE 0 4", function()
    -- Setup
    r.db:zadd("myzset1", 10, "marc", 1, "paul", 8, "max", 3, "marie", 14, "jean")
    r.db:zadd("myzset2", 10, "silvia", 15, "manon", 9, "maxwell", 1, "marc", 0, "lucie")

    KEYS = {"myzset1", "myzset2"}

    -- Run
    local ret = runScript {filename="redisScripts/zunionextended.lua", redis=r, KEYS=KEYS, ARGV={"REVRANGE", 0, 4}}

    -- Test
    assert.same(ret, {{ "manon", 15 },{ "jean", 14 },{ "marc", 11 },{ "silvia", 10 },{ "maxwell", 9 } })
  end)

  it("should return REVRANGE 0 -1", function()
    -- Setup
    r.db:zadd("myzset1", 30, "marc", 1, "paul", 8, "max", 3, "marie", 14, "jean")
    r.db:zadd("myzset2", 10, "silvia", 15, "manon", 9, "maxwell", 1, "marc")

    KEYS = {"myzset1", "myzset2"}
    spy.on(r.db, "expire")

    -- Run
    local ret = runScript {filename="redisScripts/zunionextended.lua", redis=r, KEYS=KEYS, ARGV={"REVRANGE", 0, -1}}


    -- Test
    assert.same(r.db.expire.calls[1][2], "zunion:sha1hex")
    assert.same(r.db.expire.calls[1][3], 300)

    assert.same(ret, { { "marc", 31 }, { "manon", 15 }, { "jean", 14 }, { "silvia", 10 }, { "maxwell", 9 }, { "max", 8 }, { "marie", 3 }, { "paul", 1 } })
  end)

  it("should return the cached version", function()
    -- Setup
    r.db:zadd("zunion:sha1hex", 40, "marc", 1, "paul", 8, "max", 3, "marie", 14, "jean")

    r.db:zadd("myzset1", 30, "lmarc", 1, "lpaul", 8, "lmax", 3, "lmarie", 14, "ljean")
    r.db:zadd("myzset2", 10, "lsilvia", 15, "lmanon", 9, "lmaxwell", 1, "lmarc")

    spy.on(r.db, "zunionstore")


    KEYS = {"myzset1", "myzset2"}

    local s = spy.on(r.db, "expire")

    -- Run
    local ret = runScript {filename="redisScripts/zunionextended.lua", redis=r, KEYS=KEYS, ARGV={"REVRANGE", 0, -1}}

    -- Test

    -- expire should not be called
    assert.same(#r.db.expire.calls, 0)
    -- should return zunion:sha1hex
    assert.same(ret, {{ "marc", 40 },{ "jean", 14 },{ "max", 8 },{ "marie", 3 },{ "paul", 1 } })
  end)

end)
