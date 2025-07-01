local Dummy, super = Class(EnemyBattler)

function Dummy:init()
    super.init(self)

    -- Enemy name
    self.name = "Dummy"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("dummy")

    -- Enemy health
    self.max_health = 450
    self.health = 450
    -- Enemy attack (determines bullet damage)
    self.attack = 0
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 100

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "empty"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {}

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "Enemy Weakness - ICE\nUse your most powerful ice spell."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        ""
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = ""

    self:registerAct("Pet")
end

function Dummy:onAct(battler, name)
    if name == "Pet" or name == "Standard" then
        Game.battle:pushForcedAction(battler, "PET", self)
        return "* User will attack"
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

return Dummy