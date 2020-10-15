
addEvent("setClientHUDVisible", true)


local visible = false

local lp = getLocalPlayer()

local phW = 0.175 * screenX
local phH = 0.325 * screenY
local phX = screenX - phW
local phY = 0

local imgSize = phW * 0.35

local rowH = imgSize / 3

local space = rowH * 0.1

--local mfs = (1 / dxGetFontHeight(1, "pricedown")) * rowH
local mfs = (1 / dxGetTextWidth("0", 1, "pricedown")) * (phW / 9) -- money font scale
local mfh = dxGetFontHeight(mfs, "pricedown")


local plus = 0.01 * phW

phX = phX - space * 2
phY = space * 2



local function hudRect(x, y, w, h, r, g, b, mul)
	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 255))
	dxDrawRectangle(x + h * 0.15, y + h * 0.15, w - h * 0.3, h - h * 0.3, tocolor(cmath.clamp(r - 100, 0, 255), cmath.clamp(g - 100, 0, 255), cmath.clamp(b - 100, 0, 255), 255))
	dxDrawRectangle(x + h * 0.15, y + h * 0.15, (w - h * 0.3) * mul, h - h * 0.3, tocolor(r, g, b, 255))
end


local function hudText(text, x, y, tx, ty, color, fontSize, font, aX, aY)
	dxDrawText(text, x + plus, y + plus, tx + plus, ty + plus, tocolor(0, 0, 0, 255), fontSize, font, aX, aY)
	dxDrawText(text, x - plus, y + plus, tx - plus, ty + plus, tocolor(0, 0, 0, 255), fontSize, font, aX, aY)
	dxDrawText(text, x + plus, y - plus, tx + plus, ty - plus, tocolor(0, 0, 0, 255), fontSize, font, aX, aY)
	dxDrawText(text, x - plus, y - plus, tx - plus, ty - plus, tocolor(0, 0, 0, 255), fontSize, font, aX, aY)
	
	dxDrawText(text, x, y, tx, ty, color, fontSize, font, aX, aY)
end


local function render()
	if not visible or isPedDead(lp) then
		return
	end
	
	
	dxDrawImage(phX, phY, imgSize, imgSize, "images/hud/" .. getPedWeapon(lp) .. ".png")
	
	local txt = getPedAmmoInClip(lp) .. "/" .. (getPedTotalAmmo(lp) - getPedAmmoInClip(lp))
	if txt ~= "0/1" then
		hudText(txt, phX, phY, phX + imgSize, phY + imgSize + space, tocolor(255, 255, 255, 255), (1 / dxGetFontHeight(1, "pricedown")) * imgSize * 0.275, "pricedown", "center", "bottom")
	end
	
	local hour, minute = getTime()
	if string.len(hour) == 1 then hour = "0" .. hour end
	if string.len(minute) == 1 then minute = "0" .. minute end
	hudText(hour .. ":" .. minute, phX + imgSize + space + plus, phY + plus, phX + phW + plus, phY + (imgSize - rowH) + plus, tocolor(255, 255, 255, 255), (1 / dxGetFontHeight(1, "pricedown")) * (imgSize - rowH), "pricedown", "center", "center")
	
	hudRect(phX + imgSize + space, phY + imgSize - rowH, phW - imgSize - space, rowH, 200, 130, 0, 000000 / 100) -- hunger
	
	hudRect(phX, phY + imgSize + space, phW, rowH, 200, 0, 0, getElementHealth(lp) / 100) -- health
	
	hudRect(phX, phY + imgSize + space * 2 + rowH, phW, rowH, 175, 175, 175, getPedArmor(lp) / 100) -- armor
	
	
	local money = cosmicClientGetElementData(lp, "Money")
	if money > 99999999 then
		money = 99999999
	end
	while string.len(money) < 8 do
		money = "0" .. money
	end
	money = "$" .. money
	local py = phY + imgSize + space * 3 + rowH * 2 - mfh * 0.2
	for i = 0, 8, 1 do
		hudText(string.sub(money, i + 1, i + 1), phX + ((phW / 9) * i), py, phX + ((phW / 9) * i) + 1, py + 1, tocolor(0, 200, 0, 255), mfs, "pricedown", "left", "top")
	end
	
	
	local wanteds = getPlayerWantedLevel()
	py = phY + imgSize + space * 4 + rowH * 2 + mfh * 0.6
	local starSize = ((phW - space * 5) / 6)
	for i = 0, 5, 1 do
		dxDrawImage(phX + ((starSize + space) * i), py, starSize, starSize, "images/hud/star.png", 0, 0, 0, tocolor(0, 0, 0, 155))
		if (wanteds >= (i + 1)) then
			dxDrawImage(phX + ((starSize + space) * i) + starSize * 0.1, py + starSize * 0.1, starSize - starSize * 0.2, starSize - starSize * 0.2, "images/hud/star.png", 0, 0, 0, tocolor(255, 255, 0, 255))
		end
	end
	
	
	drawMinimap()
	
	
	-- DEVELOPMENT
	local lp = lp
	if getPedOccupiedVehicle(lp) then
		lp = getPedOccupiedVehicle(lp)
	end
	local x, y, z = getElementPosition(lp)
	local rx, ry, rz = getElementRotation(lp)
	local sppp = 0.5
	
	x = math.floor(x * 1000) / 1000
	y = math.floor(y * 1000) / 1000
	z = math.floor(z * 1000) / 1000
	rx = math.floor(rx * 1000) / 1000
	ry = math.floor(ry * 1000) / 1000
	rz = math.floor(rz * 1000) / 1000
	
	dxDrawText(x .. ", " .. y .. ", " .. z .. "\n" .. rx .. ", " .. ry .. ", " .. rz .. "\nType /dp to print", screenX * 0.3 + sppp, screenY * 0.01 + sppp, screenX, screenY, tocolor(0, 0, 0, 255), 2)
	dxDrawText(x .. ", " .. y .. ", " .. z .. "\n" .. rx .. ", " .. ry .. ", " .. rz .. "\nType /dp to print", screenX * 0.3 - sppp, screenY * 0.01 + sppp, screenX, screenY, tocolor(0, 0, 0, 255), 2)
	dxDrawText(x .. ", " .. y .. ", " .. z .. "\n" .. rx .. ", " .. ry .. ", " .. rz .. "\nType /dp to print", screenX * 0.3 + sppp, screenY * 0.01 - sppp, screenX, screenY, tocolor(0, 0, 0, 255), 2)
	dxDrawText(x .. ", " .. y .. ", " .. z .. "\n" .. rx .. ", " .. ry .. ", " .. rz .. "\nType /dp to print", screenX * 0.3 - sppp, screenY * 0.01 - sppp, screenX, screenY, tocolor(0, 0, 0, 255), 2)
	dxDrawText(x .. ", " .. y .. ", " .. z .. "\n" .. rx .. ", " .. ry .. ", " .. rz .. "\nType /dp to print", screenX * 0.3, screenY * 0.01, screenX, screenY, tocolor(255, 255, 255, 255), 2)
end
addEventHandler("onClientRender", root, render)


local function debugPrintShitTestRemoveLater()
	local x, y, z = getElementPosition(lp)
	local rx, ry, rz = getElementRotation(lp)
	outputChatBox(x .. ", " .. y .. ", " .. z )
	outputChatBox(rx .. ", " .. ry .. ", " .. rz)
end
addCommandHandler("dp", debugPrintShitTestRemoveLater)




function setClientHUDVisible(v)
	visible = v
	
	setPlayerHudComponentVisible("ammo", false)
	setPlayerHudComponentVisible("armour", false)
	setPlayerHudComponentVisible("breath", false)
	setPlayerHudComponentVisible("clock", false)
	setPlayerHudComponentVisible("health", false)
	setPlayerHudComponentVisible("money", false)
	setPlayerHudComponentVisible("weapon", false)
	setPlayerHudComponentVisible("wanted", false)
	setPlayerHudComponentVisible("radar", false)
end
addEventHandler("setClientHUDVisible", getRootElement(), setClientHUDVisible)


function isClientHUDVisible()
	return visible
end