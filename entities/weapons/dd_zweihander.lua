if SERVER then 
	AddCSLuaFile() 
end

//Melee base
SWEP.Base = "dd_meleebase"

//Models paths
SWEP.Author = "NECROSSIN"
SWEP.ViewModel = Model ( "models/weapons/c_dsword2.mdl"  )
SWEP.WorldModel = Model ( "models/weapons/w_crowbar.mdl"  )

//Name and fov
SWEP.PrintName = "Zweihander"
SWEP.ViewModelFOV = 70

//Position
SWEP.Slot = 2
SWEP.SlotPos = 6


SWEP.HoldType = "melee2"//melee2

SWEP.MeleeDamage = 42//35
SWEP.MeleeRange = 20+35//64
//SWEP.MeleeSize = math.sqrt(SWEP.MeleeRange)*1.3//9.2

SWEP.SwingTime = 0.2

SWEP.BlockPos  = Vector(-9.36, 1.001, -0.447)
SWEP.BlockAng = Angle(-0.235, -25.39, -69.953)


SWEP.DrawAnim = ACT_VM_DRAW_DEPLOYED

SWEP.StartSwingAnimation = ACT_VM_SECONDARYATTACK

SWEP.IdleAnim = ACT_VM_IDLE_1


SWEP.Primary.Delay = 1.25

SWEP.HitDecal = "Manhackcut"

SWEP.SwingHoldType = "melee2"

SWEP.MeleePower = 115
SWEP.BlockPower = 115

SWEP.NoHitSoundFlesh = true

SWEP.CanSlice = true

for i=1,4 do
	util.PrecacheSound("weapons/dsword/dsword_hit"..i..".wav")
end

util.PrecacheSound("weapons/dsword/dsword_hitwall1.wav")
util.PrecacheSound("weapons/dsword/dsword_stab.wav")

util.PrecacheModel( "models/weapons/c_models/c_claidheamohmor/c_claidheamohmor.mdl" )

//function SWEP:PlaySwingSound()
//	self:EmitSound("weapons/knife/knife_slash"..math.random(1, 2)..".wav")
//end

function SWEP:PlayHitSound()
	//self:EmitSound("weapons/knife/knife_hitwall1.wav")
	self:EmitSound("weapons/dsword/dsword_hitwall1.wav")
end

function SWEP:PlayHitFleshSound()
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
	self:EmitSound("weapons/knife/knife_hit"..math.random(3)..".wav", 130, math.random(80,90))
	//self:EmitSound("weapons/dsword/dsword_hit"..math.random(4)..".wav")
end 

//Killicon
if CLIENT then //killicon.AddFont( "weapon_zs_melee_combatknife", "CSKillIcons", "j", Color(255, 255, 255, 255 ) ) 
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
	killicon.AddFont( "dd_zweihander", "Bison_30", "sliced", Color(231, 231, 231, 255 ) ) 
end

function SWEP:Precache()
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
end

function SWEP:InitializeClientsideModels()
		
	self.ActionMods = {
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(1.241, 71.024, 16) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 49.685, 0) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -4.715, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-30.118, -10.584, -18.035) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.829, -8.815, 2.362) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(2.93, 12.824, 44.318) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.273, 37.96, -5.909) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 76.817, 0) },
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 27.77, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.678, 75.078, 0) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 2.282, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 74.755, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(4.778, 67.012, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-3.971, 0.273, 0) }
	}


	self.ViewModelBoneMods = {}
	
	for k,tbl in pairs(self.ActionMods) do
		self.ViewModelBoneMods[k] = { scale = tbl.scale, pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	end
	
	self.VElements = {
		["cast_point"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.828, 1.155, -0.173), angle = Angle(0, 0, 90), size = Vector(0.224, 0.224, 0.224), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["zweihander"] = { type = "Model", model = "models/weapons/c_models/c_claidheamohmor/c_claidheamohmor.mdl", bone = "handle", rel = "", pos = Vector(0.652, -2.475, -0.285), angle = Angle(0, -90, -180), size = Vector(0.545, 0.545, 0.545), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, use_blood = true }
	}
		

	self.WElements = {
		["zweihander"] = { type = "Model", model = "models/weapons/c_models/c_claidheamohmor/c_claidheamohmor.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.785, 0.86, -0.953), angle = Angle(90, 0, 90), size = Vector(0.619, 0.619, 0.619), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, use_blood = true },
		["cast"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Anim_Attachment_LH", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	//self:InitializeClientsideModels_Additional()
	
end

