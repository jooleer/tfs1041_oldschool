function onLogin(player)
	local loginStr = "Welcome to " .. configManager.getString(configKeys.SERVER_NAME) .. "!"
	if player:getLastLoginSaved() <= 0 then
		loginStr = loginStr .. " Please choose your outfit."
		player:sendOutfitWindow()
	else
		if loginStr ~= "" then
			player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)
		end

		loginStr = string.format("Your last visit was on %s.", os.date("%a %b %d %X %Y", player:getLastLoginSaved()))
	end
	player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)
	
	-- Log In console message
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Welcome back to Tibia.")

	-- Light aura for premium accounts
	if player:getPremiumDays() > 0 then
		player:setStorageValue(30015, 1)
		doSetCreatureLight(player:getId(), 8, 215, 24*60*60*1000)
	end
	
	-- force open gamechat
	player:openChannel(3)
	
	nextUseStaminaTime[player:getId()] = 0
	
	-- Promotion
	local vocation = player:getVocation()
	local promotion = vocation:getPromotion()
	local value = player:getStorageValue(STORAGEVALUE_PROMOTION)
	if not promotion and value ~= 1 then
		player:setStorageValue(STORAGEVALUE_PROMOTION, 1)
	elseif value == 1 then
		player:setVocation(promotion)
	end

	player:registerEvent("PlayerDeath")
	player:registerEvent("DropLoot")
	return true
end
