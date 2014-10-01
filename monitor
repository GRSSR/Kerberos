protocolChannel = 1

terminalID = tonumber(os.getComputerID())

local modem = peripheral.wrap("right")
modem.open(protocolChannel)

for i =1,100,1 do
	modem.open(i)
end


while true do
	local event, modemSide, senderChannel, replyChannel,
			message, senderDistance = os.pullEvent("modem_message")
	print(message)
end