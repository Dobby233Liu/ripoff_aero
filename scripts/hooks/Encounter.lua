---@class Encounter
local Encounter, super = Utils.hookScript("Encounter")

function Encounter:beforeStateChange(old, new)
    if new == "ATTACKING" then
        local battle = Game.battle

        local enemies_left = battle:getActiveEnemies()

        if #enemies_left > 0 then
            for i,battler in ipairs(battle.party) do
                local action = battle.character_actions[i]
                if action and action.action == "PET" then
                    battle:beginAction(action)
                    table.insert(battle.attackers, battler)
                    table.insert(battle.normal_attackers, battler)
                end
            end
        end
    end

    return super.beforeStateChange(self, old, new)
end

function Encounter:addEnem(...)
    self:addEnemy(...)
end

return Encounter