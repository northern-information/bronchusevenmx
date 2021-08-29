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
  local value

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

  return {
    ["next"] = 
      function () 
        print('calling next')
        get_next(cb)
        return value
      end,
    ["reset"] = reset
  }
end

function geom_stream(start, grow)
  return make_stream(function ()
    value = start
    return function (cb)
      cb(value)
      value = value * grow
    end
  end)
end

function series_stream(start, step)
  return make_stream(function ()
    value = start
    return function (cb)
      cb(value)
      value = value + step
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
