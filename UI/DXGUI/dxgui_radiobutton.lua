

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
	
	
	
	dxDrawRectangle(x, y, obj.h, obj.h, tocolor(255, 255, 255, (150 + 55 * obj.anim) * obj.alpha))
	
	if (obj.state == true) then
		dxDrawRectangle(x + obj.h * 0.2, y + obj.h * 0.2, obj.h * 0.6, obj.h * 0.6, tocolor(100, 100, 255, (200 + 55 * obj.anim) * obj.alpha))
	end
	
	
	dxDrawText(obj.text, x + obj.h * 1.1, y, x + obj.w, y + obj.h, tocolor(255, 255, 255, 255 * obj.alpha), (1 / dxGetFontHeight(1, dxgui_FontA)) * obj.h * 0.7, dxgui_FontA, "left", "center", true, false)
end

local function click(obj, down, x, y)
	if (obj.enabled == false) then
		return
	end
	
	if (down == false and cmath.isPointInRect(x, y, obj.x, obj.y, obj.w, obj.h) == true) then
		if obj.parent ~= nil then
			local object = dxgui_GetTable()
			
			for a, b in ipairs(object) do
				if b.radio == true then
					b.state = false
				end
			end
		else
			for a, b in ipairs(obj.parent.child) do
				if b.radio == true then
					b.state = false
				end
			end
		end
		
		obj.state = true
		
		
		triggerEvent("onDXGUIClicked", obj.element)
	end
end


function dxgui_CreateRadioButton(px, py, pw, ph, pText, relative, parent)
	local new = {
		element = createElement("dxgui"),
		kill = false,
		enabled = true,
		visible = true,
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
		anim = 0,
		state = false,
		parent = nil,
		radio = true,
	}
	
	local t = nil
	
	if (parent ~= nil) then
		t = dxgui_GetElementTable(parent)
		new.parent = t
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


function dxgui_RadioButtonGetState(element)
	return dxgui_GetElementTable(element).state
end


function dxgui_RadioButtonSetState(element, state)
	dxgui_GetElementTable(element).state = state
end