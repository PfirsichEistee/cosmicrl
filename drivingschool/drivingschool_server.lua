
addEvent("drivingSchoolBuy", true)
addEvent("drivingSchoolFinish", true)
addEvent("drivingExamSyncWarns", true)


createBlip(-2026.6086425781, -101.0858001709, 36, 38, 2, 255, 255, 255, 255, 0, 10, getRootElement())
local enterMarker = createMarker(-2026.6086425781, -101.0858001709, 36, "arrow", 1, 255, 255, 0, 255, getRootElement())
local exitMarker = createMarker(-2026.7354736328, -104.48717498779, 1036, "arrow", 1, 255, 255, 0, 255, getRootElement())
setElementInterior(exitMarker, 3, -2026.7354736328, -104.48717498779, 1036)

local npc = createPed(17, -2035.0952148438, -117.51425170898, 1035.171875, 270, false)
setElementFrozen(npc, true)
setElementData(npc, "InvincibleNPC", true)
setElementInterior(npc, 3, -2035.0952148438, -117.51425170898, 1035.171875)


local function enterDrivingSchool(player, matchingDimension)
	if getElementType(player) == "player" and matchingDimension and not getPedOccupiedVehicle(player) then
		setElementFrozen(player, true)
		fadeCamera(player, false)
		
		setTimer(function()
			setElementFrozen(player, false)
			fadeCamera(player, true)
			
			setElementInterior(player, 3, -2029.7807617188, -105.37526702881, 1035.171875)
			setElementRotation(player, 0, 0, 180)
			
			toggleControl(player, "action", false)
			toggleControl(player, "fire", false)
			toggleControl(player, "aim_weapon", false)
			toggleControl(player, "previous_weapon", false)
			toggleControl(player, "sprint", false)
			toggleControl(player, "jump", false)
			toggleControl(player, "crouch", false)
			
			setPedWeaponSlot(player, 0)
		end, 1000, 1)
	end
end
addEventHandler("onMarkerHit", enterMarker, enterDrivingSchool)


local function exitDrivingSchool(player, matchingDimension)
	if getElementType(player) == "player" and matchingDimension and not getPedOccupiedVehicle(player) then
		setElementFrozen(player, true)
		fadeCamera(player, false)
		
		setTimer(function()
			setElementFrozen(player, false)
			fadeCamera(player, true)
			
			setElementInterior(player, 0, -2026.6086425781, -99.0858001709, 35.21)
			setElementRotation(player, 0, 0, 0)
			
			toggleControl(player, "action", true)
			toggleControl(player, "fire", true)
			toggleControl(player, "aim_weapon", true)
			toggleControl(player, "previous_weapon", true)
			toggleControl(player, "sprint", true)
			toggleControl(player, "jump", true)
			toggleControl(player, "crouch", true)
		end, 1000, 1)
	end
end
addEventHandler("onMarkerHit", exitMarker, exitDrivingSchool)


local function drivingSchoolBuy(license)
	if license == "PKW Schein" then
		if cosmicGetElementData(client, "Money") >= 2150 then
			if cosmicGetPlayerItem(client, getItemID("PKW Schein")) > 0 then
				triggerClientEvent(client, "infobox", client, "Diesen Schein hast du bereits!", 5, 255, 100, 100)
				return
			end
			
			triggerClientEvent(client, "infomsg", client, "Du hast mit der theoretischen Fahrpruefung begonnen (- $2150)", 100, 255, 100)
			cosmicSetElementData(client, "Money", cosmicGetElementData(client, "Money") - 2150)
			
			setElementFrozen(client, true)
			
			triggerClientEvent(client, "drivingSchoolStart", client)
		else
			triggerClientEvent(client, "infobox", client, "Du hast nicht genug Geld!", 5, 255, 100, 100)
		end
	elseif license == "Motorrad Schein" then
		if cosmicGetElementData(client, "Money") >= 1600 then
			if cosmicGetPlayerItem(client, getItemID("Motorrad Schein")) > 0 then
				triggerClientEvent(client, "infobox", client, "Diesen Schein hast du bereits!", 5, 255, 100, 100)
				return
			end
			
			triggerClientEvent(client, "infomsg", client, "Du hast mit der Fahrpruefung begonnen (- $1600)", 100, 255, 100)
			cosmicSetElementData(client, "Money", cosmicGetElementData(client, "Money") - 1600)
			
			startDrivingExam_Bike(client)
		else
			triggerClientEvent(client, "infobox", client, "Du hast nicht genug Geld!", 5, 255, 100, 100)
		end
	elseif license == "LKW Schein" then
		if cosmicGetElementData(client, "Money") >= 4500 then
			if cosmicGetPlayerItem(client, getItemID("LKW Schein")) > 0 then
				triggerClientEvent(client, "infobox", client, "Diesen Schein hast du bereits!", 5, 255, 100, 100)
				return
			end
			
			triggerClientEvent(client, "infomsg", client, "Du hast mit der Fahrpruefung begonnen (- $1600)", 100, 255, 100)
			cosmicSetElementData(client, "Money", cosmicGetElementData(client, "Money") - 4500)
			
			startDrivingExam_Truck(client)
		else
			triggerClientEvent(client, "infobox", client, "Du hast nicht genug Geld!", 5, 255, 100, 100)
		end
	end
end
addEventHandler("drivingSchoolBuy", getRootElement(), drivingSchoolBuy)


local function drivingSchoolFinish(license, a, b, player)
	if not player then
		player = client
	end
	
	if license == "PKW Schein" then
		if a == "theory" then
			setElementFrozen(player, false)
			
			if b then -- bestanden?
				triggerClientEvent(player, "infobox", player, "Du hast die theoretische Pruefung bestanden!\nNun beginnt die praktische Pruefung!", 5, 255, 255, 100)
				startDrivingExam_Car(player)
			else
				triggerClientEvent(player, "infobox", player, "Du hast die Pruefung nicht bestanden!", 5, 255, 100, 100)
			end
		else
			if b then -- bestanden?
				triggerClientEvent(player, "infobox", player, "Du hast die praktische Pruefung bestanden!", 5, 100, 255, 100)
				cosmicSetPlayerItem(player, getItemID("PKW Schein"), 1)
			else
				triggerClientEvent(player, "infobox", player, "Du hast die Pruefung nicht bestanden!", 5, 255, 100, 100)
			end
		end
	elseif license == "Motorrad Schein" then
		if b then -- bestanden?
			triggerClientEvent(player, "infobox", player, "Du hast die Pruefung bestanden!", 5, 100, 255, 100)
			cosmicSetPlayerItem(player, getItemID("Motorrad Schein"), 1)
		else
			triggerClientEvent(player, "infobox", player, "Du hast die Pruefung nicht bestanden!", 5, 255, 100, 100)
		end
	elseif license == "LKW Schein" then
		if b then -- bestanden?
			triggerClientEvent(player, "infobox", player, "Du hast die Pruefung bestanden!", 5, 100, 255, 100)
			cosmicSetPlayerItem(player, getItemID("LKW Schein"), 1)
		else
			triggerClientEvent(player, "infobox", player, "Du hast die Pruefung nicht bestanden!", 5, 255, 100, 100)
		end
	end
end
addEventHandler("drivingSchoolFinish", getRootElement(), drivingSchoolFinish)


local function stopVehicleEnter(player)
	if getElementType(player) == "player" and cosmicGetElementData(source, "drivingschool") then
		cancelEvent()
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), stopVehicleEnter)




local function clearMarkerVisibilityTo(player)
	toggleControl(player, "enter_exit", true)
	triggerClientEvent(player, "drivingExamStartSpeedWatch", player, false)
	
	for a, b in ipairs(getElementsByType("marker")) do
		if cosmicGetElementData(b, "drivingschool") then
			setElementVisibleTo(b, player, false)
			setElementVisibleTo(getAttachedElements(b)[1], player, false)
		end
	end
end


local function destroyEmptyVehicle()
	if getElementType(source) == "player" then
		if cosmicGetElementData(source, "drivingschool") then
			triggerClientEvent(source, "infobox", source, "Die Fahrpruefung wurde abgebrochen!", 5, 255, 100, 100)
			cosmicSetElementData(source, "drivingschool", nil)
			clearMarkerVisibilityTo(source)
			source = getPedOccupiedVehicle(source)
			
			if not source then
				return
			end
		else
			return
		end
	end
	
	if cosmicGetElementData(source, "drivingschool") then
		for a, b in ipairs(getElementsByType("player")) do
			if cosmicGetElementData(b, "drivingschool") then
				if not getPedOccupiedVehicle(b) or not cosmicGetElementData(getPedOccupiedVehicle(b), "drivingschool") or getPedOccupiedVehicle(b) == source then
					triggerClientEvent(b, "infobox", b, "Die Fahrpruefung wurde abgebrochen!", 5, 255, 100, 100)
					cosmicSetElementData(b, "drivingschool", nil)
					clearMarkerVisibilityTo(b)
				end
			end
		end
		
		destroyElement(source)
	end
end
addEventHandler("onVehicleExit", getRootElement(), destroyEmptyVehicle)
addEventHandler("onVehicleExplode", getRootElement(), destroyEmptyVehicle)
addEventHandler("onPlayerQuit", getRootElement(), destroyEmptyVehicle)
addEventHandler("onPlayerWasted", getRootElement(), destroyEmptyVehicle)



local function drivingExamSyncWarns(value)
	cosmicSetElementData(client, "ExamWarns", value)
end
addEventHandler("drivingExamSyncWarns", getRootElement(), drivingExamSyncWarns)