local blessings = {
	{id = 5, name = 'Blessing of Faith'},
	{id = 4, name = 'Blessing of the Divine'},
	{id = 3, name = 'Blessing of Hope'},
	{id = 1, name = 'The Spiritual Blessing'},
	{id = 2, name = 'The Sacred Blessing'},
	{id = 6, name = 'Blessing of Peace'}
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local result, bless = 'Received blessings:'
	for i = 1, #blessings do
		bless = blessings[i]
		result = player:hasBlessing(bless.id) and result .. '\n' .. bless.name or result
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 20 > result:len() and 'No blessings received.' or result)
	return true
end