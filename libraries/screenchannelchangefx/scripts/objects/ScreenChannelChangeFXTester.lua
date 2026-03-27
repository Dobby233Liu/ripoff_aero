---@class ScreenChannelChangeFXTester : Object
---@overload fun() : ScreenChannelChangeFXTester
local ScreenChannelChangeFXTester, super = Class(Object)

function ScreenChannelChangeFXTester:init()
    super.init(self, 0, 0)

    ---@type ScreenChannelChangeFX?
    self.fx = nil
    self.background = 0
end

function ScreenChannelChangeFXTester:onAdd(parent)
    super.onAdd(self, parent)
    self.fx = parent:addFX(ScreenChannelChangeFX())
end

function ScreenChannelChangeFXTester:onRemove(parent)
    super.onRemove(self, parent)
    if self.fx then parent:removeFX(self.fx) end
end

function ScreenChannelChangeFXTester:update()
    if not OVERLAY_OPEN then
        if Input.pressed("b") then
            self.background = MathUtils.wrap(self.background + 1, 0, 3)
            --[[
            with (obj_actor_tenna)
            {
                preset = irandom(37)
                if (preset >= 35)
                    preset++
            }
            ]]
        end

        if Input.pressed("y") then
            if Input.down("shift") then
                self.fx.lifetime = self.fx.lifetime + 1
                print("lifetime:", self.fx.lifetime)
            elseif self.fx.strength > 0 then
                self.fx.strength = self.fx.strength + 10
                print("stremgth:", self.fx.strength)
            end
        elseif Input.pressed("u") then
            if Input.down("shift") then
                if self.fx.lifetime > 1 then
                    self.fx.lifetime = self.fx.lifetime - 1
                end
                print("lifetime:", self.fx.lifetime)
            elseif self.fx.strength > 0 then
                self.fx.strength = self.fx.strength - 10
                print("stremgth:", self.fx.strength)
            end
        end

        if Input.pressed("b") then
            self.fx.lightemupcon = -1
            self.fx:start()
        end

        if Input.pressed("m") then
            if Input.shift() then
                self.fx.lightemupcon = 0
                self.fx.lifetime = math.max(15, self.fx.lifetime)
            else
                self.fx.lightemupcon = 1
                self.fx.lifetime = 70
            end
            self.fx.lightemuptimer = 0
            self.fx:start()
        end

        if Input.pressed("i") then
            self.fx.infinite = not self.fx.infinite
            print("infinite:", self.fx.infinite)
            if self.fx.infinite then
                self.fx.timer = self.fx.lifetime
            end
        end

        if Input.pressed("v") then
            self.fx.scroll = not self.fx.scroll
            print("scroll:", self.fx.scroll)
        end
    end

    --[[if (background == 1)
        draw_sprite(spr_rhythmgame_bg, 4, 0, 0)

    if (background == 2)
        draw_sprite_ext(bg_torhouse_bg, 0, -690, 0, 2, 2, 0, c_white, 1)

    if (background == 3)
        draw_sprite_ext(spr_dw_susiezilla_bg_empty, 0, 0, 0, 2, 2, 0, c_white, 1)]]

    super.update(self)
end

return ScreenChannelChangeFXTester
