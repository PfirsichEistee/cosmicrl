
addEvent("loginCheckClient", true)
addEvent("getRegisterData", true)
addEvent("getLoginData", true)



local function checkPlayer()
	cosmicSetElementData(client, "Online", false)
	triggerClientEvent(client, "clearChat", client)
	
	local result = dbPoll(dbQuery(dbHandler, "SELECT Username, IP, Serial FROM player WHERE Username=? OR IP=? AND Serial=?", getPlayerName(client), getPlayerIP(client), getPlayerSerial(client)), -1)
	
	if result then
		if #result > 0 then -- Player exists already
			for i = 1, #result, 1 do
				if result[i]["Username"] == getPlayerName(client) then
					triggerClientEvent(client, "clientStartLogin", client)
					return
				end
			end
			
			kickPlayer(client, "Du hast bereits einen anderen Account unter dem Namen \"" .. result[1]["Username"] .. "\"")
		else -- New player joined
			triggerClientEvent(client, "clientStartRegister", client)
		end
	end
end
addEventHandler("loginCheckClient", getRootElement(), checkPlayer)


local function loginPlayer(password)
	if password then
		local id = NameToID(getPlayerName(client))
		
		local playerResult = dbPoll(dbQuery(dbHandler, "SELECT Password FROM player WHERE ID=?", id), -1)
		
		if playerResult and playerResult[1] then
			if playerResult[1]["Password"] == password then
				local dataResult = dbPoll(dbQuery(dbHandler, "SELECT * FROM playerdata WHERE ID=?", id), -1)
				
				
				if dataResult and dataResult[1] then
					dbExec(dbHandler, "UPDATE player SET LastLogin=? WHERE ID=?", getCurrentDate(), id)
					
					cosmicSetElementData(client, "Adminlevel", dataResult[1]["Adminlevel"])
					cosmicSetElementData(client, "Spawn", dataResult[1]["Spawn"])
					cosmicSetElementData(client, "Money", dataResult[1]["Money"])
					cosmicSetElementData(client, "Bankmoney", dataResult[1]["Bankmoney"])
					cosmicSetElementData(client, "Skin", dataResult[1]["Skin"])
					cosmicSetElementData(client, "Playtime", dataResult[1]["Playtime"])
					
					cosmicSetElementData(client, "Online", true)
					--cosmicSetElementData(client, "Onlinetime", getTimestamp(0))
					
					cosmicLoadPlayerInventory(id)
					
					
					triggerClientEvent(client, "infobox", client, "Willkommen zurueck!", 3, 75, 255, 75)
					triggerClientEvent(client, "infomsg", client, "Druecke 'F1', um das Hilfemenue zu oeffnen. Unser Forum findest du unter\n" .. _forum .. ". Viel spass!", 75, 255, 75)
					outputChatBox("Du hast dich erfolgreich eingeloggt", client, 75, 255, 75)
					triggerClientEvent(client, "finishRegisterLogin", client)
					
					
					cosmicSpawnPlayer(client)
				else
					kickPlayer(client, "Unbekannter Fehler")
				end
			else
				triggerClientEvent(client, "infobox", client, "Falsches Passwort!", 3, 255, 75, 75)
			end
		else
			kickPlayer(client, "Unbekannter Fehler")
		end
	end
end
addEventHandler("getLoginData", getRootElement(), loginPlayer)


local function registerPlayer(password, day, month, year, gender)
	if password and day and month and year and gender then
		local newID = 1
		
		for a, b in pairs(playerID) do
			if b >= newID then
				newID = b + 1
			end
		end
		
		dbExec(dbHandler, "INSERT INTO player (ID, Username, Password, IP, Serial, Registerdate, Birthday, LastLogin) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", newID, getPlayerName(client), password, getPlayerIP(client), getPlayerSerial(client), getCurrentDate(), formatDate(day, month, year), getCurrentDate())
		
		playerID[getPlayerName(client)] = newID
		
		
		-- Create playerdata
		local start = {
			admin = 0,
			spawn = 0,
			money = 75,
			bankmoney = 1300,
			skin = 5,
			playtime = 0,
		}
		
		dbExec(dbHandler, "INSERT INTO playerdata (ID, Adminlevel, Spawn, Money, Bankmoney, Skin, Playtime) VALUES (?, ?, ?, ?, ?, ?, ?)", newID, start.admin, start.spawn, start.money, start.bankmoney, start.skin, start.playtime, start.pkw, start.lkw, start.flugzeug, start.helikopter)
		
		dbExec(dbHandler, "INSERT INTO inventory (ID, Items) VALUES (?, ?)", newID, "")
		cosmicLoadPlayerInventory(newID)
		
		
		cosmicSetElementData(client, "Adminlevel", start.admin)
		cosmicSetElementData(client, "Spawn", start.spawn)
		cosmicSetElementData(client, "Money", start.money)
		cosmicSetElementData(client, "Bankmoney", start.bankmoney)
		cosmicSetElementData(client, "Skin", start.skin)
		cosmicSetElementData(client, "Playtime", start.playtime)
		
		cosmicSetElementData(client, "Online", true)
		--cosmicSetElementData(client, "Onlinetime", getTimestamp(0))
		
		
		triggerClientEvent(client, "infobox", client, "Herzlich Willkommen auf " .. _servername .. " Reallife!", 3, 75, 255, 75)
		triggerClientEvent(client, "infomsg", client, "Druecke 'F1', um das Hilfemenue zu oeffnen. Unser Forum findest du unter\n" .. _forum .. ". Viel spass!", 75, 255, 75)
		outputChatBox("Du hast dich erfolgreich registriert", client, 75, 255, 75)
		triggerClientEvent(client, "finishRegisterLogin", client)
		
		
		cosmicSpawnPlayer(client)
	end
end
addEventHandler("getRegisterData", getRootElement(), registerPlayer)