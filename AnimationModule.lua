-- AnimationModule

--// ------------------------------- //--

--// Code Example

--// self.walkAnimation = GlobalAnimModule.new(ANIMATION ID, HUMANOID)  
--// self.walkAnimation:PlayAnimation()

--// ------------------------------- //--


local AnimationModule = {}
AnimationModule.__index = AnimationModule

function AnimationModule.new(ID: String, humanoid)
	local self = setmetatable({}, AnimationModule)
	
	--//
	
	self.ID = ID
	self.humanoid = humanoid
	
	--//
	
	local animation = Instance.new("Animation")
	animation.AnimationId = self.ID

	local animator = self.humanoid:WaitForChild("Animator")

	local track = animator:LoadAnimation(animation)
	
	--//
	
	self.animationTrack = track

	
	return self
end

function AnimationModule:PlayAnimation()
	if self.animationTrack and not self.animationTrack.IsPlaying then
		self.animationTrack:Play()
	end
end

function AnimationModule:StopAnimation()
	if self.animationTrack and self.animationTrack.IsPlaying then
		self.animationTrack:Stop()
	end
end

function AnimationModule:GetAnimation()
	for _, track in ipairs(self.humanoid:GetPlayingAnimationTracks()) do
		if track.Animation.AnimationId == self.ID then
			return track
		end
	end
	return nil
end

function AnimationModule:GetLength()
	return self.animationTrack.Length or 0
end

function AnimationModule:IsPlaying()
	return self.animationTrack.IsPlaying or false
end

return AnimationModule

