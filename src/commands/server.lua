return (function(methods)

  function methods:flushdb()
    for k,_ in pairs(self) do self[k] = nil end
    return true
  end

end)