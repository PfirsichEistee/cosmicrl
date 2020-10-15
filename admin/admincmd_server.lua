

local function adminVehicleOwn(player, cmd)
	if cosmicGetElementData(player, "Adminlevel") > 0 then
		local veh = getPedOccupiedVehicle(player)
		
		if veh then
			local newVehSlot = 1
			local result = dbPoll(dbQuery(dbHandler, "SELECT Slot FROM vehicle WHERE OwnerID=?", NameToID(getPlayerName(player))), -1)
			
			if result then
				local found = true
				while found do
					found = false
					for a, b in ipairs(result) do
						if b["Slot"] == newVehSlot then
							found = true
							newVehSlot = newVehSlot + 1
							break
						end
					end
				end
			end
			
			
			if getElementData(veh, "Owner") then
				dbExec(dbHandler, "DELETE FROM vehicle WHERE OwnerID=? AND Slot=?", NameToID(getElementData(veh, "Owner")), getElementData(veh, "Slot"))
			end
			
			local spawn = getElementStringTransform(veh)
			local r1, g1, b1, r2, g2, b2 = getVehicleColor(veh, true)
			local color = r1 .. "|" .. g1 .. "|" .. b1 .. "|" .. r2 .. "|" .. g2 .. "|" .. b2
			r1, g1, b1 = getVehicleHeadLightColor(veh)
			local lightcolor = r1 .. "|" .. g1 .. "|" .. b1
			
			dbExec(dbHandler, "INSERT INTO vehicle (ID, OwnerID, Slot, Model, Spawn, Color, Lightcolor) VALUES (?, ?, ?, ?, ?, ?, ?)", cosmicCreateUniqueVehicleID(), NameToID(getPlayerName(player)), newVehSlot, getElementModel(veh), spawn, color, lightcolor)
			
			
			setElementData(veh, "Owner", getPlayerName(player))
			setElementData(veh, "Slot", newVehSlot)
			
			
			triggerClientEvent(player, "infomsg", player, "Das Fahrzeug gehoert nun dir", 255, 75, 75)
		else
			triggerClientEvent(player, "infobox", player, "Du befindest dich in keinem Fahrzeug!", 1.5, 255, 75, 75)
		end
	else
		triggerClientEvent(player, "infobox", player, "Du bist kein Admin!", 1.5, 255, 75, 75)
	end
end
addCommandHandler("vehown", adminVehicleOwn)


local function adminVehicleDelete(player, cmd)
	if cosmicGetElementData(player, "Adminlevel") > 0 then
		local veh = getPedOccupiedVehicle(player)
		
		if veh then
			if getElementData(veh, "Owner") then
				dbExec(dbHandler, "DELETE FROM vehicle WHERE OwnerID=? AND Slot=?", NameToID(getElementData(veh, "Owner")), getElementData(veh, "Slot"))
			end
			
			destroyElement(veh)
			
			
			triggerClientEvent(player, "infomsg", player, "Das Fahrzeug wurde geloescht", 255, 75, 75)
		else
			triggerClientEvent(player, "infobox", player, "Du befindest dich in keinem Fahrzeug!", 1.5, 255, 75, 75)
		end
	else
		triggerClientEvent(player, "infobox", player, "Du bist kein Admin!", 1.5, 255, 75, 75)
	end
end
addCommandHandler("vehdel", adminVehicleDelete)