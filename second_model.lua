PLUGIN.name = "Second model"
PLUGIN.author = "Subleader"
PLUGIN.description = "So a character can have two models."

ix.command.Add("CharSetModelSec", {
	description = "Set the second model of a character.",
	adminOnly = true,
	arguments = {ix.type.character, ix.type.string},
	OnRun = function(self, client, target, model)
		if target then
			target.player:SetModel(model)
			target:SetData("modelCiv", model)
		end
	end
})

ix.command.Add("Swap", { -- Swap from the first and the second model
	description = "Swap from the first and the second model.",
	adminOnly = false,
	OnRun = function(self, client)
		character = client:GetCharacter()
		modelChar = character:GetModel()
		modelCur = client:GetModel()

		if character:GetData("modelCiv") then
			modelCiv = character:GetData("modelCiv")
			if modelChar == modelCur then -- Si le modele du character stored est egal au model du joueur
				client:SetModel(modelCiv)
				client:SetupHands()
				client:Notify("You have your second model")
			else
				client:SetModel(modelChar)
				client:SetupHands()
				client:Notify("You have your first model")
			end
		else
			client:Notify("You need a second model to do this")
		end
	end
})