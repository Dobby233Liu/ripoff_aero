---@class FinishRaceBase : Wave
local FinishRaceBase, super = Class("Wave")

function FinishRaceBase:init()
    super.init(self)

    self.time = -1
    self.target_time = 0
end

function FinishRaceBase:onStart()
    Kristal.Console:log(self.id.." START target_time="..tostring(self.target_time))

    self.timer:after(self.target_time, function()
        Kristal.Console:log(self.id.." DONE wave_timer="..tostring(Game.battle.wave_timer))
        self.finished = true
    end)
end

function FinishRaceBase:onEnd()
    Kristal.Console:log(self.id.." FINISHED wave_timer="..tostring(Game.battle.wave_timer))
end

return FinishRaceBase