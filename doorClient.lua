os.loadAPI("api/sovietProtocol")
os.loadAPI("api/arg")
local args = arg.parseArgs({...})

local PROTOCOL_CHANNEL = 1
local DEBUG_LEVEL = 0

local CONFIG = {}

CONFIG.id = os.getComputerID()
CONFIG.doors = {}

if args.v then
	print("debug mode")
	DEBUG_LEVEL = 9
end

function getConfig(file)

	f = io.open(file, "r")
	if f then
		for line in f:lines() do
			split = redString.split(line)
			CONFIG.doors[split[1]] = {
				side = split[2]}
			if DEBUG_LEVEL > 3 then
				print("Loaded door with id "..split[1].." which outputs on side "..split[2])
			end
		end
		f:close()
		return true
	else
		return false
	end
end

if not getConfig("laika.conf") then
	print("No config detected, loading simple config.")
	CONFIG.doors[os.getComputerID()] = {
		side = "all"
	}
end

sovietProtocol.setDebugLevel(DEBUG_LEVEL)

local laika  = nil
for side, modem in pairs(sovietProtocol.findModems()) do 
	local possible = sovietProtocol.Protocol:new("laika", PROTOCOL_CHANNEL, CONFIG.id, side)
	if possible:hello() then
		laika = possible
		break;
	else
		possible:tearDown()
	end
end

local function openDoor(side)
	if side == "all" then
		for k, side in pairs(redstone.getSides()) do
			redstone.setOutput(side, true)
		end
	else
		redstone.setOutput(side, true)
	end
end

local function closeDoor(side)
	if side == "all" then
		for k, side in pairs(redstone.getSides()) do
			redstone.setOutput(side, false)
		end
	else
		redstone.setOutput(side, false)
	end
end

function openCheck(id, door)
	print("sending check")
	laika:send("can_open", door, id)
	print("waiting for response")
	local sender, response = laika:listen()
	if response.method == "door_open" and response.body == "true" then
		return true
	else
		return false
	end
end
local id = ""
while true do
	id = ""
	local event, drive = os.pullEvent("disk")
	diskRoot = disk.getMountPath(drive)
	idFile = fs.combine(diskRoot, "ID")

	if fs.exists(idFile) then 
		f = io.open(idFile, "r")
		for line in f:lines() do
			id = id..line
		end
		f:close()
	else
		print("invalid disk")
	end

	disk.eject(drive)

	for doorID, door in pairs(CONFIG.doors) do
		if openCheck(id, doorID) then
				openDoor(door.side)
				sleep(5)
				closeDoor(door.side)
		else
			print("invalid ID for door "..doorID)
		end
	end
end
