os.loadAPI("redString")
os.loadAPI("secAPI")
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

userName, token = secAPI.readIDDisk()

modem.transmit(protocolChannel, terminalID, "register_user "..userName.." "..token)

local event, modemSide, senderChannel, replyChannel,
		message, senderDistance = os.pullEvent("modem_message")


response = parseProtocol(message)

if response.action == "error" then
	error(response.body)
end