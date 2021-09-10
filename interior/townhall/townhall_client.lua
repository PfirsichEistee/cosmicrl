
local npcmarker = createMarker(362.5751953125, 173.77848815918, 1007.4, "cylinder", 1, 255, 0, 0)
setElementInterior(npcmarker, 3, 362.5751953125, 173.77848815918, 1007.4)


local gui = {}


local function enterNpcMarker(player, matchingDimension)
	if player == getLocalPlayer() and matchingDimension and not getPedOccupiedVehicle(player) then
		if gui["window"] ~= nil then
			dxgui_ClearKill(gui["window"])
			gui = {}
			return
		end
		
		
		
		showCursor(true)
		
		local space = titleHeight * 0.1
		
		gui["window"] = dxgui_CreateWindow((screenX - (screenX * 0.3)) / 2, (screenY - (screenY * 0.4)) / 2, screenX * 0.3, screenY * 0.4, "Rathaus", false)
		
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
		
		
		if localInventoryGetItem(getItemID("Personalausweis")) == 0 then
			dxgui_GridListAddItem(gui["grid"], "Personalausweis", "#33FF33$60")
		else
			dxgui_GridListAddItem(gui["grid"], "Personalausweis", "#FFFFFF[#FF4444x#FFFFFF]")
		end
		
		if localInventoryGetItem(getItemID("Waffenschein (leicht)")) == 0 then
			dxgui_GridListAddItem(gui["grid"], "Waffenschein (leicht)", "#33FF33$6000")
		else
			dxgui_GridListAddItem(gui["grid"], "Waffenschein (leicht)", "#FFFFFF[#FF4444x#FFFFFF]")
		end
		
		if localInventoryGetItem(getItemID("Waffenschein (schwer)")) == 0 then
			dxgui_GridListAddItem(gui["grid"], "Waffenschein (schwer)", "#33FF33$32000")
		else
			dxgui_GridListAddItem(gui["grid"], "Waffenschein (schwer)", "#FFFFFF[#FF4444x#FFFFFF]")
		end
		
		if localInventoryGetItem(getItemID("Angelschein")) == 0 then
			dxgui_GridListAddItem(gui["grid"], "Angelschein", "#33FF33$800")
		else
			dxgui_GridListAddItem(gui["grid"], "Angelschein", "#FFFFFF[#FF4444x#FFFFFF]")
		end
		
		dxgui_GridListAddItem(gui["grid"], "Fahrzeugslots (10x)", "#33FF33$15 Mio.")
		dxgui_GridListAddItem(gui["grid"], "Premium Titel", "#33FF33$5 Mio.")
		dxgui_GridListAddItem(gui["grid"], "Premium Skins", "#33FF33$15 Mio.")
		dxgui_GridListAddItem(gui["grid"], "Premium Fahrzeuge", "#33FF33$20 Mio.")
		dxgui_GridListAddItem(gui["grid"], "Sportmotor Upgrades", "#33FF33$75 Mio.")
		dxgui_GridListAddItem(gui["grid"], "Identitaetsaenderung", "#33FF33$200000")
		
		
		
		addEventHandler("onDXGUIClicked", gui["buy"], function()
			local works = false
			
			local item = dxgui_GridListGetSelected(gui["grid"])
			
			if item then
				if getItemID(item[1]) == nil then -- PLACEHOLDER!!! DELETE LATER!!!
					infomsg("Dieses Item existiert noch nicht", 255, 100, 100)
					return
				end
				
				if localInventoryGetItem(getItemID(item[1])) == 0 then
					works = true
					
					triggerServerEvent("townhallBuy", getLocalPlayer(), item[1])
				else
					infobox("Diesen Schein hast du bereits!", 5, 255, 100, 100)
				end
			end
			
			if works then
				dxgui_ClearKill(gui["window"])
				gui = {}
				showCursor(false)
			end
		end)
		
		
		addEventHandler("onDXGUIClicked", gui["close"], function()
			dxgui_ClearKill(gui["window"])
			gui = {}
			showCursor(false)
		end)
	end
end
addEventHandler("onClientMarkerHit", npcmarker, enterNpcMarker)