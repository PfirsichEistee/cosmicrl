
addEvent("playerEnterMechanic", true)


local gui = {}
local ownedUpgrade = {}




local function updateVehColor()
	local r1, g1, b1 = dxgui_SliderGetProgress(gui["cr1"]), dxgui_SliderGetProgress(gui["cg1"]), dxgui_SliderGetProgress(gui["cb1"])
	local r2, g2, b2 = dxgui_SliderGetProgress(gui["cr2"]), dxgui_SliderGetProgress(gui["cg2"]), dxgui_SliderGetProgress(gui["cb2"])
	
	setVehicleColor(gui["veh"], r1 * 255, g1 * 255, b1 * 255, r2 * 255, g2 * 255, b2 * 255)
	
	r1, g1, b1 = dxgui_SliderGetProgress(gui["lr"]), dxgui_SliderGetProgress(gui["lg"]), dxgui_SliderGetProgress(gui["lb"])
	
	setVehicleHeadLightColor(gui["veh"], r1 * 255, g1 * 255, b1 * 255)
	
	
	if cosmicClientGetElementData(getLocalPlayer(), "Money") ~= gui["money"] then
		gui["money"] = cosmicClientGetElementData(getLocalPlayer(), "Money")
		dxgui_SetText(gui["txtmoney"], "#FF6666Geld:\n#66FF66$" .. gui["money"])
	end
end


local function updateVehicleUpgradeList()
	dxgui_GridListClear(gui["grid"])
	for i = 0, 16, 1 do
		local ups = getVehicleCompatibleUpgrades(gui["veh"], i)
		
		if #ups > 0 then
			dxgui_GridListAddItem(gui["grid"], "#FF6666" .. getVehicleUpgradeSlotName(i), "", "")
			
			for a, b in ipairs(ups) do
				-- item[4] == UpgradeID; item[5] == UpgradeSlot
				local own = "[_]"
				for c, d in ipairs(ownedUpgrade) do
					if d == b then
						own = "[x]"
						break
					end
				end
				
				dxgui_GridListAddItem(gui["grid"], "   " .. getTuneName(b), getTunePrice(b), own, b, i)
			end
		end
	end
end


local function mechanicButtonClicked()
	if source == gui["buy"] then
		local item = dxgui_GridListGetSelected(gui["grid"])
		if not item or not item[4] then
			return
		end
		if gui["money"] < getTunePrice(item[4]) then
			infobox("Du hast nicht genug Geld!", 2, 255, 75, 75)
			return
		end
		
		triggerServerEvent("mechanicBuy", getLocalPlayer(), 1, item[4])
		
		ownedUpgrade = getVehicleUpgrades(gui["veh"])
		updateVehicleUpgradeList()
	elseif source == gui["remove"] then
		local item = dxgui_GridListGetSelected(gui["grid"])
		if not item or not item[4] then
			return
		end
		
		triggerServerEvent("mechanicBuy", getLocalPlayer(), 5, item[4])
		
		for a, b in ipairs(ownedUpgrade) do
			if b == item[4] then
				removeVehicleUpgrade(gui["veh"], item[4])
				ownedUpgrade = getVehicleUpgrades(gui["veh"])
				updateVehicleUpgradeList()
				break
			end
		end
	elseif source == gui["clrbuy"] then
		if gui["money"] < 1250 then
			infobox("Du hast nicht genug Geld!", 2, 255, 75, 75)
			return
		end
		
		local r1, g1, b1 = dxgui_SliderGetProgress(gui["cr1"]), dxgui_SliderGetProgress(gui["cg1"]), dxgui_SliderGetProgress(gui["cb1"])
		local r2, g2, b2 = dxgui_SliderGetProgress(gui["cr2"]), dxgui_SliderGetProgress(gui["cg2"]), dxgui_SliderGetProgress(gui["cb2"])
		
		triggerServerEvent("mechanicBuy", getLocalPlayer(), 2, nil, r1 * 255, g1 * 255, b1 * 255, r2 * 255, g2 * 255, b2 * 255)
	elseif source == gui["lightbuy"] then
		if gui["money"] < 350 then
			infobox("Du hast nicht genug Geld!", 2, 255, 75, 75)
			return
		end
		
		local r1, g1, b1 = dxgui_SliderGetProgress(gui["lr"]), dxgui_SliderGetProgress(gui["lg"]), dxgui_SliderGetProgress(gui["lb"])
		
		triggerServerEvent("mechanicBuy", getLocalPlayer(), 3, nil, r1 * 255, g1 * 255, b1 * 255)
	elseif source == gui["buyplate"] then
		if gui["money"] < 100 then
			infobox("Du hast nicht genug Geld!", 2, 255, 75, 75)
			return
		end
		
		local txt = dxgui_GetText(gui["editplate"])
		if string.len(txt) < 1 or string.len(txt) > 8 then
			infobox("Das Nummernschild muss zwischen 1 und 8 Zeichen lang sein!", 2, 255, 75, 75)
			return
		end
		
		triggerServerEvent("mechanicBuy", getLocalPlayer(), 4, txt)
	elseif source == gui["close"] then
		dxguiRemoveMechanicRotator()
		dxgui_ClearKill(gui["window"])
		dxgui_ClearKill(gui["wincolor"])
		dxgui_ClearKill(gui["winlight"])
		dxgui_ClearKill(gui["winplate"])
		gui = {}
		
		removeEventHandler("onClientRender", root, updateVehColor)
		
		triggerServerEvent("mechanicExit", getLocalPlayer())
		
		
		showCursor(false)
		showChat(true)
		setClientHUDVisible(true)
	end
end


local function selectVehicleUpgrade()
	local item = dxgui_GridListGetSelected(gui["grid"])
	
	if item then
		-- Remove all upgraded
		for i = 0, 16, 1 do
			removeVehicleUpgrade(gui["veh"], getVehicleUpgradeOnSlot(gui["veh"], i))
		end
		
		-- Add owned upgrades
		for a, b in ipairs(ownedUpgrade) do
			addVehicleUpgrade(gui["veh"], b)
		end
		
		-- Add selected update
		if item[4] then
			addVehicleUpgrade(gui["veh"], item[4])
		end
	end
end


local function openMechanic()
	if gui["window"] then
		return
	end
	showCursor(true)
	showChat(false)
	setClientHUDVisible(false)
	
	local veh = getPedOccupiedVehicle(getLocalPlayer())
	
	local ph1, ph2, vehZ = getElementBoundingBox(veh)
	local x, y, z = getElementPosition(veh)
	
	setElementPosition(veh, -2051.7358398438, 141.45059204102, 27.8 - vehZ)
	setElementRotation(veh, 0, 0, 60)
	
	setVehicleOverrideLights(veh, 2)
	
	
	-- Update owned upgrades
	ownedUpgrade = getVehicleUpgrades(veh)
	
	
	-- GUI
	gui["veh"] = veh
	gui["angle"] = 60
	dxguiCreateMechanicRotator()
	
	local space = 0.01 * screenY
	local winW, winH = screenX * 0.35, screenY * 0.4
	
	gui["window"] = dxgui_CreateRectangle(space, space, winW, winH, false)
	dxgui_ToFront(gui["window"])
	
	gui["grid"] = dxgui_CreateGridList(space, space, winW * 0.6, winH - space * 2, 15, false, gui["window"])
	dxgui_GridListAddColumn(gui["grid"], "Upgrade", 0.6)
	dxgui_GridListAddColumn(gui["grid"], "Preis", 0.25)
	dxgui_GridListAddColumn(gui["grid"], "", 0.15)
	
	gui["money"] = cosmicClientGetElementData(getLocalPlayer(), "Money")
	gui["txtmoney"] = dxgui_CreateText(winW * 0.6 + space * 2, space, winW * 0.4 - space * 2, dxgui_TextDefaultHeight(dxgui_FontA) * 2, "#FF6666Geld:\n#66FF66$" .. gui["money"], dxgui_FontA, nil, "left", "top", false, false, true, 255, 255, 255, 255, false, gui["window"])
	
	local phY = winH * 0.3
	local rowH = 0.1 * winH
	
	gui["buy"] = dxgui_CreateButton(winW * 0.6 + space * 2, phY, winW * 0.4 - space * 3, rowH, "Kaufen", false, gui["window"])
	gui["remove"] = dxgui_CreateButton(winW * 0.6 + space * 2, phY + rowH + space, winW * 0.4 - space * 3, rowH, "Entfernen", false, gui["window"])
	
	gui["close"] = dxgui_CreateButton(winW * 0.6 + space * 2, winH - rowH - space, winW * 0.4 - space * 3, rowH, "Verlassen", false, gui["window"])
	
	
	
	rowH = rowH * 0.7
	gui["wincolor"] = dxgui_CreateRectangle(space, winH + space * 2, (winW - space) / 2, rowH * 9 + space * 10, false)
	dxgui_ToFront(gui["wincolor"])
	
	dxgui_CreateText(space, space, ((winW - space) / 2) - space * 2, rowH, "Farbe 1", dxgui_FontA, nil, "left", "top", false, false, false, 255, 255, 255, 255, false, gui["wincolor"])
	gui["cr1"] = dxgui_CreateSlider(space, rowH + space * 2, ((winW - space) / 2) - space * 2, rowH, false, gui["wincolor"])
	gui["cg1"] = dxgui_CreateSlider(space, rowH * 2 + space * 3, ((winW - space) / 2) - space * 2, rowH, false, gui["wincolor"])
	gui["cb1"] = dxgui_CreateSlider(space, rowH * 3 + space * 4, ((winW - space) / 2) - space * 2, rowH, false, gui["wincolor"])
	dxgui_CreateText(space, rowH * 4 + space * 5, ((winW - space) / 2) - space * 2, rowH, "Farbe 2", dxgui_FontA, nil, "left", "top", false, false, false, 255, 255, 255, 255, false, gui["wincolor"])
	
	gui["cr2"] = dxgui_CreateSlider(space, rowH * 5 + space * 6, ((winW - space) / 2) - space * 2, rowH, false, gui["wincolor"])
	gui["cg2"] = dxgui_CreateSlider(space, rowH * 6 + space * 7, ((winW - space) / 2) - space * 2, rowH, false, gui["wincolor"])
	gui["cb2"] = dxgui_CreateSlider(space, rowH * 7 + space * 8, ((winW - space) / 2) - space * 2, rowH, false, gui["wincolor"])
	
	local r1, g1, b1, r2, g2, b2 = getVehicleColor(veh, true)
	dxgui_SliderSetProgress(gui["cr1"], r1 / 255)
	dxgui_SliderSetProgress(gui["cg1"], g1 / 255)
	dxgui_SliderSetProgress(gui["cb1"], b1 / 255)
	dxgui_SliderSetProgress(gui["cr2"], r2 / 255)
	dxgui_SliderSetProgress(gui["cg2"], g2 / 255)
	dxgui_SliderSetProgress(gui["cb2"], b2 / 255)
	
	gui["clrbuy"] = dxgui_CreateButton(space, rowH * 8 + space * 9, ((winW - space) / 2) - space * 2, rowH, "Lackieren ($1250)", false, gui["wincolor"])
	
	
	local phW, phH = dxgui_GetSize(gui["wincolor"])
	local phX = ((winW - space) / 2) + space * 2
	phY = winH + space * 2
	
	gui["winlight"] = dxgui_CreateRectangle(phX, phY, phW, phH * 0.6, false)
	dxgui_ToFront(gui["winlight"])
	
	dxgui_CreateText(0.05, 0.05, 0.9, (1 - 0.3) / 5, "Lichtfarbe", dxgui_FontA, nil, "left", "top", false, false, false, 255, 255, 255, 255, true, gui["winlight"])
	gui["lr"] = dxgui_CreateSlider(0.05, 0.1 + ((1 - 0.3) / 5), 0.9, (1 - 0.3) / 5, true, gui["winlight"])
	gui["lg"] = dxgui_CreateSlider(0.05, 0.15 + ((1 - 0.3) / 5) * 2, 0.9, (1 - 0.3) / 5, true, gui["winlight"])
	gui["lb"] = dxgui_CreateSlider(0.05, 0.2 + ((1 - 0.3) / 5) * 3, 0.9, (1 - 0.3) / 5, true, gui["winlight"])
	
	local r1, g1, b1 = getVehicleHeadLightColor(veh)
	dxgui_SliderSetProgress(gui["lr"], r1 / 255)
	dxgui_SliderSetProgress(gui["lg"], g1 / 255)
	dxgui_SliderSetProgress(gui["lb"], b1 / 255)
	
	gui["lightbuy"] = dxgui_CreateButton(0.05, 0.25 + ((1 - 0.3) / 5) * 4, 0.9, (1 - 0.3) / 5, "Kaufen ($350)", true, gui["winlight"])
	
	
	
	gui["winplate"] = dxgui_CreateRectangle(phX, phY + phH * 0.6 + space, phW, phH * 0.4 - space, false)
	dxgui_ToFront(gui["winplate"])
	
	gui["editplate"] = dxgui_CreateEdit(0.05, 0.2, 0.9, 0.3, "Nummernschild", true, gui["winplate"])
	gui["buyplate"] = dxgui_CreateButton(0.05, 0.65, 0.9, 0.3, "Kaufen ($100)", true, gui["winplate"])
	
	
	mechanicCameraRotate(0)
	
	
	updateVehicleUpgradeList()
	
	addEventHandler("onClientRender", root, updateVehColor)
	addEventHandler("onDXGUIClicked", gui["grid"], selectVehicleUpgrade)
	
	addEventHandler("onDXGUIClicked", gui["buy"], mechanicButtonClicked)
	addEventHandler("onDXGUIClicked", gui["remove"], mechanicButtonClicked)
	addEventHandler("onDXGUIClicked", gui["clrbuy"], mechanicButtonClicked)
	addEventHandler("onDXGUIClicked", gui["lightbuy"], mechanicButtonClicked)
	addEventHandler("onDXGUIClicked", gui["buyplate"], mechanicButtonClicked)
	addEventHandler("onDXGUIClicked", gui["close"], mechanicButtonClicked)
end
addEventHandler("playerEnterMechanic", getRootElement(), openMechanic)


function mechanicCameraRotate(v)
	local x, y, z = -2051.7358398438, 141.45059204102, 27.8
	gui["angle"] = gui["angle"] + v * 0.15
	local ax, ay = math.sin(gui["angle"]), math.cos(gui["angle"])
	
	
	--setCameraMatrix(x - 10 * ax, y - 10 * ay, z + 6, x, y, z)
	setCameraMatrix(x - 7.1, y - 7.1, z + 6, x - 1.5, y + 1.5, z)
	
	setElementRotation(gui["veh"], 0, 0, gui["angle"])
end