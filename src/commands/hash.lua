return (function(RedisDb)

  function RedisDb:hdel(self,k, ...)
    local arg = {...}
    assert(#arg > 0)
    local r = 0
    local x = RedisDb.xgetw(self,k,"hash")
    for i=1,#arg do
      assert((type(arg[i]) == "string"))
      if x[arg[i]] then r = r + 1 end
      x[arg[i]] = nil
    end
    if empty(self,k) then self[k] = nil end
    return r
  end

  function RedisDb:hexists(self,k,k2)
    return not not RedisDb.hget(self,k,k2)
  end

  function RedisDb:hget(self,k,k2)
    assert((type(k2) == "string"))
    local x = RedisDb.xgetr(self,k,"hash")
    return x[k2]
  end

  function RedisDb:hset(self,k,k2,v)
    assert((type(k2) == "string") and (type(v) == "string"))
    local x = RedisDb.xgetw(self,k,"hash")
    x[k2] = v
    return true
  end

end)