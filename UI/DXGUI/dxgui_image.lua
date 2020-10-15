

local function draw(obj, delta, plusX, plusY)
	local x, y = obj.x, obj.y
	
	if (plusX ~= nil) then
		x = x + plusX
		y = y + plusY
	end
	
	
	dxDrawImage(x, y, obj.w, obj.h, obj.image, 0, 0, 0, tocolor(255, 255, 255, 255 * obj.alpha))
end

local function click(obj, down, x, y)
	if (obj.enabled == false) then
		return
	end
	
	if (down == false and cmath.isPointInRect(x, y, obj.x, obj.y, obj.w, obj.h) == true) then
		triggerEvent("onDXGUIClicked", obj.element)
	end
end


function dxgui_CreateImage(px, py, pw, ph, pImage, relative, parent)
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
		image = pImage,
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