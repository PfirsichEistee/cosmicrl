
local edata = {}


local syncdata = {
	["Online"] = true, ["Money"] = true, ["Bankmoney"] = true, ["Adminlevel"] = true, ["Spawn"] = true, ["Playtime"] = true,
}

local allsyncdata = {
	["Adminlevel"] = true,
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