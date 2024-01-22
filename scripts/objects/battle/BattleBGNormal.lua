local BattleBGNormal, super = Class("BattleBGBase")

function BattleBGNormal:init()
    super.init(self)

    self.lines_offset = 0
    self.lines_offset_loop = 100
    self.suppress_lines_offset_update = false
end

function BattleBGNormal:update()
    super.update(self)

    if not self.suppress_lines_offset_update then
        self.lines_offset = self.lines_offset + 1 * DTMULT

        if self.lines_offset > self.lines_offset_loop then
            self.lines_offset = self.lines_offset - self.lines_offset_loop
        end
    end
end

function BattleBGNormal:drawBackground(alpha)
    super.drawBackground(self, alpha)

    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(1)

    for i = 2, 16 do
        love.graphics.setColor(66 / 255, 0, 66 / 255, alpha / 2)
        love.graphics.line(0, -210 + (i * 50) + math.floor(self.lines_offset / 2), 640, -210 + (i * 50) + math.floor(self.lines_offset / 2))
        love.graphics.line(-200 + (i * 50) + math.floor(self.lines_offset / 2), 0, -200 + (i * 50) + math.floor(self.lines_offset / 2), 480)
    end

    for i = 3, 16 do
        love.graphics.setColor(66 / 255, 0, 66 / 255, alpha)
        love.graphics.line(0, -100 + (i * 50) - math.floor(self.lines_offset), 640, -100 + (i * 50) - math.floor(self.lines_offset))
        love.graphics.line(-100 + (i * 50) - math.floor(self.lines_offset), 0, -100 + (i * 50) - math.floor(self.lines_offset), 480)
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return BattleBGNormal