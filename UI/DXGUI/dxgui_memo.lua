
local activeRenderTargets = {}
local dragSpace = titleHeight * 0.3
local fontSize = (1 / dxGetFontHeight(1, dxgui_FontA)) * dragSpace * 1.965

local clipboard = ""

--[[
dxGetFontHeight is supposed to return a value which is 1.75 * the actual pixel size, but it doesnt look like that in my case?
The returned height is the nearly exact pixel height, but is slightly off by a factor of about ~0.03
]]


local function getCharacterFromPixel(obj, x, y)
	x = cmath.clamp(x, 0, obj.w - dragSpace) - obj.scrollX
	y = cmath.clamp(y, 0, obj.h - dragSpace) - obj.scrollY
	
	-- find row first
	local row = cmath.clamp(math.ceil(y / (dragSpace * 2)), 1, cmath.getStringMaxRows(obj.text))
	
	-- find "column"
	local col = 1
	local strRow = cmath.getStringRow(obj.text, row)
	for i = string.len(strRow), 0, -1 do
		if x >= dxGetTextWidth(string.sub(strRow, 1, i), fontSize, dxgui_FontA) then
			col = i
			
			break
		end
	end
	
	return col, row
end

local function getPixelFromCharacter(obj, x, y)
	local strRow = string.sub(cmath.getStringRow(obj.text, y), 1, x)
	
	return dxGetTextWidth(string.sub(strRow, 1, i), fontSize, dxgui_FontA) + obj.scrollX, (y - 1) * (dragSpace * 2) + obj.scrollY
end

local function getScrollPercentY(obj)
	return (1 / (-(cmath.getStringMaxRows(obj.text) - 1) * dragSpace * 2)) * obj.scrollY
end
local function setScrollPercentY(obj, perc)
	obj.scrollY = (-(cmath.getStringMaxRows(obj.text) - 1) * dragSpace * 2) * perc
end

local function getScrollPercentX(obj)
	local phW = dxGetTextWidth(obj.text, fontSize, dxgui_FontA, false) + dragSpace
	
	if phW < (obj.w - dragSpace) then
		phW = obj.w - dragSpace
	end
	
	
	-- max scrollX
	phW = phW - (obj.w - dragSpace)
	
	
	-- percent
	return (1 / -phW) * obj.scrollX
end
local function setScrollPercentX(obj, perc)
	local phW = dxGetTextWidth(obj.text, fontSize, dxgui_FontA, false) + dragSpace
	
	if phW < (obj.w - dragSpace) then
		phW = obj.w - dragSpace
	end
	
	
	-- max scrollX
	phW = phW - (obj.w - dragSpace)
	
	
	obj.scrollX = perc * -phW
end

local function getSelectionChar(obj)
	local strStart = cmath.getStringRowStartAndEnd(obj.text, obj.sel[1].y) + obj.sel[1].x
	local strEnd = nil
	
	if obj.sel[2] and (obj.sel[2].x ~= obj.sel[1].x or obj.sel[2].y ~= obj.sel[1].y) then
		strEnd = cmath.getStringRowStartAndEnd(obj.text, obj.sel[2].y) + obj.sel[2].x
		
		if strEnd < strStart then
			local ph = strEnd
			strEnd = strStart
			strStart = ph
		end
		
		if strEnd ~= strStart then
			strEnd = strEnd - 1
		end
	end
	
	return strStart, strEnd
end

local function draw(obj, delta, plusX, plusY)
	local x, y = obj.x, obj.y
	
	if (plusX ~= nil) then
		x = x + plusX
		y = y + plusY
	end
	
	
	if (dxgui_Selection == obj or dxgui_IsCursorHoveringElement(obj) == true) then
		obj.anim = cmath.move_towards(obj.anim, 1, delta * 10)
	else
		obj.anim = cmath.move_towards(obj.anim, 0, delta * 10)
	end
	
	
	
	--dxDrawRectangle(x, y, obj.w, obj.h, tocolor(155, 155, 155, 255 * obj.alpha))
	dxDrawRectangle(x, y, obj.w, obj.h, tocolor(255, 255, 255, 200 * obj.alpha + 55 * obj.anim))
	
	
	dxSetRenderTarget(obj.rt, true)
	
	dxDrawText(obj.text, obj.scrollX, obj.scrollY, obj.scrollX + obj.w - dragSpace, obj.scrollY + obj.h - dragSpace, tocolor(0, 0, 0, 255 * obj.alpha), fontSize, fontSize, dxgui_FontA, "left", "top", false, false)
	
	if obj == dxgui_Selection then
		if obj.sel[1] and (not obj.sel[2] or obj.sel[2].x == obj.sel[1].x and obj.sel[2].y == obj.sel[1].y) then
			local px, py = getPixelFromCharacter(obj, obj.sel[1].x, obj.sel[1].y)
			
			dxDrawLine(px, py, px, py + dragSpace * 2, tocolor(0, 0, 0, 255 * obj.alpha * math.abs(math.sin(getTickCount() * 0.006))))
		elseif obj.sel[1] and obj.sel[2] then
			local px1, py1 = getPixelFromCharacter(obj, obj.sel[1].x, obj.sel[1].y)
			local px2, py2 = getPixelFromCharacter(obj, obj.sel[2].x, obj.sel[2].y)
			
			if py1 > py2 then
				local phx = px1
				local phy = py1
				px1 = px2
				py1 = py2
				
				px2 = phx
				py2 = phy
			end
			
			if py1 == py2 then
				dxDrawRectangle(px1, py1, px2 - px1, dragSpace * 2, tocolor(255, 0, 0, 150))
			else
				dxDrawRectangle(px1, py1, obj.w - dragSpace - px1, dragSpace * 2, tocolor(255, 0, 0, 150 * obj.alpha))
				dxDrawRectangle(0, py2, px2, dragSpace * 2, tocolor(255, 0, 0, 150 * obj.alpha))
				
				if (py2 - py1) > 1 then
					dxDrawRectangle(0, py1 + dragSpace * 2, obj.w - dragSpace, py2 - py1 - dragSpace * 2, tocolor(255, 0, 0, 150 * obj.alpha))
				end
			end
		end
	end
	
	dxSetRenderTarget()
	
	dxDrawImage(x, y, obj.w - dragSpace, obj.h - dragSpace, obj.rt)
	
	
	if cmath.getStringMaxRows(obj.text) > 1 then
		dxDrawRectangle(x + obj.w - dragSpace, y, dragSpace, obj.h - dragSpace, tocolor(155, 155, 155, 175 * obj.alpha + 55 * obj.anim))
		dxDrawRectangle(x + obj.w - dragSpace + 1, y + 1 + getScrollPercentY(obj) * ((obj.h / 3) * 2 - dragSpace), dragSpace - 2, obj.h / 3 - 2, tocolor(255, 0, 0, 175 * obj.alpha + 55 * obj.anim))
	end
	if getScrollPercentX(obj) == getScrollPercentX(obj) then -- NaN doesnt equal anything!
		dxDrawRectangle(x, y + obj.h - dragSpace, obj.w - dragSpace, dragSpace, tocolor(155, 155, 155, 175 * obj.alpha + 55 * obj.anim))
		dxDrawRectangle(x + 1 + getScrollPercentX(obj) * ((obj.w / 3) * 2 - dragSpace), y + obj.h - dragSpace + 1, obj.w / 3 - 2, dragSpace - 2, tocolor(255, 0, 0, 175 * obj.alpha + 55 * obj.anim))
	end
	
	--guiSetAlpha(obj.guielement, obj.alpha)
	--guiSetPosition(obj.guielement, x, y, false)
end

local function click(obj, down, x, y)
	if (obj.enabled == false) then
		return
	end
	
	if not down and obj.scrollDrag then
		obj.scrollDrag = false
		return
	end
	
	if cmath.isPointInRect(x, y, obj.x, obj.y, obj.w, obj.h) then
		if down then
			if x >= (obj.x + obj.w - dragSpace) then
				obj.scrollDrag = "y"
				
				y = (1 / (obj.h - (obj.h / 3) - dragSpace)) * (y - obj.y - ((obj.h / 3) / 2))
				y = cmath.clamp(y, 0, 1)
				
				setScrollPercentY(obj, y)
			elseif y >= (obj.y + obj.h - dragSpace) then
				obj.scrollDrag = "x"
				
				x = (1 / (obj.w - (obj.w / 3) - dragSpace)) * (x - obj.x - ((obj.w / 3) / 2))
				x = cmath.clamp(x, 0, 1)
				
				setScrollPercentX(obj, x)
			end
			
			if not obj.scrollDrag then
				local px, py = getCharacterFromPixel(obj, x - obj.x, y - obj.y)
				obj.sel[2] = nil
				obj.sel[1] = {
					x = px,
					y = py,
				}
			end
		else
			if not obj.scrollDrag then
				local px, py = getCharacterFromPixel(obj, x - obj.x, y - obj.y)
				obj.sel[2] = {
					x = px,
					y = py,
				}
			end
			
			triggerEvent("onDXGUIClicked", obj.element)
		end
	end
end

local function drag(obj)
	if not obj.enabled or not getKeyState("mouse1") then
		return
	end
	
	local px, py = dxgui_GetGlobalPosition(obj)
	px = mouseX - px
	py = mouseY - py
	
	if not obj.scrollDrag then
		px, py = getCharacterFromPixel(obj, px, py)
		obj.sel[2] = {
			x = px,
			y = py,
		}
	else
		if obj.scrollDrag == "y" then
			py = (1 / (obj.h - (obj.h / 3) - dragSpace)) * (py - ((obj.h / 3) / 2))
			py = cmath.clamp(py, 0, 1)
			
			setScrollPercentY(obj, py)
		else
			px = (1 / (obj.w - (obj.w / 3) - dragSpace)) * (px - ((obj.w / 3) / 2))
			px = cmath.clamp(px, 0, 1)
			
			setScrollPercentX(obj, px)
		end
	end
end

local function scroll(obj, dir)
	if not obj.enabled then
		return
	end
	
	obj.scrollY = cmath.clamp(obj.scrollY - dir * dragSpace, -(cmath.getStringMaxRows(obj.text) - 1) * dragSpace * 2, 0)
end

local function keyPressed(obj, key)
	if (obj.enabled == false) then
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
	
	if string.len(key) > 1 then
		return
	end
	
	-- key=0 -> enter
	-- key=1 -> backspace
	
	local percX = getScrollPercentX(obj)
	local percY = getScrollPercentY(obj)
	
	
	if key ~= 0 and key ~= 1 then -- enter letter
		-- swap selection-points if necessary
		if obj.sel[2] and obj.sel[1].y > obj.sel[2].y or obj.sel[1].y == obj.sel[2].y and obj.sel[1].x > obj.sel[2].x then
			local ph = obj.sel[2]
			obj.sel[2] = obj.sel[1]
			obj.sel[1] = ph
		end
		
		-- clear selection
		local ps, pe = getSelectionChar(obj)
		
		if pe then
			obj.text = string.sub(obj.text, 1, ps - 1) .. string.sub(obj.text, pe + 1)
		end
		
		if ps == (string.len(obj.text) + 1) then
			obj.text = obj.text .. key
		else
			obj.text = string.sub(obj.text, 1, ps - 1) .. key .. string.sub(obj.text, ps)
			
			obj.scrollX = obj.scrollX - dxGetTextWidth(key, fontSize, dxgui_FontA)
			percX = getScrollPercentX(obj)
		end
		obj.sel[1].x = obj.sel[1].x + 1
		
		
		if key == "\n" then
			obj.sel[1].x = 0
			obj.sel[1].y = obj.sel[1].y + 1
		end
		
		
		obj.sel[2] = obj.sel[1]
	else
		if key == 0 then -- enter
			keyPressed(obj, "\n")
			percX = 0
		elseif key == 1 then -- backspace
			-- swap selection-points if necessary
			if obj.sel[2] and obj.sel[1].y > obj.sel[2].y or obj.sel[1].y == obj.sel[2].y and obj.sel[1].x > obj.sel[2].x then
				local ph = obj.sel[2]
				obj.sel[2] = obj.sel[1]
				obj.sel[1] = ph
			end
			
			
			local ps, pe = getSelectionChar(obj)
			
			if pe then
				obj.text = string.sub(obj.text, 1, ps - 1) .. string.sub(obj.text, pe + 1)
			else
				if ps > 0 then
					if obj.sel[1].x > 0 or obj.sel[1].y > 1 then
						obj.text = string.sub(obj.text, 1, ps - 2) .. string.sub(obj.text, ps)
						
						
						obj.sel[1].x = obj.sel[1].x - 1
						
						if obj.sel[1].x < 0 then
							obj.sel[1].y = obj.sel[1].y - 1
							obj.sel[1].x = string.len(cmath.getStringRow(obj.text, obj.sel[1].y))
						end
					end
				end
			end
			obj.sel[2] = obj.sel[1]
		end
	end
	
	
	if percX ~= percX then
		percX = 0
	end
	if percY ~= percY then
		percY = 0
	end
	
	
	setScrollPercentX(obj, cmath.clamp(percX, 0, 1))
	setScrollPercentY(obj, cmath.clamp(percY, 0, 1))
	
	
	--[[if (key ~= 0 and key ~= 1) then
		local ps, pe = getSelectionChar(obj)
		
		if obj.sel[2] and (obj.sel[2].y < obj.sel[1].y or obj.sel[2].y == obj.sel[1].y and obj.sel[2].x < obj.sel[1].x) then
			local ph = obj.sel[2]
			obj.sel[2] = obj.sel[1]
			obj.sel[1] = ph
		end
		
		if ps == pe then
			obj.text = string.sub(obj.text, 1, ps - 1) .. key .. string.sub(obj.text, ps)
			
			obj.sel[2] = nil
			obj.sel[1].x = obj.sel[1].x + 1
		else
			obj.text = string.sub(obj.text, 1, ps - 1) .. key .. string.sub(obj.text, pe + 1)
			
			obj.sel[2] = nil
			obj.sel[1].x = obj.sel[1].x + 1
		end
	else
		if key == 1 then
			local ps, pe = getSelectionChar(obj)
			
			if ps == 1 then
				return
			end
			
			
			if string.sub(obj.text, ps - 1, ps - 1) == "\n" then
				obj.sel[1].y = obj.sel[1].y - 1
			end
			
			obj.text = string.sub(obj.text, 1, ps - 2) .. string.sub(obj.text, pe)
			
			obj.sel[2] = nil
			obj.sel[1].x = obj.sel[1].x - 1
			
			if obj.sel[1].x < 0 then
				obj.sel[1].x = string.len(cmath.getStringRow(obj.text, obj.sel[1].y))
			end
			
			
			local ph = getScrollPercentX(obj)
			if ph ~= ph then
				ph = 1
			end
			setScrollPercentX(obj, cmath.clamp(ph, 0, 1))
		else
			local ps, pe = getSelectionChar(obj)
			
			outputChatBox(ps .. "; " .. pe .. "\n" .. string.sub(obj.text, ps, pe))
			outputChatBox(obj.sel[1].x .. "; " .. obj.sel[1].y)
		end
	end]]
end


function dxgui_CreateMemo(px, py, pw, ph, pText, relative, parent)
	local rt = dxCreateRenderTarget(pw - dragSpace, ph - dragSpace, true)
	
	if not rt then
		outputChatBox("[DXGUI] Es konnte keine Memo-Komponente erzeugt werden! Deine Anzeige koennte fehlerhaft sein!", 255, 0, 0)
		outputChatBox("(Hardware Limitation)", 255, 0, 0)
		dxgui_CreateMemo_alt(px, py, pw, ph, pText, relative, parent)
		return
	end
	
	
	local new = {
		element = createElement("dxgui"),
		kill = false,
		enabled = true,
		visible = true,
		alpha = 0,
		
		-- Main functions
		draw = draw,
		click = click,
		drag = drag,
		scroll = scroll,
		keyPressed = keyPressed,
		
		x = px,
		y = py,
		w = pw,
		h = ph,
		
		-- "class"-specific values
		text = pText,
		rt = rt,
		scrollX = 0,
		scrollY = 0,
		scrollDrag = false,
		sel = { [1] = nil, [2] = nil, },
		staySelected = true,
		anim = 0,
	}
	
	local newActive = {
		element = new.element,
		rt = rt,
	}
	table.insert(activeRenderTargets, newActive)
	
	
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


function dxgui_MemoGetText(element)
	local ph = dxgui_GetElementTable(element)
	
	if ph.guielement then
		return guiGetText(ph.guielement)
	else
		return ph.text
	end
end


function dxgui_MemoSetText(element, pText)
	local ph = dxgui_GetElementTable(element)
	
	if ph.guielement then
		guiSetText(ph.guielement, pText)
	else
		ph.text = pText
	end
end


function dxgui_MemoGetGUI(element)
	return dxgui_GetElementTable(element).guielement
end


local function killRenderTarget()
	if getElementType(source) == "dxgui" then
		for a, b in ipairs(activeRenderTargets) do
			if b.element == source then
				if not isElement(b.rt) then
					table.remove(activeRenderTargets, a)
					break
				end
				
				destroyElement(b.rt)
				
				table.remove(activeRenderTargets, a)
				break
			end
		end
	end
end
addEventHandler("onClientElementDestroy", getRootElement(), killRenderTarget)


local function copyPasteSelection(key, pressed)
	if key == "c" and pressed and getKeyState("lctrl") then
		if dxgui_Selection and dxgui_Selection.sel and dxgui_Selection.sel[2] then
			if dxgui_Selection.sel[2] and dxgui_Selection.sel[1].y > dxgui_Selection.sel[2].y or dxgui_Selection.sel[1].y == dxgui_Selection.sel[2].y and dxgui_Selection.sel[1].x > dxgui_Selection.sel[2].x then
				local ph = dxgui_Selection.sel[2]
				dxgui_Selection.sel[2] = dxgui_Selection.sel[1]
				dxgui_Selection.sel[1] = ph
			end
			
			local ps, pe = getSelectionChar(dxgui_Selection)
			
			if pe then
				clipboard = string.sub(dxgui_Selection.text, ps, pe)
				setClipboard(clipboard)
				infomsg("Auswahl kopiert", 255, 255, 255)
			end
		end
	elseif key == "v" and pressed and getKeyState("lctrl") then
		if dxgui_Selection and dxgui_Selection.sel then
			if dxgui_Selection.sel[2] then
				if dxgui_Selection.sel[1].y > dxgui_Selection.sel[2].y or dxgui_Selection.sel[1].y == dxgui_Selection.sel[2].y and dxgui_Selection.sel[1].x > dxgui_Selection.sel[2].x then
					local ph = dxgui_Selection.sel[2]
					dxgui_Selection.sel[2] = dxgui_Selection.sel[1]
					dxgui_Selection.sel[1] = ph
				end
				
				local ps, pe = getSelectionChar(dxgui_Selection)
			
				if pe then
					dxgui_Selection.text = string.sub(dxgui_Selection.text, 1, ps - 1) .. string.sub(dxgui_Selection.text, pe + 1)
				end
				
				dxgui_Selection.sel[2] = dxgui_Selection.sel[1]
			end
			
			for i = 1, string.len(clipboard), 1 do
				keyPressed(dxgui_Selection, string.sub(clipboard, i, i))
			end
		end
	end
end
addEventHandler("onClientKey", getRootElement(), copyPasteSelection)