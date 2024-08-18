return function(cs)
    --[[while true do
        Game.world.player:explode(0, 0, true)
        cs:wait(0.5)
    end]]
    Game.world:spawnObject(Tunnel())
end