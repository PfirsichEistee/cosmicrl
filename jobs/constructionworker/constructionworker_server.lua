
addEvent("playerHitRock", true)


local constructionworkerRockPosition = {
	Vector3(661.70001220703, 819.20001220703, -41.299999237061),
	Vector3(646.09997558594, 812.70001220703, -41.299999237061),
	Vector3(616.90002441406, 819.70001220703, -41.299999237061),
	Vector3(687.29998779297, 866.20001220703, -40.099998474121),
	Vector3(678.09997558594, 902.90002441406, -38.700000762939),
	Vector3(690.59997558594, 896.50000000001, -37.700000762939),
	Vector3(676.20001220703, 888.40002441406, -38.500000000001),
}


local filterMachine = {
	createMarker(681.94512939453, 823.93383789063, -26.855230331421, "corona", 2, 0, 255, 0, 255, nil),
	createMarker(693.58380126953, 844.32611083984, -26.837371826172, "corona", 2, 0, 255, 0, 255, nil),
}
for a, b in ipairs(filterMachine) do
	setElementVisibleTo(b, getRootElement(), false)
	
	local ph = createBlipAttachedTo(b, 0, 2, 0, 255, 0, 255, 0, 999999, nil)
	setElementVisibleTo(ph, getRootElement(), false)
end


local rock = {}
for a, b in ipairs(constructionworkerRockPosition) do
	rock[a] = createObject(906, b.x, b.y, b.z, 0, 90, math.random() * 360, false)
end



local transportMarker = {
	createMarker(824.72985839844, 849.71026611328, 10.613054084778, "cylinder", 4, 255, 0, 0, 255, nil),
	createMarker(-2101.65625, 204.23728942871, 34.387924957275, "cylinder", 4, 255, 0, 0, 255, nil),
	createMarker(2706.3820800781, 882.15246582031, 8.956210899353, "cylinder", 4, 255, 0, 0, 255, nil),
	createMarker(326.072265625, 2560.3327636719, 15.463005828857, "cylinder", 4, 255, 0, 0, 255, nil),
	createMarker(-2129.3999023438, -97.400001525879, 34.700001525879, "cylinder", 4, 255, 0, 0, 255, nil),
}
for a, b in ipairs(transportMarker) do
	setElementVisibleTo(b, getRootElement(), false)
	
	local ph = createBlipAttachedTo(b, 0, 2, 255, 0, 0, 255, 0, 999999, nil)
	setElementVisibleTo(ph, getRootElement(), false)
end




local trailer = {
	createVehicle(450, 830.29998779297, 871.20001220703, 13.5, 0, 0, 230, "COSMIC"),
	createVehicle(450, 836.70001220703, 873, 14, 0, 0, 230, "COSMIC"),
	createVehicle(450, 842.09997558594, 876.09997558594, 14, 0, 0, 230, "COSMIC"),
	createVehicle(450, 847.29998779297, 879.79998779297, 14, 0, 0, 230, "COSMIC"),
}

local function stopTrailerDestroy()
	local spawn = cosmicGetElementData(source, "Spawn")
	
	local veh = createVehicle(450, spawn.x, spawn.y, spawn.z, 0, 0, 230, "COSMIC")
	cosmicSetElementData(veh, "Job", 1)
	cosmicSetElementData(veh, "Spawn", spawn)
	setElementFrozen(veh, true)
	setVehicleDamageProof(veh, true)
	
	setVehicleVariant(veh, 0, 0)
	
	for a, b in ipairs(trailer) do
		if b == source then
			trailer[a] = veh
			break
		end
	end
end

for a, b in ipairs(trailer) do
	setElementFrozen(b, true)
	cosmicSetElementData(b, "Job", 1)
	setVehicleDamageProof(b, true)
	
	setVehicleVariant(b, 0, 0)
	
	local x, y, z = getElementPosition(b)
	cosmicSetElementData(b, "Spawn", Vector3(x, y, z))
	
	addEventHandler("onElementDestroy", b, stopTrailerDestroy)
end


local function hitTransportMarker(player, matching)
	if isElement(player) and getElementType(player) == "player" and matching and isElementVisibleTo(source, player) then
		for a, b in ipairs(transportMarker) do
			if b == source then
				if cosmicGetElementData(player, "JobType") == 2 then -- Zement
					local veh = getPedOccupiedVehicle(player)
					if not veh or cosmicGetElementData(veh, "Jobber") ~= player then
						return
					end
					if cmath.getElementSpeed(veh) > ((40000 / 60) / 60) then -- > 40kmh
						triggerClientEvent(player, "infomsg", player, "Du bist zu schnell!", 255, 100, 100)
						return
					end
					
					setElementVisibleTo(source, player, false)
					setElementVisibleTo(getAttachedElements(source)[1], player, false)
					
					if a == 1 then -- its the return point
						outputChatBox("#FFFFFFChef#FFFFDD: Gute Arbeit! Deinen Lohn erhaelst du beim naechsten Zahltag!", player, 255, 255, 255, true)
						
						destroyElement(veh)
						
						cosmicSetElementData(player, "Payday", cosmicGetElementData(player, "Payday") + 200 + math.floor(100 * math.random()))
						
						playerQuitJob(player, true)
					else
						setElementVisibleTo(transportMarker[1], player, true)
						setElementVisibleTo(getAttachedElements(transportMarker[1])[1], player, true)
						
						setElementFrozen(veh, true)
						setElementFrozen(player, true)
						
						setTimer(function()
							setElementFrozen(veh, false)
							setElementFrozen(player, false)
							
							outputChatBox("#FFFFFFArbeiter#FFFFDD: Danke. Jetzt musst du nur noch den Wagen zurueckfahren, dann ist Feierabend.", player, 255, 255, 255, true)
						end, 5000, 1)
					end
				else -- Rohstoffe
					local veh = getPedOccupiedVehicle(player)
					if not veh or cosmicGetElementData(veh, "Jobber") ~= player then
						return
					end
					if cmath.getElementSpeed(veh) > ((40000 / 60) / 60) then -- > 40kmh
						triggerClientEvent(player, "infomsg", player, "Du bist zu schnell!", 255, 100, 100)
						return
					end
					
					if a == 1 then -- its the return point
						setElementVisibleTo(source, player, false)
						setElementVisibleTo(getAttachedElements(source)[1], player, false)
						
						outputChatBox("#FFFFFFChef#FFFFDD: Gute Arbeit! Deinen Lohn erhaelst du beim naechsten Zahltag!", player, 255, 255, 255, true)
						
						destroyElement(veh)
						
						cosmicSetElementData(player, "Payday", cosmicGetElementData(player, "Payday") + 350 + math.floor(100 * math.random()))
						
						playerQuitJob(player, true)
					else
						-- look for trailer
						local trl
						for a, b in ipairs(trailer) do
							if cosmicGetElementData(b, "Jobber") == player then
								trl = b
							end
						end
						if trl then
							if cmath.distElements(trl, source) < 15 then
								destroyElement(trl)
							else
								outputChatBox("#FFFFFFArbeiter#FFFFDD: Du hast jetzt nicht ernsthaft den Anhaenger vergessen..?", player, 255, 255, 255, true)
								return
							end
						else
							outputChatBox("#FFFFFFArbeiter#FFFFDD: Du hast jetzt nicht ernsthaft den Anhaenger vergessen..?", player, 255, 255, 255, true)
							return
						end
						
						
						setElementVisibleTo(source, player, false)
						setElementVisibleTo(getAttachedElements(source)[1], player, false)
						
						setElementVisibleTo(transportMarker[1], player, true)
						setElementVisibleTo(getAttachedElements(transportMarker[1])[1], player, true)
						
						setElementFrozen(veh, true)
						setElementFrozen(player, true)
						
						setTimer(function()
							setElementFrozen(veh, false)
							setElementFrozen(player, false)
							
							outputChatBox("#FFFFFFArbeiter#FFFFDD: Danke. Jetzt musst du nur noch den Wagen zurueckfahren, dann ist Feierabend.", player, 255, 255, 255, true)
						end, 5000, 1)
					end
				end
				
				
				break
			end
		end
	end
end
addEventHandler("onMarkerHit", getRootElement(), hitTransportMarker)


function startJobConstructionWorker(player, extra)
	if extra == 1 then -- Erz-Gewinnung
		if getPedWeapon(player, 1) ~= 6 then
			triggerClientEvent(player, "infomsg", player, "Du benoetigst eine Schaufel.\nDu findest sie in allen 24/7 Shops.", 255, 100, 100)
			return
		end
		
		for a, b in ipairs(filterMachine) do
			setElementVisibleTo(b, player, true)
			setElementVisibleTo(getAttachedElements(b)[1], player, true)
		end
	elseif extra == 2 then -- Transport (Zement)
		if cosmicGetPlayerItem(player, 10) == 0 then -- LKW Schein
			triggerClientEvent(player, "infomsg", player, "Du benoetigst einen LKW-Schein", 255, 100, 100)
			return
		end
		
		cosmicSetElementData(player, "JobType", 2)
		
		local id = math.ceil(math.random() * (#transportMarker - 1)) + 1
		setElementVisibleTo(transportMarker[id], player, true)
		setElementVisibleTo(getAttachedElements(transportMarker[id])[1], player, true)
		
		local veh = createVehicle(524, 812.14495849609, 824.41497802734, 11.058280944824, -3.6203887462616, 6.7851667404175, 307.78686523438, "COSMIC")
		cosmicSetElementData(veh, "Job", 1)
		cosmicSetElementData(veh, "Jobber", player)
		
		warpPedIntoVehicle(player, veh)
		
		triggerClientEvent(player, "ghostMode", player, 4000, true)
	elseif extra == 3 then
		if cosmicGetPlayerItem(player, 10) == 0 then -- LKW Schein
			triggerClientEvent(player, "infomsg", player, "Du benoetigst einen LKW-Schein", 255, 100, 100)
			return
		end
		local found = false
		for a, b in ipairs(trailer) do
			if not cosmicGetElementData(b, "Jobber") then
				found = true
				break
			end
		end
		if not found then
			outputChatBox("#FFFFFFChef#FFFFDD: Unsere Trucker sind gerade alle unterwegs, sorry! Du kannst hier aber ein Weilchen warten und vielleicht 'nen Kaffee trinken...", player, 255, 255, 255, true)
			return
		end
		
		cosmicSetElementData(player, "JobType", 3)
		
		local id = math.ceil(math.random() * (#transportMarker - 1)) + 1
		setElementVisibleTo(transportMarker[id], player, true)
		setElementVisibleTo(getAttachedElements(transportMarker[id])[1], player, true)
		
		local veh = createVehicle(514, 812.14495849609, 824.41497802734, 11.058280944824, -3.6203887462616, 6.7851667404175, 307.78686523438, "COSMIC")
		cosmicSetElementData(veh, "Job", 1)
		cosmicSetElementData(veh, "Jobber", player)
		
		warpPedIntoVehicle(player, veh)
		
		triggerClientEvent(player, "ghostMode", player, 4000, true)
		
		
		outputChatBox("#FFFFFFChef#FFFFDD: Pass bloss auf den Anhaenger auf! Der Inhalt kann da schnell mal rausfliegen..", player, 255, 255, 255, true)
	end
	
	
	triggerClientEvent(player, "onClientJobStart", player, 1, extra)
	
	setElementData(player, "Job", 1)
	outputChatBox("Du hast mit der Arbeit begonnen. Tippe /quitjob um sie zu beenden.", player, 255, 255, 0)
end


function quitJobConstructionWorker(player, disconnected)
	for a, b in ipairs(filterMachine) do
		setElementVisibleTo(b, player, false)
		setElementVisibleTo(getAttachedElements(b)[1], player, false)
	end
	for a, b in ipairs(transportMarker) do
		setElementVisibleTo(b, player, false)
		setElementVisibleTo(getAttachedElements(b)[1], player, false)
	end
	
	for a, b in ipairs(getElementsByType("vehicle")) do
		if cosmicGetElementData(b, "Jobber") == player then
			destroyElement(b)
		end
	end
	
	cosmicSetElementData(player, "JobType", nil)
end


local function playerHitRock()
	-- source is the rock that was hit
	
	for a, b in ipairs(rock) do
		if b == source then
			if cmath.distElements(client, b) < 6 then
				if getElementHealth(b) > 0 then
					setElementHealth(b, getElementHealth(b) - 100)
					
					local x, y, z = getElementPosition(b)
					setElementPosition(b, x, y, z + (1 - (getElementHealth(b) / 1000)) * -0.25)
					
					if math.random() > 0.5 then
						local amount = math.ceil(math.random() * 3)
						
						if math.random() > 0.8 then
							amount = amount + math.ceil(math.random() * 6)
						end
						
						local r = math.pi * 2 * math.random()
						local item = createItemPickup(x + 3 * math.sin(r), y + 3 * math.cos(r), constructionworkerRockPosition[a].z - 1.25, getItemID("Stein"), amount, 3930)
					end
					
					
					if getElementHealth(b) <= 0 then
						setTimer(function(theRock)
							setElementHealth(theRock, 1000)
							
							for key, obj in ipairs(rock) do
								if obj == theRock then
									local ph = constructionworkerRockPosition[key]
									setElementPosition(obj, ph.x, ph.y, ph.z)
								end
							end
						end, 60000 * 3, 1, b)
					end
				end
			end
			
			break
		end
	end
	
	--[[local nearest = rock[1]
	for a, b in ipairs(rock) do
		if cmath.distElements(client, b) < cmath.distElements(client, nearest) then
			nearest = b
		end
	end
	
	if cmath.distElements(client, nearest) < 5 and cmath.isPedLookingAt(client, getElementPosition(nearest)) then
		triggerClientEvent(client, "cwJiggleRock", client, nearest)
	end]]
end
addEventHandler("playerHitRock", getRootElement(), playerHitRock)


local function playerDropRock(itemID)
	if itemID == 16 and getElementData(client, "Job") == getJobIdFromName("Bauarbeiter") then
		if cosmicGetElementData(client, "BlockStoneUsage") or getPedOccupiedVehicle(client) then
			return
		end
		
		for a, b in ipairs(filterMachine) do
			if cmath.distElements(client, b) < 4 then
				if cosmicGetPlayerItem(client, 16) < 5 then
					triggerClientEvent(client, "infomsg", client, "Du brauchst mindestens 5 Steine", 255, 100, 100)
					return
				end
				
				triggerClientEvent(client, "cwCreateRockAnim", client, a)
				
				cosmicSetPlayerItem(client, 16, cosmicGetPlayerItem(client, 16) - 5)
				local earnings = 0
				for i = 1, 5, 1 do
					earnings = earnings + math.ceil(6 * math.random())
				end
				
				--cosmicSetElementData(client, "Money", cosmicGetElementData(client, "Money") + earnings)
				cosmicSetElementData(client, "Payday", cosmicGetElementData(client, "Payday") + earnings)
				
				
				--triggerClientEvent(client, "infomsg", client, "+ $" .. earnings, 100, 255, 100)
				
				
				setPedAnimation(client, "grenade", "weapon_throw", -1, false, false, true, false, 250, true)
				cosmicSetElementData(client, "BlockStoneUsage", true)
				
				setTimer(function(player)
					cosmicSetElementData(player, "BlockStoneUsage", nil)
				end, 1000, 1, client)
				
				return
			end
		end
		
		triggerClientEvent(client, "infomsg", client, "Du bist zu weit entfernt", 255, 100, 100)
	end
end
addEventHandler("playerUseItem", getRootElement(), playerDropRock)


local function playerClaimTrailer(veh)
	-- source == trailer
	if cosmicGetElementData(veh, "Job") == 1 then
		local detach = true
		
		local player = getVehicleController(veh)
		
		if player and getElementData(player, "Job") == 1 and cosmicGetElementData(veh, "Jobber") == player and cosmicGetElementData(source, "Job") == 1 and
			(not cosmicGetElementData(source, "Jobber") or cosmicGetElementData(source, "Jobber") == player) then
			local found = false
			for a, b in ipairs(trailer) do
				if cosmicGetElementData(b, "Jobber") == player and b ~= source then
					-- already has a trailer!
					found = true
					
					triggerClientEvent(player, "infomsg", player, "Du hast bereits einen Anhaenger!", 255, 100, 100)
				end
			end
			
			if not found then
				detach = false
				cosmicSetElementData(source, "Jobber", player)
				setElementFrozen(source, false)
			end
		end
		
		
		if detach then
			setTimer(function(veh)
				detachTrailerFromVehicle(veh)
				
				local vehForward = Matrix(Vector3(getElementPosition(veh)), Vector3(getElementRotation(veh))):getForward()
				local x, y, z = getElementPosition(veh)
				setElementPosition(veh, x + vehForward.x * 2, y + vehForward.y * 2, z + vehForward.z * 2 + 2)
				
				--triggerClientEvent(player, "ghostMode", player, 4000, true)
			end, 100, 1, veh)
		end
	end
end
addEventHandler("onTrailerAttach", getRootElement(), playerClaimTrailer)