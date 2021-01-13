

local function draw(obj, delta, plusX, plusY)
	local x, y = obj.x, obj.y
	
	if (plusX ~= nil) then
		x = x + plusX
		y = y + plusY
	end
	
	
	if obj.border then
		dxDrawText(obj.text, x - 1, y - 1, x + obj.w - 1, y + obj.h - 1, tocolor(0, 0, 0, obj.a * obj.alpha), obj.fontScale, obj.font, obj.alignX, obj.alignY, obj.clip, obj.wordBreak, false, obj.colorCode)
		dxDrawText(obj.text, x + 1, y - 1, x + obj.w + 1, y + obj.h - 1, tocolor(0, 0, 0, obj.a * obj.alpha), obj.fontScale, obj.font, obj.alignX, obj.alignY, obj.clip, obj.wordBreak, false, obj.colorCode)
		dxDrawText(obj.text, x - 1, y + 1, x + obj.w - 1, y + obj.h + 1, tocolor(0, 0, 0, obj.a * obj.alpha), obj.fontScale, obj.font, obj.alignX, obj.alignY, obj.clip, obj.wordBreak, false, obj.colorCode)
		dxDrawText(obj.text, x + 1, y + 1, x + obj.w + 1, y + obj.h + 1, tocolor(0, 0, 0, obj.a * obj.alpha), obj.fontScale, obj.font, obj.alignX, obj.alignY, obj.clip, obj.wordBreak, false, obj.colorCode)
	end
	
	dxDrawText(obj.text, x, y, x + obj.w, y + obj.h, tocolor(obj.r, obj.g, obj.b, obj.a * obj.alpha), obj.fontScale, obj.font, obj.alignX, obj.alignY, obj.clip, obj.wordBreak, false, obj.colorCode)
end

local function click(obj, down, x, y)
	if (obj.enabled == false) then
		return
	end
	
	if (down == false and cmath.isPointInRect(x, y, obj.x, obj.y, obj.w, obj.h) == true) then
		triggerEvent("onDXGUIClicked", obj.element)
	end
end


function dxgui_CreateText(px, py, pw, ph, pText, pFont, pFontScale, pAlignX, pAlignY, pClip, pWordBreak, pColorCode, pr, pg, pb, pa, relative, parent)
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
		font = pFont,
		fontScale = pFontScale,
		alignX = pAlignX,
		alignY = pAlignY,
		clip = pClip,
		wordBreak = pWordBreak,
		colorCode = pColorCode,
		r = pr,
		g = pg,
		b = pb,
		a = pa,
		border = false,
	}
	
	if not pFontScale then
		new.fontScale = dxgui_TextDefaultScale(new.font)
	end
	
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


function dxgui_TextSetFontHeight(element, h)
	local obj = dxgui_GetElementTable(element)
	
	obj.fontScale = (1 / dxGetFontHeight(1, obj.font)) * h
end


function dxgui_TextDefaultScale(font)
	return (1 / dxGetFontHeight(1, font)) * 0.019 * screenY
end


function dxgui_TextDefaultHeight(font)
	return dxGetFontHeight(dxgui_TextDefaultScale(font), font)
end


function dxgui_TextSetBorder(element, state)
	dxgui_GetElementTable(element).border = state
end