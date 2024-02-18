return function(cutscene)
    local function waitTimer(handle)
        return cutscene:wait(function() return handle.count <= 0 end)
    end

    local player = Game.world.player

    local fake_kris = Game.world:spawnObject(Registry.createActor("kris_lw"):createSprite(), "below_soul")
    fake_kris:setScale(2)
    fake_kris:setOrigin(0.5, 1)
    local dist, dist_dir = Utils.pick({80, -80}), math.random(1)
    fake_kris:setPosition(player.x + (dist_dir == 0 and dist or 0), player.y + (dist_dir == 1 and dist or 0))
    fake_kris:setColor(0.7, 0.7, 1)
    fake_kris:set("walk/down")
    fake_kris.cutout_top = fake_kris.height

    local shadow = Game.world:spawnObject(Ellipse(fake_kris.x, fake_kris.y, 0, 0), fake_kris.layer - 0.5)
    shadow:setScale(2)
    shadow:setColor(0, 0, 0, 0.5)
    local exiting = false
    cutscene:during(function()
        if not shadow:isRemoved() and not fake_kris:isRemoved() then
            shadow.height = math.max(exiting and 0 or 1, math.min(math.floor(fake_kris.height - fake_kris.cutout_top), 5))
        end
    end)

    cutscene:playSound("swallow")
    Game.world.timer:tween(0.2, shadow, {width = fake_kris.width}, "in-cubic")
    cutscene:wait(0.25)

    local rumble = Game.world.timer:everyInstant(0.15, function() Assets.stopAndPlaySound("wing") end)
    waitTimer(Game.world.timer:tween(3, fake_kris, {cutout_top = 0}, "linear"))

    Game.world.timer:cancel(rumble)
    Assets.stopSound("wing")

    player:faceTowards(fake_kris)
    cutscene:wait(select(2, cutscene:alert(player, 0.5))) -- incomprehensible api

    exiting = true
    cutscene:playSound("petrify")
    waitTimer(Game.world.timer:tween(1, fake_kris, {cutout_top = fake_kris.height}, "out-sine"))

    fake_kris:remove()
    shadow:remove()
    cutscene:wait(1)

    player:setFacing("down")
end