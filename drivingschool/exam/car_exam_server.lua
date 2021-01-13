

local marker = {
	[1] = Vector3(-2022.5404052734, -72.371742248535, 34.581569671631),
	[2] = Vector3(-2003.7716064453, 149.08470153809, 26.948703765869),
	[3] = Vector3(-2000.4510498047, 328.82418823242, 34.42520904541),
	[4] = Vector3(-1867.6688232422, 405.68923950195, 16.428995132446),
	[5] = Vector3(-1761.7244873047, 317.15322875977, 6.4433073997498),
	[6] = Vector3(-1571.6984863281, 479.48718261719, 6.4409127235413),
	[7] = Vector3(-1532.6180419922, 820.62609863281, 6.4487557411194),
	[8] = Vector3(-1695.9757080078, 852.20574951172, 24.144144058228),
	[9] = Vector3(-1881.7161865234, 851.62133789063, 34.417518615723),
	[10] = Vector3(-1902.0825195313, 622.27160644531, 34.425380706787),
	[11] = Vector3(-2018.7905273438, 568.80975341797, 34.42537689209),
	[12] = Vector3(-2146.86328125, 519.44293212891, 34.425327301025),
	[13] = Vector3(-2148.5200195313, 335.7141418457, 34.581611633301),
	[14] = Vector3(-2237.7912597656, 322.10397338867, 34.581699371338),
	[15] = Vector3(-2254.4140625, 182.14569091797, 34.581516265869),
	[16] = Vector3(-2260.4489746094, -56.215377807617, 34.581588745117),
	[17] = Vector3(-2141.8603515625, -72.193420410156, 34.581531524658),
	[18] = Vector3(-2063.6923828125, -83.527465820313, 34.573749542236),
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
							triggerEvent("drivingSchoolFinish", player, "PKW Schein", "practical", true, player)
						else
							outputChatBox("#FFFFFFFahrlehrer#FFFFDD: Du hast " .. cosmicGetElementData(player, "ExamWarns") .. " Fehlerpunkte und die Pruefung somit nicht bestanden!", player, 255, 255, 255, true)
							triggerEvent("drivingSchoolFinish", player, "PKW Schein", "practical", false, player)
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


function startDrivingExam_Car(player)
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
	
	
	local veh = createVehicle(445, -2063.7067871094, -84.177925109863, 34.882835388184, 0, 0, 180, "SCHOOL")
	
	warpPedIntoVehicle(player, veh)
	
	cosmicSetElementData(player, "drivingschool", true)
	cosmicSetElementData(veh, "drivingschool", true)
	
	toggleControl(player, "enter_exit", false)
	setVehicleLocked(veh, true)
	
	triggerClientEvent(player, "ghostMode", player, 2000, true)
	triggerClientEvent(player, "drivingExamStartSpeedWatch", player, true, 85)
	
	outputChatBox("#FFFFFFFahrlehrer#FFFFDD: Achte darauf, nicht schneller als 80 km/h zu fahren!", player, 255, 255, 255, true)
end