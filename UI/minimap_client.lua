

local mapImg = dxCreateTexture("images/map/map.jpg", "dxt1", true, "clamp")
local imgW, imgH = dxGetMaterialSize(mapImg)
local lp = getLocalPlayer()


local space = 0.0125 * screenY
local mapW = 0.225 * screenX
local mapH = 0.225 * screenY
local mapX = space * 2
local mapY = screenY - mapH - space * 2


local secW = 600
local secH = (mapH / mapW) * secW

local tarSecW = 600



local function worldToMinimap(x, y)
	return (((x + 3000) / 6000) * imgW), ((1 - ((y + 3000) / 6000)) * imgH)
end


-- .. is being called by hud_client.lua
function drawMinimap()
	local e = getPedOccupiedVehicle(lp)
	if not e then
		e = lp
		tarSecW = 600
	else
		local vx, vy, vz = getElementVelocity(e)
		tarSecW = 750 + cmath.dist3D(0, 0, 0, vx * 400, vy * 400, vz * 400)
	end
	
	local x, y, z = getElementPosition(e)
	x = (x + 3000) / 6000
	y = 1 - ((y + 3000) / 6000)
	
	
	if secW ~= tarSecW then
		secW = cmath.lerp(secW, tarSecW, delta * 10) -- delta is given by dxgui
		secH = (mapH / mapW) * secW
	end
	
	
	dxDrawRectangle(mapX - space, mapY - space, mapW + space * 2, mapH + space * 2, tocolor(0, 0, 0, 125))
	
	local secX = cmath.clamp(x * imgW - secW / 2, 0, imgW - secW)
	local secY = cmath.clamp(y * imgH - secH / 2, 0, imgH - secH)
	dxDrawImageSection(mapX, mapY, mapW, mapH, secX, secY, secW, secH, mapImg, 0, 0, 0, tocolor(255, 255, 255, 255))
	--dxDrawImageSection(0, 0, 250, 250, 1, 1, 500, 500, mapImg)
	
	
	
	
	--Draw areas
	for a, b in ipairs(getElementsByType("radararea")) do
		local bx, by = worldToMinimap(getElementPosition(b))
		local bw, bh = getRadarAreaSize(b)
		bw = (bw / 6000) * imgW
		bh = (bh / 6000) * imgH
		by = by - bh
		
		if bx < (secX + secW) and (bx + bw) > secX and by < (secY + secH) and (by + bh) > secY then
			bw = cmath.clamp(bx + bw, secX, secX + secW) - bx
			bh = cmath.clamp(by + bh, secY, secY + secH) - by
			
			if bx < secX then
				bw = bw - (secX - bx)
				bx = secX
			end
			if by < secY then
				bh = bh - (secY - by)
				by = secY
			end
			
			bx = bx - secX
			by = by - secY
			
			bx, by, bw, bh = bx / secW, by / secH, bw / secW, bh / secH
			dxDrawRectangle(mapX + mapW * bx, mapY + mapH * by, mapW * bw, mapH * bh, tocolor(getRadarAreaColor(b)))
		end
	end
	
	
	-- Draw visible blips
	local s = 10000 / secH
	for a, b in ipairs(getElementsByType("blip")) do
		local bx, by, bz = getElementPosition(b)
		bx, by = worldToMinimap(bx, by)
		
		
		if bx > secX and bx < (secX + secW) and by > secY and by < (secY + secH) or cmath.dist2D(x * 6000, y * 6000, bx * 6000, by * 6000) <= getBlipVisibleDistance(b) then
			local icon = getBlipIcon(b)
			bx = (cmath.clamp(bx, secX, secX + secW) - secX) / secW
			by = (cmath.clamp(by, secY, secY + secH) - secY) / secH
			
			s = (10000 / secH) * getBlipSize(b) * 0.5
			
			local clr = tocolor(255, 255, 255, 255)
			if icon == 0 then
				if (bz - z) < 5 and (bz - z) > -5 then
					icon = "0-1"
				elseif (bz - z) >= 5 then -- up
					icon = "0-2"
				else -- down
					icon = "0-3"
				end
				
				clr = tocolor(getBlipColor(b))
			end
			
			dxDrawImage(mapX + mapW * bx - s / 2, mapY + mapH * by - s / 2, s, s, "images/map/" .. icon .. ".png", 0, 0, 0, clr)
			
			s = 10000 / secH
		end
	end
	
	
	-- Draw player arrow
	local rx, ry, rz = getElementRotation(e)
	
	if secX > 0 and secX < (imgW - secW) then
		dxDrawImage(mapX + mapW / 2 - s / 2, mapY + mapH / 2 - s / 2, s, s, "images/map/2.png", -rz)
	else
		x = (cmath.clamp(x * imgW, secX, secX + secW) - secX) / secW
		y = (cmath.clamp(y * imgH, secY, secY + secH) - secY) / secH
		
		dxDrawImage(mapX + mapW * x - s / 2, mapY + mapH * y - s / 2, s, s, "images/map/2.png", -rz)
	end
end


function getMinimapLocation()
	return mapX - space, mapY - space, mapW + space * 2, mapH + space * 2
end


function getMinimapX()
	return mapX - space
end

function getMinimapY()
	return mapY - space
end

function getMinimapSpace()
	return space
end

function getMinimapW()
	return mapW + space * 2
end
function getMinimapH()
	return mapH + space * 2
end