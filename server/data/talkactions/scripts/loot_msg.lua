function onSay(player, words, param)
    if player:getStorageValue(30016) == 1 then
        player:setStorageValue(30016, 0)
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Loot message has been disabled.")
    else
        player:setStorageValue(30016, 1)
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Loot message has been enabled.")
    end
  
    return false
end