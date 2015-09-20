local DOOR_OPEN_LEVEL = false
local DOOR_OPEN_LENGTH = 5
local redstone_state = {}


local function probe_redstone()
	local probed_state = {}
	for _, side in pairs(redstone.getSides()) do
		probed_state[side] = redstone.getInput(side)
	end
	return probed_state
end

local function calculate_change(previous_state)
	local changes = {}
	local current_state = probe_redstone()
	for _, side in pairs(redstone.getSides()) do
		if previous_state[side] ~= current_state[side] then
			changes[#changes+1] = side
		end
	end
	return changes
end

while true do
	redstone.setOutput("top", not DOOR_OPEN_LEVEL)
	redstone_state = probe_redstone()

	local _ = os.pullEvent("redstone") --We'll hang here untill the redstone changes

	local sides_changed = calculate_change(redstone_state)

	for _, side in pairs(sides_changed) do
		if side == "left" or side == "front" or side == "right" or side == "back" then
			redstone.setOutput("top", DOOR_OPEN_LEVEL)
			sleep(DOOR_OPEN_LENGTH)
			break
		end
	end
end