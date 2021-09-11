--[[ ## PUBLIC FUNCTIONS ##

* cosmicClientGetStats(key)
		Gets stats value; [returns value or nil]

* cosmicClientGetAchievementCount()
		Gets the amount of achievements owned; [returns int]

* cosmicClientGetPlayerStats(player, key, func)
		Gets stats value of any player; will call "func(player, key, value)" after the result is ready
		[returns value or nil]

]]


addEvent("clientSyncStats", true)
addEvent("receivePlayerStats", true)


local stats = {
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

local playerStatsQueue = {}


local function syncStats(data)
	for a, b in pairs(data) do
		stats[a] = b
	end
end
addEventHandler("clientSyncStats", getRootElement(), syncStats)


function cosmicClientGetStats(key)
	return stats[key]
end


function cosmicClientGetAchievementCount()
	local count = 0
	
	for a, b in ipairs(stats.Achievements) do
		count = count + 1
	end
	
	return count
end


local function receivePlayerStats(player, key, value)
	for a, b in ipairs(playerStatsQueue) do
		if b.player == player and b.key == key then
			b.func(player, key, value)
			
			table.remove(playerStatsQueue, a)
			
			break
		end
	end
end
addEventHandler("receivePlayerStats", getRootElement(), receivePlayerStats)


function cosmicClientGetPlayerStats(player, key, func)
	local new = {
		player = player,
		key = key,
		func = func,
	}
	
	table.insert(playerStatsQueue, new)
	
	triggerServerEvent("getPlayerStats", getLocalPlayer(), player, key)
end





