
local MYSQLUSER = "defuser"
local MYSQLPASSWORD = ""

dbHandler = nil

playerID = {}


local function mysql_connect()
	dbHandler = dbConnect("mysql", "dbname=cosmicdb;host=127.0.0.1;port=3306", MYSQLUSER, MYSQLPASSWORD)
	
	if dbHandler then
		outputDebugString("[MYSQL] Successfully connected to database!", 4, 0, 255, 0)
	else
		outputDebugString("[MYSQL] Couldn't connect to database!", 4, 255, 0, 0)
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