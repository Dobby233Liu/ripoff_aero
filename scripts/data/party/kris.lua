---@class PartyMember.kris : PartyMember
local character, super = Class("kris", false)

function character:init()
    super.init(self)

    self.health = 360
    self.stats.health = 360
end

return character