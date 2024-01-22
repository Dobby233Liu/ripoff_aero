local BattleBGParent, super = Class(Object)

function BattleBGParent:init()
    super.init(self)

    self.layer = BATTLE_LAYERS["bottom"]
    self.fill = {0, 0, 0}
    self.fade = 0
end

function BattleBGParent:update()
    super.update(self)
    self.fade = Game.battle.transition_timer / 10
end
function BattleBGParent:onStateChange(old, new) end

function BattleBGParent:drawBackground(alpha)
    local r, g, b = unpack(self.fill)
    love.graphics.setColor(r, g, b, alpha)
    love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    love.graphics.setColor(1, 1, 1, 1)
end
function BattleBGParent:draw()
    self:drawBackground(self.fade)
end

return BattleBGParent