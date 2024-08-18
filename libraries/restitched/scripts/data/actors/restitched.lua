local Restitched, super = Class(Actor, "restitched")

function Restitched:init()
    super.init(self)
    self.name = "Spamton Restitched"
    self.width, self.height = 50, 84
    self.hitbox = {12,41, 30,40}
    self.path = "npcs/restitched"
    self.voice = "sneo"
    self.flip = "right"
end

function Restitched:createSprite()
    return RestitchedActor(self)
end

return Restitched