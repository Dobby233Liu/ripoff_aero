local actor, super = Class("kris", true)

function actor:init()
    super.init(self)

    self.animations["battle/pet_ready"] = self.animations["battle/act_ready"]
    self.animations["battle/pet"] = self.animations["battle/act"]
end

return actor