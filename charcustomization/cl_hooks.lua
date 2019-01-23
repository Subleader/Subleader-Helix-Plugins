local PLUGIN = PLUGIN

hook.Add("CreateMenuButtons", "ixCharacterCustomizer", function(tabs)
	tabs["Customization"] = function(container)
		container:Add("ixCharacterCustomizer")
	end
end)