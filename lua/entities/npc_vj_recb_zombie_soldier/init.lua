AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_recb/recb_zombie_soldier.mdl"} 
ENT.StartHealth = 175
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetSkin(math.random(0,3))
	self:SetBodygroup(1,math.random(0,4))
	
	if self.Vomit_Zombie && !self.Crippled then
	     self:SetVomitZombie()
   end		
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo,hitgroup)
	if self.Damaged == false then --(dmginfo:IsBulletDamage())
		local attacker = dmginfo:GetAttacker()
	
		if math.random(1,10) == 1 && hitgroup == HITGROUP_RIGHTARM then
		ParticleEffect("drg_re1_blood_impact_large",self:GetAttachment(self:LookupAttachment("rarm")).Pos,self:GetAngles())
		self:EmitSound(Sound("vj_recb/zombie/zom_armlost.wav",70))
		self:SetBodygroup(5,1)

		elseif math.random(1,10) == 1 && hitgroup == HITGROUP_LEFTARM then
		ParticleEffect("drg_re1_blood_impact_large",self:GetAttachment(self:LookupAttachment("larm")).Pos,self:GetAngles())
		self:EmitSound(Sound("vj_recb/zombie/zom_armlost.wav",70))
		self:SetBodygroup(6,1)
    end
  end	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	if !self.Crippled then
		local legs = {6,7}
		if VJ_HasValue(legs,hitgroup) then
			self.LegHealth = self.LegHealth -dmginfo:GetDamage()
			if self.LegHealth <= 0 then
				self.Crippled = true
				local anim = ACT_FLINCH_PHYSICS
				if hitgroup == HITGROUP_LEFTLEG then
				    ParticleEffect("drg_re1_blood_impact_large",self:GetAttachment(self:LookupAttachment("lleg")).Pos,self:GetAngles())
					self:SetBodygroup(4,1)
				elseif hitgroup == HITGROUP_RIGHTLEG then
				    ParticleEffect("drg_re1_blood_impact_large",self:GetAttachment(self:LookupAttachment("rleg")).Pos,self:GetAngles())
					self:SetBodygroup(3,1)
end
				if math.random(1,4) == 1 then anim = ACT_FLINCH_PHYSICS end
				self:VJ_ACT_PLAYACTIVITY(anim,true,false,true)
				self:EmitSound(Sound("vj_recb/zombie/zom_leglost.wav",70))
				self:Cripple()
			end
		end
	end
end
 ---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
    if (dmginfo:IsBulletDamage()) && hitgroup == HITGROUP_CHEST then
	    dmginfo:ScaleDamage(0.50)
end
	
local attacker = dmginfo:GetAttacker()
if self.CanBeKnocked == true && math.random(1,20) == 1 && !self.Crippled && GetConVarNumber("VJ_RECB_Knocked") == 1 then
self:VJ_ACT_PLAYACTIVITY("knocked_to_floor",true,100,false)
self.MovementType = VJ_MOVETYPE_STATIONARY
self.HasBeenKnocked = true
self.CanBeKnocked = false
self.VJ_NoTarget = true
self.DisableMakingSelfEnemyToNPCs = true
self.DisableChasingEnemy = true
self.DisableFindEnemy = true
self.DisableWandering = true
self.CanTurnWhileStationary = false
self.HasIdleSounds = false
self.CanFlinch = 0
self:SetCollisionBounds(Vector(50,16,10),Vector(-10,-16,0))

timer.Simple(GetConVarNumber("VJ_RECB_Zombie_GetUp_Time"),function()
if IsValid(self) && !self.Crippled && GetConVarNumber("VJ_RECB_Knocked") == 1 && self.DeathAnimationCodeRan == false && self.Dead == false then
self:VJ_ACT_PLAYACTIVITY("getup",true,2.5,false)
self.HasBeenKnocked = false
self.VJ_NoTarget = false
self.DisableMakingSelfEnemyToNPCs = false
self.DisableChasingEnemy = false
self.DisableFindEnemy = false
self.DisableWandering = false
self.HasIdleSounds = true
self:SetCollisionBounds(Vector(13,13,72),Vector(-13,-13,0))

elseif IsValid(self) && self.Crippled == true && GetConVarNumber("VJ_RECB_Knocked") == 1 && self.DeathAnimationCodeRan == false && self.Dead == false then
self:VJ_ACT_PLAYACTIVITY("crawl_attack",true,1,false)
self.HasBeenKnocked = false
self.VJ_NoTarget = false
self.DisableMakingSelfEnemyToNPCs = false
self.DisableChasingEnemy = false
self.DisableFindEnemy = false
self.DisableWandering = false
self.HasIdleSounds = true
self:SetCollisionBounds(Vector(16,16,20),Vector(-16,-16,0))
end

timer.Simple(3,function()
if IsValid(self) && !self.Crippled then
self.MovementType = VJ_MOVETYPE_GROUND
self.CanBeKnocked = true
self.CanFlinch = 1

elseif IsValid(self) && self.Crippled == true then
self.MovementType = VJ_MOVETYPE_GROUND
self.CanFlinch = 0
end
end)
end)
end
end	
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	if hitgroup == HITGROUP_HEAD && dmginfo:GetDamageForce():Length() > 800 then
	    self:EmitSound(Sound("vj_recb/zombie/zom_headburst.wav",70))
		self:SetBodygroup(0,1)
		self:SetBodygroup(1,5)
	
		if self.HasGibDeathParticles == true then
			for i=1,3 do
				ParticleEffect("drg_re1_blood_impact_large",self:GetAttachment(self:LookupAttachment("head")).Pos,self:GetAngles())
				ParticleEffect("drg_re1_blood_impact_large",self:GetAttachment(self:LookupAttachment("head")).Pos,self:GetAngles())
				ParticleEffect("drg_re1_blood_impact_large",self:GetAttachment(self:LookupAttachment("head")).Pos,self:GetAngles())
				
		local bloodeffect = ents.Create("info_particle_system")
		bloodeffect:SetKeyValue("effect_name","blood_advisor_pierce_spray")
		bloodeffect:SetPos(self:GetAttachment(self:LookupAttachment("head")).Pos)
		bloodeffect:SetAngles(self:GetAttachment(self:LookupAttachment("head")).Ang)
		bloodeffect:SetParent(self)
		bloodeffect:Fire("SetParentAttachment","head")
		bloodeffect:Spawn()
		bloodeffect:Activate()
		bloodeffect:Fire("Start","",0)
		bloodeffect:Fire("Kill","",2)	
				
    end
end
		return true,{DeathAnim=true}
    end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/