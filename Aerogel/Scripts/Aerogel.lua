
-------------------------------------------------------------------------------
if Aerogel == nil then
	Aerogel = EternusEngine.ModScriptClass.Subclass("Aerogel")
end

-------------------------------------------------------------------------------
function Aerogel:Constructor()
	Aerogel.instance = self

	self.isKeyBound = false

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

	if self.player and self.player.m_defaultInputContext and not self.isKeyBound then

		self.player.m_defaultInputContext:NKRegisterNamedCommand("North", self, "SnakeNorth", 0.25)
		self.player.m_defaultInputContext:NKRegisterNamedCommand("South", self, "SnakeSouth", 0.25)
		self.player.m_defaultInputContext:NKRegisterNamedCommand("East", self, "SnakeEast", 0.25)
		self.player.m_defaultInputContext:NKRegisterNamedCommand("West", self, "SnakeWest", 0.25)
		self.player.m_defaultInputContext:NKRegisterNamedCommand("Up", self, "SnakeUp", 0.25)
		self.player.m_defaultInputContext:NKRegisterNamedCommand("Down", self, "SnakeDown", 0.25)

		self.isKeyBound = true

	end

end

-------------------------------------------------------------------------------
-- Called from C++ when the game leaves it current mode
function Aerogel:Leave()
end

-------------------------------------------------------------------------------
-- Called from C++ every update tick
function Aerogel:Process(dt)

	if self.player and self.player.m_defaultInputContext and not self.isKeyBound then

		self.player.m_defaultInputContext:NKRegisterNamedCommand("North", self, "SnakeNorth", 0.25)
		self.player.m_defaultInputContext:NKRegisterNamedCommand("South", self, "SnakeSouth", 0.25)
		self.player.m_defaultInputContext:NKRegisterNamedCommand("East", self, "SnakeEast", 0.25)
		self.player.m_defaultInputContext:NKRegisterNamedCommand("West", self, "SnakeWest", 0.25)
		self.player.m_defaultInputContext:NKRegisterNamedCommand("Up", self, "SnakeUp", 0.25)
		self.player.m_defaultInputContext:NKRegisterNamedCommand("Down", self, "SnakeDown", 0.25)

		self.isKeyBound = true

	end

end

function Aerogel:Save(outData)

end

function Aerogel:Restore(inData, version)

end

function Aerogel:LocalPlayerReady(player)
	self.player = player
end

function Aerogel:SnakeNorth(down)
	if not down then return end

	local theta = self.player:NKGetCharacterController():GetTheta() -- x/z

	local x = math.sin(theta)
	local z = -math.cos(theta)

	local dir = 1

	if x >= 0.5 then
		dir = 1
	elseif x <= -0.5 then
		dir = 2
	elseif z >= 0.5 then
		dir = 5
	elseif z <= -0.5 then
		dir = 6
	end

	EventSystem:NKBroadcastEventToClass("Grow", "AerogelMaterialSnake", {dir = dir})
end

function Aerogel:SnakeSouth(down)
	if not down then return end

	local theta = self.player:NKGetCharacterController():GetTheta() -- x/z

	local x = math.sin(theta)
	local z = -math.cos(theta)

	local dir = 2

	if x >= 0.5 then
		dir = 2
	elseif x <= -0.5 then
		dir = 1
	elseif z >= 0.5 then
		dir = 6
	elseif z <= -0.5 then
		dir = 5
	end

	EventSystem:NKBroadcastEventToClass("Grow", "AerogelMaterialSnake", {dir = dir})
end

function Aerogel:SnakeEast(down)
	if not down then return end

	local theta = self.player:NKGetCharacterController():GetTheta() -- x/z

	local x = math.sin(theta)
	local z = -math.cos(theta)

	local dir = 5

	if x >= 0.5 then
		dir = 5
	elseif x <= -0.5 then
		dir = 6
	elseif z >= 0.5 then
		dir = 2
	elseif z <= -0.5 then
		dir = 1
	end

	EventSystem:NKBroadcastEventToClass("Grow", "AerogelMaterialSnake", {dir = dir})
end

function Aerogel:SnakeWest(down)
	if not down then return end

	local theta = self.player:NKGetCharacterController():GetTheta() -- x/z

	local x = math.sin(theta)
	local z = -math.cos(theta)

	local dir = 6

	if x >= 0.5 then
		dir = 6
	elseif x <= -0.5 then
		dir = 5
	elseif z >= 0.5 then
		dir = 1
	elseif z <= -0.5 then
		dir = 2
	end

	EventSystem:NKBroadcastEventToClass("Grow", "AerogelMaterialSnake", {dir = dir})
end

function Aerogel:SnakeUp(down)
	if not down then return end
	EventSystem:NKBroadcastEventToClass("Grow", "AerogelMaterialSnake", {dir = 3})
end

function Aerogel:SnakeDown(down)
	if not down then return end
	EventSystem:NKBroadcastEventToClass("Grow", "AerogelMaterialSnake", {dir = 4})
end


EntityFramework:RegisterModScript(Aerogel)
