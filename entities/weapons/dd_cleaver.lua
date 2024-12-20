if SERVER then 
	AddCSLuaFile() 
end

//Melee base
SWEP.Base = "dd_meleebase"

//Models paths
SWEP.Author = "NECROSSIN"
SWEP.ViewModel = Model ( "models/weapons/cstrike/c_knife_t.mdl"  )
SWEP.WorldModel = Model ( "models/weapons/w_crowbar.mdl"  )

SWEP.IdleAnim = ACT_VM_IDLE

//Name and fov
SWEP.PrintName = "Cleaver"
SWEP.ViewModelFOV = 60

//Position
SWEP.Slot = 2
SWEP.SlotPos = 6

SWEP.HoldType = "melee2"

SWEP.MeleeDamage = 20//16
SWEP.MeleeRange = 20 + 15//45
//SWEP.MeleeSize = math.sqrt(SWEP.MeleeRange)*1.3//5

SWEP.SwingTime = 0.16

SWEP.HitDecal = "Manhackcut"

//SWEP.BlockPos = Vector(-7.08, 0, -10.12)
//SWEP.BlockAng = Angle(25.222, 19.809, -44.902)
SWEP.BlockPos = Vector(0, 0, 0)
SWEP.BlockAng = Angle(0, 0, 0)

SWEP.Primary.Delay = 0.7

SWEP.SwingHoldType = "melee"

SWEP.NoHitSoundFlesh = true

SWEP.Dismember = true

SWEP.BlockPower = 90

for i=1,3 do
	util.PrecacheSound("physics/metal/metal_computer_impact_bullet"..i..".wav")
end

--util.PrecacheModel( "models/weapons/c_models/c_sd_cleaver/c_sd_cleaver.mdl" )

//function SWEP:PlaySwingSound()
//	self:EmitSound("Weapon_Crowbar.Single")
//end

function SWEP:PlayHitSound()
	self:EmitSound("ambient/machines/slicer"..math.random(1,4)..".wav",100, math.Rand(100, 110))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.Rand(86, 90)) 
	self:EmitSound("ambient/machines/slicer"..math.random(1,4)..".wav",100, math.Rand(100, 110))
end

//Killicon
if CLIENT then
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
	GAMEMODE:KilliconAddFontTranslated( "dd_cleaver", "Bison_30", "killicon_cleaver", Color(231, 231, 231, 255 ) )

end

function SWEP:Precache()
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr, block)
	if not block and hitent:IsValid() and hitent:IsPlayer() and not self.m_ChangingDamage and math.abs(hitent:GetForward():Angle().yaw - self.Owner:GetForward():Angle().yaw) <= 90 then
		self.m_ChangingDamage = true
		self.MeleeDamage = self.MeleeDamage * 3
	end
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr, block)
	if self.m_ChangingDamage then
		self.m_ChangingDamage = false

		self.MeleeDamage = self.MeleeDamage / 3
	end
end
 

function SWEP:InitializeClientsideModels()

	/*self.ActionMods = {
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 29.048, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0.425, 4.719, -1.417), angle = Angle(-27.328, -0.086, -8.014) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(11.659, 5.785, 10.493) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-6.814, 17.486, 0.984) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 25.04, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 33.259, 0) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-17.48, 35.192, -0.895) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 7.063, 0) }
	}	
	
	self.BlockMods = {
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(6.375, -0.486, 1.57), angle = Angle(3.802, 17.038, -4.722) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-14.047, -25.187, 29.27) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(11.609, 3.542, 11.421) }
	}*/

	self.ActionMods = {
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-31.568, 12.215, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 13.553, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -14.557, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 37.821, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 40.824, 0) },
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 6.852, 0) },
		["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 27.712, 0) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(2.578, 47.837, -5.361) },
		["ValveBiped.Bip01_L_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 27.241, 0) },
		["ValveBiped.Bip01_L_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-15.391, 20.045, 0) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(21.796, 60.664, 19.642) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-11.895, 38.216, -14.391) },
		["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-0.605, -17.001, -0.76) }
	}

	self.BlockMods = {
		["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-1.207, 18.925, 4.436) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(6.168, -1.538, -3.995) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-6.495, 3.173, 0) }
	}

	self.ViewModelBoneMods = {}

	for k,tbl in pairs(self.ActionMods) do
		self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end

	for k,tbl in pairs(self.BlockMods) do
		self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end

	self.VElements = {
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.828, 1.155, -0.173), angle = Angle(0, 0, 90), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		//["cleaver"] = { type = "Model", model = "models/props_lab/cleaver.mdl", bone = "handle", rel = "", pos = Vector(-0.53099998235703, -0.44400000572205, -0.14200000464916), angle = Angle(0, -90, 90), size = Vector(0.75400000810623, 0.75400000810623, 0.75400000810623), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		["cleaver"] = { type = "Model", model = "models/props_lab/cleaver.mdl", bone = "v_weapon.Knife_Handle", rel = "", pos = Vector(0.024, -1.0, 1.228), angle = Angle(-90, 90, 0), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, bonemerge = false, highrender = false, nocull = false, material = "", skin = 0, bodygroup = {}, fix_scale = true },
	}

	self.WElements = {
		--["cleaver"] = { type = "Model", model = "models/weapons/c_models/c_sd_cleaver/c_sd_cleaver.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.417, 1.491, 0.239), angle = Angle(0, 0, 180), size = Vector(0.882, 0.882, 0.882), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {}, use_blood = true },
		["cleaver"] = { type = "Model", model = "models/props_lab/cleaver.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.2269999980927, 1.1879999637604, -0.14200000464916), angle = Angle(103.02799987793, 0, 0), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, fix_scale = true },
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	
	
end