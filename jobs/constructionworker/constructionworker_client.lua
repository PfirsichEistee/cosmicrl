
addEvent("cwCreateRockAnim", true)

local gui = {}



local function cwCreateRockAnim(machineNr)
	if machineNr == 1 then -- left
		local obj = createObject(3930, 676.90002441406, 827, -30)
		
		setElementCollisionsEnabled(obj, false)
		
		moveObjectOnTrail(obj, 40, Vector3(676.90002441406, 827, -41), Vector3(674.5, 828.29998779297, -40.599998474121), Vector3(641.40002441406, 843.70001220703, -34.099998474121), Vector3(641.40002441406, 843.70001220703, -37.6), Vector3(603.5, 830.20001220703, -30.10000038147), Vector3(602.62249755859, 829.58831787109, -39))
		
		setTimer(function(obj)
			destroyElement(obj)
		end, 40000, 1, obj)
	else -- right
		local obj = createObject(3930, 688.59997558594, 846.90002441406, -30)
		
		setElementCollisionsEnabled(obj, false)
		
		moveObjectOnTrail(obj, 40, Vector3(688.59997558594, 846.90002441406, -41), Vector3(685.29998779297, 848.40002441406, -40.5), Vector3(654.09997558594, 866.40002441406, -34.099998474121), Vector3(654.09997558594, 866.9, -37.5), Vector3(619.90002441406, 886.5, -30.1), Vector3(619.29998779297, 886.70001220703, -34.200000762939))
		
		setTimer(function(obj)
			local pt = 20
			
			if math.random() >= 0.5 then
				pt = 40
				
				setElementPosition(obj, 618.70001220703, 894.29998779297, -41.099998474121)
				
				moveObjectOnTrail(obj, pt, Vector3(584.59997558594, 914, -34.099998474121), Vector3(583.90002441406, 914, -37), Vector3(545.20001220703, 919.79998779297, -30), Vector3(545.20001220703, 919.79998779297, -37))
			else
				setElementPosition(obj, 620.29998779297, 896.5, -41.099998474121)
				
				moveObjectOnTrail(obj, pt, Vector3(595, 926.59997558594, -34.099998474121), Vector3(595, 926.59997558594, -39))
			end
			
			
			setTimer(function(obj)
				destroyElement(obj)
			end, pt * 1000, 1, obj)
		end, 40000, 1, obj)
	end
end
addEventHandler("cwCreateRockAnim", getRootElement(), cwCreateRockAnim)


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
	if getElementData(getLocalPlayer(), "Job") == getJobIdFromName("Bauarbeiter") and getElementModel(source) == 906 and getPedWeapon(getLocalPlayer()) == 6 and not getPedOccupiedVehicle(getLocalPlayer()) then
		cwJiggleRock(source)
		triggerServerEvent("playerHitRock", source)
	end
end
addEventHandler("onClientObjectDamage", getRootElement(), playerHitRock)




local function openInfoErzGewinnung()
	gui["infotxt"] = dxgui_CreateText(0, 0, screenX, screenY, "Die Arbeit ist ganz einfach:\nHau bloss mit deiner\nSchaufel auf die Felsen und\nsammel die Steine ein", dxgui_FontA, nil, "center", "top", false, true, false, 255, 255, 255, 255, false, nil)
	dxgui_TextSetFontHeight(gui["infotxt"], titleHeight * 2)
	dxgui_TextSetBorder(gui["infotxt"], true)
	setCameraMatrix(656.84753417969, 886.74584960938, -29.419862747192, 683.85852050781, 897.75732421875, -39.774768829346)
	
	setTimer(function()
		dxgui_SetText(gui["infotxt"], "Die Steine wirfst du\nspaeter in diese Filter")
		setCameraMatrix(679.13067626953, 868.98071289063, -15.419861793518, 692.85211181641, 844.72613525391, -26.700248718262)
	end, 7500, 1)
	
	setTimer(function()
		dxgui_Kill(gui["infotxt"])
		setCameraTarget(getLocalPlayer())
		toggleAllControls(true)
	end, 15000, 1)
end


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
	gui["job2"] = dxgui_CreateButton(x, y, w, h, "Transport von\nZement", false, gui["window"])
	
	x, y, w, h = dxgui_prep_getValues(prep, 3, 1, 1, 1)
	gui["job3"] = dxgui_CreateButton(x, y, w, h, "Transport von\nRohstoffen", false, gui["window"])
	
	
	addEventHandler("onDXGUIClicked", gui["job1"], function()
		dxgui_ClearKill(gui["window"])
		gui = {}
		showCursor(false)
		
		triggerServerEvent("playerStartJob", getLocalPlayer(), 1, 1)
	end)
	addEventHandler("onDXGUIClicked", gui["job2"], function()
		dxgui_ClearKill(gui["window"])
		gui = {}
		showCursor(false)
		
		triggerServerEvent("playerStartJob", getLocalPlayer(), 1, 2)
	end)
	addEventHandler("onDXGUIClicked", gui["job3"], function()
		dxgui_ClearKill(gui["window"])
		gui = {}
		showCursor(false)
		
		triggerServerEvent("playerStartJob", getLocalPlayer(), 1, 3)
	end)
	
	addEventHandler("onDXGUIClicked", gui["close"], function()
		dxgui_ClearKill(gui["window"])
		gui = {}
		showCursor(false)
	end)
end


local function jobStartInfo(jobID, extra)
	if jobID == 1 then
		if extra == 1 then
			toggleAllControls(false)
			openInfoErzGewinnung()
		end
	end
end
addEventHandler("onClientJobStart", getRootElement(), jobStartInfo)


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