local inspect = require('inspect')
return (function(RedisDb)

  RedisDb.inspect = inspect

  -- http://lua-users.org/wiki/TableSerialization
  function RedisDb:table_print(tt, indent, done)
    return inspect(tt)
  end


  function RedisDb:xgetr(k,ktype)
    if self[k] then
      assert(self[k].ktype == ktype, "xgetr ktype(".. k .."): ".. self[k].ktype.." === ".. ktype)
      assert(self[k].value)
      return self[k].value
    else return {} end
  end

  function RedisDb:xgetw(k,ktype)
    if self[k] and self[k].value then
      assert(self[k].ktype == ktype)
    else
      self[k] = {ktype=ktype,value={}}
    end
    return self[k].value
  end

  function RedisDb:empty(k)
    return #self[k].value == 0
  end

  -- first parameter is the command name, then option arguments
  -- last parameter is the returned value
  -- printCmd( cmd, [optional arguments], returnValue)
  function RedisDb:printCmd( cmd, ...)
    local args = {...}

    if(#args == 0) then
      args = {}
    end

    local returnValue = args[#args]
    local printedValue = returnValue

    if(type(printedValue) == "table") then
      printedValue = RedisDb.table_print(printedValue)
    else
      printedValue = tostring(printedValue)
    end


    if RedisDb.RedisDb_VERBOSE then
      print(cmd .. "(" .. inspect(args) .. ") === " .. printedValue)
    end

    return returnValue
  end
end)