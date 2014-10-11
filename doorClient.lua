os.loadAPI("api/sovietProtocol")

doorID = os.getComputerID()
local PROTOCOL_CHANNEL = 1
sovietProtocol.setDebugLevel(9)
local krb = sovietProtocol.Protocol:new("kerberos", PROTOCOL_CHANNEL, doorID)

local function openDoor()
	redstone.setOutput("bottom", true)
end

local function closeDoor()
	redstone.setOutput("bottom", false)
end

function openCheck(id)
	print("sending check")
	krb:send("can_open", doorID, id)
	print("waiting for response")
	local sender, response = krb:listen()
	if response.method == "door_open" and response.body == "true" then
		return true
	else
		return false
	end
end

local function checkID(id)
	return openCheck(id)
end

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
		print(id)
	else
		print("invalid disk")
	end
	disk.eject(drive)

	if checkID(id) then
			openDoor()
			sleep(5)
			closeDoor()
	else
		print("invalid ID")
	end
end
