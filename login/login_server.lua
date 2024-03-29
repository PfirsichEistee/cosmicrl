
addEvent("loginCheckClient", true)
addEvent("getRegisterData", true)
addEvent("getLoginData", true)



local function checkPlayer()
	local ed = getAllElementData(client)
	for a, b in pairs(ed) do
		removeElementData(client, a)
	end
	
	
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
		
		local playerResult = dbPoll(dbQuery(dbHandler, "SELECT Password, Registerdate FROM player WHERE ID=?", id), -1)
		
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
					cosmicSetElementData(client, "Exp", dataResult[1]["Exp"])
					cosmicSetElementData(client, "Playtime", dataResult[1]["Playtime"])
					cosmicSetElementData(client, "Payday", dataResult[1]["Payday"])
					cosmicSetElementData(client, "Wanteds", dataResult[1]["Wanteds"])
					cosmicSetElementData(client, "FactionID", dataResult[1]["FactionID"])
					cosmicSetElementData(client, "FactionRank", dataResult[1]["FactionRank"])
					cosmicSetElementData(client, "GroupID", dataResult[1]["GroupID"])
					cosmicSetElementData(client, "GroupRank", dataResult[1]["GroupRank"])
					
					cosmicSetElementData(client, "Online", true)
					cosmicSetClientElementData(client, "Registerdate", playerResult[1]["Registerdate"])
					--cosmicSetElementData(client, "Onlinetime", getTimestamp(0))
					
					
					triggerClientEvent(client, "infobox", client, "Willkommen zurueck!", 3, 75, 255, 75)
					triggerClientEvent(client, "infomsg", client, "Druecke 'F1', um das Hilfemenue zu oeffnen. Unser Forum findest du unter\n" .. _forum .. ". Viel spass!", 75, 255, 75)
					outputChatBox("Du hast dich erfolgreich eingeloggt", client, 75, 255, 75)
					triggerClientEvent(client, "finishRegisterLogin", client)
					
					
					cosmicSpawnPlayer(client)
					
					cosmicLoadPlayerInventory(id)
					cosmicLoadPlayerStats(id)
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
		local skinlist = {
			[1] = { -- male
				1, 2, 7, 14, 15, 20, 21, 22, 23, 24, 25, 26, 28, 29, 30, 32, 34, 35, 36, 37, 44,
			},
			[2] = { -- female
				9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 69, 75,
			},
		}
		
		local ph = math.ceil(math.random() * #skinlist[gender])
		
		local start = {
			admin = 0,
			spawn = 0,
			money = 75,
			bankmoney = 1300,
			skin = skinlist[gender][ph],
			playtime = 0,
		}
		
		dbExec(dbHandler, "INSERT INTO playerdata (ID, Adminlevel, Spawn, Money, Bankmoney, Skin, Exp, Playtime, Payday, Wanteds, FactionID, FactionRank, GroupID, GroupRank) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
			newID, start.admin, start.spawn, start.money, start.bankmoney, start.skin, 0, start.playtime, 0, 0, 0, 0, 0, 0)
		
		dbExec(dbHandler, "INSERT INTO inventory (ID, Items, Weapons) VALUES (?, ?, ?)", newID, "", "")
		cosmicLoadPlayerInventory(newID)
		cosmicLoadPlayerStats(newID)
		
		
		cosmicSetElementData(client, "Adminlevel", start.admin)
		cosmicSetElementData(client, "Spawn", start.spawn)
		cosmicSetElementData(client, "Money", start.money)
		cosmicSetElementData(client, "Bankmoney", start.bankmoney)
		cosmicSetElementData(client, "Skin", start.skin)
		cosmicSetElementData(client, "Exp", 0)
		cosmicSetElementData(client, "Playtime", start.playtime)
		cosmicSetElementData(client, "Payday", 0)
		cosmicSetElementData(client, "Wanteds", 0)
		cosmicSetElementData(client, "FactionID", 0)
		cosmicSetElementData(client, "FactionRank", 0)
		cosmicSetElementData(client, "GroupID", 0)
		cosmicSetElementData(client, "GroupRank", 0)
		
		cosmicSetElementData(client, "Online", true)
		cosmicSetClientElementData(client, "Registerdate", getCurrentDate())
		--cosmicSetElementData(client, "Onlinetime", getTimestamp(0))
		
		
		triggerClientEvent(client, "infobox", client, "Herzlich Willkommen auf " .. _servername .. " Reallife!", 3, 75, 255, 75)
		triggerClientEvent(client, "infomsg", client, "Druecke 'F1', um das Hilfemenue zu oeffnen. Unser Forum findest du unter\n" .. _forum .. ". Viel spass!", 75, 255, 75)
		outputChatBox("Du hast dich erfolgreich registriert", client, 75, 255, 75)
		triggerClientEvent(client, "finishRegisterLogin", client)
		
		
		cosmicSpawnPlayer(client)
	end
end
addEventHandler("getRegisterData", getRootElement(), registerPlayer)
