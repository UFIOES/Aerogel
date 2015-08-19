include("Scripts/AerogelMaterial.lua")
include("Scripts/Aerogel.lua")

-------------------------------------------------------------------------------
if AerogelMaterialSnake == nil then
	AerogelMaterialSnake = AerogelMaterial.Subclass("AerogelMaterialSnake")
	AerogelMaterialSnake.RegisterScriptEvent("Grow", {dir = "int"})
end

function AerogelMaterial:AerogelMaterialSnake(args)
	self.delay = 1
	self.geltype = "AerogelGreen"
	self.active = false
end

function AerogelMaterialSnake:Activate()
	self.active = true
	self:NKGetStaticGraphics():NKSetSubmeshTexture("Diffuse", "Cube", "Green")
end

function AerogelMaterialSnake:Deactivate()
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
	local collMin = vec3(pos - vec3.new(0.49,0.49,0.49))
	local collMax = vec3(pos + vec3.new(0.49,0.49,0.49))

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

		gel:Activate()

	end

	self:Deactivate()

end

EntityFramework:RegisterGameObject(AerogelMaterialSnake)
