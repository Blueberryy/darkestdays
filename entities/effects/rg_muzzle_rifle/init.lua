local math = math

function EFFECT:Init(data)
	
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()
	
	if !IsValid( MySelf ) then return end
	if self.Position:DistToSqr(MySelf:EyePos()) > 250000 then return end
	
	if !IsValid(self.WeaponEnt) then return end
	if !IsValid(self.WeaponEnt:GetOwner()) then return end
	
	local AddVel = self.WeaponEnt:GetOwner():GetVelocity()
	
	local emitter = ParticleEmitter(self.Position)
		
		ParticleEffect("dd_muzzleflash",self.Position,Angle(0,0,0),self.WeaponEnt)
		//ParticleEffect("muzzle_autorifles",self.Position,self.Angle,self.WeaponEnt)
		
		local ent = self.WeaponEnt:GetOwner() == MySelf and not GAMEMODE.ThirdPerson and MySelf:GetViewModel() or self.WeaponEnt
		
		ParticleEffectAttach("muzzle_autorifles",PATTACH_POINT_FOLLOW,ent,self.Attachment)
		
		local particle = emitter:Add("sprites/heatwave", self.Position - self.Forward*4)
		particle:SetVelocity(80*self.Forward + 20*VectorRand() + 1.05*AddVel)
		particle:SetDieTime(math.Rand(0.18,0.25))
		particle:SetStartSize(math.random(5,10))
		particle:SetEndSize(3)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetGravity(Vector(0,0,100))
		particle:SetAirResistance(160)
		
		local particle = emitter:Add("particle/particle_smokegrenade", self.Position)
		particle:SetVelocity(80*self.Forward + 1.1*AddVel)
		particle:SetDieTime(math.Rand(0.36,0.38))
		particle:SetStartAlpha(math.Rand(50,60))
		particle:SetStartSize(math.random(3,4))
		particle:SetEndSize(math.Rand(17,28))
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(245,245,245)
		particle:SetLighting(true)
		particle:SetAirResistance(80)

		
	for i=-1,1,2 do 
		local particle = emitter:Add("particle/particle_smokegrenade", self.Position)
		particle:SetVelocity(80*i*self.Right + 1.1*AddVel)
		particle:SetDieTime(math.Rand(0.36,0.38))
		particle:SetStartAlpha(math.Rand(50,60))
		particle:SetStartSize(math.random(2,3))
		particle:SetEndSize(math.Rand(12,14))
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(245,245,245)
		particle:SetLighting(true)
		particle:SetAirResistance(160)
	end
	
	emitter:Finish() emitter = nil collectgarbage("step", 64)

end


function EFFECT:Think()

	return false
	
end


function EFFECT:Render()

	
end



