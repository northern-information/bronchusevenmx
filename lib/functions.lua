fn = {}

function fn.table_find(t, element)
  for i, v in pairs(t) do
    if v == element then
      return i
    end
  end
  return false
end

function rerun()
  norns.script.load(norns.state.script)
end

function r()
  rerun()
end

function fn.break_splash(bool)
  if bool == nil then return splash_break end
  splash_break = bool
  return splash_break
end

function fn.dirty_screen(bool)
  if bool == nil then return screen_dirty end
  screen_dirty = bool
  return screen_dirty
end

function make_stream(setup)
  local get_next
  local value = nil

  print('making stream')

  function reset () 
    print('calling reset')
    get_next = setup()
    print('called reset')
  end

  function set_value (new_value)
    value = new_value
  end

  reset()

  local stream = {}

  stream["last"] = function () return value end
  stream["advance"] = function () get_next(set_value) end
  stream["next"] = 
    function () 
      stream.advance()
      return stream.last()
    end
  stream["reset"] = reset

  return stream
end

function geom_stream(start, grow)
  return make_stream(function ()
    local value = start
    return function (cb)
      cb(value)
      value = value * grow
    end
  end)
end

function series_stream(start, step)
  return make_stream(function ()
    local value = start
    return function (cb)
      cb(value)
      value = value + step
    end
  end)
end

function table_stream(t)
  return make_stream(function ()
    local index = 1
    return function (cb)
      print("table_stream -> "..t[index])
      cb(t[index])
      index = index % #t + 1
    end
  end)
end

function stream_to_table(stream, size)
  local t = { }

  for i = 1, size do
    t[i] = stream.next()
  end

  return t
end

return fn
