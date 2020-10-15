
addEvent("playerToggleEngine", true)
addEvent("playerToggleLight", true)
addEvent("playerToggleLock", true)
addEvent("playerRespawnVehicle", true)


local vehsysLastID = 0
--local vehsysRecID = {} -- recycling IDs (old IDs of destroyed cars)


local function vehsysVehicleEntered(player, seat)
	if seat == 0 then
		setVehicleEngineState(source, getElementData(source, "Engine"))
		
		
		if getElementData(source, "Brake") then
			triggerClientEvent(player, "infomsg", player, "Die Handbremse ist gezogen!\nTippe /brake, um sie zu loesen.", 255, 255, 255)
		end
		--triggerClientEvent(player, "infomsg", player, "Druecke 'F1', um mehr Informationen zu den Fahrzeugfunktionen zu erhalten", 255, 255, 255)
	end
end
addEventHandler("onVehicleEnter", getRootElement(), vehsysVehicleEntered)


local function playerToggleEngine()
	local veh = getPedOccupiedVehicle(client)
	
	if veh and getPedOccupiedVehicleSeat(client) == 0 then
		if getElementData(veh, "Owner") == getPlayerName(client) or not getElementData(veh, "Owner") then
			local state = getElementData(veh, "Engine")
			
			setElementData(veh, "Engine", not state)
			
			setVehicleEngineState(veh, not state)
		end
	end
end
addEventHandler("playerToggleEngine", getRootElement(), playerToggleEngine)


local function playerToggleLight()
	local veh = getPedOccupiedVehicle(client)
	
	if veh and getPedOccupiedVehicleSeat(client) == 0 then
		if getVehicleOverrideLights(veh) == 2 then
			setVehicleOverrideLights(veh, 1)
		else
			setVehicleOverrideLights(veh, 2)
		end
	end
end
addEventHandler("playerToggleLight", getRootElement(), playerToggleLight)


local function playerToggleLock(veh)
	if veh and getElementData(veh, "Owner") == getPlayerName(client) and cmath.distElements(client, veh) <= 6 then
		local state = not getElementData(veh, "Lock")
		
		setElementData(veh, "Lock", state)
		
		setVehicleLocked(veh, state)
		
		
		if state then
			triggerClientEvent(client, "infomsg", client, "Fahrzeug abgeschlossen!", 75, 255, 75)
		else
			triggerClientEvent(client, "infomsg", client, "Fahrzeug aufgeschlossen!", 255, 75, 75)
		end
	end
end
addEventHandler("playerToggleLock", getRootElement(), playerToggleLock)


local function playerRespawnVehicle(veh)
	if veh and getElementData(veh, "Owner") == getPlayerName(client) and cmath.distElements(client, veh) <= 6 then
		cosmicSpawnVehicle(NameToID(getPlayerName(client)), getElementData(veh, "Slot"))
		
		triggerClientEvent(client, "infomsg", client, "Fahrzeug respawnet!", 75, 255, 75)
	end
end
addEventHandler("playerRespawnVehicle", getRootElement(), playerRespawnVehicle)


local function playerToggleBrake(player, cmd)
	local veh = getPedOccupiedVehicle(player)
	
	if veh and getPedOccupiedVehicleSeat(player) == 0 then
		if getElementData(veh, "Owner") == getPlayerName(player) or not getElementData(veh, "Owner") then
			local vx, vy, vz = getElementVelocity(veh)
			if (cmath.dist3D(0, 0, 0, vx, vy, vz) * 1000) > 100 then
				triggerClientEvent(player, "infobox", player, "Du bist zu schnell!", 1.5, 255, 75, 75)
				return
			end
			
			
			local state = not getElementData(veh, "Brake")
			
			setElementData(veh, "Brake", state)
			
			setVehicleDamageProof(veh, state)
			
			
			if state then
				setElementFrozen(veh, true)
				
				triggerClientEvent(player, "infomsg", player, "Handbremse gezogen!", 75, 255, 75)
			else
				setElementFrozen(veh, false)
				
				triggerClientEvent(player, "infomsg", player, "Handbremse geloest!", 255, 75, 75)
			end
		end
	end
end
addCommandHandler("brake", playerToggleBrake)


local function playerParkVehicle(player, cmd)
	local veh = getPedOccupiedVehicle(player)
	
	if veh and getPedOccupiedVehicleSeat(player) == 0 then
		if getElementData(veh, "Owner") == getPlayerName(player) then
			if getElementData(veh, "Brake") then
				dbExec(dbHandler, "UPDATE vehicle SET Spawn=? WHERE OwnerID=? AND Slot=?", getElementStringTransform(veh), NameToID(getPlayerName(player)), getElementData(veh, "Slot"))
				
				triggerClientEvent(player, "infomsg", player, "Du hast das Fahrzeug geparkt. Beim naechsten respawn wird es hier erscheinen.", 75, 255, 75)
			else
				triggerClientEvent(player, "infobox", player, "Die Handbremse muss gezogen sein!", 2, 255, 75, 75)
			end
		else
			triggerClientEvent(player, "infobox", player, "Das Fahrzeug gehoert nicht dir!", 2, 255, 75, 75)
		end
	else
		triggerClientEvent(player, "infobox", player, "Du bist nicht der Fahrer!", 2, 255, 75, 75)
	end
end
addCommandHandler("park", playerParkVehicle)


--[[local function stopVehicleDamage(loss)
	if getElementData(source, "Brake") then
		setElementHealth(source, getElementHealth(source) + loss)
		cancelEvent()
	end
end
addEventHandler("onVehicleDamage", getRootElement(), stopVehicleDamage)]]


local function deleteVehicleOnExplode()
	if getElementData(source, "Owner") then
		local player = getPlayerFromName(getElementData(source, "Owner"))
		
		local ownerID = NameToID(getElementData(source, "Owner"))
		local slot = getElementData(source, "Slot")
		
		dbExec(dbHandler, "DELETE FROM vehicle WHERE OwnerID=? AND Slot=?", ownerID, slot)
		
		if player then
			triggerClientEvent(player, "infomsg", player, "Dein Fahrzeug auf Slot Nr. " .. slot .. " wurde zerstoert!", 255, 75, 75)
		end
	end
end
addEventHandler("onVehicleExplode", getRootElement(), deleteVehicleOnExplode)




local function vehsysCreateVehicle(OwnerID, Slot, Model, Spawn, Color, Lightcolor, Plate, Upgrades)
	local x, y, z = getPositionFromString(Spawn)
	local rx, ry, rz = getRotationFromString(Spawn)
	local r1, g1, b1 = tonumber(gettok(Color, 1, "|")), tonumber(gettok(Color, 2, "|")), tonumber(gettok(Color, 3, "|"))
	local r2, g2, b2 = tonumber(gettok(Color, 4, "|")), tonumber(gettok(Color, 5, "|")), tonumber(gettok(Color, 6, "|"))
	
	
	local veh = createVehicle(Model, x, y, z, rx, ry, rz, Plate)
	
	setVehicleColor(veh, r1, g1, b1, r2, g2, b2)
	
	r1, g1, b1 = tonumber(gettok(Lightcolor, 1, "|")), tonumber(gettok(Lightcolor, 2, "|")), tonumber(gettok(Lightcolor, 3, "|"))
	setVehicleHeadLightColor(veh, r1, g1, b1)
	
	local ups = getTokenList(Upgrades)
	
	for a, b in ipairs(ups) do
		addVehicleUpgrade(veh, b)
	end
	
	
	setElementFrozen(veh, true)
	
	setVehicleLocked(veh, true)
	setVehicleEngineState(veh, false)
	
	setElementData(veh, "Lock", true)
	setElementData(veh, "Engine", false)
	setElementData(veh, "Brake", true)
	setVehicleOverrideLights(veh, 1)
	
	setElementData(veh, "Owner", IDToName(OwnerID))
	setElementData(veh, "Slot", Slot)
end


function cosmicSpawnVehicle(OwnerID, Slot)
	local result = dbPoll(dbQuery(dbHandler, "SELECT ID, OwnerID, Slot, Model, Spawn, Color, Lightcolor, Plate, Upgrades FROM vehicle WHERE OwnerID=? AND Slot=?", OwnerID, Slot), -1)
	
	if result and result[1] then
		for a, b in ipairs(getElementsByType("vehicle")) do
			if getElementData(b, "Owner") == IDToName(OwnerID) and getElementData(b, "Slot") == Slot then
				-- Update database values
				--[[local r1, g1, b1, r2, g2, b2 = getVehicleColor(b)
				local color = getTokenString(r1, g1, b1, r2, g2, b2)
				local lightcolor = getTokenString(getVehicleHeadLightColor(b))
				local upgrades = ""
				for i = 0, 16, 1 do
					upgrades = upgrades .. getVehicleUpgradeOnSlot(b, i) .. "|"
				end
				local plate = getVehiclePlateText(b)]]
				
				--dbExec(dbHandler, "UPDATE vehicle SET Color=?, Lightcolor=?, Plate=?, Upgrades=? WHERE OwnerID=? AND Slot=?", color, lightcolor, plate, upgrades, OwnerID, Slot)
				
				
				destroyElement(b)
				break
			end
		end
		
		
		vehsysCreateVehicle(result[1]["OwnerID"], result[1]["Slot"], result[1]["Model"], result[1]["Spawn"], result[1]["Color"], result[1]["Lightcolor"], result[1]["Plate"], result[1]["Upgrades"])
	end
end


function cosmicCreateAllVehicles()
	--[[for a, b in ipairs(getElementsByType("vehicle")) do
		destroyElement(b)
	end]]
	
	local result = dbPoll(dbQuery(dbHandler, "SELECT ID, OwnerID, Slot, Model, Spawn, Color, Lightcolor, Plate, Upgrades FROM vehicle"), -1)
	
	if result then
		for a, b in ipairs(result) do
			if b["ID"] > vehsysLastID then
				vehsysLastID = b["ID"]
			end
			
			
			vehsysCreateVehicle(b["OwnerID"], b["Slot"], b["Model"], b["Spawn"], b["Color"], b["Lightcolor"], b["Plate"], b["Upgrades"])
		end
		
		
		outputDebugString("Spawned " .. #result .. " vehicles", 4, 0, 255, 0)
	end
end


function cosmicCreateUniqueVehicleID()
	vehsysLastID = vehsysLastID + 1
	return vehsysLastID
end