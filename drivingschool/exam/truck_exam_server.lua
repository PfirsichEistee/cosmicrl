

local marker = {
	[1] = Vector3(-2020.2686767578, -72.233329772949, 35.565013885498),
	[2] = Vector3(-1922.9948730469, -73.112007141113, 25.947599411011),
	[3] = Vector3(-1796.7670898438, -80.638557434082, 9.8649129867554),
	[4] = Vector3(-1755.8269042969, 292.28707885742, 7.7786812782288),
	[5] = Vector3(-1793.7293701172, 358.48608398438, 17.3782081604),
	[6] = Vector3(-1638.3389892578, 560.41674804688, 39.763961791992),
	[7] = Vector3(-1061.6922607422, 1172.2778320313, 39.179462432861),
	[8] = Vector3(-896.24816894531, 866.07336425781, 19.843950271606),
	[9] = Vector3(-437.31628417969, 563.55285644531, 17.783235549927),
	[10] = Vector3(-138.93179321289, 534.86462402344, 7.5634427070618),
	[11] = Vector3(-171.67599487305, 363.66659545898, 12.469932556152),
	[12] = Vector3(-230.78521728516, 179.60418701172, 7.2534618377686),
	[13] = Vector3(-259.76068115234, -256.57144165039, 1.9083584547043),
	[14] = Vector3(-330.78997802734, -272.32705688477, 10.671524047852),
	[15] = Vector3(-685.14562988281, -245.02139282227, 62.971183776855),
	[16] = Vector3(-926.53344726563, -236.51957702637, 38.894458770752),
	[17] = Vector3(-1074.5949707031, -467.6494140625, 34.582324981689),
	[18] = Vector3(-1284.8200683594, -799.564453125, 70.211517333984),
	[19] = Vector3(-1758.0358886719, -673.72772216797, 23.110273361206),
	[20] = Vector3(-1821.1146240234, -468.23583984375, 15.353518486023),
	[21] = Vector3(-1797.1695556641, -129.21794128418, 6.0450921058655),
	[22] = Vector3(-1882.6121826172, -107.60479736328, 15.243859291077),
	[23] = Vector3(-2063.8376464844, -86.946281433105, 35.557060241699),
}

for a, b in ipairs(marker) do
	marker[a] = createMarker(b.x, b.y, b.z, "checkpoint", 3, 255, 0, 0, 255, nil)
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
							triggerEvent("drivingSchoolFinish", player, "LKW Schein", "practical", true, player)
						else
							outputChatBox("#FFFFFFFahrlehrer#FFFFDD: Du hast " .. cosmicGetElementData(player, "ExamWarns") .. " Fehlerpunkte und die Pruefung somit nicht bestanden!", player, 255, 255, 255, true)
							triggerEvent("drivingSchoolFinish", player, "LKW Schein", "practical", false, player)
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


function startDrivingExam_Truck(player)
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
	
	
	local veh = createVehicle(456, -2063.9899902344, -86.617050170898, 35.556343078613, 0, 0, 180, "SCHOOL")
	
	warpPedIntoVehicle(player, veh)
	
	cosmicSetElementData(player, "drivingschool", true)
	cosmicSetElementData(veh, "drivingschool", true)
	
	toggleControl(player, "enter_exit", false)
	setVehicleLocked(veh, true)
	
	triggerClientEvent(player, "ghostMode", player, 2000, true)
	triggerClientEvent(player, "drivingExamStartSpeedWatch", player, true, 125)
	
	outputChatBox("#FFFFFFFahrlehrer#FFFFDD: Achte darauf, nicht schneller als 120 km/h zu fahren!", player, 255, 255, 255, true)
end