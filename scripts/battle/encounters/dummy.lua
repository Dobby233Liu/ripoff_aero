local Dummy, super = Class(Encounter)

function Dummy:init()
    super.init(self)

    -- Set TP to MAX
    Game.tension = 100

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* Dummy blocks the way!"

    -- Battle music
    self.music = "berdly_battle_heartbeat_true"

    -- Add the dummy enemy to the encounter
    self:addEnemy("dummy")

    -- Select cutscene dialogue phase
    self.sg_con = 0

    -- Disable all SnowGrave cutscenes
    self.yeetus = false
end

function Dummy:getSpellCutscene(id)
    local returnToSpellMenu = function(cutscene)
        cutscene:after(function()
            Game.battle.current_selecting = Game.battle.encounter.backup_current_selecting
            Game.battle:setState("MENUSELECT", "SPELL")
            Game.battle.current_menu_x = Game.battle.encounter.backup_current_menu_x
            Game.battle.current_menu_y = Game.battle.encounter.backup_current_menu_y
        end)
    end

    if id == "snowgrave" and not self.yeetus then
        if self.sg_con < 4 then
            return function(cutscene, user, target)
                local speaker = user.actor
                cutscene:setSpeaker(speaker)
                if self.sg_con == 0 then
                    cutscene:text("* S...[wait:5] Snowgrave?", "sad_side", speaker)
                    cutscene:text("* I...[wait:5] I don't know that spell.", "down", speaker)
                elseif self.sg_con == 1 then
                    cutscene:text("* I'm telling you,[wait:5] I...[wait:5] I...", "down", speaker)
                    cutscene:text("* I don't know what you're talking about.", "upset_down", speaker)
                elseif self.sg_con == 2 then
                    cutscene:text("* I'm telling you,[wait:5] stop!", "upset_down", speaker)
                    cutscene:text("* I... I don't know what you're talking about!", "sad", speaker)
                else
                    cutscene:text("* ...", "upset_down", speaker)
                    cutscene:text("* Fine.[wait:5] You want to see what happens so bad?", "upset_side", speaker)
                    cutscene:text("* Watch what happens when I cast a spell I don't know!", "upset", speaker)
                end
                self.sg_con = self.sg_con + 1
                cutscene:wait(1/3)
                returnToSpellMenu(cutscene)
            end
        end
    end
    return nil
end

function Dummy:onSnowgrave()
    if not self.yeetus then
        Game.battle:startCutscene("dummy.snowgrave", Game.battle:getCurrentAction().character_id)
        return false
    end
    return true
end

return Dummy