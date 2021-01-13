

local marker = {
	[1] = Vector3(-2072.3955078125, -67.916381835938, 35.223663330078),
	[2] = Vector3(-2084.7775878906, 15.164806365967, 35.231761932373),
	[3] = Vector3(-2153.2241210938, 32.621856689453, 35.22924041748),
	[4] = Vector3(-2144.0708007813, 307.60522460938, 35.226375579834),
	[5] = Vector3(-2305.8198242188, 320.79760742188, 38.843212127686),
	[6] = Vector3(-2586.296875, 160.45671081543, 4.2293434143066),
	[7] = Vector3(-2607.0412597656, 55.880447387695, 4.2319984436035),
	[8] = Vector3(-2437.7165527344, 37.001029968262, 34.637104034424),
	[9] = Vector3(-2423.9038085938, -53.422355651855, 35.225452423096),
	[10] = Vector3(-2276.2531738281, -72.384056091309, 35.213626861572),
	[11] = Vector3(-2064.3054199219, -83.084190368652, 35.223358154297),
}

for a, b in ipairs(marker) do
	marker[a] = createMarker(b.x, b.y, b.z, "checkpoint", 2, 255, 0, 0, 255, nil)
	setElementVisibleTo(marker[a], getRootElement(), false)
	cosmicSetElementData(marker[a], "drivingschool", true)
	
	local ph = createBlipAttachedTo(marker[a], 0, 2, 255, 0, 0, 255, 0, 999999, nil)
	setElementVisibleTo(ph, getRootElement(), false)
end


local function enterDrivingSchoolMarker(player, matchingDimension)
	if isElement(player) and cosmicGetElementData(source, "drivingschool") == true and getElementType(player) == "player" and cosmicGetElementData(player, "drivingschool") == true and isElementVisibleTo(source, player) and getPedOccupiedVehicle(player) ~= nil and matchingDimension then
		local found = false
		for a, b in ipairs(marker) do
			if b == source then
				found = true
				break
			end
		end
		if not found then
			return
		end
		
		setElementVisibleTo(source, player, false)
		setElementVisibleTo(getAttachedElements(source)[1], player, false)
		
		for a, b in ipairs(marker) do
			if b == source then
				if marker[a + 1] ~= nil then
					setElementVisibleTo(marker[a + 1], player, true)
					setElementVisibleTo(getAttachedElements(marker[a + 1])[1], player, true)
				else
					local veh = getPedOccupiedVehicle(player)
					
					if veh and cosmicGetElementData(veh, "drivingschool") then
						cosmicSetElementData(veh, "drivingschool", false)
						cosmicSetElementData(player, "drivingschool", nil)
						triggerClientEvent(player, "drivingExamStartSpeedWatch", player, false)
						
						local vehHP = getElementHealth(veh)
						if vehHP < 1000 then
							outputChatBox("#FFFFFFFahrlehrer#FFFFDD: Aufgrund des Fahrzeugschadens erhaelst du zwei Fehlerpunkte!", player, 255, 255, 255, true)
							cosmicSetElementData(player, "ExamWarns", cosmicGetElementData(player, "ExamWarns") + 2)
						end
						
						removePedFromVehicle(player)
						destroyElement(veh)
						
						if not cosmicGetElementData(player, "ExamWarns") or cosmicGetElementData(player, "ExamWarns") <= 3 then
							outputChatBox("#FFFFFFFahrlehrer#FFFFDD: Du hast die Pruefung mit " .. cosmicGetElementData(player, "ExamWarns") .. " Fehlerpunkten bestanden, herzlichen Glückwunsch!", player, 255, 255, 255, true)
							triggerEvent("drivingSchoolFinish", player, "Motorrad Schein", "practical", true, player)
						else
							outputChatBox("#FFFFFFFahrlehrer#FFFFDD: Du hast " .. cosmicGetElementData(player, "ExamWarns") .. " Fehlerpunkte und die Pruefung somit nicht bestanden!", player, 255, 255, 255, true)
							triggerEvent("drivingSchoolFinish", player, "Motorrad Schein", "practical", false, player)
						end
						
						cosmicSetElementData(player, "ExamWarns", nil)
						toggleControl(player, "enter_exit", true)
					end
				end
				
				break
			end
		end
	end
end
addEventHandler("onMarkerHit", getRootElement(), enterDrivingSchoolMarker)


function startDrivingExam_Bike(player)
	setElementVisibleTo(marker[1], player, true)
	setElementVisibleTo(getAttachedElements(marker[1])[1], player, true)
	setElementInterior(player, 0, -2063.7067871094, -84.177925109863, 34.882835388184)
	setElementPosition(player, -2063.7067871094, -84.177925109863, 34.882835388184)
	
	toggleControl(player, "action", true)
	toggleControl(player, "fire", true)
	toggleControl(player, "aim_weapon", true)
	toggleControl(player, "previous_weapon", true)
	toggleControl(player, "sprint", true)
	toggleControl(player, "jump", true)
	toggleControl(player, "crouch", true)
	
	
	local veh = createVehicle(581, -2064.3054199219, -83.084190368652, 35.223358154297, 0, 0, 180, "SCHOOL")
	
	warpPedIntoVehicle(player, veh)
	
	cosmicSetElementData(player, "drivingschool", true)
	cosmicSetElementData(veh, "drivingschool", true)
	
	toggleControl(player, "enter_exit", false)
	setVehicleLocked(veh, true)
	
	triggerClientEvent(player, "ghostMode", player, 2000, true)
	triggerClientEvent(player, "drivingExamStartSpeedWatch", player, true, 105)
	
	outputChatBox("#FFFFFFFahrlehrer#FFFFDD: Achte darauf, nicht schneller als 100 km/h zu fahren!", player, 255, 255, 255, true)
end