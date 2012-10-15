-- Implementation: self[key].value = {{"plop",10}, {"hey",12}, {"hello",1}}

return (function(RedisDb)

  -- local zadd = function(self, key, ...)
  function RedisDb:zadd(key, ...)
    local args = {...}
    assert(#args > 0, "zadd require at least on pair of score/member")

    -- create the sorted set if it doesn't not exist
    if(not RedisDb.exists(self, key)) then
      self[key] = {ktype="zset",value={}, _members={}}
    end

    local zset = self[key].value
    local oldSize = #self[key].value

    for i=1,#args, 2 do
      local score = tonumber(args[i])
      local member = tostring(args[i+1])

      assert(type(score) == "number", "Score must be a number")
      assert(type(member) == "string", "Member must be a number")

      if(not zset[member]) then
        table.insert(self[key]._members, member)
        table.insert(zset, {member, score})
      else
        -- linear lookup

        for curMember,oldScore in pairs(zset) do
          if(zset[curMember][1] == member) then
            zset[member].score = oldScore + score
            break
          end
        end
      end

    end

    table.sort(self[key].value, function(a,b)  return a[2] > b[2] end)
    return RedisDb.printCmd(self, 'zadd', key, unpack(args), #self[key].value - oldSize)
  end

  function RedisDb:zrevrange(key, _start, _stop, withscores)
    local ret = {}

    start = tonumber(_start)
    stop  = tonumber(_stop)

    assert(type(key)   == "string", "key is required")
    assert(type(start) == "number", "start is required")
    assert(type(stop)  == "number", "stop is required")

    if(not withscores or not type(withscores) == "string") then
      withscores = nil
    end

    if(RedisDb.exists(self, key)) then
      local zset = RedisDb.xgetr(self, key, "zset")
      start = start + 1
      if(stop == -1 or stop+1 > #zset)then stop = #zset else stop = stop + 1 end

      -- @todo - optimize that
      for i=start,stop do
        if(not withscores) then
            table.insert(ret, zset[i][1]) -- only insert the member
          else
            table.insert(ret, zset[i])
          end
      end
    else
    end

    return RedisDb.printCmd(self, 'zrevrange', key, _start, _stop, withscores or "", ret)
  end


end)