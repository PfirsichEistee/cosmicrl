
addEvent("clearChat", true)
addEvent("ghostMode", true)
addEvent("playClientSound", true)

setDevelopmentMode(true)
screenX, screenY = guiGetScreenSize()


local ghostActive = false
local ghostTimer = -1
local ghostPlayer



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