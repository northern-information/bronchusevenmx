-- bronchusevenmx.lua

engine.name = "Ge47eb"
lattice = require("lattice")
tab = require("tabutil")
include("lib/Sample")
Sequins = include("lib/Sequins")
fn = include("lib/functions")
filesystem = include("lib/filesystem")
conductor = include("lib/conductor")
sampler = include("lib/sampler")
graphics = include("lib/graphics")

bpm = 120
redraw_clock_id = nil
screen_dirty = true

function init()
  filesystem.init()
  conductor.init()
  sampler.init()
  graphics.init()
  clock.internal.set_tempo(bpm)
  clock.set_source("internal")
  bronch_lattice = lattice:new()
  p = bronch_lattice:new_pattern{
    action = function(t) conductor:act() end,
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
