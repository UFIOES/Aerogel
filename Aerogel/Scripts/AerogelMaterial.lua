include("Scripts/Objects/PlaceableObject.lua")
include("Scripts/Aerogel.lua")

-------------------------------------------------------------------------------
if AerogelMaterial == nil then
	AerogelMaterial = PlaceableObject.Subclass("AerogelMaterial")
end

function AerogelMaterial:Constructor(args)
	self.delay = 1
	self.geltype = "AerogelGreen"
end

function AerogelMaterial:Activate()
	self:NKEnableScriptProcessing(true, 250)
end

function AerogelMaterial:Deactivate(args)
	self:NKEnableScriptProcessing(false)
end

function AerogelMaterial:Interact(args)

	if args.heldItem and args.heldItem:NKGetInstance():InstanceOf(PlaceableMaterial) then

		self:NKEnableScriptProcessing(false)

		self:NKRemoveFromWorld(false, true)

		local gel = Eternus.GameObjectSystem:NKCreateNetworkedGameObject("AerogelRed", true, true):NKGetInstance()

		gel:NKSetPosition(self:NKGetPosition())

		gel:NKPlaceInWorld(true, false)
		gel:NKSetShouldRender(true)

		gel:Activate(args.heldItem:NKGetPlaceable():NKGetMaterialRepID())

		self:NKDeleteMe()

	else

		self:Activate()

	end

	return true

end

function AerogelMaterial:Update(dt)

	if self.delay > 0 then

		self.delay = self.delay - dt

		return

	end

	local pos = self:NKGetPosition()

	for dir = 1, 6 do

		local failed = false

		Eternus.PhysicsWorld:NKSetMaxQueryResults(1000)

		-- setup the AABB
		local collMin = vec3(pos - vec3.new(0.49,0.49,0.49))
		local collMax = vec3(pos + vec3.new(0.49,0.49,0.49))

		local collCenter= vec3(collMin + collMax)*vec3.new(0.5,0.5,0.5)

		local coll = NKPhysics.AABBSweepCollectAll(collMin, collMax, collCenter, Aerogel.instance.directions[dir], 1, {self})

		if type(coll) == "table" then

			for i = 1, table.getn(coll) do

				failed = true

				break

			end
		end

		Eternus.PhysicsWorld:NKResetMaxQueryResults()

		if not failed then

			local gel = Eternus.GameObjectSystem:NKCreateNetworkedGameObject(self.geltype, true, true):NKGetInstance()

			gel:NKSetPosition(pos + Aerogel.instance.directions[dir])

			gel:NKPlaceInWorld(true, false)
			gel:NKSetShouldRender(true)

			gel:Activate()

		end

	end

	self:Deactivate()

end

EntityFramework:RegisterGameObject(AerogelMaterial)
