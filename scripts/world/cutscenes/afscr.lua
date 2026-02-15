return function(c)
    c:enableMovement()
    c:wait(1)

    local hndl = Game.world.timer:every(1/30, function()
        local anchor_x, anchor_y = Game.world:localToScreenPos(550 + MathUtils.random(-30, 30), 240 + MathUtils.random(-30, 30))
        local screen = AfterImageScreen.snapScreen()
        local af = AfterImageScreen(screen, anchor_x, anchor_y, 0.5, 0.05)
        af.layer = Game.world.layer + 10
        af.graphics.grow_x = 0.01
        af.graphics.grow_y = 0.01
        af.debug_select = false
        Game.stage:addChild(af)
    end)
    c:after(function() Game.world.timer:cancel(hndl) end)

    Input.clear("cancel")
    c:wait(function()
        if Input.pressed("cancel") and not OVERLAY_OPEN then
            Input.clear("cancel")
            return true
        end
    end)
end
