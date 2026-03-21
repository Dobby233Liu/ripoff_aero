---@param self WorldCutscene
return function(self)
    if #Game.world.stage:getObjects(ScreenChannelChangeFXTester) == 0 then
        Game.world:spawnObject(ScreenChannelChangeFXTester())
    end
end
