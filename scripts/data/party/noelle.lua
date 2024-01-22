local character, super = Class("noelle", false)

function character:init()
    super.init(self)

    self.health = 166
    self.stats.health = 166

    self:addSpell("snowgrave")
end

return character