return function(cs)
    if not Game:getFlag("quicksave_flag_test") then
        cs:text("I tend to be sigma 24/7 but there are exceptions yaknow")
        Game:setFlag("quicksave_flag_test", true)
        Game:saveQuick()
        Game:gameOver(Game.world.player:localToScreenPos(0, 0))
    else
        cs:text("Well you know it by now don't you")
    end
end