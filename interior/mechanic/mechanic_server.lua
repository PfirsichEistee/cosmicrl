
addEvent("mechanicBuy", true)
addEvent("mechanicExit", true)


local mechanic = {
	[1] = cmath.List(1040.9260253906, -1018.9317016602, 31.4, 1050.5791015625, -1034.6198730469, 33, 90, nil),
}


for a, b in ipairs(mechanic) do
	createBlip(b[1], b[2], b[3], 27, 2, 255, 255, 255, 255, 0, 10, getRootElement())
	
	local marker = createMarker(b[1], b[2], b[3], "cylinder", 2.5, 255, 0, 0, 255, getRootElement())
	cosmicSetElementData(marker, "mechanic", true)
	
	b[8] = marker
end


local function playerEnterMechanicMarker(veh, matchingDimension)
	if cosmicGetElementData(source, "mechanic") and getElementType(veh) == "vehicle" and matchingDimension then
		local player = getVehicleOccupant(veh, 0)
		
		if not player then
			return
		else
			for a, b in pairs(getVehicleOccupants(veh)) do
				if b ~= player then
					triggerClientEvent(player, "infobox", player, "Du darfst nur alleine zum Mechaniker!", 2, 255, 75, 75)
					return
				end
			end
			
			if getElementData(veh, "Owner") ~= getPlayerName(player) then
				triggerClientEvent(player, "infobox", player, "Das Fahrzeug gehoert nicht dir!", 2, 255, 75, 75)
				return
			end
		end
		
		local index
		for a, b in ipairs(mechanic) do
			if b[8] == source then
				index = a
				break
			end
		end
		
		if not index then
			return
		end
		
		
		fadeCamera(player, false)
		--triggerClientEvent(player, "setClientHUDVisible", player, false)
		toggleAllControls(player, false)
		cosmicSetElementData(player, "MechanicIndex", index)
		
		setElementFrozen(veh, true)
		setElementFrozen(player, true)
		
		
		setTimer(function()
			setElementDimension(veh, 1)
			
			triggerClientEvent(player, "playerEnterMechanic", player)
			
			fadeCamera(player, true)
		end, 1000, 1)
	end
end
addEventHandler("onMarkerHit", getRootElement(), playerEnterMechanicMarker)


local function mechanicExit()
	local index = cosmicGetElementData(client, "MechanicIndex")
	if index then
		local player = client
		local veh = getPedOccupiedVehicle(player)
		
		fadeCamera(player, false)
		setElementDimension(veh, 0)
		setElementFrozen(veh, false)
		
		
		setTimer(function()
			local slot = getElementData(veh, "Slot")
			
			local hp = getElementHealth(veh)
			destroyElement(veh)
			veh = nil
			
			cosmicSpawnVehicle(NameToID(getPlayerName(player)), slot)
			
			for a, b in ipairs(getElementsByType("vehicle")) do
				if getElementData(b, "Owner") == getPlayerName(player) and getElementData(b, "Slot") == slot then
					veh = b
					break
				end
			end
			
			if veh then
				setElementPosition(veh, mechanic[index][4], mechanic[index][5], mechanic[index][6])
				setElementRotation(veh, 0, 0, mechanic[index][7])
				
				setElementData(veh, "Brake", false)
				setElementFrozen(veh, false)
				
				setElementHealth(veh, hp)
				
				warpPedIntoVehicle(player, veh)
				
				setCameraTarget(player, player)
				
				fadeCamera(player, true)
				toggleAllControls(player, true)
				setElementFrozen(player, false)
			end
		end, 1000, 1)
		
		
		cosmicSetElementData(player, "MechanicIndex", nil)
	end
end
addEventHandler("mechanicExit", getRootElement(), mechanicExit)


local function mechanicBuy(what, id_plate_or_nil, r1, g1, b1, r2, g2, b2)
	-- id_text_or_nil == upgradeID OR PlateText OR nil (color)
	if cosmicGetElementData(client, "MechanicIndex") then
		local veh = getPedOccupiedVehicle(client)
		local money = cosmicGetElementData(client, "Money")
		local price = 999999999
		
		if what == 1 then -- Normal upgrade
			for a, b in ipairs(getVehicleUpgrades(veh)) do
				if b == id_plate_or_nil then
					triggerClientEvent(client, "infobox", client, "Du besitzt dieses Upgrade bereits!", 2, 255, 75, 75)
					return
				end
			end
			
			price = getTunePrice(id_plate_or_nil)
			
			if money >= price then
				addVehicleUpgrade(veh, id_plate_or_nil)
				
				local upgrades = ""
				for i = 0, 16, 1 do
					upgrades = upgrades .. getVehicleUpgradeOnSlot(veh, i)
					if i ~= 16 then
						upgrades = upgrades .. "|"
					end
				end
				
				dbExec(dbHandler, "UPDATE vehicle SET Upgrades=? WHERE OwnerID=? AND Slot=?", upgrades, NameToID(getElementData(veh, "Owner")), getElementData(veh, "Slot"))
				
				
				cosmicSetElementData(client, "Money", money - price)
				triggerClientEvent(client, "infobox", client, "Gekauft!", 2, 75, 255, 75)
			else
				triggerClientEvent(client, "infobox", client, "Du hast nicht genug Geld!", 2, 255, 75, 75)
			end
		elseif what == 2 then -- Color
			price = 1250
			
			if money >= price then
				setVehicleColor(veh, r1, g1, b1, r2, g2, b2)
				
				local clr = getTokenString(math.floor(r1), math.floor(g1), math.floor(b1), math.floor(r2), math.floor(g2), math.floor(b2))
				
				dbExec(dbHandler, "UPDATE vehicle SET Color=? WHERE OwnerID=? AND Slot=?", clr, NameToID(getElementData(veh, "Owner")), getElementData(veh, "Slot"))
				
				
				cosmicSetElementData(client, "Money", money - price)
				triggerClientEvent(client, "infobox", client, "Gekauft!", 2, 75, 255, 75)
			else
				triggerClientEvent(client, "infobox", client, "Du hast nicht genug Geld!", 2, 255, 75, 75)
			end
		elseif what == 3 then -- Lightcolor
			price = 350
			
			if money >= price then
				setVehicleHeadLightColor(veh, r1, g1, b1)
				
				local clr = getTokenString(math.floor(r1), math.floor(g1), math.floor(b1))
				
				dbExec(dbHandler, "UPDATE vehicle SET Lightcolor=? WHERE OwnerID=? AND Slot=?", clr, NameToID(getElementData(veh, "Owner")), getElementData(veh, "Slot"))
				
				
				cosmicSetElementData(client, "Money", money - price)
				triggerClientEvent(client, "infobox", client, "Gekauft!", 2, 75, 255, 75)
			else
				triggerClientEvent(client, "infobox", client, "Du hast nicht genug Geld!", 2, 255, 75, 75)
			end
		elseif what == 4 then -- Numberplate
			price = 100
			
			if money >= price then
				if string.len(id_plate_or_nil) <= 0 or string.len(id_plate_or_nil) > 8 then
					triggerClientEvent(client, "infobox", client, "Das Nummernschild muss zwischen 1 und 8 Zeichen lang sein!", 2, 255, 75, 75)
					return
				end
				
				setVehiclePlateText(veh, id_plate_or_nil)
				
				dbExec(dbHandler, "UPDATE vehicle SET Plate=? WHERE OwnerID=? AND Slot=?", id_plate_or_nil, NameToID(getElementData(veh, "Owner")), getElementData(veh, "Slot"))
				
				
				cosmicSetElementData(client, "Money", money - price)
				triggerClientEvent(client, "infobox", client, "Gekauft!", 2, 75, 255, 75)
			else
				triggerClientEvent(client, "infobox", client, "Du hast nicht genug Geld!", 2, 255, 75, 75)
			end
		elseif what == 5 then -- Remove upgrade
			for a, b in ipairs(getVehicleUpgrades(veh)) do
				if b == id_plate_or_nil then
					removeVehicleUpgrade(veh, id_plate_or_nil)
			
					local upgrades = ""
					for i = 0, 16, 1 do
						upgrades = upgrades .. getVehicleUpgradeOnSlot(veh, i)
						if i ~= 16 then
							upgrades = upgrades .. "|"
						end
					end
					
					dbExec(dbHandler, "UPDATE vehicle SET Upgrades=? WHERE OwnerID=? AND Slot=?", upgrades, NameToID(getElementData(veh, "Owner")), getElementData(veh, "Slot"))
					
					
					triggerClientEvent(client, "infobox", client, "Upgrade entfernt!", 2, 75, 255, 75)
					
					return
				end
			end
			
			triggerClientEvent(client, "infobox", client, "Du besitzt dieses Upgrade nicht!", 2, 255, 75, 75)
		end
	end
end
addEventHandler("mechanicBuy", getRootElement(), mechanicBuy)


local function removeVehicleOnDisconnect()
	if cosmicGetElementData(source, "MechanicIndex") then
		local veh = getPedOccupiedVehicle(source)
		
		cosmicSpawnVehicle(NameToID(getPlayerName(source)), getElementData(veh, "Slot"))
	end
end
addEventHandler("onPlayerQuit", getRootElement(), removeVehicleOnDisconnect)