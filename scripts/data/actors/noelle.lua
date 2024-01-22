local actor, super = Class("noelle", true)

function actor:init()
    super.init(self)

    self.path = "party/noelle/dark_b"

    self.animations["battle/spell_notn"] = {"battle/spell", 1/15, false}
    self.animations["battle/spell_special"] = {"battle/spell_special", 1/15, true}

    self.offsets["battle/spell_special"] = {-3, 0}
end

return actor