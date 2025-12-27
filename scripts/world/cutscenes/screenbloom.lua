return function(c)
    local lw_to_dw = 2

    ---@type ScreenBloomFX
    local bloom_fx = Game.world:addFX(ScreenBloomFX(), "bloom_fx")
    bloom_fx.style = 2
    bloom_fx.distance = 0.5 * lw_to_dw
    bloom_fx.amplitude = 2 * lw_to_dw
    bloom_fx.period = 10
    bloom_fx.x_off = 1 * lw_to_dw
    bloom_fx.y_off = 1 * lw_to_dw

    Input.clear("confirm")
    c:wait(function()
        if Input.pressed("confirm") and not OVERLAY_OPEN then
            Input.clear("confirm")
            return true
        end
    end)

    Game.world:removeFX("bloom_fx")
end