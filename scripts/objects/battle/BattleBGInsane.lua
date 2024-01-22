local BattleBGInsane, super = Class("BattleBGNormal")

function BattleBGInsane:init()
    super.init(self)

    self.suppress_lines_offset_update = true

    self.is_insane = false

    -- NORMAL_IDLE, FADEIN, INSANE_IDLE, FADEOUT
    self.insane_state = "NORMAL_IDLE"
    -- temp variable for drawing previous state during FADEOUT
    self.insane_state_temp = ""

    self.insane_fade = 0
    self.insane_fade_extra_wait = 0.5

    self.static = Assets.getTexture("battle/common/bg_static")
    self.static_width = 356
    self.static_offset = 0

    self.victory = false
end

function BattleBGInsane:leEpicClamp(val, max)
    if val > max then
        return val - max
    end
    return val
end

function BattleBGInsane:update()
    super.update(self)

    local real_fade = math.min(self.insane_fade, 1)
    if self.insane_state ~= "FADEIN" then
        self.insane_fade = real_fade
    end
    if self.insane_state ~= "FADEOUT" then
        self.insane_state_temp = ""
    end

    self.lines_offset = self.lines_offset + (1 * DTMULT * (1 - math.max(0.1, real_fade)))
    self.lines_offset = self:leEpicClamp(self.lines_offset, self.lines_offset_loop)

    if self.insane_state == "INSANE_IDLE" or self.insane_state_temp == "INSANE_IDLE" then
        self.static_offset = self.static_offset + (12 * DTMULT * math.max(0.1, real_fade))
        self.static_offset = self:leEpicClamp(self.static_offset, self.static_width)
    else
        self.static_offset = 0
    end

    local showing_static = self.insane_state == "FADEIN" or self.insane_state == "INSANE_IDLE"
    if self.is_insane and not self.victory then
        if not showing_static then
            self.insane_state = "FADEIN"
        end
    elseif showing_static then
        self.insane_state_temp = self.insane_state
        self.insane_state = "FADEOUT"
    end

    if self.insane_state == "FADEIN" then
        local dest = 1 + self.insane_fade_extra_wait
        self.insane_fade = Utils.approach(self.insane_fade, dest, DTMULT / 30)
        if self.insane_fade >= dest then
            self.insane_fade = 1
            self.insane_state = "INSANE_IDLE"
        end
    elseif self.insane_state == "FADEOUT" then
        self.insane_fade = Utils.approach(real_fade, 0, DTMULT / ((self.insane_state_temp == "FADEIN" or self.victory) and 30 or 60))
        if self.insane_fade <= 0 then
            self.insane_state = "NORMAL_IDLE"
        end
    end
end

function BattleBGInsane:onStateChange(old, new)
    super.onStateChange(self, old, new)

    if new == "VICTORY" then
        self.victory = true
    end
end

function BattleBGInsane:fillScreen(r, g, b, a)
    local dr, dg, db, da = love.graphics.getColor()
    love.graphics.setColor(r, g, b, a)
    love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    love.graphics.setColor(dr, dg, db, da)
end

function BattleBGInsane:drawBackground(alpha)
    super.drawBackground(self, alpha)

    local draw_state = self.insane_state == "FADEOUT" and self.insane_state_temp or self.insane_state
    local real_alpha = alpha * math.min(self.insane_fade, 1)

    if draw_state == "INSANE_IDLE" then
        self:fillScreen(0, 0, 0, real_alpha)
        love.graphics.setColor(1, 1, 1, real_alpha * 0.25)
        for i = -self.static_offset, 640, self.static_width do
            love.graphics.draw(self.static, i, 0, 0, 1, 1)
        end
    end
    if draw_state == "FADEIN" then
        self:fillScreen(0.9, 0.9, 0.9, real_alpha)
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return BattleBGInsane