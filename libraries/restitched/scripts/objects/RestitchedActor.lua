local RestitchedActor, super = Class(ActorSprite)

function RestitchedActor:init(actor)
    super.init(self, actor)
    self:setOrigin(0, 0)
    self:setScale(1)
	
    self.spr = Assets.getFramesOrTexture("npcs/restitched/sSpamRig")
    self.needle_spr = Assets.getTexture("npcs/restitched/sNeedles_2")
	
    self.alpha = 1
    self.back_black_a = 0
    self.power_alpha = 0
	
    self.mov_x = 0
	
    self.bod_x = self.x
    self.bod_y = self.y
	
    self.whole_rot = 0
	
    self.limb_delay = 3
    self.limb_shake = 0
	
    self.tyme_1 = 0
    self.end_tyme = 0
    self.anim_speed = 0.25
    self.animation = "Dang_A"
    self.spez_anim = 0
	
    self.head_rot = 0
    self.head_index = 0
	
    self.R_Arm_Rot = 0
    self.R_Arm_TargetRot = 0
	
    self.L_Arm_Rot = 0
    self.L_Arm_TargetRot = 0
	
    self.R_Leg_Rot = 0
    self.R_Leg_TargetRot = 0
	
    self.L_Leg_Rot = 0
    self.L_Leg_TargetRot = 0
	
    self.string_scale = 10
    self.string_rot = (1)
    self.string_shake = 4
    self.L_ArmStringScale = 60
    self.R_ArmStringScale = 60
	
    self.needle = 3
	
    self._Wings = 1
	
    self.BackBlack = false
    self.BackWhiteA = 0
	
    self.head_scale = 1
	
    self.Index_Head = 15
    self.Index_String1 = 13
    self.Index_Arms = 18
    self.Index_Halo = 26
    self.Index_Torso = 39
	
    self.string_arms = true
	
    self.R_ArmEX = 0
    self.L_ArmEX = 0
	
    self.var1 = 0
    self.var2 = 0
    self.var3 = 0
	
    self.RightHandX = 0
    self.RightHandY = 0
	
    self.fall_y = 500
	
    self.nose_scale = 0
	
    self.ned_ex = {}
    self.ned_ex[0] = 0
    self.ned_ex[1] = 0
    self.ned_ex[2] = 0
    self.ned_ex[3] = 0
    self.ned_ex[4] = 0
    self.ned_ex[5] = 0
end

function RestitchedActor:draw()
    super.draw(self)
	
	-- body part position function from the original code.
    local function scrMoveROT(x, y, angle, radius)
        self.x = x
        self.y = y
        self.x = self.x + ((math.cos(angle / 57)) * radius * (self.scale_x / 2))
        self.y = self.y - ((math.sin(angle / 57)) * radius * (self.scale_y / 2))
    end
	
    --reset origin to top left corner of window being 0,0
    local old_transform = love.graphics.pop()
	
    --[[if self.ned_ex < 1000 then
        self.ned_ex[0] = self.ned_ex[0] + self.ned_ex[3] * DTMULT
        self.ned_ex[3] = self.ned_ex[3] + 0.5 * DTMULT
    end]]
	
    if self.anim_speed ~= 0 then
        self.tyme_1 = self.tyme_1 + 2 * DTMULT
    end
	
    self.bod_x = self.bod_x + self.mov_x * DTMULT
    self.mov_x = self.mov_x + ((0 - self.mov_x) / 10) * DTMULT
	
    if self.whole_rot >= 360 then
        self.whole_rot = self.whole_rot - 360
    end
    if self.whole_rot <= -360 then
        self.whole_rot = self.whole_rot + 360
    end

    -- animations
    if self.animation == "" then
        self.R_Arm_TargetRot = self.R_ArmEX + ((math.sin(self.anim_speed * self.tyme_1 * 0.06 )) * 15) * DTMULT
        self.L_Arm_TargetRot = self.L_ArmEX + ((math.sin(self.anim_speed * self.tyme_1 * 0.035)) * 15) * DTMULT
        self.R_Leg_TargetRot = (math.sin(self.anim_speed * self.tyme_1 * 0.05)) * 15
        self.L_Leg_TargetRot = (math.sin(self.anim_speed * self.tyme_1 * 0.04)) * 15
        self.anim_speed      = 0.25
        self.limb_delay      = 3
        self.limb_shake      = 0
        self.var1            = 0
        self.var2            = 0
    end
    if self.animation == "Dang_1" or self.animation == "Dang_2" or self.animation == "Dang_A" then
        self.R_Leg_TargetRot = (math.sin(self.anim_speed * self.tyme_1 * 0.2 )) * 15
        self.L_Leg_TargetRot = (math.sin(self.anim_speed * self.tyme_1 * 0.16)) * 15
        self.anim_speed      = 0.25
        if self.animation == "Dang_2" then
            self.bod_y = self.bod_y + ((150 + (math.sin(self.anim_speed * self.tyme_1 * 0.1)) * 10 - self.bod_y) / 10) * DTMULT
        end
    end
    if self.animation == "Dang_A" then
        self.string_rot      = 0
        self.limb_delay      = 15
        self.whole_rot       = self.whole_rot + (((math.cos(self.tyme_1 * 0.025)) * 20 - self.whole_rot) / 10) * DTMULT
        self.R_Arm_TargetRot = self.R_Arm_TargetRot + (( 100 + (math.sin(self.tyme_1 * 0.0325)) * 20 - self.R_Arm_TargetRot) / 5) * DTMULT
        self.L_Arm_TargetRot = self.L_Arm_TargetRot + ((-100 - (math.cos(self.tyme_1 * 0.0325)) * 20 - self.L_Arm_TargetRot) / 5) * DTMULT
        self.head_rot        = self.head_rot + ((-27 + (math.sin(self.tyme_1 * 0.05)) * 20 - self.head_rot) / 5) * DTMULT
    end
    if self.animation == "SwingBack" then
        self.limb_delay      = 15
        self.anim_speed      = 2
        self.R_Arm_TargetRot = (math.sin(self.tyme_1 * 0.05)) * 75
        self.L_Arm_TargetRot = (math.cos(self.tyme_1 * 0.05)) * 75
        self.bod_x           = self.bod_x + ((480 + (math.sin(self.tyme_1 * 0.05)) * 10 - self.bod_x) / self.limb_delay) * DTMULT
        self.bod_y           = self.bod_y + ((150 + (math.cos(self.tyme_1 * 0.025)) * 30 - self.bod_y) / self.limb_delay) * DTMULT
        self.whole_rot       = self.whole_rot + (((math.sin(self.tyme_1 * 0.025)) * 50 - self.whole_rot) / self.limb_delay) * DTMULT
    end
    if self.animation == "Orb_1" then
        self.anim_speed      = self.anim_speed + ((0.5 - self.anim_speed) / self.limb_delay) * DTMULT
        self.R_Leg_TargetRot = (math.sin(self.tyme_1 * 0.05)) * 50
        self.L_Leg_TargetRot = (math.cos(self.tyme_1 * 0.05)) * 50
        self.R_Arm_TargetRot = self.R_Arm_TargetRot + ((115 + (math.sin(self.tyme_1 * 0.1)) * 55 - self.R_Arm_TargetRot) / (self.limb_delay / 2)) * DTMULT
        self.L_Arm_TargetRot = self.L_Arm_TargetRot + ((-115 + (math.sin(self.tyme_1 * 0.1)) * -55 - self.L_Arm_TargetRot) / (self.limb_delay / 2)) * DTMULT
        self.whole_rot       = self.whole_rot + ((-22.5 + (math.sin(self.tyme_1 * 0.05)) * 10 - self.whole_rot) / (self.limb_delay / 2)) * DTMULT
        self.head_rot        = self.head_rot + ((-45 - self.head_rot) / (self.limb_delay / 2)) * DTMULT
        self.bod_x           = self.bod_x + ((450 - self.bod_x) / (self.limb_delay / 2)) * DTMULT
        self.bod_y           = self.bod_y + ((150 - self.bod_y) / self.limb_delay) * DTMULT
    end
    if self.animation == "Orb_2" then
        self.R_Leg_TargetRot = 90 + (math.sin(self.tyme_1 * 0.05)) * 30
        self.L_Leg_TargetRot = 90 + (math.cos(self.tyme_1 * 0.05)) * 30
        self.R_Arm_TargetRot = self.R_Arm_TargetRot + ((660 - self.R_Arm_TargetRot) / (self.limb_delay / 3)) * DTMULT
        self.L_Arm_TargetRot = self.L_Arm_TargetRot + ((295 - self.L_Arm_TargetRot) / (self.limb_delay / 3)) * DTMULT
        self.whole_rot       = self.whole_rot + ((45 + (math.sin(self.tyme_1 * 0.05)) * 5 - self.whole_rot) / self.limb_delay) * DTMULT
        self.head_rot        = self.head_rot + ((315 - self.head_rot) / (self.limb_delay / 3)) * DTMULT
        self.bod_y           = self.bod_y + ((200 - self.bod_y) / self.limb_delay) * DTMULT
    end
	
    self.R_Arm_Rot = self.R_Arm_Rot + ((self.R_Arm_TargetRot - (self.R_Arm_Rot)) / self.limb_delay) * DTMULT
    self.L_Arm_Rot = self.L_Arm_Rot + ((self.L_Arm_TargetRot - (self.L_Arm_Rot)) / self.limb_delay) * DTMULT
    self.R_Leg_Rot = self.R_Leg_Rot + ((self.R_Leg_TargetRot - (self.R_Leg_Rot)) / self.limb_delay) * DTMULT
    self.L_Leg_Rot = self.L_Leg_Rot + ((self.L_Leg_TargetRot - (self.L_Leg_Rot)) / self.limb_delay) * DTMULT
	
	--needles
    if self.needle > 0 then
        scrMoveROT(self.bod_x, self.bod_y, (self.whole_rot + 20), (10 + self.ned_ex[0]))
        Draw.draw(self.needle_spr, 
          (self.x + (love.math.random((-self.limb_shake), self.limb_shake))), 
          (self.y + (love.math.random((-self.limb_shake), self.limb_shake))), 
          -math.rad(self.whole_rot + 10 + (math.sin(self.anim_speed * self.tyme_1 * 0.1)) * 2), 
          1, 
          1,
          5,
          5
        )
        scrMoveROT(self.x, self.y, (self.whole_rot + 9.5 + (math.sin(self.anim_speed * self.tyme_1 * 0.1)) * 2), 129)
        Draw.draw(self.spr[11], 
          (self.x + (love.math.random((-self.limb_shake), self.limb_shake))), 
          (self.y + (love.math.random((-self.limb_shake), self.limb_shake))),
          -math.rad(-90 + self.whole_rot + 10 + (math.sin(self.anim_speed * self.tyme_1 * 0.1)) * 2),		  
          1,
          50,
          50,
          50
        )
    end
    if self.needle > 1 then
        scrMoveROT(self.bod_x, self.bod_y, self.whole_rot, (10 + self.ned_ex[2]))
        Draw.draw(self.needle_spr, 
          (self.x + (love.math.random((-self.limb_shake), self.limb_shake))), 
          (self.y + (love.math.random((-self.limb_shake), self.limb_shake))), 
          -math.rad(self.whole_rot + (math.sin(5 + self.anim_speed * self.tyme_1 * 0.1)) * 2), 
          1, 
          1,
          5,
          5
        )
        scrMoveROT(self.x, self.y, (self.whole_rot - 0.5 + (math.sin(5 + self.anim_speed * self.tyme_1 * 0.1)) * 2), 129)
        Draw.draw(self.spr[11], 
          (self.x + (love.math.random((-self.limb_shake), self.limb_shake))), 
          (self.y + (love.math.random((-self.limb_shake), self.limb_shake))),
          -math.rad(-90 + self.whole_rot + (math.sin(5 + self.anim_speed * self.tyme_1 * 0.1)) * 2),		  
          1,
          50,
          50,
          50
        )
    end
    if self.needle > 2 then
        scrMoveROT(self.bod_x, self.bod_y, (self.whole_rot - 20), (10 + self.ned_ex[1]))
        Draw.draw(self.needle_spr, 
          (self.x + (love.math.random((-self.limb_shake), self.limb_shake))), 
          (self.y + (love.math.random((-self.limb_shake), self.limb_shake))), 
          -math.rad(self.whole_rot - 10 + (math.sin(10 + self.anim_speed * self.tyme_1 * 0.1)) * 2), 
          1, 
          1,
          5,
          5
        )
        scrMoveROT(self.x, self.y, (self.whole_rot - 10.5 + (math.sin(10 + self.anim_speed * self.tyme_1 * 0.1)) * 2), 129)
        Draw.draw(self.spr[11], 
          (self.x + (love.math.random((-self.limb_shake), self.limb_shake))), 
          (self.y + (love.math.random((-self.limb_shake), self.limb_shake))),
          -math.rad(-90 + self.whole_rot - 10 + (math.sin(10 + self.anim_speed * self.tyme_1 * 0.1)) * 2),		  
          1,
          50,
          50,
          50
        )
    end
	
    if (((Utils.round(self.tyme_1 / 2)) * 2) == self.tyme_1) then
        self.string_shake = self.string_shake * -0.9 + DTMULT
    end
	
    if self.string_scale ~= 0 then
        self.string_rot = self.string_rot + self.var1 * DTMULT
        self.var2 = self.var2 + DTMULT
		
        if self.var2 == 5 then
            self.var1 = self.var1 + 0.025 * DTMULT
            self.var2 = 0
        end
		
        self.string_scale = self.string_scale - self.var1 * DTMULT
		
        if self.string_scale < 0 then
            self.string_scale = 0
        end
    end

    scrMoveROT(self.bod_x, self.bod_y, (self.whole_rot + 35), 25)
    Draw.draw(self.spr[23],                                       -- angel wing 1
      self.x + (love.math.random((-self.limb_shake), self.limb_shake)), 
      self.y + (love.math.random((-self.limb_shake), self.limb_shake)), 
      -math.rad(self.whole_rot), 
      ((self.scale_x - 1.25 + (math.sin(self.tyme_1 * -0.05)) * 0.25) * self._Wings), 
      (self.scale_y * self._Wings), 
      50,
      50
	)
    scrMoveROT(self.bod_x, self.bod_y, (self.whole_rot + 20), 32)
    Draw.draw(self.spr[22],                                       -- angel wing 2
      self.x + (love.math.random((-self.limb_shake), self.limb_shake)), 
      self.y + (love.math.random((-self.limb_shake), self.limb_shake)), 
      -math.rad(self.whole_rot), 
      ((self.scale_x - 0.5 + (math.sin(self.tyme_1 * 0.05)) * 0.25) * self._Wings), 
      (self.scale_y * self._Wings), 
      50,
      50
	)
	
    if self.string_arms then                                      -- left arm string (background)
        scrMoveROT(self.bod_x, self.bod_y, (self.whole_rot + 45), 15)
        scrMoveROT(self.x, self.y, (self.L_Arm_Rot - 90), 47)
        Draw.draw(self.spr[17], 
          self.x + 1, 
          self.y, 
          math.rad(self.string_rot + (math.sin(self.tyme_1 * 0.03)) - 1), 
          self.scale_x*1, 
          self.scale_y*self.L_ArmStringScale, 
          50,
          50
	    )
    end

    scrMoveROT(self.bod_x, self.bod_y, (self.whole_rot + 45), 15)
    Draw.draw(self.spr[self.Index_Arms + 1],                      -- left arm
      self.x + (love.math.random((-self.limb_shake), self.limb_shake)), 
      self.y + (love.math.random((-self.limb_shake), self.limb_shake)), 
      -math.rad(self.L_Arm_Rot * (self.scale_x / 2)), 
      self.scale_x, 
      self.scale_y, 
      50,
      50
	)

    if self.string_arms then                                      -- left arm string (foreground)
        scrMoveROT(self.bod_x, self.bod_y, (self.whole_rot + 45), 15)
        scrMoveROT(self.x, self.y, (self.L_Arm_Rot - 90), 47)
        Draw.draw(self.spr[11], 
          self.x + 1, 
          self.y, 
          math.rad(self.string_rot + (math.sin(self.tyme_1 * -0.03)) + 1), 
          self.scale_x*1, 
          self.scale_y*self.L_ArmStringScale, 
          50,
          50
	    )
    end

    scrMoveROT(self.bod_x, self.bod_y, (self.whole_rot - 65), 30)	
    Draw.draw(self.spr[8],                                        -- left leg
      self.x + (love.math.random((-self.limb_shake), self.limb_shake)), 
      self.y + (love.math.random((-self.limb_shake), self.limb_shake)), 
      -math.rad(self.L_Leg_Rot * (self.scale_x / 2)), 
      self.scale_x, 
      self.scale_y, 
      50,
      50
	)
    Draw.draw(self.spr[4],                                        -- upper torso
      self.bod_x + (love.math.random((-self.limb_shake), self.limb_shake)), 
      self.bod_y + (love.math.random((-self.limb_shake), self.limb_shake)), 
      -math.rad(self.whole_rot + (math.sin(self.anim_speed * self.tyme_1 * 0.057)) * 15), 
      self.scale_x, 
      self.scale_y, 
      50,
      50
	)
    scrMoveROT(self.bod_x, self.bod_y, (self.whole_rot - 45), 40)
    Draw.draw(self.spr[7],                                        -- right leg
      self.x + (love.math.random((-self.limb_shake), self.limb_shake)), 
      self.y + (love.math.random((-self.limb_shake), self.limb_shake)), 
      -math.rad(self.R_Leg_Rot * (self.scale_x / 2)), 
      self.scale_x, 
      self.scale_y, 
      50,
      50
	)
    Draw.draw(self.spr[self.Index_Torso],                         -- lower torso
      self.bod_x + (love.math.random((-self.limb_shake), self.limb_shake)), 
      self.bod_y + (love.math.random((-self.limb_shake), self.limb_shake)), 
      -math.rad(self.whole_rot + (math.sin(self.anim_speed * self.tyme_1 * 0.057)) * 15), 
      self.scale_x, 
      self.scale_y, 
      50,
      50
	)
	
    scrMoveROT(self.bod_x, self.bod_y, (self.whole_rot + 50 + 4), 38)
    Draw.draw(self.spr[self.Index_Head],                          -- head
      self.x + (love.math.random((-self.limb_shake), self.limb_shake)), 
      self.y + (love.math.random((-self.limb_shake), self.limb_shake)), 
      -math.rad(self.head_rot * (self.scale_x / 2) + self.whole_rot), 
      self.scale_x * self.head_scale, 
      self.scale_y * self.head_scale, 
      50,
      50
	)
	
    if self.Index_Halo ~= 0 then                                  -- halo
        scrMoveROT(self.bod_x, self.bod_y, (self.whole_rot + 50), (50 + (math.sin(self.anim_speed * self.tyme_1 * 0.05)) * 5))
        scrMoveROT(self.x, self.y, (self.head_rot + 110), (40 * self.head_scale))
        Draw.draw(self.spr[self.Index_Halo],
          self.x + (love.math.random((-self.limb_shake), self.limb_shake)), 
          self.y, 
          -math.rad(self.head_rot + 10), 
          2 * self.head_scale, 
          2 * self.head_scale, 
          50,
          50
        )
        if self.anim_speed ~= 0 then
            if (((Utils.round(self.tyme_1 / 5)) * 5) == self.tyme_1) then
                self.Index_Halo = self.Index_Halo + 1
                if self.Index_Halo > 38 then
                    self.Index_Halo = 26
                end
            end
        end
    end

    if self.string_arms then                                      -- right arm string (background)
        scrMoveROT(self.bod_x, self.bod_y, (self.whole_rot + 13), 35)
        scrMoveROT(self.x, self.y, (self.R_Arm_Rot - 83), 55)
        self.RightHandX = self.x
        self.RightHandY = self.y
        Draw.draw(self.spr[17], 
          self.x + (love.math.random((-self.limb_shake), self.limb_shake)), 
          self.y + (love.math.random((-self.limb_shake), self.limb_shake)), 
          math.rad(self.string_rot + (math.sin(self.tyme_1 * 0.03)) + 1), 
          self.scale_x*1, 
          self.R_ArmStringScale, 
          50,
          50
	    )
    end
	
    scrMoveROT(self.bod_x, self.bod_y, (self.whole_rot + 13), 35)    
    Draw.draw(self.spr[self.Index_Arms],                          -- right arm
      self.x + (love.math.random((-self.limb_shake), self.limb_shake)), 
      self.y + (love.math.random((-self.limb_shake), self.limb_shake)), 
      -math.rad(self.R_Arm_Rot * (self.scale_x / 2)), 
      self.scale_x, 
      self.scale_y, 
      50,
      50
	)
	
    if self.string_arms or self.spez_anim == "Line_1_Show" then   -- right arm string (foreground)
        scrMoveROT(self.bod_x, self.bod_y, (self.whole_rot + 13), 35)
        scrMoveROT(self.x, self.y, (self.R_Arm_Rot - 83), 55)
        self.RightHandX = self.x
        self.RightHandY = self.y
        Draw.draw(self.spr[11], 
          self.x + (love.math.random((-self.limb_shake), self.limb_shake)), 
          self.y + (love.math.random((-self.limb_shake), self.limb_shake)), 
          math.rad(self.string_rot + (math.sin(self.tyme_1 * -0.03)) - 1), 
          self.scale_x*1, 
          self.R_ArmStringScale, 
          50,
          50
	    )
    end
	
    if self.limb_shake ~= 0 then
        self.limb_shake = self.limb_shake - 0.5 * DTMULT
    end
	
    --reset transform stack	
    love.graphics.push(old_transform)
end

return RestitchedActor