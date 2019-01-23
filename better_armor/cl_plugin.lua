local PLUGIN = PLUGIN

function PLUGIN:RenderScreenspaceEffects()
	local Warning = {"avoxgaming/gas_mask/gas_mask_light/gas_mask_light_breath1.wav", "avoxgaming/gas_mask/gas_mask_light/gas_mask_light_breath2.wav", "avoxgaming/gas_mask/gas_mask_light/gas_mask_light_breath3.wav", "avoxgaming/gas_mask/gas_mask_light/gas_mask_light_breath4.wav", "avoxgaming/gas_mask/gas_mask_light/gas_mask_light_breath5.wav"}
	local ran = math.random(1,table.getn(Warning))
	local Warning1 = {"avoxgaming/gas_mask/gas_mask_middle/gas_mask_middle_breath1.wav", "avoxgaming/gas_mask/gas_mask_middle/gas_mask_middle_breath2.wav", "avoxgaming/gas_mask/gas_mask_middle/gas_mask_middle_breath3.wav", "avoxgaming/gas_mask/gas_mask_middle/gas_mask_middle_breath4.wav", "avoxgaming/gas_mask/gas_mask_middle/gas_mask_middle_breath5.wav"}
	local ran1 = math.random(1,table.getn(Warning1))

	if (LocalPlayer():GetNetVar("gasmask") == true) then
		local character = LocalPlayer():GetCharacter()
		local inventory = character:GetInventory()
		local items = inventory:GetItems()
		local armorHealth = 100
		for k, v in pairs(items) do
			if (v.base == "base_armor" and v:GetData("equip")) then
				armorHealth = v:GetData("Durability", 100)
			end
		end
		if (armorHealth <= 10) then
			DrawMaterialOverlay( "morganicism/metroredux/gasmask/metromask6", 0.2 )
		elseif (armorHealth <= 20) then
			DrawMaterialOverlay( "morganicism/metroredux/gasmask/metromask5", 0.2 )
		elseif (armorHealth <= 40) then
			DrawMaterialOverlay( "morganicism/metroredux/gasmask/metromask4", 0.2 )
		elseif (armorHealth < 60) then
			DrawMaterialOverlay( "morganicism/metroredux/gasmask/metromask3", 0.2 )
		elseif (armorHealth < 80) then
			DrawMaterialOverlay( "morganicism/metroredux/gasmask/metromask2", 0.2 )
		else
			DrawMaterialOverlay( "morganicism/metroredux/gasmask/metromask1", 0.2 )
		end

		if !LocalPlayer().enresp then
			LocalPlayer().enresp = true
			local duration = 3.5
			if LocalPlayer():KeyDown(IN_BULLRUSH) then
				surface.PlaySound( Warning1[ran1] )
				local duration = 2.5
			else
				surface.PlaySound( Warning[ran] )
				local duration = 3.5
			end
			timer.Simple(duration,function() LocalPlayer().enresp = false end)
		end
	else
		LocalPlayer().enresp = false
	end
end