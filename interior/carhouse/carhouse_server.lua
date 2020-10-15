
addEvent("playerCarhouseLeave", true)


local carhouseveh = {
	[1] = {
		{401, 2133, -1128.6, 25.5, 0, 0, 125},
		{600, 2135.2, -1136, 25.5, 0, 0, 90},
		{422, 2134.1, -1143.6, 24.7, 3, 356, 45},
		{508, 2121.6, -1142.1, 25.3, 0, 0, 300},
		{400, 2121.5, -1131.6, 25.5, 0, 0, 250},
	},
}

local carhousespawn = {
	-- [i] = { playerx, playery, playerz, playerRot, vehx, vehy, vehz, vehRot }
	[1] = { 2126.4169921875, -1151.4501953125, 24.031543731689, 0, 2117.5852050781, -1115.0692138672, 25.5, 251.6 },
}


local function createCarhouseMarker(x, y, z, id)
	local marker = createMarker(x, y, z, "arrow", 1, 255, 255, 0, 255, getRootElement())
	
	cosmicSetElementData(marker, "Carhouse", id)
	
	createBlip(x, y, z, 55, 2, 255, 255, 255, 255, 0, 10, getRootElement())
end


createCarhouseMarker(2131.9, -1151, 25, 1)



for a, b in ipairs(carhouseveh) do
	for c, d in ipairs(b) do
		local veh = createVehicle(d[1], d[2], d[3], d[4], d[5], d[6], d[7], "COSMIC")
		
		setElementFrozen(veh, true)
		setVehicleDamageProof(veh, true)
		setVehicleLocked(veh, true)
	end
end



local function playerCarhouseLeave(button, vehID)
	local player = client
	local ch = cosmicGetElementData(player, "Carhouse")
	cosmicSetElementData(player, "Carhouse", nil)
	if not ch then
		return
	end
	
	fadeCamera(player, false)
	
	setTimer(function()
		if button == "buy" then
			if cosmicGetElementData(player, "Money") >= vehicleprice[vehID] then
				local result = dbPoll(dbQuery(dbHandler, "SELECT Slot FROM vehicle WHERE OwnerID=?", NameToID(getPlayerName(player))), -1)
				
				if result then
					local ownerID = NameToID(getPlayerName(player))
					local newVehSlot = 1
					
					local isNew = false
					
					while not isNew do
						isNew = true
						for a, b in ipairs(result) do
							if b["Slot"] == newVehSlot then
								newVehSlot = newVehSlot + 1
								isNew = false
								break
							end
						end
					end
					
					
					local veh = createVehicle(vehID, carhousespawn[ch][5], carhousespawn[ch][6], carhousespawn[ch][7], 0, 0, carhousespawn[ch][8], "00000000")
					
					local spawn = getTokenString(carhousespawn[ch][5], carhousespawn[ch][6], carhousespawn[ch][7], 0, 0, carhousespawn[ch][8])
					local r1, g1, b1, r2, g2, b2 = getVehicleColor(veh, true)
					
					local color = getTokenString(r1, g1, b1, r2, g2, b2)
					
					
					dbExec(dbHandler, "INSERT INTO vehicle (ID, OwnerID, Slot, Model, Spawn, Color, Lightcolor, Plate, Upgrades) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", cosmicCreateUniqueVehicleID(), ownerID, newVehSlot, vehID, spawn, color, "255|255|255", "00000000", "0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0")
					
					
					setElementCollisionsEnabled(player, true)
					warpPedIntoVehicle(player, veh)
					
					setElementData(veh, "Lock", false)
					setElementData(veh, "Engine", false)
					setElementData(veh, "Brake", false)
					setVehicleOverrideLights(veh, 1)
					setElementData(veh, "Owner", IDToName(ownerID))
					setElementData(veh, "Slot", newVehSlot)
					
					setGhostMode(player, 10000, true)
					
					cosmicSetElementData(player, "Money", cosmicGetElementData(player, "Money") - vehicleprice[vehID])
				end
			else
				triggerClientEvent(player, "infobox", player, "Du hast nicht genug Geld!", 2, 255, 75, 75)
			end
		elseif button == "exit" then
			setElementPosition(player, carhousespawn[ch][1], carhousespawn[ch][2], carhousespawn[ch][3])
			setElementRotation(player, 0, 0, carhousespawn[ch][4])
		end
		
		toggleAllControls(player, true)
		setElementCollisionsEnabled(player, true)
		setElementAlpha(player, 255)
		fadeCamera(player, true)
		setElementFrozen(player, false)
		
		setCameraTarget(player, player)
	end, 1000, 1)
end
addEventHandler("playerCarhouseLeave", getRootElement(), playerCarhouseLeave)


local function playerEnterCarhouse(player, matchingDimension)
	if cosmicGetElementData(source, "Carhouse") and getElementType(player) == "player" and not getPedOccupiedVehicle(player) and matchingDimension then
		setElementFrozen(player, true)
		fadeCamera(player, false)
		toggleAllControls(player, false)
		
		local marker = source
		
		setTimer(function()
			--setElementDimension(player, 1)
			setElementAlpha(player, 0)
			setElementCollisionsEnabled(player, false)
			
			cosmicSetElementData(player, "Carhouse", cosmicGetElementData(marker, "Carhouse"))
			triggerClientEvent(player, "playerEnterCarhouse", player, cosmicGetElementData(marker, "Carhouse"))
			
			fadeCamera(player, true)
		end, 1000, 1)
	end
end
addEventHandler("onMarkerHit", getRootElement(), playerEnterCarhouse)



local function fuck(player)
	local veh = getPedOccupiedVehicle(player)
	
	setElementPosition(veh, 2125.8825683594, -1124.7862548828, 24.886108398438)
end
addCommandHandler("fuck", fuck)