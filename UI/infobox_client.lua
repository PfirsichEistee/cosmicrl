
addEvent("infobox", true)
addEvent("infomsg", true)

local info = {}
local boxinfo = {
	timer = 0,
}

local infoW = getMinimapW()
local rowH = 0.0225 * screenY
local space = getMinimapSpace()


function infobox(text, seconds, r, g, b)
	boxinfo.text = text
	boxinfo.timer = seconds
	boxinfo.r = r
	boxinfo.g = g
	boxinfo.b = b
end
addEventHandler("infobox", getRootElement(), infobox)


function infomsg(text, r, g, b)
	local new = {
		text = text,
		r = r,
		g = g,
		b = b,
		a = 1,
		targetY = getMinimapY() - ((#info + 1) * (rowH * 5 + space)),
		y = screenY,
		timer = 8,
	}
	
	table.insert(info, new)
end
addEventHandler("infomsg", getRootElement(), infomsg)


local function render()
	if isClientHUDVisible() then
		for i = 1, #info, 1 do
			info[i].y = cmath.lerp(info[i].y, info[i].targetY, delta * 5)
			
			info[i].timer = info[i].timer - delta
			
			if info[i].timer <= 0 then
				info[i].a = cmath.move_towards(info[i].a, 0, delta)
			end
			
			
			dxDrawRectangle(space, info[i].y, infoW, rowH * 5, tocolor(0, 0, 0, 155 * info[i].a))
			
			dxDrawText(info[i].text, space + space * 0.5, info[i].y + space * 0.5, space + infoW - space * 0.5, info[i].y + rowH * 5 - space * 0.5, tocolor(info[i].r, info[i].g, info[i].b, 255 * info[i].a), (1 / dxGetFontHeight(1, dxgui_FontA)) * (rowH - (space / 5)), dxgui_FontA, "left", "center", true, true, false)
		end
		
		for i = #info, 1, -1 do
			if info[i].timer <= 0 and info[i].a <= 0 then
				for k = i + 1, #info, 1 do
					info[k].targetY = info[k].targetY + (rowH * 5 + space)
				end
				
				table.remove(info, i)
			end
		end
	end
	
	if boxinfo.timer > 0 then
		boxinfo.timer = boxinfo.timer - delta
		
		dxDrawRectangle((screenX - 0.18 * screenX) / 2, space, screenX * 0.18, screenY * 0.2, tocolor(0, 0, 0, 155))
		
		dxDrawText(boxinfo.text, (screenX - 0.18 * screenX) / 2, space, ((screenX - 0.18 * screenX) / 2) + screenX * 0.18, space + screenY * 0.2, tocolor(boxinfo.r, boxinfo.g, boxinfo.b, 255), (1 / dxGetFontHeight(1, dxgui_FontA)) * rowH * 1.25, dxgui_FontA, "center", "center", true, true, false)
	end
end
addEventHandler("onClientRender", root, render)