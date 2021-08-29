conductor = {}
now_playing = nil

function conductor.init()
  conductor.arrow_of_time = 0
  conductor.id = 999
  conductor.sampler = {}
  conductor.hash_map = {}
  for key, name in pairs(filesystem:get_samples()) do
    print("adding sampler"..name)
    table.insert(conductor.sampler, Sample:new(name))
    conductor.hash_map[name] = key
  end

  -- "SCORE" DATA --
  conductor.test = Sequins{1, 2}
  -- just-intonation (perfect) fifth sequence
  conductor.rate = table_stream{1/4, 3/8, 1/2, 3/4, 1, 3/2, 2}
  conductor.offset_stream = series_stream(0, 0.001)
  conductor.amp_stream = loop_stream(series_stream(0.2, 0.05), 16)
  conductor.clockdiv_div_stream = loop_stream(series_stream(1, 1), 7)
  conductor.clockdiv_stream = loop_stream(once_stream(), 
    conductor.clockdiv_div_stream.next())
end

function conductor:act()
  -- this method acts each bronch_lattice
  local a = self.arrow_of_time

  -- hardcode event
  if a == 23 then 
    print("hardcode event")
  end

  -- sequence event
  if a % 100 == 0 then
    now_playing = self.test()
    -- local name = 'uneven-structure-' .. now_playing .. '.wav'
    -- print("now_playing "..name)
    self.sampler[now_playing]:scrub(
      self.rate.next(), 
      self.offset_stream.next(),
      self.amp_stream.next())
  end

  -- it'd be cool to "auto-bind" once stream to another for e.g. looping
  if a % 100 > 50 and self.clockdiv_stream.next() then
    self.clockdiv_stream.set_length(conductor.clockdiv_div_stream.next())
    -- local name = 'uneven-structure-' .. now_playing .. '.wav'
    -- function Sample:scrub(rate, start, amp)
    --self.sampler[now_playing]:scrub(1, self.offset_stream.next(), 1)
    self.sampler[now_playing]:scrub(
      self.rate.last(), 
      self.offset_stream.next(), 
      self.amp_stream.next())
  end

  -- rerun the script
  if a == 800 then
    rerun()
  end

  self.arrow_of_time = self.arrow_of_time + 1

  fn.dirty_screen(true)

end

return conductor
