
addEvent("playerStartJob", true)


local jobPickup = {} -- NOT ipairs!

jobPickup[getJobIdFromName("Bauarbeiter")] = createPickup(816.8, 856.8, 12.8, 3, 1239, 100)



for a, b in ipairs(jobPickup) do
	local x, y, z = getElementPosition(b)
	createBlip(x, y, z, 58, 2, 255, 255, 255, 255, 0, 10, getRootElement())
end



local function playerEnterJobPickup(player)
	for a, b in pairs(jobPickup) do
		if b == source then
			if getElementData(player, "Job") then
				triggerClientEvent(player, "infomsg", player, "Du bist bereits bei der Arbeit!", 255, 100, 100)
				return
			end
			
			triggerClientEvent(player, "openJobWindow", player, a)
			
			break
		end
	end
end
addEventHandler("onPickupHit", getRootElement(), playerEnterJobPickup)


local function playerStartJob(jobID, extra)
	if cmath.distElements(client, jobPickup[jobID]) > 4 then
		triggerClientEvent(client, "infomsg", client, "Du bist zu weit entfernt!", 255, 100, 100)
		return
	elseif getPedOccupiedVehicle(client) then
		return
	end
	
	if jobID == 1 then
		startJobConstructionWorker(client, extra)
	end
end
addEventHandler("playerStartJob", getRootElement(), playerStartJob)


function playerQuitJob(player, silent)
	if not isElement(player) then -- onPlayerQuit or onPlayerWasted event
		player = source
	end
	
	
	if getElementData(player, "Job") then
		local jobID = getElementData(player, "Job")
		
		if jobID == 1 then
			quitJobConstructionWorker(player)
		end
		
		
		if silent ~= true then
			outputChatBox("Du hast die Arbeit beendet. Dein Lohn wird dir am Zahltag ausgezahlt.", player, 255, 175, 0)
		end
		
		removeElementData(player, "Job")
	end
end
addCommandHandler("quitjob", playerQuitJob)
addEventHandler("onPlayerQuit", getRootElement(), playerQuitJob)
addEventHandler("onPlayerWasted", getRootElement(), playerQuitJob)