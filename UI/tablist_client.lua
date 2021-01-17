
local anim = 0
local tabWidth = screenX * 0.4
local tabHeight = screenY * 0.4

local scroll = 0

local wasOpen = false


local playerList = {}
local updateTimer = 1



local function formatPlaytime(m)
	local h = math.floor(m / 60)
	m = m - h * 60
	
	if string.len(m) == 1 then
		m = "0" .. m
	end
	if string.len(h) == 1 then
		h = "0" .. h
	end
	
	return h .. " : " .. m
	
	--[[local h = math.floor(m / 60)
	m = m - h * 60
	
	local d = math.floor(h / 24)
	h = h - d * 24
	
	local str = m .. "m"
	
	if h > 0 or d > 0 then
		str = h .. "h " .. str
	end
	if d > 0 then
		str = d .. "d " .. str
	end
	
	return str]]
end


local function getPingColor(ping)
	if ping < 45 then
		return 0, 255, 0
	elseif ping < 100 then
		return 255, 255, 0
	else
		return 255, 0, 0
	end
end


--[[
Info for later:
add an extra element data which holds the group-name
]]
local function updatePlayerList()
	playerList = {}
	
	local player = getElementsByType("player")
	
	-- sort by faction
	for faction = 0, #factionName, 1 do
		for a, b in ipairs(player) do
			if getElementData(b, "Online") and getElementData(b, "FactionID") == faction then
				table.insert(playerList, {
					player = b,
					name = getPlayerName(b),
					status = "WIP",
					fraktion = factionName[faction],
					fid = faction,
					gruppe = "WIP",
					spielzeit = getElementData(b, "Playtime"),
					ping = getPlayerPing(b),
				})
			end
		end
	end
	
	
	-- sort factions by rank
	for faction = 1, #factionName, 1 do
		local iStart, iEnd
		local found = false
		for a, b in ipairs(playerList) do
			if b.fraktion == factionName[faction] then
				if not found then
					found = true
					iStart = a
				end
			else
				if found then
					iEnd = a - 1
					break
				end
			end
		end
		
		if found and iStart < iEnd then
			for i = iStart, iEnd - 1, 1 do
				local highest = i
				
				for k = i + 1, iEnd, 1 do
					if getElementData(playerList[k].player, "FactionRank") > getElementData(playerList[highest].player, "FactionRank") then
						highest = k
					end
				end
				
				if highest ~= i then
					local ph = playerList[i]
					playerList[i] = playerList[highest]
					playerList[highest] = ph
				end
			end
		end
	end
	
	
	-- Dummies
	--[[for i = 1, #factionName, 1 do
		for k = 1, 6, 1 do
			table.insert(playerList, {
				player = nil,
				name = math.random(),
				status = "Neuling",
				fraktion = factionName[i],
				fid = i,
				gruppe = "-",
				spielzeit = math.floor(math.random() * 20000),
				ping = math.ceil(math.random() * 160),
			})
		end
	end]]
	
	
	-- lastly, append connecting players
	for a, b in ipairs(player) do
		if not getElementData(b, "Online") then
			table.insert(playerList, {
				player = b,
				name = getPlayerName(b),
				status = "Login...",
				fraktion = "...",
				fid = 0,
				gruppe = "...",
				spielzeit = "...",
				ping = getPlayerPing(b),
			})
		end
	end
end


local function render()
	if getKeyState("tab") and getElementData(getLocalPlayer(), "Online") then
		anim = cmath.move_towards(anim, 1, delta * 3)
	else
		anim = cmath.move_towards(anim, 0, delta * 3)
	end
	
	
	if anim > 0 then
		local animW = cmath.clamp(anim * 3, 0, 1)
		local animH = cmath.clamp(anim * 3 - 1, 0.01, 1)
		local animT = cmath.clamp(anim * 3 - 2, 0, 1) -- text
		
		local space = tabWidth * 0.01
		
		dxDrawRectangle((screenX - tabWidth * animW - space) / 2, (screenY - tabHeight * animH) / 2, tabWidth * animW + space, tabHeight * animH, tocolor(0, 0, 0, 155))
		
		if animT > 0 then
			if not wasOpen then
				wasOpen = true
				toggleControl("next_weapon", false)
				toggleControl("previous_weapon", false)
				
				updatePlayerList()
			end
			
			
			updateTimer = updateTimer - delta
			if updateTimer <= 0 then
				updateTimer = 1
				
				updatePlayerList()
			end
			
			
			local px, py = (screenX - tabWidth) / 2, (screenY - tabHeight) / 2
			local ph = tabHeight / 22
			local textSize = (1 / dxGetFontHeight(1, dxgui_FontA)) * ph * 0.75
			dxDrawRectangle(px - space / 2, py, tabWidth + space, ph, tocolor(100, 100, 255, 155))
			dxDrawRectangle(px - space / 2, py + tabHeight - ph, tabWidth + space, ph, tocolor(100, 100, 255, 155))
			
			dxDrawText("Name", px, py, px + tabWidth, py + ph, tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
			dxDrawText("Status", px + tabWidth * 0.2, py, px + tabWidth, py + ph, tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
			dxDrawText("Fraktion", px + tabWidth * 0.4, py, px + tabWidth, py + ph, tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
			dxDrawText("Gruppe", px + tabWidth * 0.6, py, px + tabWidth, py + ph, tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
			dxDrawText("Spielzeit", px + tabWidth * 0.8125, py, px + tabWidth, py + ph, tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
			dxDrawText("Ping", px + tabWidth * 0.95, py, px + tabWidth, py + ph, tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
			
			dxDrawText(_servername .. " Reallife", px, py + tabHeight - ph, px + tabWidth, py + tabHeight, tocolor(255, 255, 255, 255 * animT), textSize * 1.08, dxgui_FontA, "left", "center", true, false)
			dxDrawText(_forum, px, py + tabHeight - ph, px + tabWidth, py + tabHeight, tocolor(255, 255, 255, 255 * animT), textSize * 1.08, dxgui_FontA, "right", "center", true, false)
			dxDrawText(#playerList .. " Online", px, py + tabHeight - ph, px + tabWidth, py + tabHeight, tocolor(255, 255, 255, 255 * animT), textSize * 1.08, dxgui_FontA, "center", "center", true, false)
			
			
			scroll = cmath.clamp(scroll, 1, #playerList)
			for index = scroll, cmath.clamp(scroll + 19, scroll, #playerList), 1 do
				local i = index - scroll + 1
				
				dxDrawText(playerList[index].name, px, py + ph * i, px + tabWidth, py + ph * (i + 1), tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
				dxDrawText(playerList[index].status, px + tabWidth * 0.2, py + ph * i, px + tabWidth, py + ph * (i + 1), tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
				local r, g, b = factionColor[playerList[index].fid].r, factionColor[playerList[index].fid].g, factionColor[playerList[index].fid].b
				dxDrawText(playerList[index].fraktion, px + tabWidth * 0.4, py + ph * i, px + tabWidth, py + ph * (i + 1), tocolor(r, g, b, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
				dxDrawText(playerList[index].gruppe, px + tabWidth * 0.6, py + ph * i, px + tabWidth, py + ph * (i + 1), tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
				dxDrawText(formatPlaytime(playerList[index].spielzeit), px + tabWidth * 0.8125, py + ph * i, px + tabWidth, py + ph * (i + 1), tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
				
				r, g, b = getPingColor(playerList[index].ping)
				dxDrawText(playerList[index].ping, px + tabWidth * 0.95, py + ph * i, px + tabWidth, py + ph * (i + 1), tocolor(r, g, b, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
			end
			
			
			--[[local player = getElementsByType("player")
			scroll = cmath.clamp(scroll, 1, #player)
			for i = scroll, #player, 1 do
				if i <= 20 then
					dxDrawText(getPlayerName(player[i]), px, py + ph * i, px + tabWidth, py + ph * (i + 1), tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
					dxDrawText(getElementData(player[i], "Playtime"), px + tabWidth * 0.825, py + ph * i, px + tabWidth, py + ph * (i + 1), tocolor(255, 255, 255, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
					
					local ping = getPlayerPing(player[i])
					local r, g, b = getPingColor(ping)
					dxDrawText(ping, px + tabWidth * 0.95, py + ph * i, px + tabWidth, py + ph * (i + 1), tocolor(r, g, b, 255 * animT), textSize, dxgui_FontA, "left", "center", true, false)
				end
			end]]
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
			dir = -1
		else
			dir = 1
		end
		
		scroll = scroll + dir * 3
	end
end
addEventHandler("onClientKey", getRootElement(), scrollList)