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

-- all this stream shit should probably go in its own module

function make_stream(setup, debug)
  local get_next
  local stream = { value = nil }
  stream.set_value = 
    function (new_value)
      stream.value = new_value
    end

  function reset () get_next = setup() end

  reset()

  stream["advance"] = function () get_next(stream.set_value) end
  stream["last"] = function () 
    if stream.value == nil then
      stream.advance()
    end
    return stream.value 
  end
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
      cb(t[index])
      index = index % #t + 1
    end
  end)
end

function once_stream()
  return make_stream(function ()
    local value = true
    return function (cb)
      cb(value)
      value = false
    end
  end)
end

function loop_stream(stream, max_items, inc)
  inc = inc or 1

  local items = 0
  local value = nil
  local looped_stream = { }
  looped_stream["reset"] = 
    function () 
      items = 0
      stream.reset()
    end
  looped_stream["next"] = 
    function ()
      for i = 1, inc do
        value = stream.next()
        items = items + 1
        if items >= max_items then
          --print("that's all folks! restarting looped stream....")
          looped_stream.reset()
        end
      end
      return value
    end
  looped_stream["last"] = 
    function ()
      return value
    end
  looped_stream["set_length"] = 
    function (new_length)
      max_items = new_length
    end
  looped_stream["set_inc"] = 
    function (new_inc)
      --print("new length: "..new_length)
      inc = new_inc
    end
  return looped_stream
end

function stream_to_table(stream, size)
  local t = { }

  for i = 1, size do
    t[i] = stream.next()
  end

  return t
end

return fn
