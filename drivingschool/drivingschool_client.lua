
addEvent("drivingSchoolStart", true)


local npcmarker = createMarker(-2032.9505615234, -117.43309783936, 1034.35, "cylinder", 1, 255, 0, 0)
setElementInterior(npcmarker, 3, -2032.9505615234, -117.43309783936, 1034.35)


local gui = {}


local exam = {
	[1] = {
		img = "images/drivingschool/test1.jpg",
		question = "Duerfen Sie auf dieser Autobahn den schwarzen Pkw rechts ueberholen?",
		answer = {
			[1] = "Ja, weil zum Ueberholen ausreichend Platz ist",
			[2] = "Nein, weil auf dem linken Fahrstreifen keine Fahrzeugschlange ist",
			[3] = "Ja, weil Sie dabei nicht schneller als 80 km/h fahren",
		},
		solution = {2},
	},
	[2] = {
		img = "images/drivingschool/test2.jpg",
		question = "Welches Verhalten ist richtig?",
		answer = {
			[1] = "Ich muss den blauen Lkw durchfahren lassen",
			[2] = "Ich muss den Traktor abbiegen lassen",
			[3] = "Der blaue Lkw muss mich durchfahren lassen",
		},
		solution = {1, 2},
	},
	[3] = {
		img = "images/drivingschool/test3.jpg",
		question = "Sie moechten ueberholen. Welches Verhalten ist hier richtig?",
		answer = {
			[1] = "Ich ueberhole nicht, da das gelbe Fahrzeug ueberholen koennte",
			[2] = "Ich ueberhole, da kein Gegenverkehr zu erkennen ist",
			[3] = "Ich ueberhole nicht, da Gegenverkehr auftauchen koennte",
		},
		solution = {1, 3},
	},
	[4] = {
		img = "images/drivingschool/test4.jpg",
		question = "Welche Fahrzeuge duerfen Sie bei diesem Verkehrszeichen ueberholen?",
		answer = {
			[1] = "Motorrad ohne Beiwagen",
			[2] = "Motorrad mit Beiwagen",
			[3] = "Pkw",
		},
		solution = {1},
	},
	[5] = {
		img = "images/drivingschool/test5.jpg",
		question = "Welche Bedeutung haben diese Zeichen fuer Sie?",
		answer = {
			[1] = "Der Verkehr auf den beiden rechten Fahrstreifen ist freigegeben",
			[2] = "Die beiden linken Fahrstreifen darf ich nur zum Ueberholen benutzen",
			[3] = "Die beiden linken Fahrstreifen darf ich nicht benutzen",
		},
		solution = {1, 3},
	},
	[6] = {
		img = "images/drivingschool/test6.jpg",
		question = "Welches Verhalten ist richtig?",
		answer = {
			[1] = "Ich muss den roten Pkw vorlassen",
			[2] = "Ich darf als Erster fahren",
			[3] = "Ich muss die Strassenbahn vorlassen",
		},
		solution = {2},
	},
}


local function enterNpcMarker(player, matchingDimension)
	if player == getLocalPlayer() and matchingDimension and not getPedOccupiedVehicle(player) then
		if gui["window"] ~= nil then
			dxgui_ClearKill(gui["window"])
			gui = {}
			return
		end
		
		
		
		showCursor(true)
		
		local space = titleHeight * 0.1
		
		gui["window"] = dxgui_CreateWindow((screenX - (screenX * 0.3)) / 2, (screenY - (screenY * 0.4)) / 2, screenX * 0.3, screenY * 0.4, "Fahrschule", false)
		
		gui["infotxt"] = dxgui_CreateText(space, titleHeight + space, screenX * 0.3 - space * 2, screenY * 0.4 - space * 3 - titleHeight * 2, "Willkommen in der " .. _servername .. "-Fahrschule!\nWir verhelfen dir hier zu einem schnellen und sicheren Bestehen der Prüfung. Wir legen daher sehr viel Wert auf die Qualität unseres Unterrichts!\nWomit kann ich dir heute helfen?", dxgui_FontA, nil, "left", "top", true, true, false, 255, 255, 255, 255, false, gui["window"])
		dxgui_TextSetBorder(gui["infotxt"], true)
		
		gui["next"] = dxgui_CreateButton(screenX * 0.2, screenY * 0.4 - titleHeight - space, screenX * 0.1 - space, titleHeight, "Weiter", false, gui["window"])
		
		
		addEventHandler("onDXGUIClicked", gui["next"], function()
			dxgui_Kill(gui["infotxt"])
			dxgui_Kill(gui["next"])
			
			local prep = dxgui_prep_startColumns(gui["window"], space, titleHeight, 0.7, 0.3)
			dxgui_prep_setRows(prep, 1 / 6, 1 / 6, 1 / 6, 1 / 6, 1 / 6, 1 / 6)
			
			local px, py, pw, ph = dxgui_prep_getValues(prep, 0, 0, 1, 6)
			
			
			gui["grid"] = dxgui_CreateGridList(px, py, pw, ph, 15, false, gui["window"])
			dxgui_GridListAddColumn(gui["grid"], "Schein", 0.65)
			dxgui_GridListAddColumn(gui["grid"], "Preis", 0.35)
			
			
			px, py, pw, ph = dxgui_prep_getValues(prep, 1, 0, 1, 1)
			
			gui["buy"] = dxgui_CreateButton(px, py, pw, ph, "Kaufen", false, gui["window"])
			
			
			px, py, pw, ph = dxgui_prep_getValues(prep, 1, 5, 1, 1)
			
			gui["close"] = dxgui_CreateButton(px, py, pw, ph, "Schliessen", false, gui["window"])
			
			
			addEventHandler("onDXGUIClicked", gui["close"], function()
				dxgui_ClearKill(gui["window"])
				gui = {}
				showCursor(false)
			end)
			
			
			-- only show unobtained licenses!
			--if cosmicClientGetElementData(getLocalPlayer(), "PKW-Schein") ~= 1 then
			if localInventoryGetItem(getItemID("PKW Schein")) == 0 then
				dxgui_GridListAddItem(gui["grid"], "PKW Schein", "#33FF33$2150")
			end
			if localInventoryGetItem(getItemID("Motorrad Schein")) == 0 then
				dxgui_GridListAddItem(gui["grid"], "Motorrad Schein", "#33FF33$1600")
			end
			if localInventoryGetItem(getItemID("LKW Schein")) == 0 then
				dxgui_GridListAddItem(gui["grid"], "LKW Schein", "#33FF33$4500")
			end
			if localInventoryGetItem(getItemID("Flugzeug Schein")) == 0 then
				dxgui_GridListAddItem(gui["grid"], "Flugzeug Schein", "#33FF33$12000")
			end
			if localInventoryGetItem(getItemID("Helikopter Schein")) == 0 then
				dxgui_GridListAddItem(gui["grid"], "Helikopter Schein", "#33FF33$10500")
			end
			
			
			addEventHandler("onDXGUIClicked", gui["buy"], function()
				local item = dxgui_GridListGetSelected(gui["grid"])
				
				if item then
					triggerServerEvent("drivingSchoolBuy", getLocalPlayer(), item[1])
					dxgui_ClearKill(gui["window"])
					gui = {}
					showCursor(false)
				end
			end)
		end)
	end
end
addEventHandler("onClientMarkerHit", npcmarker, enterNpcMarker)


local function theoryLoadQuestion(nr, guiPrep)
	if gui["img"] ~= nil then
		dxgui_Kill(gui["img"])
		dxgui_Kill(gui["q"])
		dxgui_Kill(gui["q1"])
		dxgui_Kill(gui["q2"])
		dxgui_Kill(gui["q3"])
	end
	
	px, py, pw, ph = dxgui_prep_getValues(guiPrep, 0, 0, 3, 1)
	local pw = (630 / 378) * ph
	gui["img"] = dxgui_CreateImage((screenX * 0.5 - pw) / 2, py, pw, ph, exam[nr].img, false, gui["window"])
	
	px, py, pw, ph = dxgui_prep_getValues(guiPrep, 0, 1, 3, 1)
	gui["q"] = dxgui_CreateText(px, py, pw, ph, exam[nr].question, dxgui_FontA, nil, "center", "center", true, true, false, 255, 255, 255, 255, false, gui["window"])
	dxgui_TextSetBorder(gui["q"], true)
	
	px, py, pw, ph = dxgui_prep_getValues(guiPrep, 0, 2, 3, 1)
	gui["q1"] = dxgui_CreateCheckBox(px + ph, py + ph / 4, pw - ph, ph / 2, exam[nr].answer[1], false, gui["window"])
	
	px, py, pw, ph = dxgui_prep_getValues(guiPrep, 0, 3, 3, 1)
	gui["q2"] = dxgui_CreateCheckBox(px + ph, py + ph / 4, pw - ph, ph / 2, exam[nr].answer[2], false, gui["window"])
	
	px, py, pw, ph = dxgui_prep_getValues(guiPrep, 0, 4, 3, 1)
	gui["q3"] = dxgui_CreateCheckBox(px + ph, py + ph / 4, pw - ph, ph / 2, exam[nr].answer[3], false, gui["window"])
end


local function startTheoryExam()
	if gui["window"] ~= nil then
		dxgui_ClearKill(gui["window"])
		gui = {}
	end
	showCursor(true)
	
	gui["window"] = dxgui_CreateWindow((screenX - (screenX * 0.5)) / 2, (screenY - (screenY * 0.7)) / 2, screenX * 0.5, screenY * 0.7, "Theoretische Prüfung", false)
	gui["step"] = 1
	
	gui["answer"] = {}
	
	local space = titleHeight * 0.1
	local prep = dxgui_prep_startColumns(gui["window"], space, titleHeight, 0.3333, 0.3333, 0.3333)
	dxgui_prep_setRows(prep, 0.5, 0.1, 0.1, 0.1, 0.1, 0.1)
	
	
	px, py, pw, ph = dxgui_prep_getValues(prep, 2, 5, 1, 1)
	gui["conf"] = dxgui_CreateButton(px, py, pw, ph, "Weiter", false, gui["window"])
	
	
	theoryLoadQuestion(1, prep)
	
	addEventHandler("onDXGUIClicked", gui["conf"], function()
		local new = {}
		if dxgui_CheckBoxGetState(gui["q1"]) then table.insert(new, 1) end
		if dxgui_CheckBoxGetState(gui["q2"]) then table.insert(new, 2) end
		if dxgui_CheckBoxGetState(gui["q3"]) then table.insert(new, 3) end
		table.insert(gui["answer"], new)
		
		
		gui["step"] = gui["step"] + 1
		
		if exam[gui["step"]] then
			theoryLoadQuestion(gui["step"], prep)
		else
			local pass = true
			
			for i = 1, #exam, 1 do
				if #exam[i].solution == #gui["answer"][i] then
					for a, b in ipairs(exam[i].solution) do
						local found = false
						for c, d in ipairs(gui["answer"][i]) do
							if b == d then
								found = true
								break
							end
						end
						
						if not found then
							pass = false
							break
						end
					end
				else
					pass = false
					break
				end
			end
			
			
			triggerServerEvent("drivingSchoolFinish", getLocalPlayer(), "PKW Schein", "theory", pass)
			
			dxgui_ClearKill(gui["window"])
			gui = {}
			showCursor(false)
		end
	end)
end
addEventHandler("drivingSchoolStart", getRootElement(), startTheoryExam)