include("shared.lua")

local math = math
local Angle = Angle
local Vector = Vector
local Lerp = Lerp

local vec_zero = Vector( 0, 0, 0 )
local ang_zero = Angle( 0, 0, 0 )

local bulletblock_lerp = 0
function SWEP:DrawHUD()
	self:DrawCrosshair()
	if self.Owner._SkillBulletBlock then
	
		if not self.LastBlockPower then
			self.LastBlockPower = self.Owner:GetBulletBlockPower() * 1
		end
		
		local dur = 1
		
		if self.LastBlockPower < self.Owner:GetBulletBlockPower() then
			self.PopupBlockPower = CurTime() + dur
			self.PopupBlockPowerVisual = CurTime() + dur + 1
		end
		
		local delta = 0
		
		if self.PopupBlockPower and self.PopupBlockPower >= CurTime() then
			delta = math.Clamp( ( self.PopupBlockPower - CurTime() ) / dur, 0, 1 )
		end
		
		local offset = 14 * delta

		
		if self:IsBlocking() or self.PopupBlockPowerVisual and self.PopupBlockPowerVisual >= CurTime() then
			bulletblock_lerp = math.Approach( bulletblock_lerp, 1, RealFrameTime()*6)
		else
			if bulletblock_lerp > 0 then
				bulletblock_lerp = math.Approach( bulletblock_lerp, 0, RealFrameTime()*6)
			end
		end
		if bulletblock_lerp > 0 then
			self:DrawBulletBlock( offset, bulletblock_lerp or 1 )
		end
		self.LastBlockPower = self.Owner:GetBulletBlockPower() * 1
	end
end

function SWEP:AdjustMouseSensitivity()
	if self.Owner and self.Owner._efSlide then return 0.55 end
end

local function CosineInterpolation(y1, y2, mu)
	local mu2 = (1 - math.cos(mu * math.pi)) / 2
	return y1 * (1 - mu2) + y2 * mu2
end

local lerp = 0
local blocklerp = 0
local attacklerp = 0
local swinglerp = 0
function SWEP:GetViewModelPosition(pos, ang)
	
	if self:IsSwinging() then 
		local rot = self.SwingRotation
		local offset = self.SwingOffset

		ang = Angle(ang.pitch, ang.yaw, ang.roll) -- Copies.
		
		local swingtime = self.SwingTime - self.SwingTime * ((self.Owner._DefaultMeleeSpeedBonus or 0))	
		
		local swingend = self:GetSwingEnd()
		local delta = swingtime - math.max(0, swingend - CurTime())
		local power = Lerp( delta / swingtime, 0, 1 )--CosineInterpolation(0, 1, delta / swingtime)

		if power >= 0.8 then
			power = (1 - power) * 4
		end

		pos = pos + offset.x * power * ang:Right() + offset.y * power * ang:Forward() + offset.z * power * ang:Up()

		ang:RotateAroundAxis(ang:Right(), rot.pitch * power)
		ang:RotateAroundAxis(ang:Up(), rot.yaw * power)
		//ang:RotateAroundAxis(ang:Forward(), rot.roll * power)
		
	else
		if self.BlockAnim and self.BlockAnim > CurTime() and self.BlockPos and self.BlockAng then//self:IsBlocking()
			--if IsFirstTimePredicted() then
				lerp = math.Approach(lerp, (self:IsBlocking() and 1) or 0, RealFrameTime()*1*((lerp + 1) ^ 3))
			--end
			local rot = self.BlockAng
			local offset = self.BlockPos
			
			ang = Angle(ang.pitch, ang.yaw, ang.roll)
			
			local power = lerp
			
			ang:RotateAroundAxis(ang:Right(), rot.pitch * power)
			ang:RotateAroundAxis(ang:Up(), rot.yaw * power)
			ang:RotateAroundAxis(ang:Forward(), rot.roll * power)
			
			pos = pos + offset.x * power * ang:Right() + offset.y * power * ang:Forward() + offset.z * power * ang:Up()
		else
			if (self:GetNextAttack() - 0.3 or 0) > CurTime() and self.AttackPos and self.AttackAng then
				--if IsFirstTimePredicted() then
					lerp = math.Approach(lerp, ((self:GetNextAttack() - 0.5 or 0) > CurTime() and 1) or 0, RealFrameTime()*1*((lerp + 1) ^ 1.2))
				--end
				
				local rot = self.AttackAng
				local offset = self.AttackPos
				
				ang = Angle(ang.pitch, ang.yaw, ang.roll)
				
				local power = lerp
				
				ang:RotateAroundAxis(ang:Right(), rot.pitch * power)
				ang:RotateAroundAxis(ang:Up(), rot.yaw * power)
				ang:RotateAroundAxis(ang:Forward(), rot.roll * power)
				
				pos = pos + offset.x * power * ang:Right() + offset.y * power * ang:Forward() + offset.z * power * ang:Up()
			else
				--if IsFirstTimePredicted() then
					lerp = math.Approach(lerp, (self.Owner:IsSprinting() and not self.IgnoreSprint and not self.Owner:IsSliding() and 1) or 0, RealFrameTime()*1*((lerp + 1) ^ 2.5))
				--end
				ang:RotateAroundAxis(ang:Right(), (self.IdleAnim == ACT_VM_IDLE_1 and 30 or -20) * lerp)
				if self.IdleAnim == ACT_VM_IDLE_1 then
					--ang:RotateAroundAxis(ang:Forward(), -30 * lerp)
					ang:RotateAroundAxis(ang:Up(), -30 * lerp)
				end	
			end
		end
	end
	
	//if self:IsPlayingAnimation() then
	
		--if IsFirstTimePredicted() then
			swinglerp = math.Approach(swinglerp, (self:IsPlayingAnimation() and 1) or 0, RealFrameTime()*6)
		--end
	
		if self:GetHitDirection() == 3 then
			ang:RotateAroundAxis(ang:Forward(), -50 * swinglerp)
			pos = pos - ang:Right() * 5.5 * swinglerp
		end
		if self:GetHitDirection() == 2 then
			ang:RotateAroundAxis(ang:Forward(), 50 * swinglerp)
			pos = pos + ang:Right() * 5.5 * swinglerp
		end
	//end
	
	if not self.NormalViewmodelPos then
		//fixing my weird 2 handed anims
		if self.IdleAnim == ACT_VM_IDLE_1 then
			pos = pos + ang:Right() * (-1.56) + ang:Up() * (-5.16)
		else
			pos = pos - ang:Up()*1.5
		end
	end
	
	local plang = MySelf:EyeAngles()
	
	if self.ViewmodelOffset then
		pos = pos + self.ViewmodelOffset.x * plang:Right() + self.ViewmodelOffset.y * plang:Forward() + self.ViewmodelOffset.z * plang:Up()
	end
	
	pos = pos + ( DD_VIEWMODEL_Z or 0 ) * plang:Up()
		
	return pos, ang
end 

function SWEP:CalculateHandMovement()
					
	local time = self.SpellTime*0.8
		
	local sp = self.Owner:GetCurrentSpell()
	
	local bonemods = self.ViewModelBoneMods
	local sorted = self.ViewModelBoneModsSorted
	local default = self.DefaultViewModelBoneMods
	local action = self.ActionMods
	local swingmods = self.SwingMods
	local attackmods = self.AttackMods
	local attackmods2 = self.AttackMods2
	local blockmods = self.BlockMods
	local idlemods = self.IdleMods
	
	local is_attacking = self:IsAttacking()
	local is_blocking = self:IsBlocking()
	local is_swinging = self:IsSwinging()
		
	if bonemods and sorted then
		
		for i = 1, #sorted do
		
			local bone = sorted[ i ]
			if not bonemods[bone] then continue end
			
			local offset = vec_zero
			local rot = ang_zero
		
			if self:IsCasting() and action[bone] then
				if is_attacking or is_blocking then
					rot = ang_zero
					offset = vec_zero
				else
					offset = action[bone].pos
					rot = action[bone].angle
				end
			else
				if self:IsSwinging() and swingmods and swingmods[bone] and not is_blocking then
					offset = swingmods[bone].pos
					rot = swingmods[bone].angle
				elseif is_blocking and blockmods and blockmods[bone] and not is_attacking then
					offset = blockmods[bone].pos
					rot = blockmods[bone].angle
				elseif is_attacking and attackmods and attackmods[bone] and not is_blocking then
					if self.Switch and attackmods2 and attackmods2[bone] then
						offset = attackmods2[bone].pos
						rot = attackmods2[bone].angle
					else
						offset = attackmods[bone].pos
						rot = attackmods[bone].angle
					end
				else
					if idlemods then
						if idlemods[bone] then
							rot,offset = idlemods[bone].angle,idlemods[bone].pos
						end
					else
						rot = ang_zero
						offset = vec_zero
					end
				end
			end

			if bonemods[bone].angle ~= rot then
				bonemods[bone].angle = LerpAngle( 0.1, bonemods[bone].angle, rot )
			end
			if bonemods[bone].pos ~= offset then
				bonemods[bone].pos = LerpVector( 0.1, bonemods[bone].pos, offset )
			end
		end
		
	end
								
end

/*function SWEP:CalculateHandMovement(bone)
					
		local offset = Vector(0,0,0)
		local rot = Angle(0,0,0)

		local time = self.SpellTime*0.8
		
		local sp = self.Owner:GetCurrentSpell()
		
		
		if self:IsCasting() and self.ActionMods[bone] then
			if (self:IsAttacking() and !self.OneHandAnim) or self:IsBlocking() then
				rot = Angle(0,0,0)
				offset = Vector(0,0,0)
			else
				offset = self.ActionMods[bone].pos
				rot = self.ActionMods[bone].angle
			end
		else
			if self:IsSwinging() and self.SwingMods and self.SwingMods[bone] and not self:IsBlocking() then
				offset = self.SwingMods[bone].pos
				rot = self.SwingMods[bone].angle
			elseif self:IsBlocking() and self.BlockMods and self.BlockMods[bone] and not self:IsAttacking() then
				offset = self.BlockMods[bone].pos
				rot = self.BlockMods[bone].angle
			elseif self:IsAttacking() and self.AttackMods and self.AttackMods[bone] and not self:IsBlocking() then
				if self.Switch and self.AttackMods2 and self.AttackMods2[bone] then
					offset = self.AttackMods2[bone].pos
					rot = self.AttackMods2[bone].angle
				else
					offset = self.AttackMods[bone].pos
					rot = self.AttackMods[bone].angle
				end
			else
				if self.IdleMods then
					if self.IdleMods[bone] then
						rot,offset = self.IdleMods[bone].angle,self.IdleMods[bone].pos
					end
				else
					rot = Angle(0,0,0)
					offset = Vector(0,0,0)
				end
			end
		end

		self.ViewModelBoneMods[bone].angle = LerpAngle( 0.1, self.ViewModelBoneMods[bone].angle, rot )
		self.ViewModelBoneMods[bone].pos = LerpVector( 0.1, self.ViewModelBoneMods[bone].pos, offset )
		
		--self.ViewModelBoneMods[bone].angle = self:LerpAng( 0.27, self.ViewModelBoneMods[bone].angle, rot )
		--self.ViewModelBoneMods[bone].pos = self:LerpVec( 0.27, self.ViewModelBoneMods[bone].pos, offset )
		
								
end*/

function SWEP:CosineInterpolation(mu,y1,y2)
	local mu2 = (1 - math.cos(mu * math.pi)) / 2
	return y1 * (1 - mu2) + y2 * mu2
end

function SWEP:LerpVec(delta,from, to)
	
	from.x = self:CosineInterpolation( delta, from.x, to.x )
	from.y = self:CosineInterpolation( delta, from.y, to.y )
	from.z = self:CosineInterpolation( delta, from.z, to.z )
	
	return from
end

function SWEP:LerpAng(delta,from, to)
	
	from.p = self:CosineInterpolation( delta, from.p, to.p )
	from.y = self:CosineInterpolation( delta, from.y, to.y )
	from.r = self:CosineInterpolation( delta, from.r, to.r )
	
	return from
end

