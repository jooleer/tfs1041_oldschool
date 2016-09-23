function Player:onBrowseField(position)
	-- browse field disabled
	self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	return false
end

function Player:onLook(thing, position, distance)
	local description = 'You see '
	if thing:isItem() then
		description = description .. thing:getDescription(distance)
	else
		description = description .. thing:getDescription(distance)
	end
	
	if self:getGroup():getAccess() then
		if thing:isItem() then
			description = string.format("%s\nItem ID: %d", description, thing:getId())

			local actionId = thing:getActionId()
			if actionId ~= 0 then
				description = string.format("%s, Action ID: %d", description, actionId)
			end

			local uniqueId = thing:getAttribute(ITEM_ATTRIBUTE_UNIQUEID)
			if uniqueId > 0 and uniqueId < 65536 then
				description = string.format("%s, Unique ID: %d", description, uniqueId)
			end

			local itemType = thing:getType()

			local transformEquipId = itemType:getTransformEquipId()
			local transformDeEquipId = itemType:getTransformDeEquipId()
			if transformEquipId ~= 0 then
				description = string.format("%s\nTransforms to: %d (onEquip)", description, transformEquipId)
			elseif transformDeEquipId ~= 0 then
				description = string.format("%s\nTransforms to: %d (onDeEquip)", description, transformDeEquipId)
			end

			local decayId = itemType:getDecayId()
			if decayId ~= -1 then
				description = string.format("%s\nDecays to: %d", description, decayId)
			end
		elseif thing:isCreature() then
			local str = "%s\nHealth: %d / %d"
			if thing:getMaxMana() > 0 then
				str = string.format("%s, Mana: %d / %d", str, thing:getMana(), thing:getMaxMana())
			end
			description = string.format(str, description, thing:getHealth(), thing:getMaxHealth()) .. "."
		end

		local position = thing:getPosition()
		description = string.format(
			"%s\nPosition: %d, %d, %d",
			description, position.x, position.y, position.z
		)

		if thing:isCreature() then
			if thing:isPlayer() then
				description = string.format("%s\nIP: %s.", description, Game.convertIpToString(thing:getIp()))
			end
		end
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInBattleList(creature, distance)
	local description = "You see " .. creature:getDescription(distance)
	if self:getGroup():getAccess() then
		local str = "%s\nHealth: %d / %d"
		if creature:getMaxMana() > 0 then
			str = string.format("%s, Mana: %d / %d", str, creature:getMana(), creature:getMaxMana())
		end
		description = string.format(str, description, creature:getHealth(), creature:getMaxHealth()) .. "."

		local position = creature:getPosition()
		description = string.format(
			"%s\nPosition: %d, %d, %d",
			description, position.x, position.y, position.z
		)

		if creature:isPlayer() then
			description = string.format("%s\nIP: %s", description, Game.convertIpToString(creature:getIp()))
		end
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInTrade(partner, item, distance)
	self:sendTextMessage(MESSAGE_INFO_DESCR, "You see " .. item:getDescription(distance))
end

function Player:onLookInShop(itemType, count)
	return true
end

function Player:onMoveItem(item, count, fromPosition, toPosition)
	if item.actionid == 101 then
		self:sendCancelMessage('You cannot move this object.')
		return false
	end
	return true
end

function Player:onMoveCreature(creature, fromPosition, toPosition)
	return true
end

function Player:onTurn(direction)
	return true
end

function Player:onTradeRequest(target, item)
	if item.actionid == 101 then
		self:sendCancelMessage('You cannot move this object.')
		return false
	end
	return true
end

function Player:onTradeAccept(target, item, targetItem)
	return true
end

local soulCondition = Condition(CONDITION_SOUL, CONDITIONID_DEFAULT)
soulCondition:setTicks(4 * 60 * 1000)
soulCondition:setParameter(CONDITION_PARAM_SOULGAIN, 1)

local function useStamina(player)
	local staminaMinutes = player:getStamina()
	if staminaMinutes == 0 then
		return
	end

	local playerId = player:getId()
	local currentTime = os.time()
	local timePassed = currentTime - nextUseStaminaTime[playerId]
	if timePassed <= 0 then
		return
	end

	if timePassed > 60 then
		if staminaMinutes > 2 then
			staminaMinutes = staminaMinutes - 2
		else
			staminaMinutes = 0
		end
		nextUseStaminaTime[playerId] = currentTime + 120
	else
		staminaMinutes = staminaMinutes - 1
		nextUseStaminaTime[playerId] = currentTime + 60
	end
	player:setStamina(staminaMinutes)
end

function Player:onGainExperience(source, exp, rawExp)
	if not source or source:isPlayer() then
		return exp
	end

	-- Soul regeneration
	local vocation = self:getVocation()
	if self:getSoul() < vocation:getMaxSoul() and exp >= self:getLevel() then
		soulCondition:setParameter(CONDITION_PARAM_SOULTICKS, vocation:getSoulGainTicks() * 1000)
		self:addCondition(soulCondition)
	end

	-- Apply experience stage multiplier
	exp = exp * Game.getExperienceStage(self:getLevel())
	
	if self:isPremium() then
		exp = exp * 1.10
	end

	-- Stamina modifier
	if configManager.getBoolean(configKeys.STAMINA_SYSTEM) then
		useStamina(self)

		local staminaMinutes = self:getStamina()
		if staminaMinutes > 2400 and self:isPremium() then
			exp = exp * 1.5
		elseif staminaMinutes <= 840 then
			exp = exp * 0.5
		end
	end

	return exp
end

function Player:onLoseExperience(exp)
	return exp
end

-------------------------
-- staged skill system --
-------------------------

--[[
-- old function
function Player:onGainSkillTries(skill, tries)
	if skill == SKILL_MAGLEVEL then
		return tries * configManager.getNumber(configKeys.RATE_MAGIC)
	end
	return tries * configManager.getNumber(configKeys.RATE_SKILL)
end
]]--

local config = {
        -- base vocationId
        [0] = {
                -- skillId
                [SKILL_FIST] = {
                        -- [{skillLevel}] = skillRate
                        [{0, 14}] = 12,
                        [{15, 21}] = 8
                },
                [SKILL_CLUB] = {
                        [{0, 14}] = 12,
                        [{15, 21}] = 8
                },
                [SKILL_SWORD] = {
                        [{0, 14}] = 12,
                        [{15, 21}] = 8
                },
                [SKILL_AXE] = {
                        [{0, 14}] = 12,
                        [{15, 21}] = 8
                },
                [SKILL_DISTANCE] = {
                        [{0, 14}] = 12,
                        [{15, 21}] = 8
                },
                [SKILL_SHIELD] = {
                        [{0, 19}] = 12,
                        [{20, 26}] = 8
                },
                [SKILL_FISHING] = {
                        [{0, 19}] = 12,
                        [{20, 29}] = 8
                }
        },
        [1] = {
                -- skillId
                [SKILL_FIST] = {
                        -- [{skillLevel}] = skillRate
                        [{0, 14}] = 12,
                        [{15, 21}] = 8
                },
                [SKILL_CLUB] = {
                        [{0, 14}] = 12,
                        [{15, 21}] = 8
                },
                [SKILL_SWORD] = {
                        [{0, 14}] = 12,
                        [{15, 21}] = 8
                },
                [SKILL_AXE] = {
                        [{0, 14}] = 12,
                        [{15, 21}] = 8
                },
                [SKILL_DISTANCE] = {
                        [{0, 14}] = 12,
                        [{15, 21}] = 8
                },
                [SKILL_SHIELD] = {
                        [{0, 19}] = 12,
                        [{20, 26}] = 8
                },
                [SKILL_FISHING] = {
                        [{0, 19}] = 12,
                        [{20, 29}] = 8
                },
                [SKILL_MAGLEVEL] = {
                        [{0, 30}] = 5,
                        [{31, 35}] = 4,
                        [{36, 45}] = 3,
						[{46, 55}] = 2.5,
						[{56, 65}] = 2,
                        [{66, 99}] = 1
                }
        },
                [2] = {
                -- skillId
                [SKILL_FIST] = {
                        -- [{skillLevel}] = skillRate
                        [{0, 14}] = 12,
                        [{15, 21}] = 8
                },
                [SKILL_CLUB] = {
                        [{0, 14}] = 12,
                        [{15, 21}] = 8
                },
                [SKILL_SWORD] = {
                        [{0, 14}] = 12,
                        [{15, 21}] = 8
                },
                [SKILL_AXE] = {
                        [{0, 14}] = 12,
                        [{15, 21}] = 8
                },
                [SKILL_DISTANCE] = {
                        [{0, 14}] = 12,
                        [{15, 21}] = 8
                },
                [SKILL_SHIELD] = {
                        [{0, 19}] = 12,
                        [{20, 26}] = 8
                },
                [SKILL_FISHING] = {
                        [{0, 19}] = 12,
                        [{20, 29}] = 8
                },
                [SKILL_MAGLEVEL] = {
                        [{0, 30}] = 5,
                        [{31, 35}] = 4,
                        [{36, 45}] = 3,
						[{46, 55}] = 2.5,
						[{56, 65}] = 2,
                        [{66, 99}] = 1
                }
        },
                [3] = {
                -- skillId
                [SKILL_FIST] = {
                        -- [{skillLevel}] = skillRate
                        [{0, 30}] = 12,
                        [{31, 40}] = 8
                },
                [SKILL_CLUB] = {
                        [{0, 30}] = 12,
                        [{31, 40}] = 8
                },
                [SKILL_SWORD] = {
                        [{0, 30}] = 12,
                        [{31, 40}] = 8
                },
                [SKILL_AXE] = {
                        [{0, 30}] = 12,
                        [{31, 40}] = 8
                },
                [SKILL_DISTANCE] = {
                        [{0, 40}] = 12,
						[{41, 50}] = 10,
						[{51, 60}] = 8,
                        [{61, 75}] = 7,
						[{76, 85}] = 6,
						[{86, 90}] = 5,
                        [{91, 95}] = 4,
                        [{96, 150}] = 1
                },
                [SKILL_SHIELD] = {
                        [{0, 40}] = 12,
						[{41, 50}] = 10,
						[{51, 60}] = 8,
                        [{61, 75}] = 7,
						[{76, 85}] = 6,
						[{86, 90}] = 5,
                        [{91, 95}] = 4,
                        [{96, 150}] = 1
                },
                [SKILL_FISHING] = {
                        [{0, 19}] = 12,
                        [{20, 29}] = 8
                },
                [SKILL_MAGLEVEL] = {
                        [{0, 8}] = 5,
                        [{9, 13}] = 4,
                        [{14, 16}] = 3,
						[{17, 18}] = 2,
                        [{19, 90}] = 1
                }
        },
                [4] = {
                -- skillId
                [SKILL_FIST] = {
                        -- [{skillLevel}] = skillRate
                        [{0, 40}] = 12,
						[{41, 50}] = 10,
						[{51, 60}] = 8,
                        [{61, 75}] = 7,
						[{76, 85}] = 6,
						[{86, 90}] = 5,
                        [{91, 95}] = 4,
                        [{96, 150}] = 1
                },
                [SKILL_CLUB] = {
                        [{0, 40}] = 12,
						[{41, 50}] = 10,
						[{51, 60}] = 8,
                        [{61, 75}] = 7,
						[{76, 85}] = 6,
						[{86, 90}] = 5,
                        [{91, 95}] = 4,
                        [{96, 150}] = 1
                },
                [SKILL_SWORD] = {
                        [{0, 40}] = 12,
						[{41, 50}] = 10,
						[{51, 60}] = 8,
                        [{61, 75}] = 7,
						[{76, 85}] = 6,
						[{86, 90}] = 5,
                        [{91, 95}] = 4,
                        [{96, 150}] = 1
                },
                [SKILL_AXE] = {
                        [{0, 40}] = 12,
						[{41, 50}] = 10,
						[{51, 60}] = 8,
                        [{61, 75}] = 7,
						[{76, 85}] = 6,
						[{86, 90}] = 5,
                        [{91, 95}] = 4,
                        [{96, 150}] = 1
                },
                [SKILL_DISTANCE] = {
                        [{0, 30}] = 12,
                        [{31, 40}] = 8
                },
                [SKILL_SHIELD] = {
                        [{0, 40}] = 12,
						[{41, 50}] = 10,
						[{51, 60}] = 8,
                        [{61, 75}] = 7,
						[{76, 85}] = 6,
						[{86, 90}] = 5,
                        [{91, 95}] = 4,
                        [{96, 150}] = 1
                },
                [SKILL_FISHING] = {
                        [{0, 19}] = 12,
                        [{20, 29}] = 8
                },
                [SKILL_MAGLEVEL] = {
                        [{0, 3}] = 5,
                        [{4, 4}] = 4,
                        [{5, 6}] = 3,
                        [{7, 8}] = 2,
                        [{9, 90}] = 1
                }
        }
}

local function getSkillRate(player, skillId)
        local targetVocation = config[player:getVocation():getBase():getId()]
        if targetVocation then
                local targetSkillStage = targetVocation[skillId]
                if targetSkillStage then
						if (skillId == 7) then
							skillLevelz = player:getMagicLevel()
						else
							skillLevelz = player:getSkillLevel(skillId)
						end
                        for level, rate in pairs(targetSkillStage) do
								if not skillLevelz then
										return rate
								end
                                if skillLevelz >= level[1] and skillLevelz <= level[2] then
                                        return rate
                                end
                        end
                end
        end
 
        return skillId == SKILL_MAGLEVEL and configManager.getNumber(configKeys.RATE_MAGIC) or configManager.getNumber(configKeys.RATE_SKILL)
end
 
function Player:onGainSkillTries(skill, tries)
        if not APPLY_SKILL_MULTIPLIER then
                return tries
        end
        return tries * getSkillRate(self, skill)
end
-- end of staged skill system 
