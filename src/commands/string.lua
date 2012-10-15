return (function(RedisDb)

  function RedisDb:get(key)
    local x = RedisDb.xgetr(self, key, "string")
    local returnValue = x[1]
    return RedisDb.printCmd(self, 'get', key, returnValue or false)
  end

  function RedisDb:set( key, v)
    assert(type(v) == "string")
    self[key] = {ktype="string",value={v}}
    return RedisDb.printCmd(self, 'set', key, v, true)
  end

  function RedisDb:strlen(k)
    local x = RedisDb.xgetr(self,k,"string")
    return x[1] and #x[1] or 0
  end

end)