return function(c)
    local chara = c:getCharacter("kris")
    chara:setFacing("down")

    local t_wait, _
    t_wait, _ = c:text("* 111111111", {wait=false})
    while not t_wait(c) do -- or just something like `for i = 1, 3 do` if text is not needed

        -- (re)play the animation (things will get complex if you let the engine loop it)
        chara:setAnimation({"walk/down", 0.5, false})
        -- wait for frame (animation might be too fast for frame to be exactly 2)
        c:wait(function() return chara.sprite.frame >= 2 end)
        c:playSound("impact")
        c:shakeCamera(4, 4, 0.5)

        -- wait for textbox or animation to end
        c:wait(function()
            return t_wait(c) or (not chara.sprite.playing)
        end)
        -- or just c:wait(function() return not chara.sprite.playing end)
    end

    chara:resetSprite()
end
