include("Scripts/Objects/PlaceableObject.lua")

-------------------------------------------------------------------------------
if AerogelObject == nil then
	AerogelObject = PlaceableObject.Subclass("AerogelObject")
end

function AerogelObject:Constructor(args)
	self.geltype = args.geltype

	self.modificationInput = {
		modificationType = EternusEngine.Terrain.EVoxelOperations.ePlace, --found in common.lua
		dimensions = vec3.new(1.0,1.0,1.0), --Only needed for cubes and rounded cubes
		radius = 1.0, --Only needed for spheres
		brushType = EternusEngine.Terrain.EVoxelBrushShapes.eCube, --found in common.lua
	}

	self.m_showVoxelSelectionBox = true

end

function AerogelObject:SecondaryAction(args)

	if not args.camManifold then return true end

	-- The resulting truncated position
	local tpp = EternusEngine.Terrain:TruncatePosition(args.camManifold.point, args.camManifold.normal, vec3.new(1.0, 1.0, 1.0), NKTerrain.EVoxelOperations.ePlace)

	Eternus.PhysicsWorld:NKSetMaxQueryResults(1000)

	-- setup the AABB
	local collMin = vec3(tpp - vec3.new(0.45,0.45,0.45)) -- the block is centred on the 1x1x1 voxel, even for bigger voxels
	local collMax = vec3(tpp + vec3.new(0.45,0,0.45)) -- add the extends, except for the y

	local collCenter= vec3(collMin + collMax)*vec3.new(0.5,0.5,0.5)

	local coll = NKPhysics.AABBSweepCollectAll(collMin, collMax, collCenter, vec3(0.0,1.0,0.0), 0.45, nil)

	-- make sure the return value is a table
	if type(coll) == "table" then
		-- loop through the array
		for i = 1, table.getn(coll) do
			-- if the object is a gameobject stop the function
			if coll[i].gameobject then
				return true
			end
		end
	end
	Eternus.PhysicsWorld:NKResetMaxQueryResults()

	local gel = Eternus.GameObjectSystem:NKCreateNetworkedGameObject(self.geltype, true, true):NKGetInstance()

	gel:NKSetPosition(tpp)

	gel:NKPlaceInWorld(true, false)
	gel:NKSetShouldRender(true)

	gel:Activate()

	--remove hand item?

	return true

end

function AerogelObject:GetModificationType()
	return self.modificationInput.modificationType
end

EntityFramework:RegisterGameObject(AerogelObject)
