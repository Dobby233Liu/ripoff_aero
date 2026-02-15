---@class AfterImageScreen : Object
---@overload fun(...) : AfterImageScreen
local AfterImageScreen, super = Class(Object)

function AfterImageScreen.snapScreen()
    return love.graphics.newImage(SCREEN_CANVAS:newImageData())
end

function AfterImageScreen:init(screenshot, ox, oy, fade, speed)
    super.init(self, 0, 0, screenshot:getWidth(), screenshot:getHeight())

    self.screenshot = screenshot
    self.release_screenshot = true

    self.alpha = fade
    self:fadeOutSpeedAndRemove(speed)

    self:setScaleOriginExact(ox, oy)
    self:setRotationOriginExact(ox, oy)
end

function AfterImageScreen:onRemove()
    if self.release_screenshot then
        self.screenshot:release()
    end
    self.screenshot = nil
end

function AfterImageScreen:applyTransformTo(transform)
    if self.parent then
        transform:reset()
    end
    super.applyTransformTo(self, transform)
end

function AfterImageScreen:draw()
    Draw.draw(self.screenshot)
    super.draw(self)
end

return AfterImageScreen
