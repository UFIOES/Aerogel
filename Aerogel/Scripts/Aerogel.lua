
-------------------------------------------------------------------------------
if Aerogel == nil then
	Aerogel = EternusEngine.ModScriptClass.Subclass("Aerogel")
end

-------------------------------------------------------------------------------
function Aerogel:Constructor()
	Aerogel.instance = self

	self.directions = {}

	self.directions[1] = vec3.new(1, 0, 0)
	self.directions[2] = vec3.new(-1, 0, 0)
	self.directions[3] = vec3.new(0, 1, 0)
	self.directions[4] = vec3.new(0, -1, 0)
	self.directions[5] = vec3.new(0, 0, 1)
	self.directions[6] = vec3.new(0, 0, -1)

end

 -------------------------------------------------------------------------------
 -- Called once from C++ at engine initialization time
function Aerogel:Initialize()
	--Eternus.CraftingSystem:ParseRecipeFile("Data/Crafting/Aerogel_crafting.txt")
end

-------------------------------------------------------------------------------
-- Called from C++ when the current game enters
function Aerogel:Enter()

end

-------------------------------------------------------------------------------
-- Called from C++ when the game leaves it current mode
function Aerogel:Leave()
end

-------------------------------------------------------------------------------
-- Called from C++ every update tick
function Aerogel:Process(dt)

end

function Aerogel:Save(outData)

end

function Aerogel:Restore(inData, version)

end


EntityFramework:RegisterModScript(Aerogel)
