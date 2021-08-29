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
  local decay = 999
  local interpolation = 2
  local endLag = 0
  engine.play(path, amp, amp_lag, sample_start, sample_end, loop, rate, trig, decay, interpolation, endLag)
end

function Sample:loop()
  local path = self:get_path()
  local amp = self:get_volume() * .01
  local amp_lag = 0
  local sample_start = 0
  local sample_end = 1
  local loop = 1
  local rate = 1
  local trig = 1
  local decay = 999
  local interpolation = 2
  local endLag = 0
  engine.play(path, amp, amp_lag, sample_start, sample_end, loop, rate, trig, decay, interpolation, endLag)
end


function Sample:scrub(rate, sample_start, amp, decay, interpolation, sample_end, endLag, hpf, delay_send)
  rate = rate or 1
  sample_start = sample_start or 0
  amp = amp or self:get_volume() * .01
  decay = decay or 999
  interpolation = interpolation or 2
  sample_end = sample_end or 1
  endLag = endLag or 0
  hpf = hpf or 1
  delay_send = delay_send or 0
  --print("endLag:"..endLag)

  local path = self:get_path()
  local amp_lag = 0
  local loop = 0
  local trig = 1
  engine.play(path, amp, amp_lag, sample_start, sample_end, loop, rate, trig, decay, interpolation, endLag, hpf, delay_send)
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
