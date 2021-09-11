
local edata = {}


local syncdata = {
	["Money"] = true,	["Bankmoney"] = true,	["Spawn"] = true,	["GroupID"] = true,	["GroupRank"] = true,
	["Exp"] = true,		["Wanteds"] = true,
}

local allsyncdata = {
	["Adminlevel"] = true,	["Online"] = true,	["Playtime"] = true,	["FactionID"] = true,	["FactionRank"] = true,
}


function cosmicSetElementData(element, name, data)
	if not edata[element] then
		edata[element] = {}
	end
	
	edata[element][name] = data
	
	
	if syncdata[name] and getElementType(element) == "player" then
		triggerClientEvent(element, "elementDataSync", element, element, name, data)
	end
	if allsyncdata[name] then
		setElementData(element, name, data)
	end
end

function cosmicGetElementData(element, name)
	if edata[element] then
		return edata[element][name]
	end
end

function cosmicClearElementData(element)
	if edata[element] then
		edata[element] = nil
	end
end


-- Only sets data on client and "forgets" it here
function cosmicSetClientElementData(player, name, data)
	triggerClientEvent(player, "elementDataSync", player, player, name, data)
end
