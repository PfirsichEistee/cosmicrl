--[[ ## PUBLIC FUNCTIONS ##

* cosmicLoadPlayerStats(userID)
		Loads stats table of user. Only used by login_server.lua

* cosmicSetStats(userID, key, value)
		Sets stats value

* cosmicGetStats(userID, key)
		Gets stats value; [returns value or nil]

* cosmicAddStats(userID, key, value)
		Equivalent to: cosmicSetStats( userID, key, cosmicGetStats( userID, key ) + value )

* cosmicAddAchievement(userID, aID)
		Adds new achievement (achievements are ID's)

* cosmicHasAchievement(userID, aID)
		Checks if user has achievement; [returns bool]

* cosmicAchiementCount(userID)
		Gets amount of achiements owned; [returns int]


userID may be either the player-element or just his ID

]]


addEvent("getPlayerStats", true)


local stats = {}


local function convToID(userID_or_player)
	if isElement(userID_or_player) and getElementType(userID_or_player) == "player" then
		return NameToID(getPlayerName(userID_or_player))
	end
	
	return userID_or_player
end


function comsicSetStats(userID, key, value)
	userID = convToID(userID)
	
	if stats[userID] then
		if stats[userID][key] then
			stats[userID][key] = value
			
			dbExec(dbHandler, "UPDATE playerstats SET " .. key .. "=? WHERE ID=?", value, userID)
			
			
			-- Sync with client
			local player = getPlayerFromName(IDToName(userID))
			if player then
				local ph = {
					[key] = value
				}
				triggerClientEvent(player, "clientSyncStats", player, ph)
			end
		else
			outputDebugString("User " .. userID .. " does not have a stat called \"" .. key .. "\"", 1)
		end
	else
		outputDebugString("User " .. userID .. " does not have a stats-table", 1)
	end
end


function cosmicGetStats(userID, key)
	userID = convToID(userID)
	
	if stats[userID] then
		if stats[userID][key] then
			return stats[userID][key]
		else
			outputDebugString("User " .. userID .. " does not have a stat called \"" .. key .. "\"", 1)
		end
	else
		outputDebugString("User " .. userID .. " does not have a stats-table", 1)
	end
end


function cosmicAddStats(userID, key, value)
	userID = convToID(userID)
	
	if stats[userID] then
		if stats[userID][key] then
			cosmicSetStats(userID, key, stats[userID][key] + value)
			
			
			-- Sync with client
			local player = getPlayerFromName(IDToName(userID))
			if player then
				local ph = {
					[key] = stats[userID][key]
				}
				triggerClientEvent(player, "clientSyncStats", player, ph)
			end
		else
			outputDebugString("User " .. userID .. " does not have a stat called \"" .. key .. "\"", 1)
		end
	else
		outputDebugString("User " .. userID .. " does not have a stats-table", 1)
	end
end


function cosmicAddAchievement(userID, aID)
	userID = convToID(userID)
	
	if stats[userID] then
		table.insert(stats[userID]["Achievements"], aID)
		
		dbExec(dbHandler, "UPDATE playerstats SET Achievements=? WHERE ID=?", getTokenString(stats[userID]["Achievements"]), userID)
		
		
		-- Sync with client
		local player = getPlayerFromName(IDToName(userID))
		if player then
			local ph = {
				["Achievements"] = stats[userID]["Achievements"]
			}
			triggerClientEvent(player, "clientSyncStats", player, ph)
		end
	else
		outputDebugString("User " .. userID .. " does not have a stats-table", 1)
	end
end


function cosmicHasAchievement(userID, aID)
	userID = convToID(userID)
	
	if stats[userID] then
		for a, b in ipairs(stats[userID]["Achievements"]) do
			if b == aID then
				return true
			end
		end
	else
		outputDebugString("User " .. userID .. " does not have a stats-table", 1)
	end
	
	return false
end


function cosmicAchievementCount(userID)
	userID = convToID(userID)
	
	local count = 0
	
	if stats[userID] then
		for a, b in ipairs(stats[userID]["Achievements"]) do
			count = count + 1
		end
	else
		outputDebugString("User " .. userID .. " does not have a stats-table", 1)
	end
	
	return count
end


function cosmicLoadPlayerStats(userID)
	userID = convToID(userID)
	
	if not stats[userID] then
		local result = dbPoll(dbQuery(dbHandler, "SELECT Items, Weapons FROM inventory WHERE ID=?", userID), -1)
		
		if result and result[1] then
			local new = {
				Achievements = {},
				Kills = result[1]["Kills"],
				Headshots = result[1]["Headshots"],
				Deaths = result[1]["Deaths"],
				Revivals = result[1]["Revivals"],
				Jail = result[1]["Jail"],
				Gangwars = result[1]["Gangwars"],
				Bans = result[1]["Bans"],
				LastBan = result[1]["LastBan"],
				Warns = result[1]["Warns"],
			}
			
			for i = 1, 999, 1 do
				local ph = gettok(result[1]["Achievements"], i, "|")
				
				if ph then
					table.insert(new.Achievements, ph)
				else
					break
				end
			end
			
			
			stats[userID] = new
		elseif result and not result[1] then
			-- Create new stats table
			-- ID, Achievements, Kills, Headshots, Deaths, Revivals, Jail, Gangwars, Bans, LastBan, Warns
			dbExec(dbHandler, "INSERT INTO playerstats VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
				userID, "", 0, 0, 0, 0, 0, 0, 0, "-", 0)
			
			local new = {
				Achievements = {},
				Kills = 0,
				Headshots = 0,
				Deaths = 0,
				Revivals = 0,
				Jail = 0,
				Gangwars = 0,
				Bans = 0,
				LastBan = 0,
				Warns = 0,
			}
			
			stats[userID] = new
		end
	end
	
	-- Sync complete table
	local player = getPlayerFromName(IDToName(userID))
	
	if player then
		triggerClientEvent(player, "clientSyncStats", player, stats[userID])
	end
end


local function getPlayerStats(player, key)
	if cosmicGetElementData(client, "Online") then
		if isElement(player) and getElementType(player) == "player" and cosmicGetElementData(player, "Online") then
			triggerClientEvent(client, "receivePlayerStats", client, player, key, cosmicGetStats(player, key))
		end
	end
	
	triggerClientEvent(client, "receivePlayerStats", client, player, key, nil)
end
addEventHandler("getPlayerStats", getRootElement(), getPlayerStats)









