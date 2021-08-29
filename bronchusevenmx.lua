-- bronchusevenmx.lua

engine.name = "Ge47eb"
lattice = require("lattice")
include("lib/Sample")
Sequins = include("lib/Sequins")
fn = include("lib/functions")
filesystem = include("lib/filesystem")
conductor = include("lib/conductor")
graphics = include("lib/graphics")

bpm = 120
redraw_clock_id = nil

function init()
  screen_dirty = true
  filesystem.init()
  conductor.init()
  graphics.init()
  bronch_lattice = lattice:new()
  clock.internal.set_tempo(bpm)
  clock.set_source("internal")
  p = bronch_lattice:new_pattern{
    action = function(t) conductor:act() end,  -- here's the thing you're looking for
    division = 1/96,
    enabled = true
  }
  bronch_lattice:start()
  redraw_clock_id = clock.run(redraw_clock)
end

function enc(e, d)
 fn.dirty_screen(true)
end

function key(k, z)
  fn.dirty_screen(true)
end

function redraw_clock()
  while true do
    if fn.dirty_screen()then
      redraw()
      fn.dirty_screen(false)
    end
    clock.sleep(1 / graphics.fps)
  end
end

function redraw()
  graphics:render()
end

function cleanup()
  clock.cancel(redraw_clock_id)
  bronch_lattice:destroy()
end
