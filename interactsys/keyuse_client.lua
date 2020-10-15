
local usableModel = {
	[2942] = true, -- ATM
	[1775] = true, -- Sprunk
}


local function tryUsingObject()
	--clicksysPreClick(button, state, x, y, wx, wy, wz, element)
	local obj = getNearestUsableObject()
	
	if obj then
		local px, py, pz = getElementPosition(getLocalPlayer())
		
		local dis = cmath.dist3D(px, py, pz, getElementPosition(obj))
		
		if dis > 6 then
			return
		end
		
		for a, b in ipairs(getElementsByType("vehicle")) do
			if dis > cmath.dist3D(px, py, pz, getElementPosition(b)) then
				return
			end
		end
		
		clicksysPreClick("keyuse", nil, nil, nil, nil, nil, nil, obj)
	end
end
bindKey("f", "down", tryUsingObject)


function getNearestUsableObject()
	local px, py, pz = getElementPosition(getLocalPlayer())
	local nearest
	local nearestDis
	
	
	for a, b in ipairs(getElementsByType("object")) do
		if usableModel[getElementModel(b)] then
			local newDis = cmath.dist3D(px, py, pz, getElementPosition(b))
			if not nearest or nearestDis > newDis then
				nearest = b
				nearestDis = newDis
			end
		end
	end
	
	return nearest
end


local function keyuseCancelVehicleEntry(player)
	if player == getLocalPlayer() then
		local obj = getNearestUsableObject()
		
		if obj and cmath.distElements(player, obj) < cmath.distElements(player, source) then
			cancelEvent()
		end
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), keyuseCancelVehicleEntry)