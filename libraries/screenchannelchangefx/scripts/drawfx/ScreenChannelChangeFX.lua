---@class ScreenChannelChangeFX : FXBase
--- Port of obj_screen_channel_change from Chapter 3; only represents the final version
---@overload fun(priority: number): ScreenChannelChangeFX
local ScreenChannelChangeFX, super = Class("FXBase")

function ScreenChannelChangeFX:init(priority)
    super.init(self, priority)

    self.base_strength = 200
    self.base_lifetime = 7
    -- In pixels
    self.strength = self.base_strength
    self.lifetime = self.base_lifetime

    self.timer = 0

    self.scroll = false
    self.scroll_speed = 5
    self.scroll_dir = MathUtils.randomInt(1 + 1) * 2 - 1

    self.scan_x = 0
    -- In pixels
    self.scan_x_brd = 40
    self.scan_x_init = false

    self.shuffle = true
    self.scan_x_shuffle_init = false
    self.infinite = false

    self.old_screen_surf = nil
    self.wait_for_old_surf_to_be_prepared = false

    self.static_effect = Assets.getFrames("effects/static_effect")
    self.channel_shader = Assets.getShader("channel_change_sprite")
    self.perlin_texture_page = Assets.getTexture("effects/perlin_noise_240")
    self.channel_shader:send("perlin_texture_page", self.perlin_texture_page)
    self.channel_shader:send("u_pixelSize", { self.perlin_texture_page:getDimensions() })

    self.on_start = function(self) end
    self.on_stop = function(self) end

    self:lightemupInit()
end

function ScreenChannelChangeFX:start(strength, lifetime)
    self.strength = strength or self.strength
    self.lifetime = lifetime or self.lifetime
    self.timer = self.lifetime

    self.scan_x_shuffle_init = false
    self.old_screen_surf = nil

    self.on_start(self)
end

function ScreenChannelChangeFX:getFrame(frames, frame)
    return frames[1 + (math.floor(frame) % #frames)]
end

function ScreenChannelChangeFX:wrap(_val, _min, _max)
    local _small, _large = math.min(_min, _max), math.max(_min, _max)

    local _diff = _large - _small
    if _val % 1 == 0 then
        -- Max-inclusive
        _diff = _diff + 1
    end
    -- Original DR code is max-exclusive if val is not an integer for whatever reason,
    -- so we follow suit

    return _small + ((_val - _small) + _diff) % _diff
end

---@param texture love.Canvas
function ScreenChannelChangeFX:draw(texture)
    if (not self.infinite and self.timer <= 0) or self.strength == 0 then
        return super.draw(self, texture)
    end

    local tex_w, tex_h = texture:getDimensions()

    if self.scroll and not self.old_screen_surf then
        self.old_screen_surf = love.graphics.newImage(texture:newImageData())
        if self.wait_for_old_surf_to_be_prepared then return end
    end

    -- scr_ease_in(self.timer / self.lifetime, 2)
    local _ease = Utils.ease(0, 1, self.timer / self.lifetime, "in-quad")
    local _strength = self.strength * _ease
    if self.scroll then
        _strength = _strength / 3
    end

    local screen_surf = Draw.pushCanvas(tex_w, tex_h)
    if self.scroll then
        -- scr_ease_out(1 - (self.timer / self.lifetime), 4)
        local _yy = self:wrap(Utils.ease(0, 1, 1 - (self.timer / self.lifetime), "out-quart"), 0, 1) * tex_h
        ---@diagnostic disable-next-line: param-type-mismatch
        Draw.drawCanvasPart(self.old_screen_surf, 0, 0, 0, _yy, tex_w, tex_h - _yy)
        Draw.drawCanvasPart(texture, 0, tex_h - _yy, 0, 0, tex_w, _yy)
    else
        Draw.drawCanvas(texture)
    end
    Draw.popCanvas()

    if not self.scan_x_init then
        local _variation = self.scroll_speed * self.scroll_dir * self.lifetime / 2
        local _scroll = (tex_h / 2) - (_variation / 2)
        local _variation_neg = _variation * -self.scroll_dir
        self.scan_x = MathUtils.random(_variation + _variation_neg, _scroll + _variation_neg)

        self.scan_x_init = true
    end
    if self.shuffle and not self.scan_x_shuffle_init then
        local _spot = MathUtils.randomInt(self.scan_x_brd, tex_h - self.scan_x_brd + 1)
        self.scan_x = self:wrap(self.scan_x + _spot, 0, tex_h - 1)

        self.scan_x_shuffle_init = true
    end

    self.channel_shader:send("texel", { tex_w, tex_h })
    self.channel_shader:send("strength", _strength)
    self.channel_shader:send("scanx", math.floor(self.scan_x) + 0.5)
    love.graphics.setShader(self.channel_shader)
    Draw.drawCanvas(screen_surf)
    love.graphics.setShader()

    local scan_x_inc = self.scroll_speed * self.scroll_dir * (self.timer / self.lifetime) * 2 * DTMULT
    self.scan_x = self:wrap(self.scan_x + scan_x_inc, 0, tex_h - 1)

    if not self.infinite and self.timer > 0 then
        self.timer = MathUtils.approach(self.timer, 0, DTMULT)
        if self.timer == 0 then
            self.old_screen_surf = nil
            self.on_stop(self)
        end
    end

    local _alpha = _ease / 2
    local _alpha_alt = self:lightemupExtraDraw(_ease)
    if _alpha_alt ~= nil then _alpha = _alpha_alt end

    Draw.setColor(1, 1, 1, _alpha)
    local static_x, static_y = 0, 0 -- -camerax, -cameray in DR due to an oversight
    if self.infinite then
        Draw.drawWrapped(self:getFrame(self.static_effect, self.scan_x), true, true, static_x, static_y, 0, 2, 2)
    else
        Draw.drawWrapped(self:getFrame(self.static_effect, self.timer / 2), true, true, static_x, static_y, 0, 2, 2)
    end
    Draw.setColor(COLORS.white)
end

-- Tenna battle-specific

function ScreenChannelChangeFX:lightemupInit()
    self.lightemupcon = -1
    self.lightemuptimer = 0
    self.lightemup_sound_tr1 = false
    self.lightemup_sound_tr2 = false
    self.changechanneltimermax = 25
end

function ScreenChannelChangeFX:lightemupExtraDraw(_ease)
    if self.lightemupcon < 0 then return end

    local _alpha = nil

    if self.lightemupcon == 1 then
        self.lightemuptimer = MathUtils.approach(self.lightemuptimer, 70, DTMULT)

        if self.lightemuptimer >= 3 and not self.lightemup_sound_tr1 then
            self.lightemup_sound_tr1 = true
            Assets.playSound("tv_static")
        end
        if self.lightemuptimer >= 65 and not self.lightemup_sound_tr2 then
            self.lightemup_sound_tr2 = true
            Assets.stopSound("tv_static")
        end

        local _alpha2 = 1
        if self.lightemuptimer < 3 then
            _alpha2 = Utils.ease(0, 1, self.lightemuptimer / 3, "linear")
        elseif self.lightemuptimer >= 3 and self.lightemuptimer < 60 then
            _alpha2 = 1
        elseif self.lightemuptimer >= 60 then
            _alpha2 = Utils.ease(1, 0, (self.lightemuptimer - 60) / 10, "linear")
        end

        if self.lightemuptimer == 70 then
            self.lightemupcon = 0
            self.lightemup_sound_tr1 = false
            self.lightemup_sound_tr2 = false
            self.lifetime = self.base_lifetime
        end

        Draw.setColor(1, 1, 1, _alpha2)
        Draw.drawWrapped(self:getFrame(self.static_effect, self.timer), true, true, 0, 0, 0, 2, 2)
    else
        _alpha = _ease / 3
        if self.changechanneltimermax < 25 then
            _alpha = Utils.ease(0, _ease / 3, self.strength / self.base_strength, "linear")
        end
    end

    return _alpha
end

return ScreenChannelChangeFX
