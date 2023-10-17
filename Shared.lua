--// [Shared Modules] //--

--// GetService
local cs = game:GetService("CollectionService")

--// Player
local Player = game.Players.LocalPlayer
local Character = Player.Character
if not Character or not Character.Parent then
	Character = Player.CharacterAdded:Wait()
end

--/

local SharedModules = {}

function SharedModules:IsInfrontOfPlayer(TargetCharacter)
	local dirToOtherPlayer: (Vector3) = (TargetCharacter:WaitForChild("HumanoidRootPart").Position - Character:WaitForChild("HumanoidRootPart").Position).unit
	return Character:WaitForChild("HumanoidRootPart").CFrame.LookVector:Dot(dirToOtherPlayer) > 0.45
end

function SharedModules:MagnitudeCheck(TargetCharacter)
	local rootPart = Character:FindFirstChild("HumanoidRootPart")
	local TargetRootPart = TargetCharacter.HumanoidRootPart

	local distance = (rootPart.Position - TargetRootPart.Position).Magnitude

	return distance 
end

function SharedModules:GetClosestCharacter(TargetFocusDistance)
	TargetFocusDistance = TargetFocusDistance or 20

	local Player = game.Players.LocalPlayer
	local Character = Player.Character
	if not Character then
		return nil
	end

	local closestPlayerObject, closestNpcObject
	local closestDistance, closestNpcDistance = math.huge, math.huge

	local function updateClosestObject(object, distance, isPlayer)
		if distance < TargetFocusDistance and SharedModules.IsInfrontOfPlayer(Character, object) then
			if isPlayer and distance < closestDistance then
				closestPlayerObject, closestDistance, closestNpcObject, closestNpcDistance = object, distance, closestPlayerObject, closestDistance
			elseif not isPlayer and distance < closestNpcDistance then
				closestNpcObject, closestNpcDistance, closestPlayerObject, closestDistance = object, distance, closestNpcObject, closestNpcDistance
			end
		end
	end

	for _, player in ipairs(game.Players:GetPlayers()) do
		if player ~= Player then
			local distance = SharedModules.MagnitudeCheck(player.Character)
			updateClosestObject(player.Character, distance, true)
		end
	end

	for _, npc in pairs(cs:GetTagged("enemy")) do
		local distance = SharedModules.MagnitudeCheck(Character, npc)
		updateClosestObject(npc, distance, false)
	end

	return closestPlayerObject or closestNpcObject
end


return SharedModules
