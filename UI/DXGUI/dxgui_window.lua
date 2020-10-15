
local fontScale = (1 / dxGetFontHeight(1, dxgui_FontA)) * titleHeight * 0.7


local function draw(obj, delta)
	dxDrawRectangle(obj.x, obj.y, obj.w, obj.h, tocolor(0, 0, 0, 160 * obj.alpha))
	
	
	-- Draw objects
	for a, b in ipairs(obj.child) do
		b.draw(b, delta, obj.x, obj.y)
	end
	
	
	-- Kill objects
	for i = #obj.child, 1, -1 do
		if (obj.child[i].kill == true and obj.child[i].alpha <= 0) then
			table.remove(obj.child, i)
		end
	end
	
	
	dxDrawRectangle(obj.x, obj.y, obj.w, titleHeight, tocolor(0, 130, 220, 220 * obj.alpha))
	dxDrawText(obj.title, obj.x, obj.y, obj.x + obj.w, obj.y + titleHeight, tocolor(255, 255, 255, 255 * obj.alpha), fontScale, dxgui_FontA, "center", "center", true, false)
end

local function click(obj, down, x, y)
	if (obj.enabled == false) then
		return
	end
	
	if (down == true and y > (obj.y + titleHeight)) then
		for a, b in ipairs(obj.child) do
			if (b.kill == false and cmath.isPointInRect(x, y, b.x + obj.x, b.y + obj.y, b.w, b.h) == true) then
				dxgui_SetSelection(b)
				
				b.click(b, down, x - obj.x, y - obj.y)
				
				return
			end
		end
	end
	
	if (down == true) then
		if (cmath.isPointInRect(x, y, obj.x, obj.y, obj.x + obj.w, obj.y + obj.h) == true) then
			obj.dragX = x - obj.x
			obj.dragY = y - obj.y
		end
	end
	
	obj.isDragging = false
end

local function drag(obj)
	if (obj.enabled == false) then
		obj.isDragging = false
		return
	end
	
	if (obj.isDragging == true) then
		obj.x = mouseX - obj.dragX
		obj.y = mouseY - obj.dragY
	else
		if (cmath.dist2D(mouseX - obj.x, mouseY - obj.y, obj.dragX, obj.dragY) > (0.01 * screenX)) then
			if (cmath.isPointInRect(obj.dragX, obj.dragY, 0, 0, obj.w, titleHeight) == false) then
				dxgui_ClearSelection()
			end
			
			obj.isDragging = true
		end
	end
end


function dxgui_CreateWindow(px, py, pw, ph, pTitle, relative)
	local new = {
		element = createElement("dxgui"),
		kill = false,
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
		child = {},
		title = pTitle,
		isDragging = false,
		dragX = 0,
		dragY = 0,
	}
	
	if (relative == true) then
		new.x = new.x * screenX
		new.y = new.y * screenY
		new.w = new.w * screenX
		new.h = new.h * screenY
	end
	
	dxgui_AddItem(new)
	
	return new.element
end