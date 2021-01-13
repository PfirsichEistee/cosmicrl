

local function draw(obj, delta, plusX, plusY)
	local x, y = obj.x, obj.y
	
	if (plusX ~= nil) then
		x = x + plusX
		y = y + plusY
	end
	
	
	local rowH = obj.h / obj.rows
	local space = titleHeight * 0.1
	local fontScale = (1 / dxGetFontHeight(1, dxgui_FontA)) * rowH * 0.7
	
	dxDrawRectangle(x, y, obj.w, obj.h, tocolor(50, 50, 50, 155 * obj.alpha))
	
	dxDrawRectangle(x, y, obj.w, rowH, tocolor(100, 100, 100, 220 * obj.alpha))
	
	
	obj.gridScroll = cmath.clamp(obj.gridScroll, 1, #obj.item)
	
	if (#obj.item > 0 and obj.gridScroll <= obj.selected and (obj.gridScroll + obj.rows - 1) > obj.selected) then
		dxDrawRectangle(x, (obj.selected - obj.gridScroll + 1) * rowH + y, obj.w, rowH, tocolor(0, 90, 180, 150 * obj.alpha))
	end
	
	local lw = 0
	for i = 1, #obj.column, 1 do
		dxDrawText(obj.column[i].text, x + lw + space, y, x + lw + obj.w * obj.column[i].size, y + rowH, tocolor(255, 255, 255, 255 * obj.alpha), fontScale, dxgui_FontA, "left", "center", true, false)
		
		
		for k = 1, #obj.item, 1 do
			if (obj.item[k + obj.gridScroll - 1] ~= nil) then
				dxDrawText(obj.item[k + obj.gridScroll - 1][i], x + lw + space, y + rowH * k, x + lw + obj.w * obj.column[i].size, y + rowH * (k + 1), tocolor(255, 255, 255, 255 * obj.alpha), fontScale, dxgui_FontA, "left", "center", true, false, false, true)
			end
			
			if (k >= (obj.rows - 1)) then
				break
			end
		end
		
		
		lw = lw + obj.w * obj.column[i].size
	end
	
	if (#obj.item > 1) then
		local sp = ((obj.gridScroll - 1) / (#obj.item - 1)) * (obj.h - rowH * 1.75)
		
		dxDrawRectangle(x + obj.w - rowH * 0.25, y + rowH + sp, rowH * 0.25, rowH * 0.75, tocolor(100, 100, 100, 220 * obj.alpha))
	end
end

local function click(obj, down, x, y)
	if (obj.enabled == false) then
		return
	end
	
	if (down == false and cmath.isPointInRect(x, y, obj.x, obj.y, obj.w, obj.h) == true) then
		local localX = x - obj.x
		local localY = y - obj.y
		
		local rowH = obj.h / obj.rows
		
		
		local selrow = math.floor(localY / rowH) + obj.gridScroll - 1
		
		if (selrow >= 1 and selrow <= #obj.item and selrow >= obj.gridScroll) then
			obj.selected = selrow
		else
			obj.selected = 0
			
			local localX = (x - obj.x) / obj.w
			local col = 1
			
			local ph = 0
			for i = 1, #obj.column, 1 do
				if (localX > ph and localX < (obj.column[i].size + ph)) then
					col = i
				end
				
				ph = ph + obj.column[i].size
			end
			
			if (selrow == (obj.gridScroll - 1) and obj.allowSort == true) then
				dxgui_GridListSort(obj.element, col, (not obj.lastSortReverse))
			end
		end
		
		
		triggerEvent("onDXGUIClicked", obj.element)
	end
end

local function scroll(obj, dir)
	if not obj.enabled then
		return
	end
	
	obj.gridScroll = obj.gridScroll + dir
end


function dxgui_CreateGridList(px, py, pw, ph, pRows, relative, parent)
	local new = {
		element = createElement("dxgui"),
		kill = false,
		enabled = true,
		visible = true,
		alpha = 0,
		
		-- Main functions
		draw = draw,
		click = click,
		scroll = scroll,
		
		x = px,
		y = py,
		w = pw,
		h = ph,
		
		-- "class"-specific values
		selected = 0, -- nothing selected = 0
		column = {},
		item = {},
		rows = pRows,
		gridScroll = 1, -- which index is the first visible entry?
		lastSortReverse = false,
		allowSort = true,
	}
	
	--[[
	column = {
		[1] = {
			size = 0.6,
			text = "Name",
		}
	}
	]]
	
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


function dxgui_GridListAddColumn(element, pText, pSize)
	local obj = dxgui_GetElementTable(element)
	
	local new = {
		text = pText,
		size = pSize,
	}
	
	table.insert(obj.column, new)
end


function dxgui_GridListAddItem(element, ...)
	local args = {...}
	
	local obj = dxgui_GetElementTable(element)
	
	table.insert(obj.item, args)
end


function dxgui_GridListRemoveItem(element, index)
	local obj = dxgui_GetElementTable(element)
	
	if index > #obj.item then
		index = #obj.item
	end
	
	table.remove(obj.item, index)
end


function dxgui_GridListClear(element)
	local obj = dxgui_GetElementTable(element)
	
	obj.selected = 0
	
	obj.item = {}
end


function dxgui_GridListGetSelected(element)
	local obj = dxgui_GetElementTable(element)
	
	if (obj.selected > 0) then
		return obj.item[obj.selected]
	end
end


function dxgui_GridListItemCount(element)
	return #dxgui_GetElementTable(element).item
end


function dxgui_GridListGetItem(element, index)
	return dxgui_GetElementTable(element).item[index]
end


function dxgui_GridListSetAllowSort(element, allow)
	dxgui_GetElementTable(element).allowSort = allow
end


function dxgui_GridListGetAllowSort(element)
	return dxgui_GetElementTable(element).allowSort
end


local sortOrder = { '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z', }

local function sortGetLetterWeight(letter, rev)
	letter = string.upper(letter)
	for a, b in ipairs(sortOrder) do
		if b == letter then
			if rev then
				return (#sortOrder - a + 1)
			else
				return a
			end
		end
	end
	return 999
end

local function sortAlphabetic(obj, c, rev)
	for i = 1, (#obj.item - 1), 1 do
		local smallestIndex = i
		for k = (i + 1), #obj.item, 1 do
			if sortGetLetterWeight(string.sub(obj.item[k][c], 1, 1), rev) < sortGetLetterWeight(string.sub(obj.item[smallestIndex][c], 1, 1), rev) then
				smallestIndex = k
			end
		end
		
		if smallestIndex ~= i then
			local ph = obj.item[i]
			obj.item[i] = obj.item[smallestIndex]
			obj.item[smallestIndex] = ph
		end
	end
end

local function sortNumeric(obj, c, rev)
	for i = 1, (#obj.item - 1), 1 do
		local smallestIndex = i
		for k = (i + 1), #obj.item, 1 do
			if not rev then
				if tonumber(obj.item[k][c]) < tonumber(obj.item[smallestIndex][c]) then
					smallestIndex = k
				end
			else
				if tonumber(obj.item[k][c]) > tonumber(obj.item[smallestIndex][c]) then
					smallestIndex = k
				end
			end
		end
		
		if smallestIndex ~= i then
			local ph = obj.item[i]
			obj.item[i] = obj.item[smallestIndex]
			obj.item[smallestIndex] = ph
		end
	end
end

function dxgui_GridListSort(element, byColumn, reverseSort)
	local obj = dxgui_GetElementTable(element)
	
	local numeric = true
	for i = 1, #obj.item, 1 do
		if not tonumber(obj.item[i][byColumn]) then
			numeric = false
			break
		end
	end
	
	
	if numeric then
		sortNumeric(obj, byColumn, reverseSort)
	else
		sortAlphabetic(obj, byColumn, reverseSort)
	end
	
	obj.lastSortReverse = reverseSort
end