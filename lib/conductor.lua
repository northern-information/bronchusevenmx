conductor = {}
now_playing = nil

function conductor.init()
  conductor.arrow_of_time = 0
  -- "SCORE" DATA --

  -- guitar
  conductor.guitar_sequence = Sequins{1, 2}
  conductor.guitar_samples = {}
  conductor.guitar_samples[1] = "uneven-structure-1.wav"
  conductor.guitar_samples[2] = "uneven-structure-2.wav"

  -- drums
  conductor.drum_sequence = Sequins{1}
  conductor.drum_samples = {}
  conductor.drum_samples[1] = "deep-state-music.wav"
  conductor.sixteenth = loop_stream(once_stream(), 6)
  conductor.drum_step = loop_stream(series_stream(0, 1), 16)
  conductor.drum_bar_offset = loop_stream(series_stream(0, 1/5), 5, 3)
  conductor.drum_8_offset = loop_stream(series_stream(0, 1/40), 8, 5)
  conductor.sample_len = loop_stream(series_stream(1/80, 1/80), 5, 2)
  conductor.hpf_steps = loop_stream(series_stream(1000, 500), 5)
  conductor.sample_len = loop_stream(series_stream(1/80, 1/80), 5, 2)
  conductor.kick2 = loop_stream(table_stream{6, 9, 10, 13, 14}, 5, 3)

  -- stream zone
  local rates = {1/8, 3/16, 1/4, 3/8, 1/2, 3/4, 1, 3/2, 2, 3, 4}
  conductor.interp = Sequins{1, 2}
  -- just-intonation (perfect) fifth sequence
  conductor.rate = loop_stream(table_stream(rates), #rates, 5)
  conductor.offset_stream = series_stream(0, 0.001)
  conductor.amp_stream = loop_stream(series_stream(0.3, 0.05), 13)
  conductor.clockdiv_div_stream = loop_stream(series_stream(1, 1), 7)
  conductor.burst_stream = loop_stream(once_stream(), 
    conductor.clockdiv_div_stream.next())
  conductor.changerate_stream = loop_stream(once_stream(), 70)
  conductor.decay_stream = loop_stream(series_stream(0.05, 0.05), 11)
  conductor.len_stream = loop_stream(series_stream(0.001, 0.001), 17)

  conductor.changerate_stream = loop_stream(once_stream(), 70)

end

function conductor:act()
  -- this method acts each bronch_lattice
  local a = self.arrow_of_time

  -- hardcode event
  if a == 23 then 
    -- print("hardcode event")
  end

  if self.sixteenth.next() then
    local amp = 0.5
    local decay = 6
    local interp = 1
    local rate = 1

    self.drum_step.next()
    self.kick2.next()

    if self.drum_step.last() == 0 or self.drum_step.last() == self.kick2.next() then
      local offset = self.drum_bar_offset.next()
      local hpf = 20
      local sample_len = self.sample_len.next()
      print("hpf:"..self.hpf_steps.next())
      sampler:get_by_name("deep-state-music.wav"):scrub(
        rate, offset, amp, decay, interp, sample_len, 0, hpf)
    elseif self.drum_step.last() == 4 then
      local offset = self.drum_bar_offset.next() + self.drum_8_offset.next()
      local hpf = self.hpf_steps.last()
      sampler:get_by_name("deep-state-music.wav"):scrub(
        rate, offset, amp, decay, interp, sample_len, 2, hpf)
    end
  end

  -- guitar events
  if a % 100 == 0 then
    now_playing = self.guitar_sequence()
    local name = 'uneven-structure-' .. now_playing .. '.wav'
    -- print("now_playing "..name)
    --sampler:get_by_name("deep-state-music.wav"):scrub(rate, offset, amp, decay, interp, sample_len, end_lag, hpf)
    sampler:get_by_name(name):scrub(
      self.rate.next(), 
      self.offset_stream.next(),
      self.amp_stream.next() * 0.3,
      999,
      2, 
      0.5,
      0)
  end

  if self.changerate_stream.next() then
      self.rate.next()
  end

  -- it'd be cool to "auto-bind" once stream to another for e.g. looping
  if a % 100 > 50 and self.burst_stream.next() then
    self.burst_stream.set_length(conductor.clockdiv_div_stream.next())
    now_playing = self.guitar_sequence()
    local name = 'uneven-structure-' .. now_playing .. '.wav'
    -- function Sample:scrub(rate, start, amp)
    --self.sampler[now_playing]:scrub(1, self.offset_stream.next(), 1)
    sampler:get_by_name(name):scrub(
      self.rate.last(), 
      self.offset_stream.next(), 
      self.amp_stream.next() * 0.4,
      self.decay_stream.next(),
      self.interp(),
      self.len_stream.next(),
      0.5)
  end

  -- rerun the script
  if a == 800 then
    -- rerun()
  end

  self.arrow_of_time = self.arrow_of_time + 1

  fn.dirty_screen(true)

end

return conductor
