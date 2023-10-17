--// [NPC Module] //--

local NpcCombat = {}

function NpcCombat.new()
	local self = setmetatable({}, NpcCombat)

	return self
end

function NpcCombat:FindNearestPlayers(Npc, Config)

	
	local MaxDistance = require(Config).MaxDistance

	local closestPlayer = nil
	local closestDistance = math.huge

	for _, player in pairs(game.Players:GetPlayers()) do
		local Character = player.Character
		if not Character or not Character.Parent then
			Character = player.CharacterAdded:Wait()
		end
		
		local distance = (Npc.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
		if distance < MaxDistance then
			if distance < closestDistance then
				closestDistance = distance
				closestPlayer = Character
			end
		end
	end
	
	if closestPlayer == nil then --warn("Could not find player")
		return nil
	end
	
	return closestPlayer
end

function NpcCombat:GetMagnitude(char1, char2)	
	local distance = (char1.HumanoidRootPart.Position - char2.HumanoidRootPart.Position).Magnitude
	
	return distance
end

return NpcCombat
