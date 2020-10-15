
addEvent("onDXGUIEditEnter", false)


local function draw(obj, delta, plusX, plusY)
	local x, y = obj.x, obj.y
	
	if (plusX ~= nil) then
		x = x + plusX
		y = y + plusY
	end
	
	
	--if (isCursorShowing() == true and cmath.isPointInRect(mouseX, mouseY, x, y, obj.w, obj.h) == true) then
	if (dxgui_Selection == obj or dxgui_IsCursorHoveringElement(obj) == true) then
		obj.anim = cmath.move_towards(obj.anim, 1, delta * 10)
	else
		obj.anim = cmath.move_towards(obj.anim, 0, delta * 10)
	end
	
	
	local fontScale = (1 / dxGetFontHeight(1, dxgui_FontA)) * obj.h * 0.55
	local space = obj.h * 0.05
	
	dxDrawRectangle(x, y, obj.w, obj.h, tocolor(255, 255, 255, 200 * obj.alpha + 55 * obj.anim))
	
	
	local txt = obj.text
	if (obj.hidden == true) then
		txt = ""
		
		for i = 1, string.len(obj.text), 1 do
			txt = txt .. "*"
		end
	end
	
	
	local phw = obj.w - space * 2
	local textW = dxGetTextWidth(txt, fontScale, dxgui_FontA)
	
	if (txt ~= "") then
		if (textW <= phw) then
			dxDrawText(txt, x + space, y + space, x + obj.w - space, y + obj.h - space, tocolor(0, 0, 0, 255 * obj.alpha), fontScale, dxgui_FontA, "left", "center", true, false)
		else
			dxDrawText(txt, x + space, y + space, x + obj.w - space, y + obj.h - space, tocolor(0, 0, 0, 255 * obj.alpha), fontScale, dxgui_FontA, "right", "center", true, false)
		end
	else
		dxDrawText(obj.alphaText, x + space, y + space, x + obj.w - space, y + obj.h - space, tocolor(75, 75, 75, 255 * obj.alpha), fontScale, dxgui_FontA, "left", "center", true, false)
	end
	
	
	if (obj == dxgui_Selection) then
		local phx = x + space
		
		if (textW > phw) then
			phx = x + obj.w - space - textW
		end
		
		phx = phx + dxGetTextWidth(string.sub(txt, 1, obj.selchar), fontScale, dxgui_FontA)
		
		if (phx >= x and phx <= (x + obj.w - 2)) then
			dxDrawRectangle(phx, y + ((obj.h - (obj.h * 0.55)) / 2), 2, obj.h * 0.55, tocolor(0, 0, 0, 255 * obj.alpha * math.abs(math.sin(getTickCount() * 0.006))))
		end
	end
end

local function click(obj, down, x, y)
	if (obj.enabled == false) then
		return
	end
	
	if (cmath.isPointInRect(x, y, obj.x, obj.y, obj.w, obj.h) == true) then
		local txt = obj.text
		if (obj.hidden == true) then
			txt = ""
			
			for i = 1, string.len(obj.text), 1 do
				txt = txt .. "*"
			end
		end
		
		local fontScale = (1 / dxGetFontHeight(1, dxgui_FontA)) * obj.h * 0.55
		local space = obj.h * 0.05
		
		local phw = obj.w - space * 2
		local textW = dxGetTextWidth(txt, fontScale, dxgui_FontA)
		local phx = obj.x + space
		
		if (textW > phw) then
			phx = obj.x + obj.w - space - textW
		end
		
		
		obj.selchar = 0
		
		for i = 1, string.len(txt), 1 do
			if ((dxGetTextWidth(string.sub(txt, 1, i), fontScale, dxgui_FontA) + phx) < x) then
				obj.selchar = i
			end
		end
		
		
		triggerEvent("onDXGUIClicked", obj.element)
	end
end

local function keyPressed(obj, key)
	if (obj.enabled == false) then
		return
	end
	
	if (obj.onlyNumbers == true and tonumber(key) == nil) then
		return
	end
	
	if (key == "ä") then
		keyPressed(obj, "a")
		keyPressed(obj, "e")
		return
	elseif (key == "ö") then
		keyPressed(obj, "o")
		keyPressed(obj, "e")
		return
	elseif (key == "ü") then
		keyPressed(obj, "u")
		keyPressed(obj, "e")
		return
	end
	
	if (string.len(key) > 1) then
		return
	end
	
	-- key=0 -> enter
	-- key=1 -> backspace
	
	if (key ~= 0 and key ~= 1) then
		local strlen = string.len(obj.text)
		
		
		if (obj.selchar >= 0 and obj.selchar <= strlen) then
			obj.text = string.sub(obj.text, 1, obj.selchar) .. key .. string.sub(obj.text, obj.selchar + 1, strlen)
		end
		
		obj.selchar = obj.selchar + 1
	else
		if (key == 1) then
			if (obj.selchar > 0) then
				obj.text = string.sub(obj.text, 1, obj.selchar - 1) .. string.sub(obj.text, obj.selchar + 1, strlen)
				
				obj.selchar = obj.selchar - 1
			end
		else
			triggerEvent("onDXGUIEditEnter", obj.element)
		end
	end
end


function dxgui_CreateEdit(px, py, pw, ph, pText, relative, parent)
	local new = {
		element = createElement("dxgui"),
		kill = false,
		enabled = true,
		alpha = 0,
		
		-- Main functions
		draw = draw,
		click = click,
		drag = drag,
		keyPressed = keyPressed,
		
		x = px,
		y = py,
		w = pw,
		h = ph,
		
		-- "class"-specific values
		alphaText = pText,
		text = "",
		anim = 0,
		selchar = 0,
		staySelected = true,
		hidden = false,
		onlyNumbers = false,
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


function dxgui_EditSetHidden(element, hidden)
	dxgui_GetElementTable(element).hidden = hidden
end


function dxgui_EditSetOnlyNumbers(element, to)
	dxgui_GetElementTable(element).onlyNumbers = to
end