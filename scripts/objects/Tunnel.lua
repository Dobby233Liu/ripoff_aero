---@class Tunnel : Object
---@overload fun(self:Tunnel, ...) : Tunnel
local Tunnel, super = Class(Object)

function Tunnel:init()
    super.init(self, SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 320, 320)
    self:setParallax(0, 0)
    self:setOrigin(0.5, 0.5)
    self:setScale(2)
    self:setColor(Utils.hexToRgb("#3FBCDB"))

    self.depth_tex = love.graphics.newImage(Assets.getTextureData("DEPTH"), { linear = true, mipmaps = true })
    self.depth_tex:setMipmapFilter("linear")
    self.depth_tex:setWrap("mirroredrepeat", "mirroredrepeat")

    self.mesh = love.graphics.newMesh({
        {
            0, 0,
            0, 0,
            1, 1, 1
        },
        {
            self.width / 2, self.height / 2,
            1, 1,
            0, 0, 0
        },
        {
            self.width, 0,
            2, 0,
            1, 1, 1
        },
        {
            self.width, 0,
            0, 0,
            1, 1, 1
        },
        {
            self.width / 2, self.height / 2,
            1, 1,
            0, 0, 0
        },
        {
            self.width, self.height,
            2, 0,
            1, 1, 1
        },
        {
            0, self.height,
            0, 0,
            1, 1, 1
        },
        {
            self.width / 2, self.height / 2,
            1, 1,
            0, 0, 0
        },
        {
            self.width, self.height,
            2, 0,
            1, 1, 1
        },
        {
            0, 0,
            0, 0,
            1, 1, 1
        },
        {
            self.width / 2, self.height / 2,
            1, 1,
            0, 0, 0
        },
        {
            0, self.height,
            2, 0,
            1, 1, 1
        },
    }, "triangles")
    self.mesh:setTexture(self.depth_tex)

    self.sink_factor = 0

    self.canvas = love.graphics.newCanvas(self.width, self.height)
end

function Tunnel:onAdd(...)
    super.onAdd(self, ...)

    Draw.pushCanvas(self.canvas)
    love.graphics.clear(0, 0, 0, 0)
    Draw.popCanvas()
end

function Tunnel:update()
    for i = 0, 4 - 1 do
        self.mesh:setVertexAttribute(3*i + 1, 2, 0, -self.sink_factor)
        self.mesh:setVertexAttribute(3*i + 2, 2, 1, 1-self.sink_factor)
        self.mesh:setVertexAttribute(3*i + 3, 2, 2, -self.sink_factor)
    end

    self.sink_factor = Utils.clampWrap(self.sink_factor + DTMULT/2000, 0, 1)
end

function Tunnel:draw()
    if false then
        love.graphics.setColor(self:getDrawColor())
        love.graphics.draw(self.mesh)
        love.graphics.setColor(1, 1, 1)
    else
        Draw.pushCanvas(self.canvas)
        love.graphics.setColor(1, 1, 1, 1/15 * DTMULT)
        love.graphics.draw(self.mesh)
        Draw.popCanvas()

        love.graphics.setColor(self:getDrawColor())
        Draw.draw(self.canvas)
        love.graphics.setColor(1, 1, 1)
    end

    super.draw(self)
end

return Tunnel