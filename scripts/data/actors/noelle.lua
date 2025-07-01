local actor, super = Class("noelle", true)

function actor:init()
    super.init(self)

    self.animations["battle/pet_ready"] = self.animations["battle/act_ready"]
    self.animations["battle/pet"] = self.animations["battle/act"]
    self.animations["battle/spell_notn"] = {"battle/spell", 1/15, false}
    self.animations["battle/spell_special"] = {"battle/spell_special", 1/15, true}

    self.offsets["battle/spell_special"] = {-3, 0}
end

return actor