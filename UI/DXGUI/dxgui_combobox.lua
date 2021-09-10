

local function draw(obj, delta, plusX, plusY)
	local x, y = obj.x, obj.y
	
	if (plusX ~= nil) then
		x = x + plusX
		y = y + plusY
	end
	
	local space = titleHeight * 0.1
	local fontScale = (1 / dxGetFontHeight(1, dxgui_FontA)) * obj.rowH * 0.7
	
	
	if dxgui_IsCursorHoveringElement(obj) then
		obj.cAnim = cmath.move_towards(obj.cAnim, 1, delta * 10)
	else
		obj.cAnim = cmath.move_towards(obj.cAnim, 0, delta * 10)
	end
	
	if obj.open then
		obj.dAnim = cmath.move_towards(obj.dAnim, 1, delta * 10)
	else
		obj.dAnim = cmath.move_towards(obj.dAnim, 0, delta * 10)
	end
	
	
	
	dxDrawRectangle(x, y, obj.w, obj.rowH, tocolor(255, 255, 255, 205 * obj.alpha + 30 * obj.cAnim))
	if obj.selected ~= 0 then
		dxDrawText(obj.item[obj.selected], x + space, y + space, x + obj.w - space, y + obj.rowH - space, tocolor(0, 0, 0, 225 * obj.alpha + 30 * obj.cAnim), fontScale, dxgui_FontA, "left", "center", true, false)
	else
		dxDrawText(obj.caption, x + space, y + space, x + obj.w - space, y + obj.rowH - space, tocolor(100, 0, 0, 255 * obj.alpha), fontScale, dxgui_FontA, "left", "center", true, false)
	end
	
	dxDrawImage(x + obj.w - obj.rowH + space, y + space, obj.rowH - space * 2, obj.rowH - space * 2, "images/DXGUI/dropdown.png", -90 * obj.dAnim - 90, 0, 0, tocolor(0, 0, 0, 155 * obj.alpha))
	
	
	if obj.dAnim > 0 then
		dxDrawRectangle(x, y + obj.rowH, obj.w, obj.rowH * 4, tocolor(200, 200, 200, 205 * obj.alpha * obj.dAnim))
		
		for i = 0, 3, 1 do
			if obj.item[obj.gridScroll + i] ~= nil then
				dxDrawText(obj.item[obj.gridScroll + i], x + space, y + obj.rowH * (i + 1) + space, x + obj.w - space, y + obj.rowH * (i + 2) - space, tocolor(0, 0, 0, 255 * obj.alpha * obj.dAnim), fontScale, dxgui_FontA, "left", "center", true, false)
			end
		end
	end
end

local function click(obj, down, x, y)
	if not obj.enabled then
		return
	end
	
	if (down == false and cmath.isPointInRect(x, y, obj.x, obj.y, obj.w, obj.h) == true) then
		if obj.open then
			x = x - obj.x
			y = y - obj.y
			
			local phRow = math.floor(y / obj.rowH)
			
			if phRow > 0 then
				phRow = phRow + obj.gridScroll - 1
				
				if obj.item[phRow] ~= nil then
					obj.selected = phRow
				end
			end
		end
		
		
		obj.open = not obj.open
		
		if obj.open then
			obj.h = obj.rowH * 5
		else
			obj.h = obj.rowH
		end
		
		triggerEvent("onDXGUIClicked", obj.element)
	end
end

local function scroll(obj, dir)
	if not obj.enabled then
		return
	end
	
	obj.gridScroll = cmath.clamp(obj.gridScroll + dir, 1, #obj.item)
end


function dxgui_CreateComboBox(px, py, pw, ph, pCaption, relative, parent)
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
		item = {},
		selected = 0, -- 0 == nothing
		gridScroll = 1,
		rowH = ph,
		cAnim = 0, -- cursor hover
		dAnim = 0, -- dropdown menu
		caption = pCaption,
		open = false,
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
		new.rowH = new.h
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


function dxgui_ComboBoxAddItem(element, pText)
	table.insert(dxgui_GetElementTable(element).item, pText)
end


function dxgui_ComboBoxRemoveIndex(element, index)
	local ph = dxgui_GetElementTable(element)
	
	if ph.item[index] ~= nil then
		if ph.selected >= index then
			ph.selected = 0
		end
		
		table.remove(ph.item, index)
	end
end


function dxgui_ComboBoxRemoveItem(element, pText)
	local ph = dxgui_GetElementTable(element)
	
	for a, b in ipairs(ph.item) do
		if b == pText then
			if ph.selected >= a then
				ph.selected = 0
			end
			
			table.remove(ph.item, a)
			
			break
		end
	end
end


function dxgui_ComboBoxClear(element)
	local ph = dxgui_GetElementTable(element)
	
	ph.item = {}
	ph.selected = 0
end


function dxgui_ComboBoxGetSelection(element)
	local ph = dxgui_GetElementTable(element)
	
	return ph.item[ph.selected]
end


function dxgui_ComboBoxGetItems(element)
	return dxgui_GetElementTable(element).item
end