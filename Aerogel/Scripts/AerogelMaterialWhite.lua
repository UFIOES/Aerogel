include("Scripts/AerogelMaterial.lua")
include("Scripts/Aerogel.lua")

-------------------------------------------------------------------------------
if AerogelMaterialWhite == nil then
	AerogelMaterialWhite = AerogelMaterial.Subclass("AerogelMaterialWhite")
	AerogelMaterialWhite.RegisterScriptEvent("Deactivate", {})
end

function AerogelMaterialWhite:Constructor(args)
	self.delay = 1
	self.dir = nil
	self.geltype = "AerogelWhite"
end

function AerogelMaterialWhite:Interact(args)

	if args.heldItem and args.heldItem:NKGetInstance():InstanceOf(PlaceableMaterial) then

		self:NKEnableScriptProcessing(false)

		self:NKRemoveFromWorld(false, true)

		local gel = Eternus.GameObjectSystem:NKCreateNetworkedGameObject("AerogelRed", true, true):NKGetInstance()

		gel:NKSetPosition(self:NKGetPosition())

		gel:NKPlaceInWorld(true, false)
		gel:NKSetShouldRender(true)

		gel:Activate(args.heldItem:NKGetPlaceable():NKGetMaterialRepID())

		self:NKDeleteMe()

		return true

	elseif args.targetPoint then

		local point = args.targetPoint - self:NKGetPosition()

		if point:x() > 0.499 then
			self:Activate(1)
		elseif point:x() < -0.499 then
			self:Activate(2)
		elseif point:y() > 0.499 then
			self:Activate(3)
		elseif point:y() < -0.499 then
			self:Activate(4)
		elseif point:z() > 0.499 then
			self:Activate(5)
		elseif point:z() < -0.499 then
			self:Activate(6)
		end

		return true

	end

end

function AerogelMaterialWhite:Activate(dir)
	if not dir then return end
	self:NKEnableScriptProcessing(true, 250)
	self.dir = dir
	self:NKGetStaticGraphics():NKSetSubmeshTexture("Diffuse", "Cube", "Gold")
end

function AerogelMaterial:Deactivate(args)
	self:NKEnableScriptProcessing(false)
	self:NKGetStaticGraphics():NKSetSubmeshTexture("Diffuse", "Cube", "White")
end

function AerogelMaterialWhite:Update(dt)

	if self.delay > 0 then

		self.delay = self.delay - dt

		return

	end

	local pos = self:NKGetPosition()

	local failed = false

	Eternus.PhysicsWorld:NKSetMaxQueryResults(1000)

	-- setup the AABB
	local collMin = vec3(pos - vec3.new(0.25,0.25,0.25))
	local collMax = vec3(pos + vec3.new(0.25,0.25,0.25))

	local collCenter= vec3(collMin + collMax)*vec3.new(0.5,0.5,0.5)

	local coll = NKPhysics.AABBSweepCollectAll(collMin, collMax, collCenter, Aerogel.instance.directions[self.dir], 1, {self})

	if type(coll) == "table" then

		for i = 1, table.getn(coll) do

			failed = true

			break

		end
	end

	Eternus.PhysicsWorld:NKResetMaxQueryResults()

	if not failed then

		local gel = Eternus.GameObjectSystem:NKCreateNetworkedGameObject(self.geltype, true, true):NKGetInstance()

		gel:NKSetPosition(pos + Aerogel.instance.directions[self.dir])

		gel:NKPlaceInWorld(true, false)
		gel:NKSetShouldRender(true)

		gel:Activate(self.dir)

	end

	self:Deactivate()

end

EntityFramework:RegisterGameObject(AerogelMaterialWhite)
