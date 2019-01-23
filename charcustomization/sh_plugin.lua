local PLUGIN = PLUGIN
PLUGIN.name = "Character Customization"
PLUGIN.desc = "Panel that allows to change bodygroups and skins"
PLUGIN.author = "Subleader"

ix.util.Include("cl_hooks.lua")

if (SERVER) then
	netstream.Hook("ixBodygroupSend", function(client, index, value)
		local character = client:GetCharacter()
		local groups = character:GetData("groups", {})
		groups[index] = value
		character:SetData("groups", groups)
		client:SetBodygroup(index, value or 0)
	end)

	netstream.Hook("ixSkinSend", function(client, skinmodel)
		local character = client:GetCharacter()
		character:SetData("skin", skinmodel)
		client:SetSkin(skinmodel or 0)
	end)
end
