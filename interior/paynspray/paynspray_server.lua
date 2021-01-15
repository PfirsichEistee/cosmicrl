
-- ID, [2]x1, y1, z1, [5]rx1, ry1, rz1, [8]x2, y2, z2, [11]rx2, ry2, rz2, [14]colshape, [15]gate, [16] depth

local paynspray = {
	[1] = cmath.List(5043, 1843.3000, -1856.3000, 13.9000, 0, 0, 0, 1844.45, -1856.3, 15.2, 0, 90, 0, nil, nil, 5),
	[2] = cmath.List(5856, 1025, -1029.4, 33.1, 0, 0, 90, 1025, -1027.75, 34.8, 0, 90, 90, nil, nil, 5),
	[3] = cmath.List(11319, -1904.6, 277.6, 43, 0, 0, 90, -1904.6, 280.5, 45.7, 0, 90, 90, nil, nil, 4),
	[4] = cmath.List(9625, -2425.6, 1028.1, 52.3, 0, 0, 90, -2425.6, 1025.6, 55, 0, -90, 90, nil, nil, 4),
}


for a, b in ipairs(paynspray) do
	local dx, dy = b[8] - b[2], b[9] - b[3]
	local col = createColSphere(b[2] + dx * b[16], b[3] + dy * b[16], b[4] - 0.5, 3)
	cosmicSetElementData(col, "paynspray", true)
	cosmicSetElementData(col, "busy", false)
	
	b[14] = col
	b[15] = createObject(b[1], b[8], b[9], b[10], b[11], b[12], b[13])
	
	
	createBlip(b[8], b[9], b[10], 63, 2, 255, 255, 255, 255, 0, 10, getRootElement())
end


local function enterPaynSpray(veh, matchDimension)
	if cosmicGetElementData(source, "paynspray") and not cosmicGetElementData(source, "busy") and getElementType(veh) == "vehicle" and matchDimension then
		local player = getVehicleOccupant(veh, 0)
		
		if player then
			if cosmicGetElementData(player, "Money") >= 125 then
				cosmicSetElementData(source, "busy", true)
				
				cosmicSetElementData(player, "Money", cosmicGetElementData(player, "Money") - 125)
				
				setElementFrozen(veh, true)
				toggleAllControls(player, false)
				
				
				local list
				
				for a, b in ipairs(paynspray) do
					if b[14] == source then
						list = b
						
						break
					end
				end
				
				if not list then
					return
				end
				
				
				local dx, dy, dz = list[5] - list[11], list[6] - list[12], list[7] - list[13]
				stopObject(list[15])
				setElementPosition(list[15], list[8], list[9], list[10])
				setElementRotation(list[15], list[11], list[12], list[13])
				
				moveObject(list[15], 2000, list[2], list[3], list[4], dx, dy, dz)
				
				
				setTimer(function()
					fixVehicle(veh)
					
					setElementFrozen(veh, false)
					toggleAllControls(player, true)
					
					--cosmicSetElementData(list[14], "busy", false)
					
					
					moveObject(list[15], 2000, list[8], list[9], list[10], -dx, -dy, -dz)
					
					setTimer(function()
						cosmicSetElementData(list[14], "busy", false)
					end, 2000, 1)
				end, 4000, 1)
			else
				triggerClientEvent(player, "infobox", player, "Eine Reperatur kostet dich $125!", 2, 255, 75, 75)
			end
		end
	end
end
addEventHandler("onColShapeHit", getRootElement(), enterPaynSpray)