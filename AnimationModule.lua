--// Animation Module //--

local AnimationModule = {


}

function AnimationModule:CreateAnimation(ID, humanoid)
	
	local Animation = Instance.new("Animation")
	Animation.AnimationId = ID
	
	local animator = humanoid:WaitForChild("Animator")

	local Track = animator:LoadAnimation(Animation)

	return Track
end

function AnimationModule:PlayAnimation(Animation)
	if Animation and not Animation.IsPlaying then
		Animation:Play()
	end
end

function AnimationModule:StopAnimation(Animation)
	if Animation and Animation.IsPlaying then
		Animation:Stop()
	end
end

function AnimationModule:GetAnimation(ID, humanoid)
	for i, v in ipairs(humanoid:GetPlayingAnimationTracks()) do
		if v.Animation.AnimationId == ID then
			return v
		end
	end
	return nil  -- Moved this line outside the loop to return nil if no match is found.
end

function AnimationModule:GetLength(Animation)
	if Animation then
		return Animation.Length
	else
		return 0  -- Return 0 if the Animation is nil.
	end
end

function AnimationModule:IsPlaying(Animation)
	if Animation then
		return Animation.IsPlaying
	else
		return false  -- Return false if the Animation is nil.
	end
end

return AnimationModule
