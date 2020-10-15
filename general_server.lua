

local function cosmicLoadData()
	
end
addEventHandler("onResourceStart", resourceRoot, cosmicLoadData)


function setGhostMode(player, millis, waitForInput)
	triggerClientEvent(player, "ghostMode", player, millis, waitForInput)
end



-- Reads things such as mouse wheel input
--[[local function generalCommandManager(cmd)
	if cosmicGetElementData(source, "Online") ~= true then
		cancelEvent()
	else
		local lastcmd = cosmicGetElementData(source, "lastcmd")
		if lastcmd and (getTickCount() - lastcmd) <= 750 then
			triggerClientEvent(source, "infobox", source, "Nicht spammen!", 2, 255, 75, 75)
			cancelEvent()
		end
		
		cosmicSetElementData(source, "lastcmd", getTickCount())
	end
end
addEventHandler("onPlayerCommand", getRootElement(), generalCommandManager)]]