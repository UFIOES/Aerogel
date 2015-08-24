include("Scripts/Objects/PlaceableObject.lua")

-------------------------------------------------------------------------------
if AerogelMaterialBlack == nil then
	AerogelMaterialBlack = PlaceableObject.Subclass("AerogelMaterialBlack")
end

function AerogelMaterialBlack:Constructor(args)

	self.geltype = "AerogelMatBlack"

	self.delay = 0.1

	self.usedDirs = {}
	self.usedDirs[1] = false
	self.usedDirs[2] = false
	self.usedDirs[3] = false
	self.usedDirs[4] = false
	self.usedDirs[5] = false
	self.usedDirs[6] = false

end

function AerogelMaterialBlack:Activate()
	self:NKEnableScriptProcessing(true, 50)
end

function AerogelMaterialBlack:Deactivate()
	self:NKEnableScriptProcessing(false)
	self:NKDeleteMe()
end

function AerogelMaterialBlack:Update(dt)

	if self.delay > 0 then

		self.delay = self.delay - dt

		return

	end

	local pos = self:NKGetPosition()

	for dir = 1, 6 do

		Eternus.PhysicsWorld:NKSetMaxQueryResults(1000)

		local collMin = vec3(pos - vec3.new(0.25,0.25,0.25))
		local collMax = vec3(pos + vec3.new(0.25,0.25,0.25))

		local collCenter= vec3(collMin + collMax)*vec3.new(0.5,0.5,0.5)

		local coll = NKPhysics.AABBSweepCollectAll(collMin, collMax, collCenter, Aerogel.instance.directions[dir], 1, {self})

		if type(coll) == "table" then

			for i = 1, table.getn(coll) do

				if coll[i].gameobject and coll[i].gameobject:NKGetInstance():InstanceOf(AerogelMaterial) then

					coll[i].gameobject:NKGetInstance():NKDeleteMe()

					local gel = Eternus.GameObjectSystem:NKCreateNetworkedGameObject(self.geltype, true, true):NKGetInstance()

					gel:NKSetPosition(pos + Aerogel.instance.directions[dir])

					gel:NKPlaceInWorld(true, false)
					gel:NKSetShouldRender(true)

					gel:Activate(self.materialID)

					break

				end

			end
		end

		Eternus.PhysicsWorld:NKResetMaxQueryResults()

	end

	self:Deactivate()

end

EntityFramework:RegisterGameObject(AerogelMaterialBlack)
