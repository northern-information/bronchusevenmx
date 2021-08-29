conductor = {}
now_playing = nil

function conductor.init()
  conductor.arrow_of_time = 0
  conductor.id = 999
  conductor.sampler = {}
  conductor.hash_map = {}
  for key, name in pairs(filesystem:get_samples()) do
    table.insert(conductor.sampler, Sample:new(name))
    conductor.hash_map[name] = key
  end
  -- "score" data
  conductor.test = Sequins{1, 2}
  conductor.offset_stream = series_stream(0, 0.01)
  
  -- conductor.start = Sequins{}
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
    print(now_playing)
    self:trigger_sample_by_name('uneven-structure-' .. now_playing .. '.wav')
  end

  if a % 100 > 50 then
    local name = 'uneven-structure-' .. now_playing .. '.wav'
    name = self.hash_map[name]
    -- function Sample:scrub(rate, start, amp)
    --self.sampler[name]:scrub(1, self.offset_stream.next(), 1)
    self.sampler[name]:scrub()
  end

  -- rerun the script
  if a == 1000 then
    rerun()
  end

  self.arrow_of_time = self.arrow_of_time + 1

  fn.dirty_screen(true)

end



function conductor:trigger_sample_by_name(name)
  self.sampler[self.hash_map[name]]:trigger()
end

return conductor
