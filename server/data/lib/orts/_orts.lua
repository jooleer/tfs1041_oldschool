-- load storages first
dofile('data/lib/orts/051-storages.lua')

dofile('data/lib/orts/001-string.lua')
dofile('data/lib/orts/002-tables.lua')

dofile('data/lib/orts/050-functions.lua')
dofile('data/lib/orts/055-teleport_item_destinations.lua')

dofile('data/lib/orts/demonOakQuest.lua')
dofile('data/lib/orts/killingInTheNameOfQuest.lua')
dofile('data/lib/orts/svargrondArenaQuest.lua')
dofile('data/lib/orts/achievements_lib.lua')

-- custom
function getTibianTime()
	local worldTime = getWorldTime()
	local hours = math.floor(worldTime / 60)

	local minutes = worldTime % 60
	if minutes < 10 then
		minutes = '0' .. minutes
	end
	return hours .. ':' .. minutes
end

function getBlessingsCost(level)
	if level <= 30 then
		return 2000
	elseif level >= 120 then
		return 20000
	else
		return (level - 20) * 200
	end
end

function getPvpBlessingCost(level)
	if level <= 30 then
		return 2000
	elseif level >= 270 then
		return 50000
	else
		return (level - 20) * 200
	end
end