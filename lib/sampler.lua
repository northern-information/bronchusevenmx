local sampler = {}

function sampler.init()
  sampler.bank = {}
  sampler.lookup = {}
  for k, name in pairs(filesystem:get_samples()) do
    print("adding sample: " .. name)
    table.insert(sampler.bank, Sample:new(name))
    sampler.lookup[name] = k
  end
end

function sampler:get_by_name(name)
  return self.bank[self.lookup[name]]
end

return sampler