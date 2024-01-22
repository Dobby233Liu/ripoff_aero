---@class UIBox
local UIBox, super = Class("UIBox")

function UIBox:init(x, y, width, height, skin)
    super.init(self, x, y, width, height, skin)

    self.corner1 = Assets.getFramesOrTexture("ui/box/" .. self.skin .. "/corner1")
    self.corner2 = Assets.getFramesOrTexture("ui/box/" .. self.skin .. "/corner2")
    self.top1 = Assets.getFramesOrTexture("ui/box/" .. self.skin .. "/top1")
    self.top2 = Assets.getFramesOrTexture("ui/box/" .. self.skin .. "/top2")
    self.window_shine = Assets.getTexture("ui/box/" .. self.skin .. "/window_shine")
    self.glass_pane = Assets.getTexture("ui/box/" .. self.skin .. "/glass_pane")
    if self.glass_pane then
        self.glass_pane:setFilter("linear", "linear")
        local w,h = self.glass_pane:getDimensions()
        self.glass_pane_quad = love.graphics.newQuad(0, 0, w, h, w, h)
    end

    self.contrast = Kristal.getLibConfig("ripoff_aero", "contrast") or 0.4
    self.frostness = Kristal.getLibConfig("ripoff_aero", "frostness") or 0.125
end

function UIBox:draw()
    if self.skin ~= "aero" then
        super.draw(self)
        return
    end

    self.left_frame   = ((self.left_frame   + (DTMULT / self.speed)) - 1) % #self.left   + 1
    self.top_frame    = ((self.top_frame    + (DTMULT / self.speed)) - 1) % #self.top    + 1
    self.corner_frame = ((self.corner_frame + (DTMULT / self.speed)) - 1) % #self.corner + 1

    local left_width  = self.left[1]:getWidth()
    local left_height = self.left[1]:getHeight()
    local top1_width   = (self.top1 or self.top)[1]:getWidth()
    local top1_height  = (self.top1 or self.top)[1]:getHeight()
    local top2_width   = (self.top2 or self.top)[1]:getWidth()
    local top2_height  = (self.top2 or self.top)[1]:getHeight()

    local off_inner = 7*2
    local off_outer = 14*2
    local off_outer_c = off_outer - 1*2

    local  r, g, b, a = self:getDrawColor()
    -- r,g,b = unpack(Utils.hexToRgb("#9DA2C4"))
    local fr,fg,fb,fa  = unpack(self.fill_color)
    local whitened = Utils.lerp({1, 1, 1}, {r, g, b}, self.contrast)
    Draw.setColor(whitened, a*self.frostness)
    love.graphics.rectangle("fill", -off_outer_c, -off_outer_c, self.width+off_outer_c*2, self.height+off_outer_c*2)

    if self.glass_pane then
        local glass_realw, glass_realh = self.glass_pane:getDimensions()
        local glass_coverage_w, glass_coverage_h = self.width+off_outer_c*2, self.height+off_outer_c*2
        --glass_coverage_w, glass_coverage_h = SCREEN_WIDTH, SCREEN_HEIGHT
        local glass_scale = math.max(1, math.min(glass_coverage_w/glass_realw, glass_coverage_h/glass_realh))
        glass_coverage_w, glass_coverage_h = glass_coverage_w * glass_scale, glass_coverage_h * glass_scale
        local glass_w, glass_h = glass_realw * glass_scale, glass_realh * glass_scale
        self.glass_pane_quad:setViewport((glass_w-glass_coverage_w)/2, (glass_h-glass_coverage_h)/2, glass_coverage_w, glass_coverage_h, glass_w, glass_h)
        Draw.setColor(1,1,1,a)
        love.graphics.setBlendMode("add")
        Draw.draw(self.glass_pane, self.glass_pane_quad, self.width/2, self.height/2, 0, 1, 1, glass_coverage_w/2, glass_coverage_h/2)
        love.graphics.setBlendMode("alpha")
    end

    Draw.setColor(1, 1, 1, a)

    Draw.draw(self.left[math.floor(self.left_frame)], 0, 0, 0, 2, self.height / left_height, left_width, 0)
    Draw.draw(self.left[math.floor(self.left_frame)], self.width, 0, 0, -2, self.height / left_height, left_width, 0)

    Draw.draw((self.top1 or self.top)[math.floor(self.top_frame)], 0, 0, 0, self.width / top1_width, 2, 0, top1_height)
    Draw.draw((self.top2 or self.top)[math.floor(self.top_frame)], 0, self.height, math.pi, self.width / top2_width, 2, top2_width, top2_height)

    for i = 1, 4 do
        local cx, cy = self.corners[i][1] * self.width, self.corners[i][2] * self.height
        local sprite = ((self.corners[i][2] == 0 and self.corner1 or self.corner2) or self.corner)[math.floor(self.corner_frame)]
        local width  = 2 * ((self.corners[i][1] * 2) - 1) * -1
        local height = 2 * ((self.corners[i][2] * 2) - 1) * -1
        Draw.draw(sprite, cx, cy, 0, width, height, sprite:getWidth(), sprite:getHeight())
    end

    --[[if self.window_shine then
        Draw.setColor(1,1,1,a)
        local wshine_width = self.window_shine:getWidth()
        local wshine_height = self.window_shine:getHeight()
        Draw.draw(self.window_shine,
            -off_outer, -off_outer,
            0,
            math.floor((self.width+off_outer*2)/wshine_width), math.floor((self.height+off_outer*2)/wshine_height),
            0, 0)
    end]]

    Draw.setColor(fr,fg,fb,fa or a)
    love.graphics.rectangle("fill", -off_inner, -off_inner, self.width+off_inner*2, self.height+off_inner*2)

    ---@diagnostic disable-next-line: undefined-field
    super.super.draw(self)
end

--function UIBox:addFX() end

--[[function UIBox:draw()
    if self.skin ~= "darkx" then
        super.draw(self)
        return
    end

    self.left_frame   = ((self.left_frame   + (DTMULT / self.speed)) - 1) % #self.left   + 1
    self.top_frame    = ((self.top_frame    + (DTMULT / self.speed)) - 1) % #self.top    + 1
    self.corner_frame = ((self.corner_frame + (DTMULT / self.speed)) - 1) % #self.corner + 1

    local left_width  = self.left[1]:getWidth()
    local left_height = self.left[1]:getHeight()
    local top_width   = self.top[1]:getWidth()
    local top_height  = self.top[1]:getHeight()

    local axis_off = 0
    if self.skin == "dark" then axis_off = 17 end
    axis_off = axis_off * 2
    local shine_off = 0
    if self.skin == "dark" then shine_off = 18 end
    shine_off = shine_off * 2

    local  r, g, b,a = self:getDrawColor()
    local fr,fg,fb   = unpack(self.fill_color)
    Draw.setColor(r, g, b, a)
    love.graphics.rectangle("fill", -axis_off, -axis_off, self.width + axis_off * 2, self.height + axis_off * 2)

    Draw.setColor(r, g, b, a)

    Draw.draw(self.left[math.floor(self.left_frame)], -shine_off, -shine_off, 0, (self.width+shine_off*2)/left_width, (self.height+shine_off*2) / left_height, 0, 0)
    Draw.draw(self.left[math.floor(self.left_frame)], self.width+shine_off, -shine_off, 0, -(self.width+shine_off*2)/left_width, (self.height+shine_off*2) / left_height, 0, 0)

    Draw.setColor(fr, fg, fb, a)
    Draw.draw(self.top[math.floor(self.top_frame)], 0, 0, 0, self.width / top_width, 2, 0, top_height)
    Draw.draw(self.top[math.floor(self.top_frame)], 0, self.height, math.pi, self.width / top_width, 2, top_width, top_height)

    if self.shine_bar then
        local shine_width = self.shine_bar[1]:getWidth()
        local shine_height = self.shine_bar[1]:getHeight()
        Draw.draw(self.shine_bar[1], self.width/2, -shine_off, 0, (self.width + shine_off * 2)/shine_width, 2, shine_width/2, 0)
        Draw.draw(self.shine_bar[1], self.width/2, self.height + shine_off, 0, (self.width + shine_off * 2)/shine_width, 2, shine_width/2, shine_height)
    end

    super.super.draw(self)
end]]

return UIBox