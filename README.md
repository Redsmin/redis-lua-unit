Redis-lua-unit
==============

Redis-lua-unit - Unit-test for Redis LUA scripts

Installation
------------

    luarocks install redis-lua-unit

If you don't have the `luarocks` package manager installed run (change the default `2.0.10` version if necessary):

    VERSION="2.0.10";wget "http://luarocks.org/releases/luarocks-${VERSION}.tar.gz" && tar -xvf luarocks-${VERSION}.tar.gz && (cd "luarocks-${VERSION}/";./configure;make;sudo make install);rm -rf "luarocks-${VERSION}/";rm "luarocks-${VERSION}.tar.gz";echo "done";

Or on OSX `brew install luarocks`

Supported
---------

We accept pull-request !

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
    [ ] sunionstore

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
