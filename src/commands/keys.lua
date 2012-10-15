return (function(RedisDb)

  function RedisDb:del(...)
    local arg = {...}
    assert(#arg > 0)
    local r = 0
    for i=1,#arg do
      if self[arg[i]] then r = r + 1 end
      self[arg[i]] = nil
    end
    return r
  end

   function RedisDb:exists(key)
    local returnValue = not not self[key]

    return RedisDb.printCmd(self, 'exists', key, returnValue)
  end

  function RedisDb:_type(k)
    return (self[k] and self[k].ktype) and self[k].ktype or "none"
  end

  function RedisDb:expire(key, seconds)
    local ret = false

    if(RedisDb.exists(self, key)) then
      self[key].expire = seconds
      ret = true
    end

    return RedisDb.printCmd(self, 'expire', key, seconds, ret)
  end

  -- Integer reply: TTL in seconds or -1 when key does not exist or does not have a timeout.
  function RedisDb:ttl( key)
    if(not RedisDb.exists(self, key) or not self[key].expire) then return RedisDb.printCmd(self, 'ttl', key, false) end

    local returnValue = self[key].expire

    return RedisDb.printCmd(self, 'ttl', key, returnValue)
  end

end)