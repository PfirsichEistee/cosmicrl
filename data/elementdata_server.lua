
local edata = {}


local syncdata = {
	["Money"] = true, ["Bankmoney"] = true, ["Spawn"] = true, ["PKW-Schein"] = true, ["LKW-Schein"] = true, ["Flugzeug-Schein"] = true, ["Helikopter-Schein"] = true,
}

local allsyncdata = {
	["Adminlevel"] = true, ["Online"] = true, ["Playtime"] = true, 
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