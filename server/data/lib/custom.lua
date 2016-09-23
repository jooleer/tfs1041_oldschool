-- STORAGES
STORAGEVALUE_PROMOTION = 30018

-- custom Global Storage functions
function getEternalStorageValue(key, parser)
	local value = result.getString(db.storeQuery("SELECT `value` FROM `global_storage` WHERE `key` = " .. key .. ";"), "value")
	if not value then
		if parser then
			return false
		else
			return -1
		end
	end
	return tonumber(value) or value
end
 
function setEternalStorageValue(key, value)
	if getEternalStorageValue(key, true) then
		db.query("UPDATE `global_storage` SET `value` = '" .. value .. "' WHERE `key` = " .. key .. ";")
	else
		db.query("INSERT INTO `global_storage` (`key`, `value`) VALUES (" .. key .. ", " .. value .. ");")
	end
	return true
end

--
function getPartyMembers(player, distance) -- finds all party members in the distance or lower
	local party = player:getParty()
	local partyMembers = {}

    if party then
		if distance then
			if getDistanceBetween(player:getPosition(), party:getLeader():getPosition()) < distance then
				table.insert(partyMembers, party:getLeader():getId())
			end
		else 
			table.insert(partyMembers, party:getLeader():getId())
		end
		for _, member in ipairs(party:getMembers()) do
			if distance then
				if getDistanceBetween(player:getPosition(), Player(member:getId()):getPosition()) < distance then
					table.insert(partyMembers, member:getId())
				end
			else
				table.insert(partyMembers, member:getId())
			end
		end
	else
		table.insert(partyMembers, player:getId())
	end

	return partyMembers
end