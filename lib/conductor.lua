conductor = {}

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

    self:trigger_sample_by_name('uneven-structure-' .. self.test() .. '.wav')

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