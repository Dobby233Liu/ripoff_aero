return function(cutscene)
    local cb, waitCb
    local function createWaitCallback()
        local done = false
        return function() done = true end, function() return done end
    end

    local player = Game.world.player

    local fake_kris = Game.world:spawnObject(Registry.createActor("kris_lw"):createSprite(), "below_soul")
    fake_kris:setScale(2)
    fake_kris:setOrigin(0.5, 1)
    local away = Utils.pick({80, -80})
    local away_x, away_y = 0, 0
    if math.random(1) == 0 then away_x = away else away_y = away end
    fake_kris:setPosition(player.x + away_x, player.y + away_y)
    fake_kris:setColor(0.8, 0.8, 1)
    fake_kris:set("walk")
    fake_kris:setFacing("down")
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

    cb, waitCb = createWaitCallback()
    cutscene:playSound("bump", 0.95)
    Game.world.timer:tween(0.2, shadow, {width = fake_kris.width}, "in-cubic", cb)
    cutscene:wait(waitCb)

    cb, waitCb = createWaitCallback()
    Game.world.timer:tween(3, fake_kris, {cutout_top = 0}, "linear", cb)
    local rumble = Game.world.timer:everyInstant(0.2, function() Assets.stopAndPlaySound("wing") end)
    cutscene:wait(waitCb)
    Game.world.timer:cancel(rumble)
    Assets.stopSound("wing")

    player:faceTowards(fake_kris)
    cb, waitCb = createWaitCallback()
    player:alert(0.5, {callback = cb})
    cutscene:wait(waitCb)

    cb, waitCb = createWaitCallback()
    exiting = true
    cutscene:playSound("petrify")
    Game.world.timer:tween(1, fake_kris, {cutout_top = fake_kris.height}, "out-sine", cb)
    cutscene:wait(waitCb)

    fake_kris:remove()
    shadow:remove()
    cutscene:wait(1)

    player:setFacing("down")
end