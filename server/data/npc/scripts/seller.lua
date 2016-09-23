local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local Topic = {}

function creatureSayCallback(cid, type, msg)
 
	if(not npcHandler:isFocused(cid)) then
		return false
	end
	
	local player = Player(cid)
	local t = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
	local delayTime = 3*1000

	return true
	
end

local function onTradeRequest(cid)
	local player = Player(cid)
	if player:getStorageValue(STORAGEVALUE_DJINNQUEST) < 12 then
		npcHandler:say('Sorry, I don\'t do business with strangers.', cid)
		return false
	end
	return true
end

-- Basic
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'For very important people, I deal with high quality tier equipments.'})
keywordHandler:addAliasKeyword({'offer'})
keywordHandler:addAliasKeyword({'goods'})
keywordHandler:addAliasKeyword({'equipment'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'I am Sumail Hassan, a green djinn.'})

npcHandler:setMessage(MESSAGE_GREET, "What do you want from me, |PLAYERNAME|?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye now, Neutrala |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Bye then.')
npcHandler:setMessage(MESSAGE_SENDTRADE, "At your service, just browse through my wares.")

npcHandler:setCallback(CALLBACK_ONTRADEREQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())