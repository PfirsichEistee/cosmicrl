
local weather = {} -- weather[HOUR 0-23] = WEATHER-ID
local weatherTimer


local function hourTick()
	outputChatBox("an hour passed")
	print("an hour passed")
end


local function cosmicGeneralStart()
	setMinuteDuration(60000)
	setTime(getRealTime().hour, getRealTime().minute)
	
	for i = 0, 23, 1 do
		weather[i] = math.floor(math.random() * 21)
	end
	setWeather(weather[getRealTime().hour])
	
	setTimer(function()
		hourTick()
		setTimer(hourTick, 60000 * 60, 0)
	end, (60 - getRealTime().minute) * 60000, 1)
end
addEventHandler("onResourceStart", resourceRoot, cosmicGeneralStart)


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