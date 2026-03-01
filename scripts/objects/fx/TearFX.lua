-- Based on code from:
-- https://github.com/Bronya-Rand/DDLCModTemplate2.0/blob/1c7a92bd38dd6a81fc915bb0de9ebcaafdde91aa/game/definitions/effects.rpy#L117
---@class TearFX : FXBase
local TearFX, super = Class("FXBase")

function TearFX:init(width, height, tears, off_time_mult, on_time_mult, x_off_min, x_off_max, priority)
    super.init(self, priority or 150)

    self.tears = 10

    self.tear_area_lim = 10

    self.off_time_base = 0.2
    self.off_time_mult = 1
    self.on_time_base = 0.2
    self.on_time_mult = 1

    self.tex_y_off = -1

    self.x_off_min = 0
    self.x_off_max = 50

    self.width = width
    self.height = height
    self:createPieces(tears, off_time_mult, on_time_mult, x_off_min, x_off_max)

    self.screen_time = 0
end

function TearFX:makeTearingScreen(tears, off_time_mult, on_time_mult, x_off_min, x_off_max)
    local spr = Sprite(love.graphics.newImage(SCREEN_CANVAS:newImageData()))
    spr:addFX(self(spr.width, spr.height, tears, off_time_mult, on_time_mult, x_off_min, x_off_max), "tear")
    return spr
end

---@class TearFX.Piece
---@field quad love.Quad
---@field x number
---@field y number
---@field off_time number
---@field on_time number

function TearFX:createPieces(tears, off_time_mult, on_time_mult, x_off_min, x_off_max)
    self.tears = tears or self.tears
    self.off_time_mult = off_time_mult or self.off_time_mult
    self.on_time_mult = on_time_mult or self.on_time_mult
    self.x_off_min = x_off_min or self.x_off_min
    self.x_off_max = x_off_max or self.x_off_max

    local tear_points = {0, self.height}
    for _ = 1, self.tears do
        table.insert(tear_points, MathUtils.randomInt(self.tear_area_lim, self.height - self.tear_area_lim))
    end
    table.sort(tear_points)

    ---@type TearFX.Piece[]
    self.pieces = {}
    for i = 1, math.max(0, #tear_points - 1) do
        local start = tear_points[i]
        local ending = tear_points[i + 1]
        local y = math.max(0, self.tex_y_off + start)
        local h = math.max(0, ending - start)
        table.insert(self.pieces, {
            quad = love.graphics.newQuad(0, y, self.width, h, self.width, self.height),
            x = 0,
            y = start,
            off_time = self.off_time_base * self.off_time_mult * (1 + MathUtils.random()),
            on_time = self.on_time_base * self.on_time_mult * (1 + MathUtils.random())
        })
    end
end

---@param piece TearFX.Piece
function TearFX:updatePiece(piece)
    local timer = self.screen_time % (piece.off_time + piece.on_time)
    if timer > piece.off_time then
        if piece.x == 0 then
            piece.x = MathUtils.randomInt(self.x_off_min, self.x_off_max)
        end
    else
        piece.x = 0
    end
end

function TearFX:draw(drawable)
    Draw.draw(drawable)

    for _, piece in ipairs(self.pieces) do
        self:updatePiece(piece)
        Draw.draw(drawable, piece.quad, piece.x, piece.y)
    end

    self.screen_time = self.screen_time + DT
end

return TearFX
