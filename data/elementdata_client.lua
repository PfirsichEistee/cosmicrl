
addEvent("elementDataSync", true)


local edata = {}



function cosmicClientGetElementData(element, name)
	if edata[element] then
		return edata[element][name]
	end
end


function cosmicClientSetElementData(element, name, value)
	if not edata[element] then
		edata[element] = {}
	end
	
	edata[element][name] = value
end


local function syncServerData(element, name, value)
	if not edata[element] then
		edata[element] = {}
	end
	
	edata[element][name] = value
end
addEventHandler("elementDataSync", getRootElement(), syncServerData)