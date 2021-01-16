
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




function startJobConstructionWorker(player, extra)
	if extra == 1 then -- Erz-Gewinnung
		if getPedWeapon(player, 1) ~= 6 then
			triggerClientEvent(player, "infomsg", player, "Du benoetigst eine Schaufel.\nDu findest sie in allen 24/7 Shops.", 255, 100, 100)
			return
		end
		
		triggerClientEvent(player, "onClientJobStart", player, 1, extra)
		
		for a, b in ipairs(filterMachine) do
			setElementVisibleTo(b, player, true)
			setElementVisibleTo(getAttachedElements(b)[1], player, true)
		end
	else -- Transport
		
	end
	
	
	setElementData(player, "job", 1)
	outputChatBox("Du hast mit der Arbeit begonnen. Tippe /quitjob um sie zu beenden.", player, 255, 255, 0)
end


function quitJobConstructionWorker(player, disconnected)
	for a, b in ipairs(filterMachine) do
		setElementVisibleTo(b, player, false)
		setElementVisibleTo(getAttachedElements(b)[1], player, false)
	end
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
	if itemID == 16 and getElementData(client, "job") == getJobIdFromName("Bauarbeiter") then
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
				
				cosmicSetElementData(client, "Money", cosmicGetElementData(client, "Money") + earnings)
				
				
				triggerClientEvent(client, "infomsg", client, "+ $" .. earnings, 100, 255, 100)
				
				
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