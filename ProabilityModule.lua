-- //

local Probability = {}

function Probability:generateRandomEvent()
	local Possibilities = { Dog = 100 }

	local totalProbability = 0
	local cumulativeProbabilities = {}

	-- Calculate cumulative probabilities
	for event, probability in pairs(Possibilities) do
		totalProbability = totalProbability + probability
		cumulativeProbabilities[event] = totalProbability
	end

	-- Generate a random number between 0 and 1
	local randomValue = math.random() * totalProbability

	-- Find the event based on the random value
	for event, cumulativeProbability in pairs(cumulativeProbabilities) do
		if randomValue <= cumulativeProbability then
			return event
		end
	end

	-- In case of unexpected situations, return the last event
	return next(Possibilities)
end

return Probability
