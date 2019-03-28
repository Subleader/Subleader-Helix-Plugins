ITEM.name = "Medikit"
ITEM.description = "A Medikit Base."
ITEM.category = "Medical"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.healthPoint = 0
ITEM.medAttr = 0

function ITEM:GetDescription()
		return L(self.description .. "\n \n Medical Skills:" .. self.medAttr .. "\n Health Point : " .. self.healthPoint)
end

ITEM.functions.Apply = {
	name = "Heal myself",
	icon = "icon16/pill.png",
	OnRun = function(itemTable)
		local client = itemTable.player
		local character = client:GetCharacter()
		local medical = character:GetAttribute("medical", 0)
		if medical >= itemTable.medAttr then
			client:SetNWBool("Bleeding",false)
			client:SetNetworkedFloat("NextBandageuse", 2 + CurTime())
			client:SetHealth(math.min(client:Health() + itemTable.healthPoint + medical/2, client:GetMaxHealth()))
			client:EmitSound("stalker/hgn/pl_medkit.wav")
			character:SetAttrib("medical", medical + 0.2)
		else
			client:Notify("Vous n'avez pas les connaissances nécessaires")
			return false
		end
	end
}
ITEM.functions.Give = {
	name = "Heal someone else",
	icon = "icon16/pill.png",
	OnRun = function(itemTable)
		local client = itemTable.player
		local character = client:GetCharacter()
		local medical = character:GetAttribute("medical", 0)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity

		-- Check if the entity is a valid door.
		if (IsValid(entity) and entity:IsPlayer()) then
			if medical >= itemTable.medAttr then
				entity:SetNWBool("Bleeding",false)
				entity:SetNetworkedFloat("NextBandageuse", 2 + CurTime())
				entity:SetHealth(math.min(client:Health() + itemTable.healthPoint + medical/2, entity:GetMaxHealth()))
				client:EmitSound("stalker/hgn/pl_medkit.wav")
				character:SetAttrib("medical", medical + 0.2)
			else
				client:Notify("Vous n'avez pas les connaissances nécessaires")
				return false
			end
		else
			client:Notify("Vous devez regarder un joueur")
			return false
		end
	end
}