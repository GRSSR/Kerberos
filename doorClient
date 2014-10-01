doorID = os.getComputerID()

local modem = peripheral.wrap("top")
modem.open(doorID)

local function openDoor()
	redstone.setOutput("bottom", true)
end

local function closeDoor()
	redstone.setOutput("bottom", false)
end

function openCheck(id)
	print("sending check")
	modem.transmit(1, doorID, "can_open "..doorID.." "..id)
	print("waiting for response")
	local event, modemSide, senderChannel, replyChannel,
		message, senderDistance = os.pullEvent("modem_message")
	if message == "door_open "..doorID.." true" then
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
