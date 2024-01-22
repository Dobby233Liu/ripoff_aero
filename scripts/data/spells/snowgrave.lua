local spell, super = Class("snowgrave", false)

function spell:getTPCost(chara)
    if Game.battle.encounter:getSpellCutscene(self.id) ~= nil then
        return 0
    end
    return getTPCost(self, chara)
end

function spell:onCast(user, target)
    if Game.battle.encounter.onSnowgrave ~= nil and not Game.battle.encounter:onSnowgrave() then
        return false
    end

    return onCast(self, user, target)
end

function spell:onStart(user, target)
    if Game.battle.encounter.getSpellCutscene ~= nil then
        local cutscene = Game.battle.encounter:getSpellCutscene(self.id)
        if cutscene ~= nil then
            Game.battle.encounter.backup_current_selecting = Game.battle:getCurrentAction().character_id
            Game.battle.encounter.backup_current_menu_x = Game.battle.current_menu_x
            Game.battle.encounter.backup_current_menu_y = Game.battle.current_menu_y
            Game.battle:startCutscene(cutscene, user, target)
            Game.battle:finishActionBy(user)
            return
        end
    end

    Game.battle:battleText(self:getCastMessage(user, target))
    user:setAnimation(Game.battle.encounter.onSnowgrave ~= nil and "battle/spell_notn" or "battle/spell", function()
        local result = self:onCast(user, target)
        if result or result == nil then
            Game.battle:finishActionBy(user)
        end
    end)
end

return spell