
local defaultFontScale = (1 / dxGetFontHeight(1, dxgui_FontA)) * (0.025 * screenY)


local function updateSliderProgress(obj)
	local gx, gy = dxgui_GetGlobalPosition(obj)
	
	local lx = mouseX - gx
	
	local ph = obj.h / 3
	
	obj.progress = cmath.clamp((lx - ph) / (obj.w - ph * 2), 0, 1)
end


local function draw(obj, delta, plusX, plusY)
	local x, y = obj.x, obj.y
	
	if (plusX ~= nil) then
		x = x + plusX
		y = y + plusY
	end
	
	
	--if (isCursorShowing() == true and cmath.isPointInRect(mouseX, mouseY, x, y, obj.w, obj.h) == true) then
	if (dxgui_IsCursorHoveringElement(obj) == true) then
		obj.anim = cmath.move_towards(obj.anim, 1, delta * 10)
	else
		obj.anim = cmath.move_towards(obj.anim, 0, delta * 10)
	end
	
	
	local ph = obj.h / 3
	
	dxDrawRectangle(x + ph, y + ph, obj.w - ph * 2, obj.h - ph * 2, tocolor(255, 255, 255, 145 * obj.alpha + 55 * obj.anim * obj.alpha))
	
	dxDrawRectangle(x + ph + (obj.w - ph * 2) * obj.progress - obj.h * 0.5, y, obj.h, obj.h, tocolor(100, 100, 255, 200 * obj.alpha + 55 * obj.anim * obj.alpha))
end

local function click(obj, down, x, y)
	if (obj.enabled == false) then
		return
	end
	
	updateSliderProgress(obj)
	
	if (down == false and cmath.isPointInRect(x, y, obj.x, obj.y, obj.w, obj.h) == true) then
		triggerEvent("onDXGUIClicked", obj.element)
	end
end

local function drag(obj)
	if (obj.enabled == false) then
		return
	end
	
	updateSliderProgress(obj)
end


function dxgui_CreateSlider(px, py, pw, ph, relative, parent)
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
		anim = 0,
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


function dxgui_SliderGetProgress(element)
	return dxgui_GetElementTable(element).progress
end


function dxgui_SliderSetProgress(element, p)
	dxgui_GetElementTable(element).progress = p
end