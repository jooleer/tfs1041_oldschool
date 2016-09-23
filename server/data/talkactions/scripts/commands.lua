local config = {
    listItemId = 1966,
    staffCommands = {
    },
    playerCommands = {
	'/buyhouse - while standing infront of the house, you buy it if you have enough money',
	'/leavehouse - abandons your house, if you have one',
	'/sellhouse [player] - while standing in your house, opens a trade for it with a nearby player',
	'/uptime - check how much time server has been online',
	'/frags - display message with your kills',
	'/online - check players currently online',
	'/played - check time spent playing',
	'/report [message] - send the message to our database with your current position',
	'/loot - enable/disable loot messages',
	'/light - premium account only, disable or enable light aura',
	'/shop - redeem items bought at the web shop',
	'/help - show commands list'
    }
}

function onSay(cid, words, param)
    local player = Player(cid)
    local storeCommands = {}
    local text = ''
    local line = 0

    if player:getGroup():getAccess() then
        for i = 1, #config.staffCommands do
            storeCommands[#storeCommands + 1] = config.staffCommands[i]
        end

        for i = 1, #config.playerCommands do
            storeCommands[#storeCommands + 1] = config.playerCommands[i]
        end       

        text = text .. 'Commands:\n'
        for _, t in ipairs(storeCommands) do
            line = line + 1
            text = text ..'\n'.. t ..'\n'
        end
        player:showTextDialog(config.listItemId, text)
    else
        for i = 1, #config.playerCommands do
            storeCommands[#storeCommands + 1] = config.playerCommands[i]
        end
        text = text .. 'Commands:\n'
        for _, t in ipairs(storeCommands) do
            line = line + 1
            text = text ..'\n'.. t ..'\n'
        end
        player:showTextDialog(config.listItemId, text)   
    end
    return false
end