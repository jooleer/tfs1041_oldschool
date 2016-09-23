local holes = {468, 481, 483}
local pools = {2016, 2017, 2018, 2019, 2020, 2021, 2025, 2026, 2027, 2028, 2029, 2030}
function onUse(cid, item, fromPosition, target, toPosition, isHotkey)
	if isInArray(holes, target.itemid) then
		target:transform(target.itemid + 1)
		target:decay()
	elseif isInArray(pools, target.itemid) then
        local hole = 0
        for i = 1, #holes do
            local tile = Tile(target:getPosition()):getItemById(holes[i])
            if tile then
                hole = tile
            end
        end
        if hole ~= 0 then
			target:remove(1)
            hole:transform(hole:getId() + 1)
            hole:decay()
        end
	--[[elseif target.itemid == 231 then
		local rand = math.random(1, 100)
		if rand == 1 then
			Game.createItem(2159, 1, toPosition)
		elseif rand > 95 then
			Game.createMonster("Scarab", toPosition)
		end
		toPosition:sendMagicEffect(CONST_ME_POFF) ]]--
	else
		return false
	end
	return true
end
