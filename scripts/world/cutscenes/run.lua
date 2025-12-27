return function(c)
    local rfx = Game.world:addFX(RecolorFX(1, 0, 0))
    c:enableMovement()
    c:disableMovement()
    c:wait(10)
    Game.world:removeFX(rfx)
end