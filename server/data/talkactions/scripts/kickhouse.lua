function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end
	
	local house = House(getTileHouseInfo(player:getPosition()))
	
	if not house then
		player:sendCancelMessage("You are not inside a house.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end
	
	house:setOwnerGuid(0)
	player:sendTextMessage(MESSAGE_INFO_DESCR, "You have successfully removed house owner.")
	return false
	
end