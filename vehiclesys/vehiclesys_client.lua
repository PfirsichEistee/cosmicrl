

local gui = {}



local function toggleVehicleEngine()
	if getPedOccupiedVehicle(getLocalPlayer()) and getPedOccupiedVehicleSeat(getLocalPlayer()) == 0 then
		triggerServerEvent("playerToggleEngine", getLocalPlayer())
	end
end
bindKey("x", "down", toggleVehicleEngine)


local function toggleVehicleLight()
	if getPedOccupiedVehicle(getLocalPlayer()) and getPedOccupiedVehicleSeat(getLocalPlayer()) == 0 then
		triggerServerEvent("playerToggleLight", getLocalPlayer())
	end
end
bindKey("l", "down", toggleVehicleLight)


local function vehicleWindowClick()
	if not isElement(gui["veh"]) or getElementHealth(gui["veh"]) == 0 then
		dxgui_ClearKill(gui["window"])
		gui = {}
		showCursor(false)
		return
	end
	
	if source == gui["lock"] then
		if getElementData(gui["veh"], "Owner") == getPlayerName(getLocalPlayer()) then
			if cmath.distElements(getLocalPlayer(), gui["veh"]) <= 6 then
				local phtxt = "Abschliessen"
				if not getElementData(gui["veh"], "Lock") then
					phtxt = "Aufschliessen"
				end
				
				dxgui_SetText(gui["lock"], phtxt)
				
				
				triggerServerEvent("playerToggleLock", getLocalPlayer(), gui["veh"])
			else
				infobox("Du bist zu weit entfernt!", 1.5, 255, 75, 75)
			end
		else
			infobox("Das Fahrzeug gehoert nicht dir!", 1.5, 255, 75, 75)
		end
	elseif source == gui["trunk"] then
		outputChatBox("[!] WIP [!]", 255, 175, 0)
	elseif source == gui["respawn"] then
		if getElementData(gui["veh"], "Owner") == getPlayerName(getLocalPlayer()) then
			if cmath.distElements(getLocalPlayer(), gui["veh"]) <= 6 then
				triggerServerEvent("playerRespawnVehicle", getLocalPlayer(), gui["veh"])
				
				dxgui_ClearKill(gui["window"])
				gui = {}
				showCursor(false)
			else
				infobox("Du bist zu weit entfernt!", 1.5, 255, 75, 75)
			end
		else
			infobox("Das Fahrzeug gehoert nicht dir!", 1.5, 255, 75, 75)
		end
	elseif source == gui["info"] then
		outputChatBox("**Fahrzeug-Informationen**", 255, 175, 0)
		outputChatBox("Besitzer: " .. (getElementData(gui["veh"], "Owner") or "Niemand"), 255, 175, 0)
	elseif source == gui["close"] then
		dxgui_ClearKill(gui["window"])
		gui = {}
		showCursor(false)
	end
end


local function openVehicleWindow(wx, wy, wz, veh)
	if veh and getElementType(veh) == "vehicle" and not gui["window"] and cmath.distElements(getLocalPlayer(), veh) <= 6 then
		gui["veh"] = veh
		
		
		local winW, winH = 0.225 * screenX, 0.225 * screenY
		local space = 0.05 * winH
		local rowH = (winH - titleHeight - space * 4) / 3
		
		gui["window"] = dxgui_CreateWindow((screenX - winW) / 2, (screenY - winH) / 2, winW, winH, getVehicleName(veh), false)
		
		local phtxt = "Abschliessen"
		if getElementData(veh, "Lock") then
			phtxt = "Aufschliessen"
		end
		
		local phW = (winW - space * 3) / 2
		gui["lock"] = dxgui_CreateButton(space, titleHeight + space, phW, rowH, phtxt, false, gui["window"])
		gui["trunk"] = dxgui_CreateButton(phW + space * 2, titleHeight + space, phW, rowH, "Kofferraum", false, gui["window"])
		gui["respawn"] = dxgui_CreateButton(space, titleHeight + rowH + space * 2, phW, rowH, "Respawnen", false, gui["window"])
		gui["info"] = dxgui_CreateButton(phW + space * 2, titleHeight + rowH + space * 2, phW, rowH, "Infos", false, gui["window"])
		
		gui["close"] = dxgui_CreateButton((winW - phW) / 2, titleHeight + rowH * 2 + space * 3, phW, rowH, "Schliessen", false, gui["window"])
		
		
		addEventHandler("onDXGUIClicked", gui["lock"], vehicleWindowClick)
		addEventHandler("onDXGUIClicked", gui["trunk"], vehicleWindowClick)
		addEventHandler("onDXGUIClicked", gui["respawn"], vehicleWindowClick)
		addEventHandler("onDXGUIClicked", gui["info"], vehicleWindowClick)
		addEventHandler("onDXGUIClicked", gui["close"], vehicleWindowClick)
	end
end
addEventHandler("clicksysClicked", getRootElement(), openVehicleWindow)


--[[local function stopVehicleDamage()
	if getElementData(source, "Brake") then
		cancelEvent()
	end
end
addEventHandler("onClientVehicleDamage", getRootElement(), stopVehicleDamage)]]