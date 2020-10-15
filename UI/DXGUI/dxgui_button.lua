
local defaultFontScale = (1 / dxGetFontHeight(1, dxgui_FontA)) * (0.025 * screenY)


local function draw(obj, delta, plusX, plusY)
	local x, y = obj.x, obj.y
	
	if (plusX ~= nil) then
		x = x + plusX
		y = y + plusY
	end
	
	
	--if (isCursorShowing() == true and cmath.isPointInRect(mouseX, mouseY, x, y, obj.w, obj.h) == true) then
	if (dxgui_IsCursorHoveringElement(obj) == true) then
		obj.hoverAnim = cmath.move_towards(obj.hoverAnim, 1, delta * 10)
	else
		obj.hoverAnim = cmath.move_towards(obj.hoverAnim, 0, delta * 10)
	end
	
	if (dxgui_Selection == obj) then
		obj.clickAnim = cmath.move_towards(obj.clickAnim, 1, delta * 20)
	else
		obj.clickAnim = cmath.move_towards(obj.clickAnim, 0, delta * 20)
	end
	
	
	local ph = (0.025 * (1 - obj.clickAnim))
	
	local fontMul = (1 / (obj.w - 0.025 * obj.w * 2)) * (obj.w - ph * obj.w * 2)
	
	dxDrawRectangle(x + ph * obj.w, y + ph * obj.h, obj.w - ph * obj.w * 2, obj.h - ph * obj.h * 2, tocolor(130, 130 + 20 * obj.clickAnim, 160 + 40 * obj.clickAnim, 200 * obj.alpha + 55 * obj.hoverAnim))
	dxDrawText(obj.text, x + ph * obj.w + 1.5, y + ph * obj.h + 1.5, x + obj.w - ph * obj.w + 1.5, y + obj.h - ph * obj.h + 1.5, tocolor(0, 0, 0, 255 * obj.alpha), obj.fontScale * fontMul, dxgui_FontA, "center", "center", true, false)
	dxDrawText(obj.text, x + ph * obj.w, y + ph * obj.h, x + obj.w - ph * obj.w, y + obj.h - ph * obj.h, tocolor(255, 255, 255, 255 * obj.alpha), obj.fontScale * fontMul, dxgui_FontA, "center", "center", true, false)
end

local function click(obj, down, x, y)
	if (obj.enabled == false) then
		return
	end
	
	if (down == false and cmath.isPointInRect(x, y, obj.x, obj.y, obj.w, obj.h) == true) then
		triggerEvent("onDXGUIClicked", obj.element)
	end
end


function dxgui_CreateButton(px, py, pw, ph, pText, relative, parent)
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
		hoverAnim = 0,
		clickAnim = 0,
		fontScale = defaultFontScale,
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


function dxgui_ButtonSetFontHeight(element, h)
	dxgui_GetElementTable(element).fontScale = (1 / dxGetFontHeight(1, dxgui_FontA)) * h
end