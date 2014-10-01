-- protocol action door other
os.loadAPI("redString")
os.loadAPI("secAPI")
local modem = peripheral.wrap("bottom")

protocolChannel = 1

modem.open(protocolChannel)

secAPI.loadUsers("/database/users")

function parseProtocol(message)
	local split = redString.split(message)
	ret = {}
	ret["action"] = split[1]
	ret["id"] = split[2]
	ret["body"] = split[3]
	return ret
end

function checkDoorAccess(doorID, user)
	accessList = secAPI.loadAccessList(fs.combine("database", doorID))
	if accessList[user] == true then
		return true
	end
	return false
end

function can_open(origin, doorID, userToken)
	user = secAPI.mapUser(userToken)
	if user then
		if checkDoorAccess(doorID, user) then
			modem.transmit(origin, protocolChannel, "door_open "..doorID.." true")
			print("sent door_open "..doorID.." true")
		else
			modem.transmit(origin, protocolChannel, "door_open "..doorID.." false")
		end
	else
		modem.transmit(origin, protocolChannel, "door_open "..doorID.." false")
	end
end

function create_user(origin, userName, none)
	userToken = secAPI.generateKey(50)
	secAPI.addUser(userName, userToken)
	secAPI.saveUsers("/database/users")
	print("sending: ".."user_key "..userName.." "..userToken)
	modem.transmit(origin, protocolChannel, "user_key "..userName.." "..userToken)
end

function register_user(origin, userName, userToken)
	secAPI.addUser(userName, userToken)
	secAPI.saveUsers("/database/users")
	modem.transmit(origin, protocolChannel, "user_key "..userName.." "..userToken)
end

function allow_access(origin, doorID, userToken)
	userName = secAPI.mapUser(userToken)
	accessList = secAPI.loadAccessList(fs.combine("database", doorID))
	accessList[userName] = true
	secAPI.saveAccessList(fs.combine("database", doorID), accessList)
	modem.transmit(origin, protocolChannel, "access_granted "..userName.." "..doorID)
end

function register_door(origin, doorID, none)
end

methods = {
	["can_open"] = can_open,
	["create_user"] = create_user,
	["register_user"] = register_user,
	["allow_access"] = allow_access
}

function handleRequest(origin, request)
	if request.action and request.id then
		if methods[request.action] then
			methods[request.action](origin, request.id, request.body)
		else
			print("invalid method "..request.action)
			return false
		end
	else
		print("incomplete request")
		return false
	end
	print("request handled")
	return true
end

print("Starting DoorSecServer")

while true do
	local event, modemSide, senderChannel, replyChannel,
		message, senderDistance = os.pullEvent("modem_message")
		print("recieved request:"..message)
		if not handleRequest(replyChannel, parseProtocol(message)) then
			modem.transmit(replyChannel, 1, "error")
		end

end
