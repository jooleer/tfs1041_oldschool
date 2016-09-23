function onSpeak(player, type, message)
	local playerAccountType = player:getAccountType()
	local playerAccess = player:getGroup():getAccess()
	if player:getLevel() == 1 and playerAccountType < ACCOUNT_TYPE_GAMEMASTER then
		player:sendCancelMessage("You may not speak into channels as long as you are on level 1.")
		return false
	end

	if type == TALKTYPE_CHANNEL_Y then
		if playerAccountType >= ACCOUNT_TYPE_GAMEMASTER then
			if playerAccess then
				type = TALKTYPE_CHANNEL_R1
			else
				type = TALKTYPE_CHANNEL_Y
			end
		end
	elseif type == TALKTYPE_CHANNEL_O then
		if playerAccountType < ACCOUNT_TYPE_GAMEMASTER then
			type = TALKTYPE_CHANNEL_Y
		end
	elseif type == TALKTYPE_CHANNEL_R1 then
		if playerAccountType < ACCOUNT_TYPE_GAMEMASTER and not getPlayerFlagValue(player, PlayerFlag_CanTalkRedChannel) then
			type = TALKTYPE_CHANNEL_Y
		end
	end
	
	return type
end
