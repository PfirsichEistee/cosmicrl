
local gui = {}



local function cwJiggleRock(rock)
	setObjectScale(rock, 1.1)
	
	setTimer(function()
		setObjectScale(rock, 1.05)
		
		setTimer(function()
			setObjectScale(rock, 1)
		end, 50, 1)
	end, 100, 1)
end


local function playerHitRock(loss, attacker)
	if getElementData(getLocalPlayer(), "job") == getJobIdFromName("Bauarbeiter") and getElementModel(source) == 906 and getPedWeapon(getLocalPlayer()) == 6 and not getPedOccupiedVehicle(getLocalPlayer()) then
		cwJiggleRock(source)
		triggerServerEvent("playerHitRock", source)
	end
end
addEventHandler("onClientObjectDamage", getRootElement(), playerHitRock)



function openWindowConstructionWorker()
	if gui["window"] then
		dxgui_ClearKill(gui["window"])
		gui = {}
	end
	
	showCursor(true)
	gui["window"] = dxgui_CreateWindow(0.35, 0.35, 0.3, 0.3, "Bauarbeiter-Job", true)
	
	local prep = dxgui_prep_startColumns(gui["window"], nil, nil, 0.2, 0.8 / 3, 0.8 / 3, 0.8 / 3)
	dxgui_prep_setRows(prep, 0.7, 0.3)
	
	local x, y, w, h = dxgui_prep_getValues(prep, 0, 0, 4, 1)
	dxgui_CreateText(x, y, w, h, "Willkommen... Wir haben heute eine helfende Hand wirklich noetig...\nAlso, wie schaut's aus?", dxgui_FontA, nil, "left", "top", true, true, false, 255, 255, 255, 255, false, gui["window"])
	
	x, y, w, h = dxgui_prep_getValues(prep, 0, 1, 1, 1)
	gui["close"] = dxgui_CreateButton(x, y, w, h, "Schliessen", false, gui["window"])
	
	x, y, w, h = dxgui_prep_getValues(prep, 1, 1, 1, 1)
	gui["job1"] = dxgui_CreateButton(x, y, w, h, "Erz-Gewinnung", false, gui["window"])
	
	x, y, w, h = dxgui_prep_getValues(prep, 2, 1, 1, 1)
	gui["job2"] = dxgui_CreateButton(x, y, w, h, "Transport von\nRohstoffen", false, gui["window"])
	
	
	addEventHandler("onDXGUIClicked", gui["job1"], function()
		dxgui_ClearKill(gui["window"])
		gui = {}
		showCursor(false)
		
		triggerServerEvent("playerStartJob", getLocalPlayer(), 1, 1)
	end)
	
	addEventHandler("onDXGUIClicked", gui["close"], function()
		dxgui_ClearKill(gui["window"])
		gui = {}
		showCursor(false)
	end)
end


--[[local function playerHitRock(key, pressed)
	if pressed and key == "mouse1" and not isCursorShowing() and getPedWeapon(getLocalPlayer()) == 6 and canHit then
		--if getElementData(getLocalPlayer(), "job") ~= getJobIdFromName("Bauarbeiter") then
		--	return
		--end
		
		setTimer(function()
			local task = getPedTask(getLocalPlayer(), "secondary", 0)
			if task == "TASK_SIMPLE_FIGHT" then
				triggerServerEvent("playerHitRock", getLocalPlayer())
				
				canHit = false
				
				setTimer(function()
					canHit = true
				end, 750, 1)
			end
		end, 50, 1)
	end
end
addEventHandler("onClientKey", getRootElement(), playerHitRock)]]



--[[local function test()
	outputChatBox("damege")
end
addEventHandler("onClientObjectDamage", getRootElement(), test)]]