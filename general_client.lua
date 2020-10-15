
addEvent("clearChat", true)
addEvent("ghostMode", true)

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