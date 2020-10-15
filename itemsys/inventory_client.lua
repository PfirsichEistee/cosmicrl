
addEvent("clientSyncInventory", true)


local localInventory = {}


local gui = {}


local function closeInventory()
	-- Save layout
	local itemLayout = {}
	local inv = dxgui_GetElementTable(gui["inv"]).item
	
	for x = 1, 14, 1 do
		for y = 1, 7, 1 do
			if inv[x][y].id ~= 0 then
				table.insert(itemLayout, inv[x][y].id .. "|" .. x .. "|" .. y)
			end
		end
	end
	
	setClientTable("Inventory", itemLayout)
	
	
	-- Close window
	dxgui_ClearKill(gui["window"])
	
	gui = {}
	
	showCursor(false)
end


local function invClick()
	if source == gui["use"] then
		
	elseif source == gui["drop"] then
		
	elseif source == gui["trash"] then
		
	end
end



local function openInventory()
	if gui["window"] then
		closeInventory()
		return
	end
	showCursor(true)
	
	local space = 0.005 * screenY
	
	local winW = 0.4 * screenX
	local winH = (winW / 2) + titleHeight * 2 + space * 2
	
	gui["window"] = dxgui_CreateWindow((screenX - winW) / 2, (screenY - winH) / 2, winW, winH, "Inventar", false)
	
	gui["inv"] = dxgui_CreateInventory(0, titleHeight, winW, winH - titleHeight * 2 - space * 2, 14, 7, false, gui["window"])
	
	
	local btnW = winW / 5
	
	gui["use"] = dxgui_CreateButton(winW - btnW - space, winH - titleHeight - space, btnW, titleHeight, "Benutzen", false, gui["window"])
	gui["drop"] = dxgui_CreateButton(winW - btnW * 2 - space * 2, winH - titleHeight - space, btnW, titleHeight, "Ablegen", false, gui["window"])
	gui["trash"] = dxgui_CreateButton(winW - btnW * 3 - space * 3, winH - titleHeight - space, btnW, titleHeight, "Wegwerfen", false, gui["window"])
	
	gui["close"] = dxgui_CreateButton(space, winH - titleHeight - space, btnW, titleHeight, "Schliessen", false, gui["window"])
	
	
	addEventHandler("onDXGUIClicked", gui["close"], closeInventory)
	
	
	-- Read saved layout and add items
	local itemLayout = getClientTable("Inventory") -- [1] = "ID|COLUMN|ROW"
	
	local usedIds = {}
	local inv = dxgui_GetElementTable(gui["inv"]).item
	
	for i = #itemLayout, 1, -1 do
		local id, col, row = tonumber(gettok(itemLayout[i], 1, "|")), tonumber(gettok(itemLayout[i], 2, "|")), tonumber(gettok(itemLayout[i], 3, "|"))
		
		if id and col and row and inv[col] and inv[col][row] and inv[col][row].id == 0 then
			for a, b in ipairs(localInventory) do
				if b.id == id then
					inv[col][row].id = id
					inv[col][row].amount = b.amount
					inv[col][row].image = getItemImage(id)
					
					table.insert(usedIds, id)
					
					break
				end
			end
		end
	end
	
	if #usedIds < #localInventory then
		for a, b in ipairs(localInventory) do
			local found = false
			for c, d in ipairs(usedIds) do
				if d == b.id then
					found = true
					break
				end
			end
			
			if not found then
				local stop = false
				for y = 1, 7, 1 do
					for x = 1, 14, 1 do
						if inv[x][y].id == 0 then
							inv[x][y].id = b.id
							inv[x][y].amount = b.amount
							inv[x][y].image = getItemImage(b.id)
							
							stop = true
							
							break
						end
					end
					if stop then
						break
					end
				end
			end
		end
	end
end
bindKey("i", "down", openInventory)


local function updateOpenedWindow(id, amount)
	if gui["window"] then
		local found
		if amount > 0 then
			found = dxgui_InventoryFindAndSet(gui["inv"], id, id, amount, true)
		else
			found = dxgui_InventoryFindAndSet(gui["inv"], id, 0, 0, nil)
		end
		
		if not found and amount > 0 then
			dxgui_InventoryAddItem(gui["inv"], id, amount, getItemImage(id))
		end
	end
end

local function itemOutput(id, deltaAmount)
	if deltaAmount > 0 then
		outputChatBox("[Inventar] + " .. deltaAmount .. "x " .. getItemName(id), 125, 255, 125)
	else
		outputChatBox("[Inventar] - " .. -deltaAmount .. "x " .. getItemName(id), 255, 125, 125)
	end
end

local function clientSyncInventory(item, reset)
	if reset then
		if gui["window"] then
			closeInventory()
		end
		
		localInventory = item
		return
	end
	
	if not item[1] then -- single item
		updateOpenedWindow(item.id, item.amount)
		if item.amount == 0 then
			for a, b in ipairs(localInventory) do
				if b.id == item.id then
					itemOutput(b.id, item.amount - b.amount)
					table.remove(localInventory, a)
					return
				end
			end
		end
		
		
		local found = false
		for a, b in ipairs(localInventory) do
			if b.id == item.id then
				itemOutput(b.id, item.amount - b.amount)
				b.amount = item.amount
				found = true
				break
			end
		end
		
		if not found then
			itemOutput(item.id, item.amount)
			table.insert(localInventory, item)
		end
	else -- multiple items
		for a, b in ipairs(item) do
			updateOpenedWindow(b.id, b.amount)
			if b.amount == 0 then
				for c, d in ipairs(localInventory) do
					if d.id == b.id then
						itemOutput(b.id, b.amount - d.amount)
						table.remove(localInventory, c)
						break
					end
				end
			else
				local found = false
				
				for c, d in ipairs(localInventory) do
					if d.id == b.id then
						itemOutput(b.id, b.amount - d.amount)
						d.amount = b.amount
						found = true
						break
					end
				end
				
				if not found then
					itemOutput(b.id, b.amount)
					table.insert(localInventory, b)
				end
			end
		end
	end
end
addEventHandler("clientSyncInventory", getRootElement(), clientSyncInventory)