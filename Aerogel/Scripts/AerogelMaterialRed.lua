include("Scripts/AerogelMaterialBlack.lua")

-------------------------------------------------------------------------------
if AerogelMaterialRed == nil then
	AerogelMaterialRed = AerogelMaterialBlack.Subclass("AerogelMaterialRed")
end

function AerogelMaterialRed:Constructor(args)
	self.geltype = "AerogelMatRed"

	self.materialID = NKTerrainGetMaterialID("Mesa Rock")

	self.delay = 0.1

	self.usedDirs = {}
	self.usedDirs[1] = false
	self.usedDirs[2] = false
	self.usedDirs[3] = false
	self.usedDirs[4] = false
	self.usedDirs[5] = false
	self.usedDirs[6] = false

end

function AerogelMaterialBlack:Activate(materialID)

	if materialID then self.materialID = materialID end

	self:NKEnableScriptProcessing(true, 50)

end

function AerogelMaterialRed:Deactivate()

	self:NKEnableScriptProcessing(false)

	self:NKRemoveFromWorld(false, true)

	local input = {
		modificationType = EternusEngine.Terrain.EVoxelOperationsStrings["Place"],
		materialID = self.materialID,
		position = self:NKGetWorldPosition(),
		dimensions = vec3.new(1.0,1.0,1.0),
		radius = 1,
		brushType = EternusEngine.Terrain.EVoxelBrushShapesStrings["Rounded Cube"],
		player = nil,
		userdata1 = self:NKGetNetId()
	}

	Eternus.Terrain:NKModifyWorld(input)

	self:NKDeleteMe()

end

EntityFramework:RegisterGameObject(AerogelMaterialRed)
