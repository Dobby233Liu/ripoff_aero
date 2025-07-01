local ExtendedEncounter, super = Class("Encounter")

function ExtendedEncounter:init()
    super.init(self)

    -- Disable Kristal background for custom background
    self.background = false

    -- Whether to create bg_drawer or not
    self.background_mine = true

    -- Background drawing object
    self.bg_drawer = BattleBGNormal
    self.bg_drawer_obj = nil
end

function ExtendedEncounter:ensureBGDrawerExists()
    if self.background_mine and self.bg_drawer_obj == nil then
        self.bg_drawer_obj = self.bg_drawer()
        Game.battle:addChild(self.bg_drawer_obj)
    end
end

function ExtendedEncounter:update()
    self:ensureBGDrawerExists()
end
function ExtendedEncounter:drawBackground(alpha) end

function ExtendedEncounter:beforeStateChange(old, new)
    super.beforeStateChange(self, old, new)
    self:ensureBGDrawerExists()
    self.bg_drawer_obj:onStateChange(old, new)
end

return ExtendedEncounter