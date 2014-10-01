os.loadAPI("redString")

drive = "left"

function parseProtocol(message)
	local split = redString.split(message)
	ret = {}
	ret["action"] = split[1]
	ret["id"] = tonumber(split[2])
	ret["body"] = split[3]
	return ret
end

protocolChannel = 1

terminalID = tonumber(os.getComputerID())

local modem = peripheral.wrap("right")
modem.open(terminalID)

args = {...}

if not disk.isPresent(drive) then
	error("no disk present")
end

userName = args[1]

if not userName then
	error("usage: createUser [userName]")
end

modem.transmit(protocolChannel, terminalID, "create_user "..userName)

local event, modemSide, senderChannel, replyChannel,
		message, senderDistance = os.pullEvent("modem_message")

print(message)

response = parseProtocol(message)

if response.action == "error" then
	error(response.body)
end

diskRoot = disk.getMountPath(drive)
idFile = fs.combine(diskRoot, "ID")

f = io.open(idFile, "w")
f:write(response.body)
f:close()

disk.setLabel(drive, userName.."'s ID")