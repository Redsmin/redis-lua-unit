Redis-lua-unit
==============

Redis-lua-unit - Unit-test for Redis LUA scripts

Installation
------------

    luarocks install redis-lua-unit

If you don't have the `luarocks` package manager installed run (change the default `2.0.10` version if necessary):

    VERSION="2.0.10";wget "http://luarocks.org/releases/luarocks-${VERSION}.tar.gz" && tar -xvf luarocks-${VERSION}.tar.gz && (cd "luarocks-${VERSION}/";./configure;make;sudo make install);rm -rf "luarocks-${VERSION}/";rm "luarocks-${VERSION}.tar.gz";echo "done";

Or on OSX `brew install luarocks`
