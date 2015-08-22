include("Scripts/AerogelMaterial.lua")
include("Scripts/Aerogel.lua")

-------------------------------------------------------------------------------
if AerogelMaterialSnake == nil then
	AerogelMaterialSnake = AerogelMaterial.Subclass("AerogelMaterialSnake")
	AerogelMaterialSnake.RegisterScriptEvent("Grow", {dir = "int"})
	AerogelMaterialSnake.RegisterScriptEvent("ToggleActiveLock", {})
	AerogelMaterialSnake.RegisterScriptEvent("Deactivate", {force = "boolean"})
end

function AerogelMaterial:AerogelMaterialSnake(args)
	self.delay = 1
	self.geltype = "AerogelGreen"
	self.active = false
	self.activeLock = false
end

function AerogelMaterialSnake:Activate(lock)
	if self.active then return end

	self.active = true

	if lock then
		self.activeLock = true
		self:NKGetStaticGraphics():NKSetSubmeshTexture("Diffuse", "Cube", "Locked")
	else
		self:NKGetStaticGraphics():NKSetSubmeshTexture("Diffuse", "Cube", "Green")
	end

end

function AerogelMaterialSnake:Deactivate(args)
	if self.activeLock and not (args and args.force) then return end
	self.active = false
	self:NKGetStaticGraphics():NKSetSubmeshTexture("Diffuse", "Cube", "Blue")
end

function AerogelMaterialSnake:Update(dt)

end

function AerogelMaterialSnake:Grow(args)

	if not self.active then return end

	local pos = self:NKGetPosition()

	local failed = false

	Eternus.PhysicsWorld:NKSetMaxQueryResults(1000)

	-- setup the AABB
	local collMin = vec3(pos - vec3.new(0.25,0.25,0.25))
	local collMax = vec3(pos + vec3.new(0.25,0.25,0.25))

	local collCenter= vec3(collMin + collMax)*vec3.new(0.5,0.5,0.5)

	local coll = NKPhysics.AABBSweepCollectAll(collMin, collMax, collCenter, Aerogel.instance.directions[args.dir], 1, {self})

	if type(coll) == "table" then

		for i = 1, table.getn(coll) do

			failed = true

			break

		end
	end

	Eternus.PhysicsWorld:NKResetMaxQueryResults()

	if not failed then

		local gel = Eternus.GameObjectSystem:NKCreateNetworkedGameObject(self.geltype, true, true):NKGetInstance()

		gel:NKSetPosition(pos + Aerogel.instance.directions[args.dir])

		gel:NKPlaceInWorld(true, false)
		gel:NKSetShouldRender(true)

		gel:Activate(self.activeLock)

	end

	self:Deactivate()

end

function AerogelMaterialSnake:ToggleActiveLock(args)

	if self.active then

		self.activeLock = not self.activeLock

		if self.activeLock then

			self:NKGetStaticGraphics():NKSetSubmeshTexture("Diffuse", "Cube", "Locked")

		else

			self:NKGetStaticGraphics():NKSetSubmeshTexture("Diffuse", "Cube", "Green")

		end

	end

end

EntityFramework:RegisterGameObject(AerogelMaterialSnake)
