Sample = {}

function Sample:new(name)
  local s = setmetatable({}, { __index = Sample })
  s.name = name
  s.path = filesystem:get_sample_path() .. "/" .. s.name 
  s.volume = 100
  return s
end

function Sample:trigger()
  local path = self:get_path()
  local amp = self:get_volume() * .01
  local amp_lag = 0
  local sample_start = 0
  local sample_end = 1
  local loop = 0
  local rate = 1
  local trig = 1
  engine.play(path, amp, amp_lag, sample_start, sample_end, loop, rate, trig)
end

function Sample:scrub(rate, start, amp)
  rate = rate or 1
  start = start or 0
  amp = amp or self:get_volume() * .01

  local path = self:get_path()
  local amp_lag = 0
  local sample_end = 1
  local loop = 0
  local trig = 1
  engine.play(path, amp, amp_lag, start, sample_end, loop, rate, trig)
end

function Sample:get_name()
  return self.name
end

function Sample:get_path()
  return self.path
end

function Sample:set_volume(i)
  self.volume = util.clamp(i, 0, 100)
end

function Sample:get_volume()
  return self.volume
end
