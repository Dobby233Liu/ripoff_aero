-- Based on code from:
-- https://github.com/Bronya-Rand/DDLCModTemplate2.0/blob/1c7a92bd38dd6a81fc915bb0de9ebcaafdde91aa/game/definitions/effects.rpy#L117
return function(c)
    c:wait(10/30)
    local img = Game.stage:addChild(TearFX:makeTearingScreen())
    c:wait(3)
    img:remove()
end