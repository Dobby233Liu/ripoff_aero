local LavaWaverBG, super = Class(Event)

function LavaWaverBG:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    self.bg_tex = Assets.getTexture(properties["texture"] or "world/events/lavabg")
    self.debug_select = false
    self.shader = Assets.getShader("lavawave")
end

function LavaWaverBG:draw()
    super.draw(self)
    if self.world.color == COLORS.black then return    end
    local lava_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
    Draw.drawWrapped(self.bg_tex, true, true)
    Draw.popCanvas(true)
    self.shader:send("wave_sine", Kristal.getTime() * 90)
    self.shader:send("wave_mag", 6)
    self.shader:send("wave_height", 10)
    self.shader:send("texsize", { SCREEN_WIDTH, SCREEN_HEIGHT })
    self.alpha = 0.80 + self.world.map.lava_alpha
    love.graphics.setShader(self.shader)
    Draw.drawWrapped(lava_canvas, true, true)
    love.graphics.setShader()
    Draw.setColor(1,1,1,1)
end

return LavaWaverBG
