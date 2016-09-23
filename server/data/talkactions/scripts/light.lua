function onSay(player, words, param)

	if player:getPremiumDays() > 0 then
		if player:getStorageValue(30015) < 1 then
			player:setStorageValue(30015, 1)
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Light aura enabled.")
			doSetCreatureLight(player:getId(), 8, 215, 24*60*60*1000)
		else
			player:setStorageValue(30015, 0)
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Light aura disabled.")
			player:removeCondition(CONDITION_LIGHT)
		end
	else
		player:sendCancelMessage("You need a premium account.")
	end
	
    return false
end