

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
end

local function click(obj, down, x, y)
	if (obj.enabled == false) then
		return
	end
	
	if (down == true) then
		for a, b in ipairs(obj.child) do
			if (b.kill == false and cmath.isPointInRect(x, y, b.x + obj.x, b.y + obj.y, b.w, b.h) == true) then
				dxgui_SetSelection(b)
				
				b.click(b, down, x - obj.x, y - obj.y)
				
				break
			end
		end
	end
end


function dxgui_CreateRectangle(px, py, pw, ph, relative)
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
		child = {},
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