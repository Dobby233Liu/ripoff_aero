function Mod:getUISkin()
    return "aero"
end

Mod.WAVY_LAKE = modRequire("ultimate_wave")

function Mod:postInit()
    --[[Game.world:addFX(ShaderFX(Mod.WAVY_LAKE, {
        sine = function() return Kristal.getTime() end,
        texture_dim = {SCREEN_WIDTH, SCREEN_HEIGHT},
        clamp_chunk_dim = 0,
        freq = 8,
        mag = 8,
        thickness = {1, 0},
        ref_other_axis = true
    }))]]
end

---@param battler PartyBattler
function Mod:onBattleAction(action, action_name, battler, enemy)
    local battle = Game.battle

    if action_name == "PET" then
        local attacksound = nil
        local attackpitch = battler.chara:getAttackPitch()
        local src = Assets.stopAndPlaySound(attacksound or "stardrop")
        src:setPitch(attackpitch or 1)

        battle.actions_done_timer = 1.2

        local crit = action.points == 150
        if crit then
            -- do something
        end

        battler:setAnimation("battle/pet", function()
            action.icon = nil

            if action.target and action.target.done_state then
                enemy = battle:retargetEnemy()
                action.target = enemy
                if not enemy then
                    battle.cancel_attack = true
                    battle:finishAction(action)
                    return
                end
            end

            local damage = Utils.round(action.damage or (action.points or 0) / 5)
            if damage < 0 then
                damage = 0
            end

            if damage > 0 then
                Game:giveTension(Utils.round(enemy:getAttackTension(action.points or 100))) -- todo

                local attacksprite = nil
                local dmg_sprite = Sprite(attacksprite or "effects/attack/slap_n")
                dmg_sprite:setOrigin(0.5, 0.5)
                if crit then
                    dmg_sprite:setScale(2.5, 2.5)
                else
                    dmg_sprite:setScale(2, 2)
                end
                local relative_pos_x, relative_pos_y = enemy:getRelativePos(enemy.width/2, enemy.height/2)
                dmg_sprite:setPosition(relative_pos_x + enemy.dmg_sprite_offset[1], relative_pos_y + enemy.dmg_sprite_offset[2])
                dmg_sprite:setLayer(enemy.layer + 0.01)
                dmg_sprite.battler_id = action.character_id or nil
                table.insert(enemy.dmg_sprites, dmg_sprite)
                local dmg_anim_speed = 1/15
                dmg_sprite:play(dmg_anim_speed, false, function(s) s:remove(); Utils.removeFromTable(enemy.dmg_sprites, dmg_sprite) end) -- Remove itself and Remove the dmg_sprite from the enemy's dmg_sprite table when its removed
                enemy.parent:addChild(dmg_sprite)
            end
            enemy:addMercy(damage)

            battle:finishAction(action)

            Utils.removeFromTable(battle.normal_attackers, battler)
            Utils.removeFromTable(battle.auto_attackers, battler)

            if not battle:retargetEnemy() then
                battle.cancel_attack = true
            elseif #battle.normal_attackers == 0 and #battle.auto_attackers > 0 then
                local next_attacker = battle.auto_attackers[1]

                local next_action = battle:getActionBy(next_attacker, true)
                if next_action then
                    battle:beginAction(next_action)
                    battle:processAction(next_action)
                end
            end
        end)

        return false
    end
end