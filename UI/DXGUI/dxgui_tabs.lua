
local fontScale = (1 / dxGetFontHeight(1, dxgui_FontA)) * titleHeight * 0.7 * 0.75


local function draw(obj, delta, plusX, plusY)
	local x, y = obj.x, obj.y
	
	if (plusX ~= nil) then
		x = x + plusX
		y = y + plusY
	end
	
	obj.anim = cmath.move_towards(obj.anim, (obj.selectedTab - 1) / #obj.tab, delta * 10)
	
	
	dxDrawRectangle(x, y, obj.w, obj.h, tocolor(0, 0, 0, 155 * obj.alpha))
	
	
	for i = 1, #obj.tab, 1 do
		for a, b in ipairs(obj.tab[i]) do
			if (b.alpha > 0) then
				b.draw(b, delta, x, y)
			end
		end
	end
	
	
	-- Kill objects
	for i = #obj.tab[obj.selectedTab], 1, -1 do
		if (obj.tab[obj.selectedTab][i].kill == true and obj.tab[obj.selectedTab][i].alpha <= 0) then
			table.remove(obj.tab[obj.selectedTab], i)
		end
	end
	
	
	dxDrawRectangle(x, y, obj.w, titleHeight * 0.75, tocolor(50, 50, 50, 220 * obj.alpha))
	
	local ph = obj.w / #obj.tab
	for i = 0, (#obj.tab - 1), 1 do
		dxDrawText(obj.tabTitle[i + 1], x + ph * i, y, x + ph * i + ph, y + titleHeight * 0.75, tocolor(255, 255, 255, 255 * obj.alpha), fontScale, dxgui_FontA, "center", "center", true, false)
	end
	
	dxDrawRectangle(x + obj.w * obj.anim, y + titleHeight * 0.75 - 2, ph, 4, tocolor(0, 130, 220, 220 * obj.alpha))
end

local function click(obj, down, x, y)
	if (obj.enabled == false) then
		return
	end
	
	if (y > obj.y and y < (obj.y + titleHeight * 0.75)) then
		if (down == false and cmath.isPointInRect(x, y, obj.x, obj.y, obj.w, obj.h) == true) then
			local ph = (obj.w / #obj.tab)
			for i = 0, (#obj.tab - 1), 1 do
				if (x > (obj.x + ph * i) and x < (obj.x + ph * (i + 1))) then
					obj.selectedTab = i + 1
					
					for a, b in ipairs(obj.tab) do
						for c, d in ipairs(b) do
							if (d.guielement ~= nil) then
								if (a == obj.selectedTab) then
									guiSetEnabled(d.guielement, true)
								else
									guiSetEnabled(d.guielement, false)
								end
							end
						end
					end
				end
			end
		end
	else
		if (down == true and y > (obj.y + titleHeight * 0.75)) then
			for a, b in ipairs(obj.tab[obj.selectedTab]) do
				if (b.kill == false and cmath.isPointInRect(x, y, b.x + obj.x, b.y + obj.y, b.w, b.h) == true) then
					dxgui_SetSelection(b)
					
					b.click(b, down, x - obj.x, y - obj.y)
					
					return
				end
			end
		end
	end
end


function dxgui_CreateTabs(px, py, pw, ph, pTitle, relative, parent)
	local new = {
		element = createElement("dxgui"),
		kill = false,
		enabled = true,
		alpha = 0,
		
		-- Main functions
		draw = draw,
		click = click,
		
		x = px,
		y = py,
		w = pw,
		h = ph,
		
		-- "class"-specific values
		tabTitle = {},
		tab = {},
		selectedTab = 1,
		anim = 0,
	}
	
	table.insert(new.tabTitle, pTitle)
	table.insert(new.tab, {})
	
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
		table.insert(t.child, new)
	end
	
	return new.element
end


function dxgui_TabsAddTab(element, title)
	local obj = dxgui_GetElementTable(element)
	
	table.insert(obj.tabTitle, title)
	table.insert(obj.tab, {})
end


function dxgui_TabsSetTab(element, tab)
	dxgui_GetElementTable(element).selectedTab = tab
end