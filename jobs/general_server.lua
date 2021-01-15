
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
			if getElementData(player, "job") then
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
	
	
	setElementData(client, "job", jobID)
	outputChatBox("yeah lets go " .. jobID .. "; " .. extra)
	
	if jobID == 1 then
		startJobConstructionWorker(client, extra)
	end
end
addEventHandler("playerStartJob", getRootElement(), playerStartJob)



local function cmd(player)
	setElementPosition(player, 842.06604003906, 856.48767089844, 13.006146430969)
end
addCommandHandler("ok", cmd)