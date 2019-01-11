local PLUGIN = PLUGIN
PLUGIN.name = "Better Armor"
PLUGIN.author = "Subleader and Alexgrist (Outfit base used)"
PLUGIN.desc = "Compatible with bad air and localized damage, plus it adds damage resistance"

ix.util.Include("cl_plugin.lua")

function Schema:EntityTakeDamage( target, dmginfo )
	if ( target:IsPlayer() ) then
		if ( target:GetNetVar("resistance") == true ) then
			if (dmginfo:IsDamageType(DMG_BULLET)) then
				dmginfo:ScaleDamage(target:GetNWFloat("dmg_bullet"))
			elseif (dmginfo:IsDamageType(DMG_SLASH)) then
				dmginfo:ScaleDamage(target:GetNWFloat("dmg_slash"))
			elseif (dmginfo:IsDamageType(DMG_SHOCK)) then
				dmginfo:ScaleDamage(target:GetNWFloat("dmg_shock"))
			elseif (dmginfo:IsDamageType(DMG_BURN)) then
				dmginfo:ScaleDamage(target:GetNWFloat("dmg_burn"))
			elseif (dmginfo:IsDamageType(DMG_RADIATION)) then
				dmginfo:ScaleDamage(target:GetNWFloat("dmg_radiation"))
			elseif (dmginfo:IsDamageType(DMG_ACID)) then
				dmginfo:ScaleDamage(target:GetNWFloat("dmg_acid"))
			elseif (dmginfo:IsExplosionDamage()) then
				dmginfo:ScaleDamage(target:GetNWFloat("dmg_explosive"))
			end
		end
	end
end
