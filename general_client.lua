
addEvent("clearChat", true)
addEvent("ghostMode", true)
addEvent("playClientSound", true)

setDevelopmentMode(true)
screenX, screenY = guiGetScreenSize()


local ghostActive = false
local ghostTimer = -1
local ghostPlayer

local eventHandler = {}
local bindKeys = {}



function clearChat()
	for i = 1, 30, 1 do
		outputChatBox(" ")
	end
end
addEventHandler("clearChat", getRootElement(), clearChat)



function setGhostMode(millis, waitForInput)
	if not ghostActive then
		local player = getLocalPlayer()
		if getPedOccupiedVehicle(player) then
			player = getPedOccupiedVehicle(player)
		end
		
		for a, b in ipairs(getElementsByType(getElementType(player))) do
			setElementCollidableWith(player, b, false)
		end
		
		setElementAlpha(player, 155)
		ghostActive = true
		
		if not waitForInput then
			ghostTimer = -1
			ghostPlayer = nil
			
			setTimer(function()
				if player then
					for a, b in ipairs(getElementsByType(getElementType(player))) do
						setElementCollidableWith(player, b, true)
					end
					
					setElementAlpha(player, 255)
				end
				
				ghostActive = false
			end, millis, 1)
		else
			ghostTimer = millis
			ghostPlayer = player
		end
	end
end
addEventHandler("ghostMode", getRootElement(), setGhostMode)


local function disableGhostMode(key, pressed)
	if pressed and ghostActive and ghostTimer > 0 then
		setTimer(function()
			if ghostPlayer then
				for a, b in ipairs(getElementsByType(getElementType(ghostPlayer))) do
					setElementCollidableWith(ghostPlayer, b, true)
				end
				
				setElementAlpha(ghostPlayer, 255)
			end
			
			ghostActive = false
		end, ghostTimer, 1)
		
		ghostTimer = -1
	end
end
addEventHandler("onClientKey", root, disableGhostMode)


local function playClientSound(id_or_path)
	if tonumber(id_or_path) then
		if id_or_path == 1 then
			playSound("sounds/reached.mp3")
		end
	else
		playSound(id_or_path)
	end
end
addEventHandler("playClientSound", getRootElement(), playClientSound)


local function preEventHandler(...)
	-- "this" is the element the handler is attached to
	-- "eventName" is self explanatory
	
	for a, b in ipairs(eventHandler) do
		if b.element == this and b.event == eventName then
			if b.online == false or getElementType(b.element) ~= "player" then
				b.func(...)
			else
				if cosmicClientGetElementData(b.element, "Online") == true then
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


local function bindKeyPressed(key, pressed)
	if not cosmicClientGetElementData(getLocalPlayer(), "Online") then
		return
	end
	
	for a, b in ipairs(bindKeys) do
		if b.key == key then
			if b.state == "both" or pressed and b.state == "down" or not pressed and b.state == "up" then
				b.func(b.key, b.state, unpack(b.args))
				break
			end
		end
	end
end
addEventHandler("onClientKey", root, bindKeyPressed)

function cosmicBindKey(key, state, func, ...)
	local new = {
		key = key,
		state = state,
		func = func,
		args = {...},
	}
	
	table.insert(bindKeys, new)
end

function cosmicUnbindKey(key, state, func)
	for a, b in ipairs(bindKeys) do
		if b.key == key then
			if state == nil or b.state == state then
				if func == nil or b.func == func then
					table.remove(bindKeys, a)
					break
				end
			end
		end
	end
end



--[[ USEFUL FUNCTIONS ]]--

-- Object movement
function moveObjectOnTrail(element, t, ...) -- (element, timeInSeconds, Vector3 point1, Vector3 point2, Vector3 point...)
	local points = {...}
	
	local x, y, z = getElementPosition(element)
	local totalDist = cmath.dist3D(x, y, z, points[1].x, points[1].y, points[1].z)
	
	if #points > 1 then
		for i = #points, 2, -1 do
			totalDist = totalDist + cmath.dist3D(points[i - 1].x, points[i - 1].y, points[i - 1].z, points[i].x, points[i].y, points[i].z)
		end
	end
	
	
	local timePerUnit = t / totalDist
	
	
	local movement = {
		element = element,
		points = points,
		timePerUnit = timePerUnit,
	}
	
	
	local phTime = cmath.dist3D(x, y, z, points[1].x, points[1].y, points[1].z) * timePerUnit
	moveObject(element, phTime * 1000, points[1].x, points[1].y, points[1].z)
	
	
	if #points > 1 then
		for i = 1, #points - 1, 1 do
			-- object IS at point i and at time phTime
			setTimer(function(element, x, y, z, tx, ty, tz, tpu)
				setElementPosition(element, x, y, z)
				
				local phTime = cmath.dist3D(x, y, z, tx, ty, tz) * tpu
				
				moveObject(element, phTime * 1000, tx, ty, tz)
			end, phTime * 1000, 1, element, points[i].x, points[i].y, points[i].z, points[i + 1].x, points[i + 1].y, points[i + 1].z, timePerUnit)
			
			phTime = phTime + cmath.dist3D(points[i].x, points[i].y, points[i].z, points[i + 1].x, points[i + 1].y, points[i + 1].z) * timePerUnit
		end
	end
end


function dxDrawTextBordered(text, leftX, topY, rightX, bottomY, color, scaleXY, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
	local phX, phY = 1, 1
	for i = 1, 5, 1 do
		dxDrawText(text, leftX + phX * 4, topY + phY * 4, rightX + phX * 4, bottomY + phY * 4, tocolor(0, 0, 0, 255), scaleXY, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
		
		phX = -phX
		if i == 3 then
			phY = -1
		end
	end
	
	dxDrawText(text, leftX, topY, rightX, bottomY, color, scaleXY, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
end
