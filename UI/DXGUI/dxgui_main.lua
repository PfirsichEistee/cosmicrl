
addEvent("onDXGUIClicked", false)
addEvent("dxgui_OnClick", false)


--screenX, screenY = guiGetScreenSize()

mouseX, mouseY = nil, nil

titleHeight = 0.035 * screenY
tabsHeight = 0.7 * titleHeight -- not used by dxgui

delta = 0 -- Delta time in seconds
local lastTime = getTickCount() -- getTichCount() returns millis

local object = {}


dxgui_Selection = nil


dxgui_FontA = dxCreateFont("fonts/Monstercat.ttf", 32)


local lastClickWasGui = false
local function catchGuiClick()
	lastClickWasGui = true
end
addEventHandler("onClientGUIClick", getRootElement(), catchGuiClick)



function dxgui_AddItem(elementTable)
	table.insert(object, elementTable)
end

function dxgui_GetTable()
	return object
end

function dxgui_Kill(element)
	dxgui_GetElementTable(element).kill = true
	--[[for a, b in ipairs(object) do
		if (b.element == element) then
			b.kill = true
		end
	end]]
end

function dxgui_GetElementTable(element)
	for a, b in ipairs(object) do
		if (b.element == element) then
			return b
		elseif (b.child ~= nil) then
			for c, d in ipairs(b.child) do
				if (d.element == element) then
					return d
				elseif (d.tab ~= nil) then
					for i = 1, #d.tab, 1 do
						for e, f in ipairs(d.tab[i]) do
							if (f.element == element) then
								return f
							end
						end
					end
				end
			end
		elseif (b.tab ~= nil) then
			for i = 1, #b.tab, 1 do
				for c, d in ipairs(b.tab[i]) do
					if (d.element == element) then
						return d
					end
				end
			end
		end
	end
end

function dxgui_GetTableParent(elementTable)
	for a, b in ipairs(object) do
		if b == elementTable then
			return nil
		elseif (b.child ~= nil) then
			for c, d in ipairs(b.child) do
				if d == elementTable then
					return b
				elseif (d.tab ~= nil) then
					for i = 1, #d.tab, 1 do
						for e, f in ipairs(d.tab[i]) do
							if f == elementTable then
								return d
							end
						end
					end
				end
			end
		elseif (b.tab ~= nil) then
			for i = 1, #b.tab, 1 do
				for c, d in ipairs(b.tab[i]) do
					if d == elementTable then
						return b
					end
				end
			end
		end
	end
end

function dxgui_ClearSelection()
	dxgui_Selection = nil
end

function dxgui_SetSelection(obj)
	if (isElement(obj) == true) then
		obj = dxgui_GetElementTable(obj)
	end
	
	dxgui_Selection = obj
end

function dxgui_SetText(element, text)
	dxgui_GetElementTable(element).text = text
end

function dxgui_GetText(element)
	return dxgui_GetElementTable(element).text
end

function dxgui_SetEnabled(element, enabled)
	dxgui_GetElementTable(element).enabled = enabled
end

function dxgui_GetEnabled(element)
	return dxgui_GetElementTable(element).enabled
end

function dxgui_SetPosition(element, x, y)
	local obj = dxgui_GetElementTable(element)
	
	obj.x = x
	obj.y = y
end

function dxgui_GetPosition(element)
	local obj = dxgui_GetElementTable(element)
	
	return obj.x, obj.y
end

function dxgui_SetSize(element, w, h)
	local obj = dxgui_GetElementTable(element)
	
	obj.w = w
	obj.h = h
end

function dxgui_GetSize(element)
	local obj = dxgui_GetElementTable(element)
	
	return obj.w, obj.h
end

function dxgui_SetColor(element, r, g, b, a)
	local obj = dxgui_GetElementTable(element)
	
	obj.r = r
	obj.g = g
	obj.b = b
	obj.a = a
end

function dxgui_GetCursorHoveringElementTable()
	if not isCursorShowing() then
		return
	end
	
	for i = 1, #object, 1 do
		if object[i].visible and dxgui_IsCursorOverElementWithChilds(object[i]) then
			if object[i].child ~= nil then
				for a, b in ipairs(object[i].child) do
					if b.visible and cmath.isPointInRect(mouseX, mouseY, b.x + object[i].x, b.y + object[i].y, b.w, b.h) then
						if b.tab ~= nil then
							for c, d in ipairs(b.tab[b.selectedTab]) do
								if d.visible and cmath.isPointInRect(mouseX, mouseY, d.x + b.x + object[i].x, d.y + b.y + object[i].y, b.w, b.h) then
									return d
								end
							end
						end
						
						return b
					end
				end
			elseif object[i].tab ~= nil then
				for a, b in ipairs(object[i].tab[object[i].selectedTab]) do
					if b.visible and cmath.isPointInRect(mouseX, mouseY, b.x + object[i].x, b.y + object[i].y, b.w, b.h) then
						return b
					end
				end
			end
			
			return object[i]
		end
	end
end

function dxgui_IsCursorHoveringElement(elementTable)
	if not isCursorShowing() then
		return false
	end
	
	for i = 1, #object, 1 do
		if object[i].visible and cmath.isPointInRect(mouseX, mouseY, object[i].x, object[i].y, object[i].w, object[i].h) then
			if object[i] == elementTable then
				return true
			else
				if object[i].child ~= nil then
					for a, b in ipairs(object[i].child) do
						if b.visible and b == elementTable and cmath.isPointInRect(mouseX, mouseY, b.x + object[i].x, b.y + object[i].y, b.w, b.h) then
							return true
						elseif b.tab ~= nil then
							for c, d in ipairs(b.tab[b.selectedTab]) do
								if d.visible and d == elementTable and cmath.isPointInRect(mouseX, mouseY, d.x + b.x + object[i].x, d.y + b.y + object[i].y, d.w, d.h) then
									return true
								end
							end
						end
					end
				elseif (object[i].tab ~= nil) then
					for a, b in ipairs(object[i].tab[object[i].selectedTab]) do
						if b.visible and b == elementTable and cmath.isPointInRect(mouseX, mouseY, b.x + object[i].x, b.y + object[i].y, b.w, b.h) then
							return true
						end
					end
				end
			end
			
			break
		end
	end
	
	return false
end

function dxgui_IsCursorOverElementWithChilds(elementTable)
	if not isCursorShowing() or not elementTable.visible then
		return false
	end
	
	local x, y = dxgui_GetGlobalPosition(elementTable)
	--local x, y = elementTable.x, elementTable.y
	
	if cmath.isPointInRect(mouseX, mouseY, x, y, elementTable.w, elementTable.h) then
		return true
	elseif elementTable.child ~= nil then
		x = mouseX - x
		y = mouseY - y
		
		for a, b in ipairs(elementTable.child) do
			if cmath.isPointInRect(x, y, b.x, b.y, b.w, b.h) then
				return true
			end
		end
	end
	
	return false
end

function dxgui_GetGlobalPosition(elementTable)
	for a, b in ipairs(object) do
		if (b == elementTable) then
			return b.x, b.y
		elseif (b.child ~= nil) then
			for c, d in ipairs(b.child) do
				if (d == elementTable) then
					return (b.x + d.x), (b.y + d.y)
				elseif (d.tab ~= nil) then
					for e, f in ipairs(d.tab[d.selectedTab]) do
						if (f == elementTable) then
							return (b.x + d.x + f.x), (b.y + d.y + f.y)
						end
					end
				end
			end
		elseif (b.tab ~= nil) then
			for c, d in ipairs(b.tab[b.selectedTab]) do
				if (d == elementTable) then
					return (b.x + d.x), (b.y + d.y)
				end
			end
		end
	end
end

function dxgui_ClearClickEvents(element)
	local obj = element
	if isElement(obj) then
		obj = dxgui_GetElementTable(element)
	else
		element = obj.element
	end
	
	for a, b in ipairs(getEventHandlers("onDXGUIClicked", element)) do
		removeEventHandler("onDXGUIClicked", element, b)
	end
	
	if obj.child then
		for a, b in ipairs(obj.child) do
			dxgui_ClearClickEvents(b)
		end
	elseif obj.tab then
		for i = 1, #obj.tab, 1 do
			for a, b in ipairs(obj.tab[i]) do
				dxgui_ClearClickEvents(b)
			end
		end
	end
end

function dxgui_ToFront(element)
	local obj = dxgui_GetElementTable(element)
	
	for i = 1, #object, 1 do
		if object[i] == obj then
			if (i ~= 1) then
				local ph = object[i]
				
				for k = i, 2, -1 do
					object[k] = object[k - 1]
				end
				
				object[1] = ph
				
				break
			end
		end
	end
end

function dxgui_ClearKill(element)
	dxgui_ClearClickEvents(element)
	dxgui_Kill(element)
end



local function render()
	-- Update delta value
	delta = getTickCount() - lastTime
	lastTime = getTickCount()
	delta = delta / 1000
	
	-- Update cursor values
	if (isCursorShowing() == true) then
		local phX = mouseX
		local phY = mouseY
		mouseX, mouseY = getCursorPosition()
		mouseX = mouseX * screenX
		mouseY = mouseY * screenY
		
		if (dxgui_Selection ~= nil and dxgui_Selection.drag ~= nil and (phX ~= mouseX or phY ~= mouseY)) then
			-- Drag selected object
			dxgui_Selection.drag(dxgui_Selection)
		end
	else
		mouseX = nil
		mouseY = nil
		dxgui_Selection = nil
	end
	
	
	-- Update Selection
	if (dxgui_Selection ~= nil) then
		guiSetInputMode("no_binds")
		
		if (dxgui_Selection.enabled == false) then
			dxgui_Selection = nil
		end
	else
		guiSetInputMode("allow_binds")
	end
	
	
	-- Update alpha values
	for i = #object, 1, -1 do
		local mA = 1
		if (object[i].kill == false) then
			object[i].alpha = cmath.move_towards(object[i].alpha, 1, delta * 5)
		else
			object[i].alpha = cmath.move_towards(object[i].alpha, 0, delta * 5)
			mA = object[i].alpha
		end
		
		if (object[i].child ~= nil) then
			for a, b in ipairs(object[i].child) do
				local mB = 1
				if (b.kill == false) then
					b.alpha = cmath.move_towards(b.alpha, 1, delta * 5)
				else
					b.alpha = cmath.move_towards(b.alpha, 0, delta * 5)
					mB = b.alpha
				end
				b.alpha = b.alpha * mA
				
				if (b.tab ~= nil) then
					for k = 1, #b.tab, 1 do
						for c, d in ipairs(b.tab[k]) do
							if (d.kill == false and b.selectedTab == k) then
								d.alpha = cmath.move_towards(d.alpha, 1, delta * 5)
							else
								d.alpha = cmath.move_towards(d.alpha, 0, delta * 5)
							end
							d.alpha = d.alpha * mA * mB
						end
					end
				end
			end
		elseif (object[i].tab ~= nil) then
			for k = 1, #object[i].tab, 1 do
				for a, b in ipairs(object[i].tab[k]) do
					if (b.kill == false and object[i].selectedTab == k) then
						b.alpha = cmath.move_towards(b.alpha, 1, delta * 5)
					else
						b.alpha = cmath.move_towards(b.alpha, 0, delta * 5)
					end
					b.alpha = b.alpha * mA
				end
			end
		end
	end
	
	
	-- Draw objects
	for i = #object, 1, -1 do
		if object[i].visible then
			object[i].draw(object[i], delta)
		end
	end
	
	
	-- Kill objects
	for i = #object, 1, -1 do
		if (object[i].kill == true and object[i].alpha <= 0) then
			table.remove(object, i)
		end
	end
end
addEventHandler("onClientRender", root, render)


local function click(button, state, x, y, worldX, worldY, worldZ, clickedElement)
	if lastClickWasGui then
		lastClickWasGui = false
		dxgui_ClearSelection()
		return
	end
	if not isCursorShowing() or button ~= "left" then
		return
	end
	
	local down = true
	
	if (state == "up") then
		down = false
	end
	
	
	if (down == true) then
		-- Look for new selected
		for i = 1, #object, 1 do
			--if (cmath.isPointInRect(x, y, object[i].x, object[i].y, object[i].w, object[i].h) == true and object[i].kill == false) then
			if dxgui_IsCursorOverElementWithChilds(object[i]) and not object[i].kill then
				dxgui_Selection = object[i]
				
				dxgui_Selection.click(dxgui_Selection, down, x, y)
				
				if (i ~= 1 and dxgui_Selection.stayInBackground ~= true) then
					local ph = object[i]
					
					for k = i, 2, -1 do
						object[k] = object[k - 1]
					end
					
					object[1] = ph
				end
				
				return
			end
		end
		
		dxgui_Selection = nil
	else
		if (dxgui_Selection ~= nil) then
			-- Update selected
			local gx, gy = dxgui_GetGlobalPosition(dxgui_Selection)
			
			dxgui_Selection.click(dxgui_Selection, down, x - (gx - dxgui_Selection.x), y - (gy - dxgui_Selection.y))
			
			if (dxgui_Selection.staySelected ~= true) then
				dxgui_Selection = nil
			end
		end
	end
	
	if (dxgui_Selection == nil) then
		local found = false
		for i = 1, #object, 1 do
			if (cmath.isPointInRect(x, y, object[i].x, object[i].y, object[i].w, object[i].h) == true) then
				found = true
				break
			end
		end
		
		if (found == false) then
			triggerEvent("dxgui_OnClick", source, button, state, x, y, worldX, worldY, worldZ, clickedElement)
		end
	end
end
addEventHandler("onClientClick", getRootElement(), click)


local function character(c)
	if (dxgui_Selection ~= nil and dxgui_Selection.keyPressed ~= nil) then
		dxgui_Selection.keyPressed(dxgui_Selection, c)
	end
end
addEventHandler("onClientCharacter", getRootElement(), character)


local repeatTimer
local repeatKey = "enter"

local function keyRepeatFunc()
	if (dxgui_Selection ~= nil and dxgui_Selection.keyPressed ~= nil) then
		if (repeatKey == "enter") then
			dxgui_Selection.keyPressed(dxgui_Selection, 0)
		else
			dxgui_Selection.keyPressed(dxgui_Selection, 1)
		end
	else
		killTimer(repeatTimer)
		repeatTimer = nil
	end
end

local function key(button, pressed)
	if (button == "enter" or button == "backspace") then
		if (pressed) then
			if (repeatTimer ~= nil) then
				killTimer(repeatTimer)
				repeatTimer = nil
			end
			repeatKey = button
			
			
			if (dxgui_Selection ~= nil and dxgui_Selection.keyPressed ~= nil) then
				if (repeatKey == "enter") then
					dxgui_Selection.keyPressed(dxgui_Selection, 0)
				else
					dxgui_Selection.keyPressed(dxgui_Selection, 1)
				end
			else
				return
			end
			
			repeatTimer = setTimer(function()
				keyRepeatFunc()
				
				killTimer(repeatTimer)
				repeatTimer = setTimer(keyRepeatFunc, 30, 0)
			end, 250, 1)
		else
			if (repeatTimer ~= nil) then
				killTimer(repeatTimer)
				repeatTimer = nil
			end
		end
	elseif (button == "mouse_wheel_up" or button == "mouse_wheel_down") then
		local dir = -1
		
		if (button == "mouse_wheel_down") then
			dir = 1
		end
		
		
		local obj = dxgui_GetCursorHoveringElementTable()
		
		if (obj ~= nil and obj.scroll ~= nil) then
			--obj.scroll = obj.scroll + dir
			obj.scroll(obj, dir)
		end
	end
end
addEventHandler("onClientKey", getRootElement(), key)
