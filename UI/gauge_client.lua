
local size = getMinimapH()
local posX = screenX - size - getMinimapSpace()
local posY = screenY - size - getMinimapSpace()



function drawGauge()
	local veh = getPedOccupiedVehicle(getLocalPlayer())
	
	if veh and getPedOccupiedVehicleSeat(getLocalPlayer()) == 0 then
		-- 270 km/h == 270000 m/h == 75 m/s
		local mult = (1 / 75) * cmath.getElementSpeed(veh)
		
		dxDrawImage(posX, posY, size, size, "images/hud/speed-bg.png", 0, 0, 0, tocolor(255, 255, 255, 175))
		dxDrawImage(posX, posY, size, size, "images/hud/speed-needle.png", -122 + 244 * mult, 0, 0, tocolor(255, 255, 255, 175))
		
		
		mult = 1
		dxDrawImage(posX - (size / 2), posY + (size / 2), size / 2, size / 2, "images/hud/fuel-bg.png", 0, 0, 0, tocolor(255, 255, 255, 175))
		dxDrawImage(posX - (size / 2), posY + (size / 2), size / 2, size / 2, "images/hud/fuel-needle.png", -122 + 244 * mult, 0, 0, tocolor(255, 255, 255, 175))
	end
end