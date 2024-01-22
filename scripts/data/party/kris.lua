local character, super = Class("kris", false)

function character:init()
    super.init(self)

    self.health = 160
    self.stats.health = 160
end

return character