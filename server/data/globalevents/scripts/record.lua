function onRecord(current, old)
	addEvent(broadcastMessage, 150, "New record: " .. current .. " players are logged in.", MESSAGE_STATUS_DEFAULT)
	db.query("UPDATE `server_config` SET `value` = " .. os.time() .. " WHERE `config` = 'record_timestamp';")
	return true
end