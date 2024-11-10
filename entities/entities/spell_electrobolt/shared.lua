ENT.Name = "Electro Bolt"
ENT.Type = "anim"

ENT.Base = "spell__base"

ENT.Mana = 50
ENT.Damage = 17

ENT.CastGesture = ACT_SIGNAL_FORWARD

if CLIENT then
ENT.Mat = Material( "sprites/rollermine_shock" )
end

if CLIENT then 
	GAMEMODE:KilliconAddSpell("spell_electrobolt","electrobolt")
end

if SERVER then
	AddCSLuaFile("shared.lua")
end

PrecacheParticleSystem( "v_electrobolt" )
PrecacheParticleSystem( "electrobolt" )
PrecacheParticleSystem( "electrobolt_splash" )
PrecacheParticleSystem( "electrobolt_main_beam" )
PrecacheParticleSystem( "v_electrobolt_main_beam" )
PrecacheParticleSystem( "electrocuted" )


util.PrecacheSound("ambient/levels/labs/electric_explosion1.wav")
util.PrecacheSound( "npc/vort/attack_shoot.wav" )
local util = util

local endMdl = Model("models/props_junk/PopCan01a.mdl")

function ENT:Cast()
	
	if !self.EntOwner:CanCast(self) then 
		self.EntOwner._efCantCast = CurTime() + 1
	return end
	
	local distance = 900
	local aimvec = self.EntOwner:GetAimVector()
	
	local filter = self.EntOwner:GetMeleeFilter()
	
	local trace = util.TraceLine(
		{
		start = self.EntOwner:GetShootPos(), 
		endpos = self.EntOwner:GetShootPos() + aimvec * distance, 
		filter = filter,
		mask = MASK_PLAYERSOLID
		}
	)	
	
	local tr = {}
	tr.start = self.EntOwner:GetShootPos()
	tr.endpos = self.EntOwner:GetShootPos() + aimvec * distance
	tr.mins = Vector(-22,-22,-14)
	tr.maxs = Vector(22,22,14)
	tr.filter = filter
	tr.mask = MASK_PLAYERSOLID
	
	tr = util.TraceHull(tr)
	
	if tr.Hit and ValidEntity(tr.Entity) and not tr.Entity:IsWorld() then
		trace = tr
	end

	
	self:SetDTFloat(1,CurTime() + 0.2)
	self:SetDTVector(0,trace.HitPos)
	self:SetDTVector(1,vector_origin)
	self:SetDTFloat(2,self.EntOwner:GetShootPos():Distance(self:GetDTVector(0)))
	
	if CLIENT then
		self:SetRenderBoundsWS( self.Entity:GetPos(),self:GetDTVector(0))
		/*if self.End then
			self.End:SetPos(self:GetDTVector(0))
		end*/
	end
	
	if SERVER then
		self:UseDefaultMana()
		
		WorldSound("npc/vort/attack_shoot.wav",self:GetDTVector(0),90,math.random(110,130))
		
		local e = EffectData()
			e:SetOrigin(trace.HitPos)
			e:SetNormal(trace.Normal*-1)
		util.Effect("electrobolt_hit",e,nil,true)
		
		local e = EffectData()
			e:SetOrigin(trace.HitPos)
			e:SetNormal(trace.Normal*-1)
		util.Effect("StunstickImpact",e,true,true)
		
		util.Decal("SmallScorch", trace.HitPos - trace.HitNormal, trace.HitPos + trace.HitNormal)
		
		--local targets = ents.FindInSphere( self:GetDTVector(0), 55 )
		
		--for _,pl in pairs(targets) do
		--	if pl and ValidEntity(pl) and not (trace.Entity:IsPlayer() and trace.Entity:Team() == self.EntOwner:Team()) then
				--trace.Entity = pl
				--break
		--	end
		--end
		if ValidEntity(trace.Entity) and trace.Entity:GetClass() == "projectile_cyclonetrap" and trace.Entity:Team() == self.EntOwner:Team() and not (trace.Entity:GetDTBool(1) or trace.Entity:GetDTBool(2))  then
			trace.Entity:SetDTBool(0,true)
			return 
		end
		
		if ValidEntity(trace.Entity) and not trace.Entity:IsWorld() and not (trace.Entity:IsPlayer() and trace.Entity:IsTeammate(self.EntOwner)) then
			
			local Dmg = DamageInfo()
			Dmg:SetAttacker(self.EntOwner)
			Dmg:SetInflictor(self.Entity)
			Dmg:SetDamage(17+25*trace.Entity:WaterLevel())
			Dmg:SetDamageType(DMG_SHOCK)
			Dmg:SetDamagePosition(self:GetDTVector(0))	
			
			//if trace.Entity:IsPlayer() then
				//local e = EffectData()
				//e:SetEntity(trace.Entity)
				//util.Effect("electrocution",e,true,true)
			//end
			
			trace.Entity:TakeDamageInfo(Dmg)
			
			if trace.Entity:IsPlayer() then
				trace.Entity:SetLocalVelocity(vector_origin)
	
				
				trace.Entity:SetEffect("electrocuted")
				
				if ValidEntity(self.EntOwner) and self.EntOwner:IsPlayer() then
					if self.EntOwner:GetPerk("elementalist") then
						//self.EntOwner:SetMana(self.EntOwner:GetMana()+math.random(9,12),0,self.EntOwner:GetMaxMana())
					end
				end
				
				/*if self.EntOwner:GetPerk("chainreaction") then
					//check for additional player
					for _,pl in pairs(team.GetPlayers(trace.Entity:Team())) do
						if ValidEntity(pl) and pl:Alive() and trace.Entity ~= pl and trace.Entity:GetPos():Distance(pl:GetPos()) <= 120 then
						
							local pos = pl:LocalToWorld(pl:OBBCenter())
							
							self:SetDTVector(1,pos)
						
							local Dmg = DamageInfo()
							Dmg:SetAttacker(self.EntOwner)
							Dmg:SetInflictor(self.Entity)
							Dmg:SetDamage(math.random(20,35))
							Dmg:SetDamageType(DMG_SHOCK)
							Dmg:SetDamagePosition(self:GetDTVector(1))	
									
							pl:SetEffect("electrocuted")		
							pl:TakeDamageInfo(Dmg)
						
							pl:SetLocalVelocity(vector_origin)
							local e = EffectData()
							e:SetEntity(pl)
							util.Effect("electrocution",e,true,true)
							
							local e = EffectData()
							e:SetOrigin(self:GetDTVector(1))
							util.Effect("Sparks",e)
							
							
							break
						end
					end
				end*/
			end
			
		end
			
		
		
	end
	
	--self:SetRenderBounds(Vector(-90, -90, -98), Vector(90, 90, 90))

	
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end
end


function ENT:OnRemove()
	if CLIENT then
		if IsValid(self.EntOwner) then
			self.EntOwner:StopParticles()
		end
		/*if IsValid(self.End) then
			self.End:Remove()
			self.End = nil
		end*/
	end
end

function ENT:Think()
	
	if SERVER then
		if !IsValid(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
	end
	
	if CLIENT then
		if !IsValid(self.End) then
			self:CreateEndPos()
		end
		if IsValid(self.End) and self.End:GetPos() ~= self:GetDTVector(0) then
			self.End:SetPos(self:GetDTVector(0))
		end
	end
	
end

if CLIENT then
function ENT:OnInitialize()
	self:SetRenderBounds(Vector(-90, -90, -98), Vector(90, 90, 90))
	//self.Emitter = ParticleEmitter(self:GetPos())
	
	//self:CreateEndPos()
	
end

function ENT:CreateEndPos()
	/*if IsValid(self.End) then 
		self.End:Remove()
		self.End = nil
	end
	
	self.End = ClientsideModel(endMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE)
	if IsValid(self.End) then
		self.End:SetPos(self:GetPos())
		self.End:SetAngles(self:GetAngles())
		self.End:SetNoDraw(true)
		self.End:SetOwner(self)
	end*/
	
end

function ENT:OnDraw()
	
	local owner = self.EntOwner
	local wep = owner:GetActiveWeapon()
	local point = wep and wep.WElements and wep.WElements["cast"] and wep.WElements["cast"].modelEnt
	
	if self:GetDTFloat(1) and self:GetDTFloat(1) >= CurTime() then
		
		self.LastEmit = self.LastEmit or 0
		
		if self.LastEmit > CurTime() then return end
		
		self.LastEmit = self:GetDTFloat(1) 
		
		if !IsValid(self.BeamParticle) then		
			self.BeamParticle = point:CreateParticleEffect( "electrobolt_main_beam", 0, {} )
			self.BeamParticle:SetShouldDraw( false )
		end
		
		if point and (owner ~= MySelf or GAMEMODE.ThirdPerson) then
			self.BeamParticle:SetControlPoint( 1, self:GetDTVector(0) )
		end
		
		/*if self.End and point and (owner ~= MySelf or GAMEMODE.ThirdPerson) then
			if self.End and self.End:GetPos() ~= self:GetDTVector(0) then
				self.End:SetPos(self:GetDTVector(0))
			end
			local CPoint0 = {
				["entity"] = point,
				["attachtype"] = PATTACH_ABSORIGIN_FOLLOW,
				}
			local CPoint1 = {
				["entity"] = self.End,
				["attachtype"] = PATTACH_ABSORIGIN_FOLLOW,
				}
			self.End:CreateParticleEffect("electrobolt_main_beam",{CPoint0,CPoint1})
			
		end*/
	
	end
	
	if IsValid(self.BeamParticle) and (owner ~= MySelf or GAMEMODE.ThirdPerson) then
		self.BeamParticle:Render()
	end
	
	if owner:GetCurSpellInd() ~= self:GetDTInt(0) then
		if self.Particle then
			self.Particle = nil
			if MySelf == owner and not GAMEMODE.ThirdPerson then
				owner:StopParticles()
			end
		end
		return 
	end
	
	if MySelf == owner and not GAMEMODE.ThirdPerson then
		if self.Particle then
			self.Particle = nil
			owner:StopParticles()
		end
		return
	end
	
	if not self.Particle then
		owner:StopParticles()
		ParticleEffectAttach("electrobolt",PATTACH_POINT_FOLLOW,owner,owner:LookupAttachment("anim_attachment_LH"))
		self.Particle = true
	end
	
end
ENT.CanIgnorePassive = true
function ENT:HandDraw( owner, reverse, point, ignore_passive)
	
	
	if self:GetDTFloat(1) and self:GetDTFloat(1) >= CurTime() and point then
		
		self.VLastEmit = self.VLastEmit or 0
		
		if self.VLastEmit > CurTime() then return end
		
		self.VLastEmit = self:GetDTFloat(1) 
		
		if !IsValid(self.BeamParticleVM) then		
			self.BeamParticleVM = point:CreateParticleEffect( "electrobolt_main_beam", 0, {} )
			self.BeamParticleVM:SetShouldDraw( false )
		end
		
		if self.EntOwner == MySelf then
			self.BeamParticleVM:SetControlPoint( 1, self:GetDTVector(0) )
		end
		
		
		/*if self.EntOwner == MySelf and self.End then
			local CPoint0 = {
				["entity"] = point,
				["attachtype"] = PATTACH_ABSORIGIN_FOLLOW,
				}
			local CPoint1 = {
				["entity"] = self.End,
				["attachtype"] = PATTACH_ABSORIGIN_FOLLOW,
				}
			self.End:CreateParticleEffect("electrobolt_main_beam",{CPoint0,CPoint1})
			
		end*/
	
	end
	
	if IsValid(self.BeamParticleVM) then
		self.BeamParticleVM:Render()
	end
	
	if point and not point.Particle and not ignore_passive then
		ParticleEffectAttach("v_electrobolt",PATTACH_ABSORIGIN_FOLLOW,point,0)
		point.Particle = true
	end
	
	end

end





