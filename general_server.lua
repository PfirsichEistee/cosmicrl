
addEvent("onHourTick", false)
addEvent("onMinuteTick", false)


local weather = {} -- weather[HOUR 0-23] = WEATHER-ID

local eventHandler = {}


local function hourTick()
	setWeather(weather[getRealTime().hour])
	
	triggerEvent("onHourTick", resourceRoot)
end

local function minuteTick()
	for a, b in ipairs(getElementsByType("player")) do
		if cosmicGetElementData(b, "Online") then
			if getPlayerIdleTime(b) < 300000 then
				cosmicSetElementData(b, "Playtime", cosmicGetElementData(b, "Playtime") + 1)
				
				if (cosmicGetElementData(b, "Playtime") % 60) == 0 and cosmicGetElementData(b, "Payday") > 0 then
					triggerClientEvent(b, "playClientSound", b, 1)
					
					triggerClientEvent(b, "infomsg", b, "Es ist Zahltag! Du hast $" .. cosmicGetElementData(b, "Payday") .. " verdient!", 100, 255, 100)
					
					cosmicSetElementData(b, "Bankmoney", cosmicGetElementData(b, "Bankmoney") + cosmicGetElementData(b, "Payday"))
					
					cosmicSetElementData(b, "Payday", 0)
				end
			else
				-- Player has been afk for more than 5 minutes
				
			end
		end
	end
	
	triggerEvent("onMinuteTick", resourceRoot)
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
	
	setTimer(function()
		minuteTick()
		setTimer(minuteTick, 60000, 0)
		
		-- perfectly sync time
		setMinuteDuration(60000)
		setTime(getRealTime().hour, getRealTime().minute)
	end, (60 - cmath.clamp(getRealTime().second, 0, 59)) * 1000, 1)
end
addEventHandler("onResourceStart", resourceRoot, cosmicGeneralStart)


local function cosmicGeneralQuit()
	for a, b in ipairs(getElementsByType("player")) do
		setElementPosition(b, cosmicGetSpawnPosition(0))
	end
end
addEventHandler("onResourceStop", resourceRoot, cosmicGeneralQuit)


function setGhostMode(player, millis, waitForInput)
	triggerClientEvent(player, "ghostMode", player, millis, waitForInput)
end



local function preEventHandler(...)
	-- "this" is the element the handler is attached to
	-- "eventName" is self explanatory
	
	for a, b in ipairs(eventHandler) do
		if b.element == this and b.event == eventName then
			if b.online == false or getElementType(b.element) ~= "player" then
				b.func(...)
			else
				if cosmicGetElementData(b.element, "Online") == true then
					b.func(...)
				end
			end
			
			break
		end
	end
end

function cosmicAddEventHandler(event, element, func, online)
	online = online or true
	
	local new = {
		event = event,
		element = element,
		func = func,
		online = online,
	}
	
	table.insert(eventHandler, new)
	addEventHandler(event, element, preEventHandler)
end

function cosmicRemoveEventHandler(event, element, func)
	for a, b in ipairs(eventHandler) do
		if b.event == event and b.element == element and b.func == func then
			removeEventHandler(event, element, preEventHandler)
			table.remove(eventHandler, a)
			
			break
		end
	end
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
