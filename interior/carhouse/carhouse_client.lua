
addEvent("playerEnterCarhouse", true)


local carhouse = {
	-- {VEHICLE ID, VEH X, VEH Y, VEH Z, CAM X, CAM Y, CAM Z, }
	[1] = {
		{401, 2133, -1128.6, 25.5, 2126, -1136.2, 28},
		{600, 2135.2, -1136, 25.5, 2126, -1136.2, 28},
		{422, 2134.1, -1143.6, 24.7, 2126, -1136.2, 28},
		{508, 2121.6, -1142.1, 25.3, 2130, -1136.2, 28},
		{400, 2121.5, -1131.6, 25.5, 2130, -1136.2, 28},
	}
}



local cam = {
	position = Vector3(0, 0, 0),
	target = Vector3(0, 0, 0),
	houseID = 0,
	index = 0,
}




local function render()
	-- Move target
	cam.target.x, cam.target.y, cam.target.z = cmath.lerp3D(cam.target.x, cam.target.y, cam.target.z, carhouse[cam.houseID][cam.index][2], carhouse[cam.houseID][cam.index][3], carhouse[cam.houseID][cam.index][4], delta * 10)
	
	-- Move position
	cam.position.x, cam.position.y, cam.position.z = cmath.lerp3D(cam.position.x, cam.position.y, cam.position.z, carhouse[cam.houseID][cam.index][5], carhouse[cam.houseID][cam.index][6], carhouse[cam.houseID][cam.index][7], delta * 10)
	
	
	setCameraMatrix(cam.position.x, cam.position.y, cam.position.z, cam.target.x, cam.target.y, cam.target.z)
	
	
	-- Draw text
	
	dxDrawText(getVehicleNameFromModel(carhouse[cam.houseID][cam.index][1]), screenX * 0.01, screenY * 0.75, screenX, screenY, tocolor(255, 175, 0, 255), (1 / dxGetFontHeight(1, "pricedown")) * 0.1 * screenY, "pricedown", "left", "top", false, false, false, false)
	dxDrawText("$" .. vehicleprice[carhouse[cam.houseID][cam.index][1]], screenX * 0.01, screenY * 0.85, screenX, screenY, tocolor(0, 255, 0, 255), (1 / dxGetFontHeight(1, "pricedown")) * 0.075 * screenY, "pricedown", "left", "top", false, false, false, false)
	
	dxDrawText("[EINGABE] Kaufen\n[LEERTASTE] Verlassen", 0, screenY * 0.75, screenX, screenY, tocolor(255, 255, 255, 255), (1 / dxGetFontHeight(1, "pricedown")) * 0.075 * screenY, "pricedown", "center", "center", false, false, false, false)
end

local function changeVehicle(button, pressed)
	if pressed then
		if button == "a" or button == "arrow_l" then
			cam.index = cam.index - 1
			if cam.index < 1 then
				cam.index = #carhouse[cam.houseID]
			end
		elseif button == "d" or button == "arrow_r" then
			cam.index = cam.index + 1
			if cam.index > #carhouse[cam.houseID] then
				cam.index = 1
			end
		elseif button == "enter" or button == "space" then
			if button == "enter" then
				local vehID = carhouse[cam.houseID][cam.index][1]
				
				if cosmicClientGetElementData(getLocalPlayer(), "Money") >= vehicleprice[vehID] then
					triggerServerEvent("playerCarhouseLeave", getLocalPlayer(), "buy", vehID)
				else
					infobox("Du hast nicht genug Geld!", 2, 255, 75, 75)
				end
			else
				triggerServerEvent("playerCarhouseLeave", getLocalPlayer(), "exit", nil)
			end
			
			removeEventHandler("onClientKey", getRootElement(), changeVehicle)
			removeEventHandler("onClientRender", root, render)
			showChat(true)
			setClientHUDVisible(true)
		end
	end
end


local function playerEnterCarhouse(id)
	showChat(false)
	setClientHUDVisible(false)
	
	
	cam.position = Vector3(carhouse[id][1][5], carhouse[id][1][6], carhouse[id][1][7])
	cam.target = Vector3(carhouse[id][1][2], carhouse[id][1][3], carhouse[id][1][4])
	cam.houseID = id
	cam.index = 1
	
	setCameraMatrix(cam.position.x, cam.position.y, cam.position.z, cam.target.x, cam.target.y, cam.target.z)
	addEventHandler("onClientKey", getRootElement(), changeVehicle)
	addEventHandler("onClientRender", root, render)
end
addEventHandler("playerEnterCarhouse", getRootElement(), playerEnterCarhouse)