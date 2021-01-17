
local MYSQLUSER = "root"
local MYSQLPASSWORD = ""

dbHandler = nil

playerID = {}


local function mysql_connect()
	dbHandler = dbConnect("mysql", "dbname=cosmicdb;host=127.0.0.1;port=3306", MYSQLUSER, MYSQLPASSWORD)
	
	if dbHandler then
		outputDebugString("\n[MYSQL] Successfully connected to database!", 4, 0, 255, 0)
	else
		outputDebugString("\n[MYSQL] Couldn't connect to database!", 4, 255, 0, 0)
	end
	
	
	local result = dbPoll(dbQuery(dbHandler, "SELECT ??, ?? FROM player", "ID", "Username"), -1)
	
	if result then
		for a, b in ipairs(result) do
			playerID[b["Username"]] = b["ID"]
		end
		
		outputDebugString("[MYSQL] Found " .. #result .. " users", 4, 0, 255, 0)
	end
end
mysql_connect()



local function dataResourceStart()
	cosmicCreateAllVehicles()
end
addEventHandler("onResourceStart", resourceRoot, dataResourceStart)


local function dataPlayerLeave()
	if cosmicGetElementData(source, "Online") then
		outputDebugString("Player '" .. getPlayerName(source) .. "' left. Saving data...", 4, 0, 255, 0)
		cosmicUnloadAndSavePlayerInventory(source)
		
		dbExec(dbHandler, "UPDATE playerdata SET Adminlevel=?, Spawn=?, Money=?, Bankmoney=?, Skin=?, Playtime=?, Payday=?, FactionID=?, FactionRank=?, GroupID=?, GroupRank=? WHERE id=" .. NameToID(getPlayerName(source)),
			cosmicGetElementData(source, "Adminlevel"), cosmicGetElementData(source, "Spawn"), cosmicGetElementData(source, "Money"), cosmicGetElementData(source, "Bankmoney"), cosmicGetElementData(source, "Skin"), cosmicGetElementData(source, "Playtime"), cosmicGetElementData(source, "Payday"), cosmicGetElementData(source, "FactionID"), cosmicGetElementData(source, "FactionRank"), cosmicGetElementData(source, "GroupID"), cosmicGetElementData(source, "GroupRank"))
		
		cosmicClearElementData(source)
	end
end
addEventHandler("onPlayerQuit", getRootElement(), dataPlayerLeave)


local function dataResourceStop()
	for a, b in ipairs(getElementsByType("player")) do
		source = b
		dataPlayerLeave()
	end
end
addEventHandler("onResourceStop", resourceRoot, dataResourceStop)




function NameToID(name)
	return playerID[name]
end

function IDToName(id)
	for a, b in pairs(playerID) do
		if b == id then
			return a
		end
	end
end