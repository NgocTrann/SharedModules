-- [[ Script made by CH50S ]] --

--// GetService
local ss = game:GetService("ServerStorage")
local rs = game:GetService("RunService")
local rep = game:GetService("ReplicatedStorage")

--// Folders
local PetFolder = ss:WaitForChild("Pets") 
local repSharedModulesFolder = rep:WaitForChild("SharedModules")
local petsWorkspaceFolder = workspace:WaitForChild("Pets")

--// Modules
local GlobalAnimModule = require(repSharedModulesFolder:WaitForChild("AnimationModule"))

--/

local Pet = {}
Pet.__index = Pet

function Pet.new(owner: PlayerObject, name: String)
	local self = setmetatable({}, Pet)

	self.owner = owner
	self.ownerCharacter = owner.Character

	self.petName = name
	self.clonedpetObject = nil
	self.petHumanoid = nil

	self.petAnimationsModule = nil
	
	self.ownerID = nil

	self.followConnection = nil
	self.AnimationConnection = nil

	self.walkAnimation = nil
	self.idleAnimation = nil

	return self
end

function Pet:Spawn()
	local FindPet = PetFolder:FindFirstChild(self.petName):Clone()

	FindPet.Parent = petsWorkspaceFolder
	
	local OwnerTag = Instance.new("StringValue", FindPet)
	OwnerTag.Name = "OwnerTag"
	OwnerTag.Value = self.owner.Name
	
	self.clonedpetObject = FindPet
	self.petHumanoid = FindPet:FindFirstChild("Humanoid")
	self.petHumanoidRootPart = FindPet:FindFirstChild("HumanoidRootPart")
	self.petAnimationsModule = require(FindPet:FindFirstChild("Animations"))

	self.walkAnimation = GlobalAnimModule.new(self.petAnimationsModule.WalkAnim, self.petHumanoid)  
	self.idleAnimation = GlobalAnimModule.new(self.petAnimationsModule.IdleAnim, self.petHumanoid)

	self.idleAnimation:PlayAnimation()

	self:EnableAnimation()
end

function Pet:Remove()
	self:DisableFollow()
	
	for i,v in ipairs(petsWorkspaceFolder:GetDescendants()) do
		if v:IsA("StringValue") then
			
		end
	end
	
end

function Pet:ActivateFollow()
	task.spawn(function()
		self.followConection = rs.Heartbeat:Connect(function()
			self.petHumanoid:MoveTo(self.ownerCharacter:WaitForChild("HumanoidRootPart").Position - CFrame.new(self.petHumanoidRootPart.Position, self.ownerCharacter:WaitForChild("HumanoidRootPart").Position).LookVector * 4)
		end)
	end)
end

function Pet:DisableFollow()
	self.followConection:Disconnect()
end

function Pet:EnableAnimation()
	task.spawn(function()
		self.AnimationConnection = rs.Heartbeat:Connect(function()
			if self:IsMoving() == true then
				--// Play Walk Animation

				self.idleAnimation:StopAnimation()

				if self.walkAnimation:IsPlaying() == false then
					self.walkAnimation:PlayAnimation()
				end

			elseif self:IsMoving() == false then
				--// Stop Walk Animation

				self.walkAnimation:StopAnimation()

				if self.idleAnimation:IsPlaying() == false then
					self.idleAnimation:PlayAnimation()
				end
			end
		end)
	end)
end

function Pet:IsMoving()

	if math.floor(self.petHumanoidRootPart.Velocity.Magnitude) > 0 then
		return true
		-- is moving
	else
		return false
		-- not moving
	end

end

return Pet
