---@class Tunnel : Object
---@overload fun(self:Tunnel, ...) : Tunnel
local Tunnel, super = Class(Object)

function Tunnel:init()
    local scale = 2
    local size = math.max(SCREEN_WIDTH, SCREEN_HEIGHT) / scale
    super.init(self, SCREEN_WIDTH/2, SCREEN_HEIGHT/2, size, size)
    self:setParallax(0, 0)
    self:setOrigin(0.5, 0.5)
    self:setScale(scale)
    self:setColor(Utils.hexToRgb("#3FBCDB"))

    self.depth_tex = love.graphics.newImage(Assets.getTextureData("DEPTH"), { linear = true, mipmaps = true })
    self.depth_tex:setMipmapFilter("linear")
    self.depth_tex:setWrap("mirroredrepeat", "mirroredrepeat")

    self.right = 1
    local left_adjust = self.right
    self.mesh = love.graphics.newMesh({
        {   -- top
            0, 0,
            0, 0,
            1, 1, 1
        },
        {
            self.width / 2, self.height / 2,
            self.right/2, 1,
            0, 0, 0
        },
        {
            self.width, 0,
            self.right, 0,
            1, 1, 1
        },

        {   -- right
            self.width, 0,
            left_adjust+0, 0,
            1, 1, 1
        },
        {
            self.width / 2, self.height / 2,
            left_adjust+self.right/2, 1,
            0, 0, 0
        },
        {
            self.width, self.height,
            left_adjust+self.right, 0,
            1, 1, 1
        },

        {   -- bottom
            0, self.height,
            left_adjust+0, 0,
            1, 1, 1
        },
        {
            self.width / 2, self.height / 2,
            left_adjust+self.right/2, 1,
            0, 0, 0
        },
        {
            self.width, self.height,
            left_adjust+self.right, 0,
            1, 1, 1
        },

        {   -- left
            0, 0,
            0, 0,
            1, 1, 1
        },
        {
            self.width / 2, self.height / 2,
            self.right/2, 1,
            0, 0, 0
        },
        {
            0, self.height,
            self.right, 0,
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
        local left_adjust = 0
        if i == 1 or i == 2 then left_adjust = self.right end
        self.mesh:setVertexAttribute(3*i + 1, 2, left_adjust+0, -self.sink_factor)
        self.mesh:setVertexAttribute(3*i + 2, 2, left_adjust+self.right/2, 1-self.sink_factor)
        self.mesh:setVertexAttribute(3*i + 3, 2, left_adjust+self.right, -self.sink_factor)
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