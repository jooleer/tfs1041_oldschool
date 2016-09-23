local config = {
	[1] = {
		items = {{2530, 1}, {2190, 1}, {2484, 1}, {2458, 1}, {2649, 1}, {2643, 1}, {2050, 1}},
		container = {{2554, 1}, {2120, 1}, {2674, 2}}
	},
	[2] = {
		items = {{2530, 1}, {2182, 1}, {2484, 1}, {2458, 1}, {2649, 1}, {2643, 1}, {2050, 1}},
		container = {{2554, 1}, {2120, 1}, {2674, 2}}
	},
	[3] = {
		items = {{2530, 1}, {2389, 5}, {2484, 1}, {2458, 1}, {2649, 1}, {2643, 1}, {2050, 1}},
		container = {{2554, 1}, {2120, 1}, {2674, 2}, {2419, 1}}
	},
	[4] = {
		items = {{2530, 1}, {2419, 1}, {2484, 1}, {2458, 1}, {2649, 1}, {2643, 1}, {2050, 1}},
		container = {{2554, 1}, {2120, 1}, {2674, 2}, {2321, 1}, {2428, 1}}
	}
}

function onLogin(player)
	local targetVocation = config[player:getVocation():getId()]
	if not targetVocation then
		return true
	end

	if player:getLastLoginSaved() ~= 0 then
		return true
	end

	for i = 1, #targetVocation.items do
		player:addItem(targetVocation.items[i][1], targetVocation.items[i][2])
	end

	local backpack = player:addItem(1988)
	if not backpack then
		return true
	end

	for i = 1, #targetVocation.container do
		backpack:addItem(targetVocation.container[i][1], targetVocation.container[i][2])
	end
		
	local kingletter = backpack:addItem(2598)
	local text = 'You should present yourself to Guide Benedict, ask him about the mission and he shall tell you about it. Remember that is a honour to serve the kingdom, and you should be glad to be chosen to such important task.\n\nSigned,\nKing Talaturen V.'
	kingletter:setAttribute(ITEM_ATTRIBUTE_TEXT, text)
	
	return true
end