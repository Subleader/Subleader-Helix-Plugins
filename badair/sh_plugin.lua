local PLUGIN = PLUGIN
PLUGIN.name = "Bad Air"
PLUGIN.author = "Black Tea and Subleader"
PLUGIN.desc = "Remastered Bad Air"
PLUGIN.toxicAreas = PLUGIN.toxicAreas or {}

ix.util.Include("cl_plugin.lua")

local PLAYER = FindMetaTable("Player")


if (!CLIENT) then
	-- gets two vector and gives min and max vector for Vector:WithinAA(min, max)
	local function sortVector(vector1, vector2)
		local minVector = Vector(0, 0, 0)
		local maxVector = Vector(0, 0, 0)

		for i = 1, 3 do
			if (vector1[i] >= vector2[i]) then
				maxVector[i] = vector1[i]
				minVector[i] = vector2[i]
			else
				maxVector[i] = vector2[i]
				minVector[i] = vector1[i]
			end
		end

		return minVector, maxVector
	end

	ix.badair = ix.badair or {}

	-- get all bad air area.
	function ix.badair.getAll()
		return PLUGIN.toxicAreas
	end

	-- Add toxic bad air area.
	function ix.badair.addArea(vMin, vMax)
		vMin, vMax = sortVector(vMin, vMax)

		if (vMin and vMax) then
			table.insert(PLUGIN.toxicAreas, {vMin, vMax})
		end
	end

	function PLUGIN:SaveData()
		self:SetData(ix.badair.getAll())
	end
	
	function PLUGIN:LoadData()
		PLUGIN.toxicAreas = self:GetData()
	end

	-- This timer does the effect of bad air.
	timer.Create("badairTick", 1, 0, function()
		for _, client in ipairs(player.GetAll()) do
			local char = client:GetCharacter()
			local clientPos = client:GetPos() + client:OBBCenter()
			client.currentArea = nil

			for index, vec in ipairs((ix.badair.getAll() or {})) do
				if (clientPos:WithinAABox(vec[1], vec[2])) then
					if (client:IsAdmin()) then
						client.currentArea = index
					end

					if (client:Alive() and char) then
						if (!client:GetNetVar("gasmask")) then
							client:TakeDamage(3)
							client:ScreenFade(1, ColorAlpha(color_white, 150), .5, 0)
						end		

						break
					end
				end
			end
		end
	end)

	netstream.Start("addArea", function(client, v1, v2)
		if (!client:IsAdmin()) then
			client:notify(L("notAllowed", client))
		end

		client:notify(L("badairAdded", client))
		ix.badair.addArea(v1, v2)
	end)
end

ix.command.Add("badairadd", {
	description = "Add an area",
	adminOnly = true,
	OnRun = function(self, client, arguments)
		local pos = client:GetEyeTraceNoCursor().HitPos

		if (!client:GetNetVar("badairMin")) then
			client:SetNetVar("badairMin", pos, client)
			client:Notify(L("badairCommand", client))
		else
			local vMin = client:GetNetVar("badairMin")
			local vMax = pos
			ix.badair.addArea(vMin, vMax)

			client:SetNetVar("badairMin", nil, client)
			client:Notify(L("badairAdded", client))
		end
	end
})

ix.command.Add("badairremove", {
	description = "Remove an area",
	adminOnly = true,
	OnRun = function(self, client, arguments)
		if (client.currentArea) then
			client:Notify(L("badairRemoved", client))

			table.remove(PLUGIN.toxicAreas, client.currentArea)	
		else
			client:Notify(L("badairBeArea", client))
		end
	end
})

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
