return (function(RedisDb)
  function RedisDb:echo(self,v)
    assert(type(v) == "string")
    return v
  end

  function RedisDb:ping(self)
    return "PONG"
  end
end)