
local fontScale = (1 / dxGetFontHeight(1, dxgui_FontA)) * (0.025 * screenY)


local function draw(obj, delta, plusX, plusY)
	local x, y = obj.x, obj.y
	
	if (plusX ~= nil) then
		x = x + plusX
		y = y + plusY
	end
	
	
	local space = 0.1 * obj.h
	
	dxDrawRectangle(x, y, obj.w, obj.h, tocolor(255, 255, 255, 205 * obj.alpha))
	
	dxDrawRectangle(x + space, y + space, (obj.w - space * 2) * obj.progress, obj.h - space * 2, tocolor(100, 100, 255, 230 * obj.alpha))
	
	dxDrawText(obj.text, x, y, x + obj.w, y + obj.h, tocolor(0, 0, 0, 190 * obj.alpha), fontScale, dxgui_FontA, "center", "center", true, false)
end

local function click(obj, down, x, y)
	if (obj.enabled == false) then
		return
	end
	
	if (down == false and cmath.isPointInRect(x, y, obj.x, obj.y, obj.w, obj.h) == true) then
		triggerEvent("onDXGUIClicked", obj.element)
	end
end


function dxgui_CreateProgressBar(px, py, pw, ph, pText, relative, parent)
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
		text = pText,
		progress = 0,
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


function dxgui_SetProgress(element, progress)
	dxgui_GetElementTable(element).progress = progress
end


function dxgui_GetProgress(element, progress)
	return dxgui_GetElementTable(element).progress
end