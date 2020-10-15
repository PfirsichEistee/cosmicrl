
addEvent("atmClientGetReceipt", true)


local gui = {}

local atmHistroy = {}



local function atmUpdateGridList()
	dxgui_GridListClear(gui["grid"])
	
	atmHistroy = getClientTable("atm")
	
	
	for i = #atmHistroy, 1, -3 do
		dxgui_GridListAddItem(gui["grid"], atmHistroy[i - 2], atmHistroy[i - 1], atmHistroy[i])
	end
end


local function closeATM()
	dxgui_ClearKill(gui["window"])
	
	gui = {}
	
	showCursor(false)
end


local function atmClickButton()
	if not gui["atm"] or gui["atm"] and cmath.distElements(getLocalPlayer(), gui["atm"]) > 6 then
		closeATM()
		return
	end
	
	if source == gui["aus"] then
		if tonumber(dxgui_GetText(gui["easumme"])) and tonumber(dxgui_GetText(gui["easumme"])) > 0 then
			triggerServerEvent("atmPlayerOperation", getLocalPlayer(), 1, tonumber(dxgui_GetText(gui["easumme"])))
			
			return
		end
	elseif source == gui["ein"] then
		if tonumber(dxgui_GetText(gui["easumme"])) and tonumber(dxgui_GetText(gui["easumme"])) > 0 then
			triggerServerEvent("atmPlayerOperation", getLocalPlayer(), 2, tonumber(dxgui_GetText(gui["easumme"])))
			
			return
		end
	elseif source == gui["ueb_4_okay"] then
		if tonumber(dxgui_GetText(gui["ueb_2_summe"])) and tonumber(dxgui_GetText(gui["ueb_2_summe"])) > 0 then
			triggerServerEvent("atmPlayerOperation", getLocalPlayer(), 3, tonumber(dxgui_GetText(gui["ueb_2_summe"])), dxgui_GetText(gui["ueb_1_empfaenger"]), dxgui_GetText(gui["ueb_3_grund"]))
			
			return
		end
	elseif source == gui["close"] then
		closeATM()
		return
	end
	
	
	infobox("Ueberpruefe deine Angaben!", 3, 255, 75, 75)
end


local function openATM(wx, wy, wz, element)
	if element and getElementModel(element) == 2942 and cmath.distElements(getLocalPlayer(), element) <= 6 and not gui["window"] then
		showCursor(true)
		
		gui["window"] = dxgui_CreateWindow((1 - 0.3) / 2, (1 - 0.3) / 2, 0.25, 0.35, "Geldautomat", true)
		gui["atm"] = element
		
		
		local winY = 0.3 * screenY
		local winW, winH = 0.25 * screenX, 0.05 * screenY
		local space = 0.05 * winH
		
		gui["close"] = dxgui_CreateButton(winW - 0.4 * winW - space, winY + space, 0.4 * winW, winH - space * 2, "Schliessen", false, gui["window"])
		
		
		winY = titleHeight * 0.75
		winW, winH = dxgui_GetSize(gui["window"])
		winH = 0.3 * screenY
		
		gui["tabs"] = dxgui_CreateTabs(0, titleHeight, winW, (0.3 * screenY) - titleHeight, "Ein-/Auszahlung", false, gui["window"])
		dxgui_TabsAddTab(gui["tabs"], "Ueberweisung")
		dxgui_TabsAddTab(gui["tabs"], "Kontoauszug")
		
		winH = winH - titleHeight * 1.75
		
		
		local rowH = winH / 5
		space = rowH * 0.1
		
		gui["easumme"] = dxgui_CreateEdit(rowH, winY + rowH, winW - rowH * 2, rowH, "Summe", false, gui["tabs"])
		dxgui_EditSetOnlyNumbers(gui["easumme"], true)
		
		gui["aus"] = dxgui_CreateButton(space, winY + winH - rowH - space, (winW - space * 3) / 2, rowH, "Auszahlen", false, gui["tabs"])
		gui["ein"] = dxgui_CreateButton(((winW - space * 3) / 2) + space * 2, winY + winH - rowH - space, (winW - space * 3) / 2, rowH, "Einzahlen", false, gui["tabs"])
		
		
		
		dxgui_TabsSetTab(gui["tabs"], 2)
		
		gui["ueb_1_empfaenger"] = dxgui_CreateEdit(0, 0, winW - space * 2, rowH, "Empfaenger", false, gui["tabs"])
		gui["ueb_2_summe"] = dxgui_CreateEdit(0, 0, winW - space * 2, rowH, "Summe", false, gui["tabs"])
		dxgui_EditSetOnlyNumbers(gui["ueb_2_summe"], true)
		
		gui["ueb_3_grund"] = dxgui_CreateEdit(0, 0, winW - space * 2, rowH, "Grund", false, gui["tabs"])
		gui["ueb_4_okay"] = dxgui_CreateButton(0, 0, winW - space * 2, rowH, "Ueberweisen", false, gui["tabs"])
		
		for a, b in pairs(gui) do
			if string.sub(a, 1, 4) == "ueb_" then
				local index = tonumber(string.sub(a, 5, 5))
				
				dxgui_SetPosition(b, space, winY + ((winH - rowH * 4) / 5) * index + rowH * (index - 1))
			end
		end
		
		
		
		dxgui_TabsSetTab(gui["tabs"], 3)
		
		gui["grid"] = dxgui_CreateGridList(space, winY + space, winW - space * 2, winH * 0.85 - space, 7, false, gui["tabs"])
		dxgui_GridListAddColumn(gui["grid"], "Datum", 0.3)
		dxgui_GridListAddColumn(gui["grid"], "Grund", 0.35)
		dxgui_GridListAddColumn(gui["grid"], "Summe", 0.35)
		
		atmUpdateGridList()
		
		
		gui["money"] = dxgui_CreateText(space, winY + (winH * 0.85), winW - space * 2, winH * 0.15, "Kontostand: #66FF66$" .. cosmicClientGetElementData(getLocalPlayer(), "Bankmoney"), dxgui_FontA, nil, "left", "center", false, false, true, 255, 255, 255, 255, false, gui["tabs"])
		
		
		dxgui_TabsSetTab(gui["tabs"], 1)
		
		
		addEventHandler("onDXGUIClicked", gui["aus"], atmClickButton)
		addEventHandler("onDXGUIClicked", gui["ein"], atmClickButton)
		addEventHandler("onDXGUIClicked", gui["ueb_4_okay"], atmClickButton)
		addEventHandler("onDXGUIClicked", gui["close"], atmClickButton)
	end
end
addEventHandler("clicksysClicked", getRootElement(), openATM)


local function atmClientGetReceipt(money, reason)
	if money > 0 then
		money = "#66FF66+ $" .. money
	else
		money = "#FF6666- $" .. -money
	end
	
	
	table.insert(atmHistroy, getCurrentDate())
	table.insert(atmHistroy, reason)
	table.insert(atmHistroy, money)
	
	
	while #atmHistroy > (20 * 3) do
		table.remove(atmHistroy, 1)
		table.remove(atmHistroy, 1)
		table.remove(atmHistroy, 1)
	end
	
	
	setClientTable("atm", atmHistroy)
	
	
	if gui["window"] then
		dxgui_SetText(gui["money"], "Kontostand: #66FF66$" .. cosmicClientGetElementData(getLocalPlayer(), "Bankmoney"))
		
		atmUpdateGridList()
	end
end
addEventHandler("atmClientGetReceipt", getRootElement(), atmClientGetReceipt)