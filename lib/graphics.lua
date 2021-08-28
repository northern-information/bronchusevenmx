local graphics = {}

function graphics.init()
  screen.aa(0)
  screen.font_face(0)
  screen.font_size(8)
  graphics.screen_dirty = true
  graphics.fps = 15
end

function graphics:report()
  self:text(0, 10, "BRONCHUSEVENMX", 15)
  self:text(0, 20, conductor.arrow_of_time, 15)
end

function graphics:render()
  screen.clear()
  self:report()
  screen.update()
end

function graphics:mlrs(x1, y1, x2, y2, level)
  screen.level(level or 15)
  screen.move(x1, y1)
  screen.line_rel(x2, y2)
  screen.stroke()
end

function graphics:mls(x1, y1, x2, y2, level)
  screen.level(level or 15)
  screen.move(x1, y1)
  screen.line(x2, y2)
  screen.stroke()
end

function graphics:rect(x, y, w, h, level)
  screen.level(level or 15)
  screen.rect(x, y, w, h)
  screen.fill()
end

function graphics:circle(x, y, r, level)
  screen.level(level or 15)
  screen.circle(x, y, r)
  screen.fill()
end

function graphics:text(x, y, s, level)
  if s == nil then return end
  screen.level(level or 15)
  screen.move(x, y)
  screen.text(s)
end

return graphics