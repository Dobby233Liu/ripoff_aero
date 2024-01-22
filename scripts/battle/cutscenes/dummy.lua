return {
    snowgrave = function(cutscene, charaId)
        local user = Game.battle.party[charaId]
        Game:getActiveMusic():fade(0, 3)
        cutscene:wait(4)
        cutscene:setAnimation(user, "battle/spell_special")
        user:flash()
        cutscene:wait(1)

        local sg_xs = user.x
        local sg_ys = user.y
        local sg_object = nil
        local sg_timer = 0
        local sg_bell_timer = 0
        local sg_amplitude = 0
        cutscene:wait(function()
            sg_amplitude = Utils.approach(sg_amplitude, 1, DTMULT * 0.3)
            
            if user.y > (sg_ys - 70) then
                user.y = user.y - (sg_amplitude * DTMULT)
                user.x = user.x + (sg_amplitude * 2.94 * DTMULT)
            end
            
            user.x = user.x + (math.sin((sg_timer / 3)) * DTMULT * sg_amplitude)
            user.y = user.y + (math.cos((sg_timer / 3)) * DTMULT * sg_amplitude)
            
            if sg_bell_timer >= 4 and sg_timer < 70 then
                sg_bell_timer = sg_bell_timer - 4
                Assets.playSound("bell", 0.5, 0.5 + Utils.random(0.3))
                local sp = Sprite("battle/snowgrave/shine")
                sp:setAnimation({"battle/snowgrave/shine", 1/60, true})
                sp:setScaleOrigin(0, 0)
                sp:setRotationOrigin(0, 0)
                local dust = AfterImage(sp, 3, 0.1)
                dust.layer = user.layer
                dust.x = user.x + 25
                dust.y = user.y - 50
                dust.physics.speed = (Utils.random(2) + 1)
                dust.physics.direction = Utils.random(0, 180)
                dust.physics.gravity = (0.2 + Utils.random(0.3))
                dust.physics.gravity_direction = Utils.random(70, 110)
                dust.scale_x = 1
                dust.scale_y = 1
                dust.graphics.grow = 0.2
                Game.battle:addChild(dust)
            end
            sg_timer = sg_timer + DTMULT
            sg_bell_timer = sg_bell_timer + DTMULT

            if sg_timer >= 70 and sg_object == nil then
                sg_object = SnowGraveSpellDooby(u) -- customized version with timing changes
                sg_object.damage = math.ceil(((user.chara:getStat("magic") * 40) + 600))
                sg_object.layer = BATTLE_LAYERS["above_ui"]
                sg_object.donotend = true
                Game.battle:addChild(sg_object)
            end
            return sg_timer > 210 and sg_object ~= nil
        end)

        cutscene:setSprite(user, "battle/spell", 0)
        user.sprite:setFrame(3)
        user.overlay_sprite:setFrame(3)
        -- ???
        user.sprite:stop(true)
        user.overlay_sprite:stop(true)
        user.physics.gravity = 1
        cutscene:wait(function()
            return user.y >= (sg_ys - 6)
        end)
        user.physics.speed = 0
        user.physics.speed_x = 0
        user.physics.speed_y = 0
        user.physics.gravity = 0

        cutscene:setSprite(user, "battle/defeat", 0)
        local shakeActorSprite = function(spr, sx, sy)
            spr.shake_x = sx
            spr.shake_y = sy
        end
        shakeActorSprite(user.sprite, 10, 0)
        shakeActorSprite(user.overlay_sprite, 10, 0)
        cutscene:wait(1)
        Game.battle.battle_ui.encounter_text:advance()
        cutscene:wait(3)

        local speaker = user.actor
        cutscene:setSpeaker(speaker)
        cutscene:text("* ...", "", speaker)
        user.sprite.flip_x = true
        user.overlay_sprite.flip_x = true
        cutscene:text("* What...", "", speaker)
        cutscene:text("* What happened?", "", speaker)
        cutscene:text("* There was so much snow,[wait:1] I couldn't see anything...", "", speaker)
        cutscene:text("* I...", "", speaker)
        user.sprite.flip_x = false
        user.overlay_sprite.flip_x = false
        cutscene:setSprite(user, "walk/up", 0)
        -- ???
        user.sprite:stop(true)
        user.overlay_sprite:stop(true)
        cutscene:wait(4)
        cutscene:text("* I don't feel so good.", "", speaker)
        cutscene:text("* I think", "", speaker)
        cutscene:text("* I'm going to go home.", "", speaker)

        cutscene:setSprite(user, "walk/up", 1/2)
        sg_timer = 0
        user.physics.speed_y = -1
        cutscene:wait(function()
            user.x = user.x + (math.sin((sg_timer / 2)) * 0.7 * DTMULT)
            sg_timer = sg_timer + DTMULT
            return sg_timer > 320
        end)

        cutscene:after(function()
            Game.battle.encounter.no_end_message = true
            Game.battle:finishActionBy(user)
            Game.battle.party[charaId]:remove()
            table.remove(Game.battle.party, charaId)
            Game:removePartyMember(user.chara)
            Game.battle.battle_ui:transitionOut()
            Game.battle.current_selecting = 0
            Game.battle.tension_bar.animating_in = false
            Game.battle.tension_bar.shown = false
            Game.battle.tension_bar.physics.speed_x = -10
            Game.battle.tension_bar.physics.friction = -0.4
            for _,battler in ipairs(Game.battle.party) do
                battler:setSleeping(false)
                battler.defending = false
                battler.action = nil
    
                if battler.chara.health < 1 then
                    battler:revive()
                    battler.chara:setHealth(Utils.round(battler.chara:getStat("health") / 8))
                end
    
                battler:setAnimation("battle/victory")
    
                local box = Game.battle.battle_ui.action_boxes[Game.battle:getPartyIndex(battler.chara.id)]
                box:resetHeadIcon()
            end
            Game.battle.timer:after(4, function()
                Game.battle:setState("VICTORY")
            end)
        end)
    end
}