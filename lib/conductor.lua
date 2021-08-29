conductor = {}
now_playing = nil
ticks_per_beat = 24
beats_per_measure = 16

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
  conductor.offset_stream = series_stream(0, 0.002)
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
    local rate = self.rate.next()
    print(rate)
    self.sampler[now_playing]:scrub(
      rate, 
      self.offset_stream.next(),
      1)
  end

  if a % 100 > 50 and a % 5 == 0 then
    -- local name = 'uneven-structure-' .. now_playing .. '.wav'
    -- function Sample:scrub(rate, start, amp)
    --self.sampler[now_playing]:scrub(1, self.offset_stream.next(), 1)
    self.sampler[now_playing]:scrub(
      self.rate.last(), 
      self.offset_stream.next(), 
      1)
  end

  -- rerun the script
  if a == 800 then
    rerun()
  end

  self.arrow_of_time = self.arrow_of_time + 1

  fn.dirty_screen(true)

end

return conductor
