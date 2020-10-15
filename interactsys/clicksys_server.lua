
addEvent("clicksysClicked", true)
-- Parameters: worldX, worldY, worldZ, Element


local function clicksysServerClick(wx, wy, wz, element)
	-- !! wx, wy and wz MIGHT be nil if event was called by keypress !!
	
	if element then
		-- If the server needs to do something with the click, return and DONT trigger it clientside
		-- ...
		-- ...
	end
	
	-- Didnt return, so trigger client event
	triggerClientEvent(source, "clicksysClicked", source, wx, wy, wz, element)
end
addEventHandler("clicksysClicked", getRootElement(), clicksysServerClick)




function getNearestModelTo(player, model)
	local px, py, pz = getElementPosition(player)
	local nearest
	local nearestDis
	
	
	for a, b in ipairs(getElementsByType("object")) do
		if getElementModel(b) == model then
			local newDis = cmath.dist3D(px, py, pz, getElementPosition(b))
			if not nearest or nearestDis > newDis then
				nearest = b
				nearestDis = newDis
			end
		end
	end
	
	return nearest
end