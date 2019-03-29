local PANEL = {}

-- Called when the panel is initialized.
function PANEL:Init()
	local BodygroupData = {}
	local skinmodel = nil
	self:SetSize(ScrW()/1.8, ScrH()/1.7)
	self:Center()

	self.bottom = vgui.Create( "DButton", self, "bottom" )
	self.bottom:Dock( BOTTOM )
	self.bottom:SetSize( 25, 25 )
	self.bottom:SetText( "Validate" )
	self.bottom:SetFont("ixSmallFont")
	self.bottom:DockMargin( 0, 5, 0, 0 )
	function self.bottom:DoClick()
		local bodygroup = LocalPlayer():GetBodyGroups()
		for k, v in pairs( bodygroup ) do
			local index = v.id
			local value = BodygroupData[v.id]

			if (index > -1) then
				if (value and value < 1) then
					value = nil
				end

				netstream.Start("ixBodygroupSend", index, value)
			end
		end
		netstream.Start("ixSkinSend", skinmodel)
	end

	characterModel = vgui.Create( "ixModelPanel", self, "characterModel" )
	characterModel:SetPos(0, 0)
	characterModel:SetSize( self:GetWide() / 1.30 - 7 , self:GetTall() /3)
	characterModel:SetModel(LocalPlayer():GetCharacter():GetModel())
	characterModel:SetFOV(80)
	characterModel:Dock(RIGHT)

	self.left = vgui.Create( "DScrollPanel", self )
	self.left:Dock( LEFT )
	self.left:SetSize( self:GetWide() / 3 - 7 , self:GetTall() /3)
	self.left:SetPaintBackground( true )
	self.left:DockMargin( 0, 0, 4, 0 )

		self.labelbody = vgui.Create( "DLabel", self, "labelbody" )
		self.labelbody:SetText( "  Bodygroups" )
		self.labelbody:SetFont("ixSmallFont")
		self.labelbody:SetSize( 36, 36 )
		self.labelbody:Dock( TOP )
		self.left:AddItem( self.labelbody )

		local bodygroup = LocalPlayer():GetBodyGroups()
		local bodygrouptest = LocalPlayer():GetCharacter():GetData("groups", {})
		--PrintTable(bodygrouptest)
		--PrintTable(bodygroup)
		for k, v in pairs( bodygroup ) do
			print (k)
			if k > 1 then
				self.but = vgui.Create( "DComboBox", self, "but" )
				self.but:SetValue( v.name )
				self.but:SetFont("ixSmallFont")
				self.but:SetSize( 36, 36 )
				self.but:Dock( TOP )
				if bodygrouptest[k-1] then
					self.but:SetValue( bodygrouptest[k-1] )
					table.insert(BodygroupData, v.id, bodygrouptest[k-1])
					characterModel.Entity:SetBodygroup(v.id, bodygrouptest[k-1])
				end
				--PrintTable(v.submodels)
				for x, y in pairs( v.submodels ) do
					print (x)
					self.but:AddChoice( x , x )
				end
				function self.but:OnSelect(self, index, value)
					if (BodygroupData[v.id]) then
						table.remove(BodygroupData, v.id)
						table.insert(BodygroupData, v.id, value)
						characterModel.Entity:SetBodygroup(v.id, value)
					else
						table.insert(BodygroupData, v.id, value)
						characterModel.Entity:SetBodygroup(v.id, value)
					end
				end 
				self.left:AddItem( self.but )
			end
		end

		self.labelskin = vgui.Create( "DLabel", self, "labelskin" )
		self.labelskin:SetText( "  Skin" )
		self.labelskin:SetFont("ixSmallFont")
		self.labelskin:SetSize( 36, 36 )
		self.labelskin:DockMargin( 0, 20, 0, 0 )
		self.labelskin:Dock( TOP )
		self.left:AddItem( self.labelskin )

		self.butskin = vgui.Create( "DComboBox", self, "butskin" )
		self.butskin:SetValue( LocalPlayer():GetCharacter():GetData("skin", 0) or "Skin" )
		characterModel.Entity:SetSkin(LocalPlayer():GetCharacter():GetData("skin", 0) or "Skin")
		self.butskin:SetFont("ixSmallFont")
		self.butskin:SetSize( 36, 36 )
		self.butskin:SetSortItems( false )
		self.butskin:Dock( TOP )
		local skcount = LocalPlayer():SkinCount()
		for i=0,skcount do
			self.butskin:AddChoice( i )
		end
		function self.butskin:OnSelect(self, index, value)
			skinmodel = index
			characterModel.Entity:SetSkin(index)
		end
		self.left:AddItem( self.butskin )
end

vgui.Register("ixCharacterCustomizer", PANEL, "EditablePanel")