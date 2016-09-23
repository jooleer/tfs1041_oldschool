local config = {
	 ['troll'] = {amount = 80, storage = 12457, startstorage = 12450, startvalue = 4, mission = 'trolls', creature = 'trolls'},
}

function onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)

	local monster = config[creature:getName():lower()]
	if creature:isPlayer() or not monster or creature:getMaster() then
		return true
	end

	local partyMembers = getPartyMembers(killer, 9)
	local rewardDamage = true
	
	for x=1, #partyMembers do
		local partyMember = Player(partyMembers[x])
		local stor = partyMember:getStorageValue(monster.storage)+1
		if (stor+1) < monster.amount and partyMember:getStorageValue(monster.startstorage) == monster.startvalue then
			partyMember:setStorageValue(monster.storage, stor)
			partyMember:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, ''..(stor+1)..' out of '..monster.amount..' '..monster.creature..' killed.')
		end
		if (stor+1) == monster.amount and partyMember:getStorageValue(monster.startstorage) == monster.startvalue then
			partyMember:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, 'Congratulations, you have killed '..(stor+1)..' '..monster.creature..' and completed the '..monster.mission..' mission.')
			partyMember:setStorageValue(monster.storage, stor)
			partyMember:setStorageValue(monster.startstorage, monster.startvalue+1)
		end
		if partyMember:getId() == mostDamageKiller:getId() then
			rewardDamage = false
		end
	end 
	
	if rewardDamage == true then
		local partyMembers = getPartyMembers(mostDamageKiller, 9)
		for x=1, #partyMembers do
			local partyMember = Player(partyMembers[x])
			local stor = partyMember:getStorageValue(monster.storage)+1
			if (stor+1) < monster.amount and partyMember:getStorageValue(monster.startstorage) == monster.startvalue then
				partyMember:setStorageValue(monster.storage, stor)
				partyMember:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, ''..(stor+1)..' out of '..monster.amount..' '..monster.creature..'s killed.')
			end
			if (stor+1) == monster.amount and partyMember:getStorageValue(monster.startstorage) == monster.startvalue then
				partyMember:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, 'Congratulations, you have killed '..(stor+1)..' '..monster.creature..'s and completed the '..monster.mission..' mission.')
				partyMember:setStorageValue(monster.storage, stor)
				partyMember:setStorageValue(monster.startstorage, monster.startvalue+1)
			end
		end
	end

	return true
	
end