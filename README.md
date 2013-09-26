Redis-lua-unit [![Gittip](http://badgr.co/gittip/fgribreau.png)](https://www.gittip.com/fgribreau/)
==============
--------------

Redis-lua-unit - Framework agnostic unit-testing for Redis Lua scripts

**Work in progress, pull requests are welcome!**

==============
--------------

Installation
------------

    wget https://raw.github.com/Redsmin/redis-lua-unit/master/redis-lua-unit-1.0-0.src.rock
    luarocks install ./redis-lua-unit-1.0-0.src.rock

If you don't have the `luarocks` package manager installed run (change the default `2.0.10` version if necessary):

    VERSION="2.0.10";wget "http://luarocks.org/releases/luarocks-${VERSION}.tar.gz" && tar -xvf luarocks-${VERSION}.tar.gz && (cd "luarocks-${VERSION}/";./configure;make;sudo make install);rm -rf "luarocks-${VERSION}/";rm "luarocks-${VERSION}.tar.gz";echo "done";

Or on OSX `brew install luarocks`

Usage
-----

`redis-lua-unit` is framework agnostic and may be used with anything. The following examples will be written using [busted](http://olivinelabs.com/busted/).

```lua

-- include redis-mock
runScript, Redis = require("redis-mock")()
-- include your favorite unit-testing framework

local redis = nil

describe("Testing redis-lua-unit", function()

  before_each(function()
    -- RedisDb Mock instance (the above redis lua script will be able to call redis.call, redis.pcall, ...)
    redis = Redis()
  end)

  it("should return the cached version when the sha1hex(keys) already exist", function()
    -- Keys that will be forwarded to the script
    KEYS = {"b:nm:1350247717260", "b:nm:1350247710000"}

    -- Each redis command is available through redis.db:COMMAND
    -- if it isn't feel free to submit a pull-request
    redis.db:zadd("zunion:sha1hex", 2, "two", 1, "one" , 3, "three")

    spy.on(redis.db, "exists")

    -- runScript require {filename, redis, KEYS}
    -- + filename {string} path of the redis lua script
    -- + redis {"object"} returned by the globally available Redis() constructor
    -- + [KEYS] {table} key names
    -- + [ARGV] {table} additional arguments
    runScript {filename="redisScripts/zunion.lua", redis=redis, KEYS=KEYS}

    -- Check
    assert.spy(redis.db.exists).was.called())
  end)

end)
```

More examples are available in `examples/`.

Supported
---------

We accept pull-requests !


    # lua
    [~] call
    [~] pcall
    [~] sha1hex

    # keys
    [x] del
    [ ] dump
    [x] exists
    [~] expire
    [ ] expireat
    [ ] keys
    [ ] migrate
    [-] move
    [ ] object
    [ ] persist
    [ ] pexpire
    [ ] pexpireat
    [ ] pttl
    [ ] randomkey
    [ ] rename
    [ ] renamenx
    [ ] restore
    [ ] sort
    [~] ttl
    [x] type

    # strings
    [ ] append
    [ ] bitcount
    [ ] bitop
    [ ] decr
    [ ] decrby
    [x] get
    [ ] getbit
    [ ] getrange
    [ ] getset
    [ ] incr
    [ ] incrby
    [ ] incrbyfloat
    [ ] mget
    [ ] mset
    [ ] msetnx
    [ ] psetex
    [x] set
    [ ] setbit
    [ ] setex
    [ ] setrange
    [x] strlen

    # hashes
    [x] hdel
    [x] hexists
    [x] hget
    [ ] hgetall
    [ ] hincrby
    [ ] hincrbyfloat
    [ ] hkeys
    [ ] hlen
    [ ] hmget
    [ ] hmset
    [x] hset
    [ ] hsetnx
    [ ] hvals

    # lists
    [ ] blpop
    [ ] brpop
    [ ] brpoplpus
    [ ] lindex
    [ ] linsert
    [ ] llen
    [ ] lpop
    [ ] lpush
    [ ] lpushx
    [ ] lrange
    [ ] lrem
    [ ] lset
    [ ] ltrim
    [ ] rpop
    [ ] rpoplpush
    [ ] rpush
    [ ] rpushx

    # sets
    [x] sadd
    [ ] scard
    [ ] sdiff
    [ ] sdiffstore
    [ ] sinter
    [ ] sinterstore
    [ ] sismember
    [ ] smembers
    [ ] smove
    [ ] spop
    [ ] srandmember
    [ ] srem
    [ ] sunion
    [~] sunionstore

    # sorted sets
    [x] zadd
    [ ] zcard
    [ ] zcount
    [ ] zincrby
    [ ] zinterstore
    [ ] zrange
    [ ] zrangebyscore
    [ ] zrank
    [ ] zrem
    [ ] zremrangebyrank
    [ ] zremrangebyscore
    [~] zrevrange
    [ ] zrevrangebyscore
    [ ] zrevrank
    [ ] zscore
    [ ] zunionstore

    # pub/sub
    [ ] psubscribe
    [ ] publish
    [ ] punsubscribe
    [ ] subscribe
    [ ] unsubscribe

    # transactions
    [ ] discard
    [ ] exec
    [ ] multi
    [ ] unwatch
    [ ] watch

    # scripting
    [ ] eval
    [ ] evalsha
    [ ] script exists
    [ ] script flush
    [ ] script kill
    [ ] script load

    # connection
    [ ] auth
    [x] echo
    [x] ping
    [ ] quit
    [-] select

    # server
    [ ] bgrewriteaof
    [ ] bgsave
    [ ] client kill
    [ ] client list
    [ ] config get
    [ ] config set
    [ ] config resetstat
    [ ] dbsize
    [ ] debug object
    [ ] debug segfault
    [x] flushall
    [x] flushdb
    [ ] info
    [ ] lastsave
    [ ] monitor
    [ ] save
    [ ] shutdown
    [ ] slaveof
    [ ] slowlog
    [ ] sync
    [ ] time

Authors
-------

* [Francois-Guillaume Ribreau](http://twitter.com/FGRibreau)
* Original work from [@pchapuis](http://twitter.com/pchapuis) [fakeredis](https://github.com/catwell/cw-lua/tree/master/fakeredis)

Sponsor
-------
This project is sponsored by:
* [Redsmin](https://redsmin.com): Full featured GUI that provides online real-time visualization and administration service for Redis.
* [Bringr](http://brin.gr): filter, observe, understand the real-time social web

Copyright and license
---------------------
Copyright (c) 2012 Francois-Guillaume Ribreau (npm@fgribreau.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
