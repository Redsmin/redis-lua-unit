-- zunion numkeys key [key ..] [REVRANGE start stop]
-- simple zunion - MIT LICENSE
-- Francois-Guillaume Ribreau @FGRibreau https://redsmin.com http://brin.gr

local expire = 5*60 -- expire after 5 minutes
local lgth = #KEYS
-- Define the key name
local name = "zunion:" .. redis.sha1hex(table.concat(KEYS))
local start = 0
local stop = -1

if(#ARGV > 0) then
  if(ARGV[1] == "REVRANGE") then
    start = tonumber(ARGV[2]) or 0
    stop = tonumber(ARGV[3]) or -1
  end
end

local function getResults()
  -- return the result from the biggest to the lowest
  return redis.call('zrevrange', name, start, stop, 'WITHSCORES')
end

-- If the key already exist returns it
if redis.call('exists', name) == true then
  return getResults()
end

-- do a zunionstore
table.insert(KEYS, 1, "zunionstore")
table.insert(KEYS, 2, name)
table.insert(KEYS, 3, lgth)
redis.call(unpack(KEYS));

-- Add an expire
redis.call("expire", name, expire);

-- Return the key
return getResults()