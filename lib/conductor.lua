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
  conductor.test = Sequins{2, 1}
end

function conductor:act()
  -- this method acts each bronch_lattice
  conductor.arrow_of_time = conductor.arrow_of_time + 1
  local a = conductor.arrow_of_time

  -- hardcode event
  if a == 1 then 
    conductor:trigger_sample_by_name('uneven-structure-1.wav')
  end

  -- sequence event
  if a % 100 == 0 then

    conductor:trigger_sample_by_name('uneven-structure-' .. conductor.test() .. '.wav')

  end

  -- rerun the script
  if a == 1000 then
    rerun()
  end

  fn.dirty_screen(true)

end



function conductor:trigger_sample_by_name(name)
  conductor.sampler[conductor.hash_map[name]]:trigger()
end

return conductor