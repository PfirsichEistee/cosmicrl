
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

local lastPlayerHP = -1
local dmgAnim = 0
local bloodAnim = 0
local deathAnim = 0


-- Level
local lvlBarW = 0.3 * screenX
local lvlBarH = 0.008 * screenY
local lvlBarX = (screenX - lvlBarW) / 2
local lvlBarY = lvlBarH * 5 + lvlBarH / 2
local lvlImgSize = lvlBarH * 8
local lvlFontSize = (1 / dxGetFontHeight(1, "pricedown")) * lvlImgSize * 0.6
local lvlLevel = 36
local lvlExp = 0 -- in % from 0 to 1
local lvlTimer = 0



local minigame = {
	pixsize = (screenY / 4) * 3,
	size = 25,
	snake = {},
	foodX = 1,
	foodY = 1,
	dirX = 1,
	dirY = 0,
	timer = 0,
	reset = true,
	active = false,
}



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


local function drawLevel()
	local totalExp = cosmicClientGetElementData(getLocalPlayer(), "Exp") or 0
	local targetLvl = getLevel(totalExp)
	
	totalExp = totalExp - getExp(lvlLevel)
	local targetExp = totalExp / (getExp(lvlLevel + 1) - getExp(lvlLevel))
	
	if lvlLevel > targetLvl then
		lvlLevel = targetLvl
	elseif lvlLevel == targetLvl and lvlExp > targetExp then
		lvlExp = targetExp
	end
	
	if lvlLevel == targetLvl and math.abs(lvlExp - targetExp) <= 0.001 then
		if lvlTimer <= 0 then
			return
		end
		lvlTimer = lvlTimer - delta
	else
		lvlTimer = 4
	end
	
	if lvlLevel ~= targetLvl then
		lvlExp = cmath.lerp(lvlExp, 1, delta * 10)
		
		if math.abs(lvlExp - 1) <= 0.01 then
			lvlLevel = lvlLevel + 1
			lvlExp = 0
		end
	else
		lvlExp = cmath.lerp(lvlExp, targetExp, delta * 10)
	end
	
	
	
	hudRect(lvlBarX, lvlBarY - lvlBarH / 2, lvlBarW, lvlBarH, 100, 100, 255, lvlExp)
	
	dxDrawImage(lvlBarX - lvlImgSize / 2, lvlBarY - lvlImgSize / 2, lvlImgSize, lvlImgSize, "images/hud/level.png", 0, 0, 0)
	dxDrawImage(lvlBarX + lvlBarW - lvlImgSize / 2, lvlBarY - lvlImgSize / 2, lvlImgSize, lvlImgSize, "images/hud/level.png", 0, 0, 0)
	
	hudText(lvlLevel, lvlBarX, lvlBarY, lvlBarX, lvlBarY, tocolor(255, 255, 255, 255), lvlFontSize, "pricedown", "center", "center")
	hudText(lvlLevel + 1, lvlBarX + lvlBarW, lvlBarY, lvlBarX + lvlBarW, lvlBarY, tocolor(255, 255, 255, 255), lvlFontSize, "pricedown", "center", "center")
end


local function render()
	if getElementHealth(lp) < lastPlayerHP then
		dmgAnim = 1
	end
	if lastPlayerHP > 0 and getElementHealth(lp) <= 0 then
		bloodAnim = 1
	end
	lastPlayerHP = getElementHealth(lp)
	
	if deathAnim > 0 then
		dxDrawRectangle(0, 0, screenX, screenY, tocolor(0, 0, 0, 255 * deathAnim))
	end
	if dmgAnim > 0 then
		dmgAnim = dmgAnim - delta * 3
		if dmgAnim < 0 then
			dmgAnim = 0
		end
		
		dxDrawImage(0, 0, screenX, screenY, "images/hud/dmg.png", 0, 0, 0, tocolor(255, 255, 255, 255 * dmgAnim))
	end
	if bloodAnim > 0 then
		bloodAnim = bloodAnim - delta * 0.1
		if bloodAnim < 0 then
			bloodAnim = 0
		end
		
		dxDrawImage(0, 0, screenX, screenY, "images/hud/blood.png", 0, 0, 0, tocolor(255, 255, 255, 255 * bloodAnim))
	end
	
	
	
	if not visible then
		return
	elseif isPedDead(lp) then
		deathAnim = cmath.move_towards(deathAnim, 1, delta * 5)
		drawWasted()
		
		return
	end
	deathAnim = cmath.move_towards(deathAnim, 0, delta * 5)
	minigame.reset = true
	minigame.active = false
	
	
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
		--hudText(string.sub(money, i + 1, i + 1), phX + ((phW / 9) * i), py, phX + ((phW / 9) * i) + 1, py + 1, tocolor(0, 200, 0, 255), mfs, "pricedown", "left", "top")
		--hudText(string.sub(money, i + 1, i + 1), phX + ((phW / 9) * i) + ((phW / 9) / 2), py, phX + ((phW / 9) * i) + 1 + ((phW / 9) / 2), py + 1, tocolor(0, 200, 0, 255), mfs, "pricedown", "center", "top")
		hudText(string.sub(money, i + 1, i + 1), phX + ((phW / 9) * i), py, phX + ((phW / 9) * (i + 1)), py + 1, tocolor(0, 200, 0, 255), mfs, "pricedown", "center", "top")
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
	drawGauge()
	drawLevel()
	
	
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
	
	dxDrawText(x .. ", " .. y .. ", " .. z .. "\n" .. rx .. ", " .. ry .. ", " .. rz .. "\nType /dp to print", screenX * 0.3 + sppp, screenY * 0.08 + sppp, screenX, screenY, tocolor(0, 0, 0, 255), 2)
	dxDrawText(x .. ", " .. y .. ", " .. z .. "\n" .. rx .. ", " .. ry .. ", " .. rz .. "\nType /dp to print", screenX * 0.3 - sppp, screenY * 0.08 + sppp, screenX, screenY, tocolor(0, 0, 0, 255), 2)
	dxDrawText(x .. ", " .. y .. ", " .. z .. "\n" .. rx .. ", " .. ry .. ", " .. rz .. "\nType /dp to print", screenX * 0.3 + sppp, screenY * 0.08 - sppp, screenX, screenY, tocolor(0, 0, 0, 255), 2)
	dxDrawText(x .. ", " .. y .. ", " .. z .. "\n" .. rx .. ", " .. ry .. ", " .. rz .. "\nType /dp to print", screenX * 0.3 - sppp, screenY * 0.08 - sppp, screenX, screenY, tocolor(0, 0, 0, 255), 2)
	dxDrawText(x .. ", " .. y .. ", " .. z .. "\n" .. rx .. ", " .. ry .. ", " .. rz .. "\nType /dp to print", screenX * 0.3, screenY * 0.08, screenX, screenY, tocolor(255, 255, 255, 255), 2)
end
addEventHandler("onClientRender", root, render)


local function debugPrintShitTestRemoveLater()
	local x, y, z = getElementPosition(lp)
	local rx, ry, rz = getElementRotation(lp)
	outputChatBox(x .. ", " .. y .. ", " .. z )
	outputChatBox(rx .. ", " .. ry .. ", " .. rz)
end
addCommandHandler("dp", debugPrintShitTestRemoveLater)



local function square(x, y, color)
	local px = (screenX - minigame.pixsize) / 2
	local py = (screenY - minigame.pixsize) / 2
	dxDrawRectangle(px + (minigame.pixsize / minigame.size) * x, py + (minigame.pixsize / minigame.size) * y, minigame.pixsize / minigame.size, minigame.pixsize / minigame.size, color)
end

local function isSnakeAt(x, y)
	for a, b in ipairs(minigame.snake) do
		if b.x == x and b.y == y then
			return true
		end
	end
	return false
end

function drawWasted()
	--dxDrawRectangle(0, 0, screenX, screenY, tocolor(0, 0, 0, 255))
	
	dxDrawText("wasted.", 0, 0, screenX, screenY, tocolor(255, 0, 0, 255), 3, "pricedown", "center", "center")
	
	
	-- minigame
	if not minigame.active then
		return
	end
	if minigame.reset then
		minigame.reset = false
		
		minigame.snake = {
			[1] = {
				x = math.floor(minigame.size / 2),
				y = math.floor(minigame.size / 2),
			},
		}
		
		minigame.foodX = math.floor(math.random() * minigame.size)
		minigame.foodY = math.floor(math.random() * minigame.size)
	end
	
	
	local px = (screenX - minigame.pixsize) / 2
	local py = (screenY - minigame.pixsize) / 2
	dxDrawLine(px, py, px + minigame.pixsize, py, tocolor(255, 0, 0, 255))
	dxDrawLine(px, py + minigame.pixsize, px + minigame.pixsize, py + minigame.pixsize, tocolor(255, 0, 0, 255))
	dxDrawLine(px, py, px, py + minigame.pixsize, tocolor(255, 0, 0, 255))
	dxDrawLine(px + minigame.pixsize, py, px + minigame.pixsize, py + minigame.pixsize, tocolor(255, 0, 0, 255))
	
	square(minigame.foodX, minigame.foodY, tocolor(190, 0, 0, 180))
	
	
	if minigame.timer <= 0 then
		local phX = minigame.snake[1].x + minigame.dirX
		local phY = minigame.snake[1].y + minigame.dirY
		
		if phX == minigame.foodX and phY == minigame.foodY then
			local ph = minigame.snake[#minigame.snake]
			
			for i = #minigame.snake, 2, -1 do
				minigame.snake[i] = minigame.snake[i - 1]
			end
			
			table.insert(minigame.snake, ph)
			
			minigame.snake[1] = {
				x = minigame.foodX,
				y = minigame.foodY,
			}
			
			for i = 1, 5000, 1 do
				minigame.foodX = math.floor(math.random() * minigame.size)
				minigame.foodY = math.floor(math.random() * minigame.size)
				
				local found = false
				for a, b in ipairs(minigame.snake) do
					if minigame.foodX == b.x and minigame.foodY == b.y then
						found = true
						break
					end
				end
				
				if not found then
					break
				end
			end
		else
			for i = #minigame.snake, 2, -1 do
				minigame.snake[i].x = minigame.snake[i - 1].x
				minigame.snake[i].y = minigame.snake[i - 1].y
			end
			
			if isSnakeAt(minigame.snake[1].x + minigame.dirX, minigame.snake[1].y + minigame.dirY) then
				minigame.reset = true
			end
			
			minigame.snake[1].x = minigame.snake[1].x + minigame.dirX
			minigame.snake[1].y = minigame.snake[1].y + minigame.dirY
			if minigame.snake[1].x < 0 then
				minigame.snake[1].x = minigame.size - 1
			elseif minigame.snake[1].x >= minigame.size then
				minigame.snake[1].x = 0
			elseif minigame.snake[1].y < 0 then
				minigame.snake[1].y = minigame.size - 1
			elseif minigame.snake[1].y >= minigame.size then
				minigame.snake[1].y = 0
			end
		end
		
		minigame.timer = 0.05
	else
		minigame.timer = minigame.timer - delta
	end
	
	for a, b in ipairs(minigame.snake) do
		square(b.x, b.y, tocolor(255, 255, 255, 180))
	end
end

local function startMinigame(key, down)
	if not minigame.active and bloodAnim <= 0.5 then
		minigame.active = true
	end
	
	if down and minigame.snake[1] ~= nil then
		if key == "w" and not isSnakeAt(minigame.snake[1].x, minigame.snake[1].y - 1) then
			minigame.dirX = 0
			minigame.dirY = -1
		elseif key == "a" and not isSnakeAt(minigame.snake[1].x - 1, minigame.snake[1].y) then
			minigame.dirX = -1
			minigame.dirY = 0
		elseif key == "s" and not isSnakeAt(minigame.snake[1].x, minigame.snake[1].y + 1) then
			minigame.dirX = 0
			minigame.dirY = 1
		elseif key == "d" and not isSnakeAt(minigame.snake[1].x + 1, minigame.snake[1].y) then
			minigame.dirX = 1
			minigame.dirY = 0
		end
	end
end
addEventHandler("onClientKey", getRootElement(), startMinigame)






function setClientHUDVisible(v)
	visible = v
	
	if visible then
		local totalExp = cosmicClientGetElementData(getLocalPlayer(), "Exp") or 0
		lvlLevel = getLevel(totalExp)
		
		totalExp = totalExp - getExp(lvlLevel)
		lvlExp = totalExp / (getExp(lvlLevel + 1) - getExp(lvlLevel))
	end
	
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
