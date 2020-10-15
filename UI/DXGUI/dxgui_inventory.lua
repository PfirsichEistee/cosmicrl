
local fontScale = (1 / dxGetFontHeight(1, dxgui_FontA))


local function draw(obj, delta, plusX, plusY)
	local x, y = obj.x, obj.y
	
	if (plusX ~= nil) then
		x = x + plusX
		y = y + plusY
	end
	
	
	dxDrawRectangle(x, y, obj.w, obj.h, tocolor(40, 40, 40, 160 * obj.alpha))
	
	
	local px = (obj.w - obj.cellW * obj.columns) / obj.columns
	local py = (obj.h - obj.cellH * obj.rows) / obj.rows
	
	for c = 0, (obj.columns - 1), 1 do
		for r = 0, (obj.rows - 1), 1 do
			dxDrawRectangle(x + c * obj.cellW + c * px + (px / 2), y + r * obj.cellH + r * py + (py / 2), obj.cellW, obj.cellH, tocolor(120, 120, 120, 200 * obj.alpha))
			
			
			if (obj.item[c + 1][r + 1].id ~= 0) then
				if (obj.isDragging == false or obj.selected ~= (r * obj.columns + c + 1)) then
					if (obj.item[c + 1][r + 1].image ~= nil) then
						dxDrawImage(x + c * obj.cellW + c * px + (px / 2), y + r * obj.cellH + r * py + (py / 2), obj.cellW, obj.cellH, obj.item[c + 1][r + 1].image, 0, 0, 0, tocolor(255, 255, 255, 255 * obj.alpha))
					else
						dxDrawRectangle(x + c * obj.cellW + c * px + (px / 2) + 10, y + r * obj.cellH + r * py + (py / 2) + 10, obj.cellW - 20, obj.cellH - 20, tocolor(255, 0, 0, 255 * obj.alpha))
					end
					
					dxDrawText(obj.item[c + 1][r + 1].amount, x + c * obj.cellW + c * px + (px / 2) + 2, y + r * obj.cellH + r * py + (py / 2) + 2, x + c * obj.cellW + c * px + (px / 2) + obj.cellW + 2, y + r * obj.cellH + r * py + (py / 2) + obj.cellH + 2, tocolor(0, 0, 0, 255 * obj.alpha), fontScale * obj.cellH * 0.4, dxgui_FontA, "center", "bottom", true, false)
					dxDrawText(obj.item[c + 1][r + 1].amount, x + c * obj.cellW + c * px + (px / 2), y + r * obj.cellH + r * py + (py / 2), x + c * obj.cellW + c * px + (px / 2) + obj.cellW, y + r * obj.cellH + r * py + (py / 2) + obj.cellH, tocolor(255, 255, 255, 255 * obj.alpha), fontScale * obj.cellH * 0.4, dxgui_FontA, "center", "bottom", true, false)
				end
			end
		end
	end
	
	local selY = math.floor((obj.selected - 1) / obj.columns) + 1
	local selX = (obj.selected - 1) - ((selY - 1) * obj.columns) + 1
	if (obj.isDragging == true) then
		if (obj.item[selX][selY].image ~= nil) then
			dxDrawImage(mouseX - (obj.cellW / 2), mouseY - (obj.cellH / 2), obj.cellW, obj.cellH, obj.item[selX][selY].image, 0, 0, 0, tocolor(255, 255, 255, 255 * obj.alpha))
		else
			dxDrawRectangle(mouseX - ((obj.cellW - 20) / 2), mouseY - ((obj.cellH - 20) / 2), obj.cellW - 20, obj.cellH - 20, tocolor(255, 0, 0, 255 * obj.alpha))
		end
		
		if obj.item[selX][selY].id == 0 then
			obj.isDragging = false
			obj.selected = 0
		end
	elseif (obj.selected > 0) then
		dxDrawImage(x + (selX - 1) * obj.cellW + (selX - 1) * px + (px / 2), y + (selY - 1) * obj.cellH + (selY - 1) * py + (py / 2), obj.cellW, obj.cellH, "images/DXGUI/InventorySelection.png", 0, 0, 0, tocolor(255, 255, 255, 255 * obj.alpha))
	end
end

local function click(obj, down, x, y)
	if (obj.enabled == false) then
		return
	end
	
	if (down == true) then
		local mx = math.floor((x - obj.x) / (obj.w / obj.columns))
		local my = math.floor((y - obj.y) / (obj.h / obj.rows))
		local pos = (my * obj.columns + mx + 1)
		
		if (mx >= 0 and mx < obj.columns and my >= 0 and my < obj.rows and obj.item[mx + 1][my + 1].id ~= 0) then
			obj.selected = pos
			--obj.isDragging = true
			obj.downX = x
			obj.downY = y
		else
			obj.selected = 0
		end
	else
		if (obj.isDragging == true) then
			obj.isDragging = false
			
			local mx = math.floor((x - obj.x) / (obj.w / obj.columns))
			local my = math.floor((y - obj.y) / (obj.h / obj.rows))
			local pos = (my * obj.columns + mx)
			
			if (mx >= 0 and mx < obj.columns and my >= 0 and my < obj.rows) then
				-- switch selected pos with target pos
				
				local selY = math.floor((obj.selected - 1) / obj.columns)
				local selX = (obj.selected - 1) - (selY * obj.columns)
				
				local ph = obj.item[selX + 1][selY + 1]
				obj.item[selX + 1][selY + 1] = obj.item[mx + 1][my + 1]
				obj.item[mx + 1][my + 1] = ph
				
				obj.selected = pos + 1
			end
		end
		
		triggerEvent("onDXGUIClicked", obj.element)
	end
end

local function drag(obj)
	if (obj.enabled == false) then
		obj.isDragging = false
		return
	end
	
	if (obj.isDragging == false and obj.selected ~= 0) then
		local px, py = dxgui_GetGlobalPosition(obj)
		px = mouseX - (px - obj.x)
		py = mouseY - (py - obj.y)
		
		if (cmath.dist2D(obj.downX, obj.downY, px, py) > (0.01 * screenX)) then
			obj.isDragging = true
		end
	end
end


function dxgui_CreateInventory(px, py, pw, ph, pColumns, pRows, relative, parent)
	local new = {
		element = createElement("dxgui"),
		kill = false,
		enabled = true,
		alpha = 0,
		
		-- Main functions
		draw = draw,
		click = click,
		drag = drag,
		
		x = px,
		y = py,
		w = pw,
		h = ph,
		
		-- "class"-specific values
		columns = pColumns,
		rows = pRows,
		cellW = 0,
		cellH = 0,
		selected = 0, -- nothing selected
		isDragging = false,
		downX = 0,
		downY = 0,
		item = {},
	}
	
	local t = nil
	
	if (parent ~= nil) then
		t = dxgui_GetElementTable(parent)
	end
	
	if (relative == true) then
		if (t == nil) then
			new.x = new.x * screenX
			new.y = new.y * screenY
			new.w = new.w * screenX
			new.h = new.h * screenY
		else
			new.x = new.x * t.w
			new.y = new.y * t.h
			new.w = new.w * t.w
			new.h = new.h * t.h
		end
	end
	
	
	new.cellW = (new.w / new.columns) * 0.9
	new.cellH = (new.h / new.rows) * 0.9
	
	
	for c = 1, new.columns, 1 do
		table.insert(new.item, {})
		for r = 1, new.rows, 1 do
			table.insert(new.item[c], {})
			
			new.item[c][r] = {
				id = 0,
				amount = 0,
				image = nil,
			}
		end
	end
	
	
	
	if (t == nil) then
		dxgui_AddItem(new)
	else
		if (t.tab == nil) then
			table.insert(t.child, new)
		else
			table.insert(t.tab[t.selectedTab], new)
		end
	end
	
	return new.element
end


function dxgui_InventorySetItem(element, column, row, pID, pAmount, pImage)
	local obj = dxgui_GetElementTable(element)
	
	obj.item[column][row].id = pID
	obj.item[column][row].amount = pAmount
	obj.item[column][row].image = pImage
end


function dxgui_InventoryAddItem(element, pID, pAmount, pImage)
	local obj = dxgui_GetElementTable(element)
	
	for y = 1, obj.rows, 1 do
		for x = 1, obj.columns, 1 do
			if obj.item[x][y].id == 0 then
				obj.item[x][y].id = pID
				obj.item[x][y].amount = pAmount
				obj.item[x][y].image = pImage
				
				return
			end
		end
	end
end


function dxgui_InventoryGetItem(element, column, row)
	return dxgui_GetElementTable(element).item[column][row]
end


function dxgui_InventoryFindAndSet(element, findID, pID, pAmount, image_or_keep)
	-- Returns if it found the item
	
	local obj = dxgui_GetElementTable(element)
	
	for y = 1, obj.rows, 1 do
		for x = 1, obj.columns, 1 do
			if obj.item[x][y].id == findID then
				obj.item[x][y].id = pID
				obj.item[x][y].amount = pAmount
				
				if image_or_keep ~= true then
					obj.item[x][y].image = pImage
				end
				
				return true
			end
		end
	end
	
	return false
end


function dxgui_InventoryGetSelectedItem(element)
	local obj = dxgui_GetElementTable(element)
	
	if (obj.selected ~= 0) then
		local selY = math.floor((obj.selected - 1) / obj.columns)
		local selX = (obj.selected - 1) - (selY * obj.columns)
		
		return obj.item[selX + 1][selY + 1]
	end
end