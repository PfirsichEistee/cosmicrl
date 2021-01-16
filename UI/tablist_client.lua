
local anim = 0
local tabWidth = screenX * 0.4
local tabHeight = screenY * 0.4

local scroll = 0

local wasOpen = false



local function getPingColor(ping)
	if ping < 45 then
		return 0, 255, 0
	elseif ping < 100 then
		return 255, 255, 0
	else
		return 255, 0, 0
	end
end


local function render()
	if getKeyState("tab") and getElementData(getLocalPlayer(), "Online") then
		anim = cmath.move_towards(anim, 1, delta * 4)
	else
		anim = cmath.move_towards(anim, 0, delta * 4)
	end
	
	
	if anim > 0 then
		local animW = cmath.clamp(anim * 3, 0, 1)
		local animH = cmath.clamp(anim * 3 - 1, 0.05, 1)
		local animT = cmath.clamp(anim * 3 - 2, 0, 1) -- text
		
		local space = tabWidth * 0.01
		
		dxDrawRectangle((screenX - tabWidth * animW - space) / 2, (screenY - tabHeight * animH) / 2, tabWidth * animW + space, tabHeight * animH, tocolor(0, 0, 0, 155))
		
		if animT > 0 then
			if not wasOpen then
				wasOpen = true
				toggleControl("next_weapon", false)
				toggleControl("previous_weapon", false)
			end
			
			
			local px, py = (screenX - tabWidth) / 2, (screenY - tabHeight) / 2
			local ph = tabHeight / 17
			local textSize = (1 / dxGetFontHeight(1, dxgui_FontA)) * ph * 0.75
			dxDrawRectangle(px - space / 2, py, tabWidth + space, ph, tocolor(100, 100, 255, 155))
			dxDrawRectangle(px - space / 2, py + ph * 16, tabWidth + space, ph, tocolor(100, 100, 255, 155))
			
			dxDrawText("Name", px, py, px + tabWidth, py + ph, tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
			dxDrawText("Status", px + tabWidth * 0.25, py, px + tabWidth, py + ph, tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
			dxDrawText("Fraktion", px + tabWidth * 0.5, py, px + tabWidth, py + ph, tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
			dxDrawText("Spielzeit", px + tabWidth * 0.75, py, px + tabWidth, py + ph, tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
			dxDrawText("Ping", px + tabWidth * 0.9, py, px + tabWidth, py + ph, tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
			
			dxDrawText(_servername .. " Reallife", px, py + tabHeight - ph, px + tabWidth, py + tabHeight, tocolor(255, 255, 255, 255 * animT), textSize * 1.08, dxgui_FontA, "left", "center", true, false)
			dxDrawText(_forum, px, py + tabHeight - ph, px + tabWidth, py + tabHeight, tocolor(255, 255, 255, 255 * animT), textSize * 1.08, dxgui_FontA, "right", "center", true, false)
			
			
			local player = getElementsByType("player")
			scroll = cmath.clamp(scroll, 1, #player)
			for i = scroll, #player, 1 do
				if i <= 15 then
					dxDrawText(getPlayerName(player[i]), px, py + ph * i, px + tabWidth, py + ph * (i + 1), tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
					dxDrawText(getElementData(player[i], "Playtime"), px + tabWidth * 0.75, py + ph * i, px + tabWidth, py + ph * (i + 1), tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
					
					local ping = getPlayerPing(player[i])
					local r, g, b = getPingColor(ping)
					dxDrawText(ping, px + tabWidth * 0.9, py + ph * i, px + tabWidth, py + ph * (i + 1), tocolor(r, g, b, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
				end
			end
		else
			if wasOpen then
				wasOpen = false
				toggleControl("next_weapon", true)
				toggleControl("previous_weapon", true)
			end
		end
	else
		if wasOpen then
			wasOpen = false
			toggleControl("next_weapon", true)
			toggleControl("previous_weapon", true)
		end
	end
end
addEventHandler("onClientRender", getRootElement(), render)


--[[local function stopWeaponSwitch(prev, current) -- looks really bad
	if anim > 0.5 then
		cancelEvent()
	end
end
addEventHandler("onClientPlayerWeaponSwitch", getLocalPlayer(), stopWeaponSwitch)]]


local function scrollList(key, pressed)
	if pressed and (key == "mouse_wheel_up" or key == "mouse_wheel_down") then
		local dir = 0
		if key == "mouse_wheel_up" then
			dir = 1
		else
			dir = -1
		end
		
		scroll = scroll + dir
	end
end
addEventHandler("onClientKey", getRootElement(), scrollList)