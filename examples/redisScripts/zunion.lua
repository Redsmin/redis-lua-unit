-- zunion numkeys key [key ..] [COMMAND command]
-- zunion v1 - MIT LICENSE
-- Francois-Guillaume Ribreau @FGRibreau https://redsmin.com

local expire = 5*60; -- expire after 5 minutes
local lgth = #KEYS;
-- Define the key name
local name = "zunion:" .. redis.sha1hex(table.concat(KEYS))

local function getResults()
  -- return the result from the biggest to the lowest
  return redis.call('zrevrange', name, 0, 10, 'WITHSCORES')
end

-- If the key already exist returns it
if redis.call('exists', name) == 1 then
  return getResults()
end

-- do a zunionstore
table.insert(KEYS, 1, "zunionstore")
table.insert(KEYS, 2, name)
table.insert(KEYS, 3, lgth)
redis.call(unpack(KEYS));

-- Add an expire
redis.call("EXPIRE", name, expire);

-- Return the key
return getResults()