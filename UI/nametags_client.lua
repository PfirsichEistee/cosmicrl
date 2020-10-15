
local aimg = 1

local txtSize = (1 / dxGetFontHeight(1, dxgui_FontA)) * 0.05 * screenY

local timer = 0


local function render()
	local cx, cy, cz = getCameraMatrix()
	
	for a, b in ipairs(getElementsByType("player")) do
		local px, py, pz = getElementPosition(b)
		pz = pz + 1.25
		local dist = cmath.dist3D(cx, cy, cz, px, py, pz)
		
		if dist < 15 and isLineOfSightClear(cx, cy, cz, px, py, pz, true, false, false, true, true, false, true) then
			local x, y = getScreenFromWorldPosition(px, py, pz, 0, false)
			
			if x then
				dxDrawText(getPlayerName(b), x, y, x, y, tocolor(255 - getElementHealth(b) * 2.55, getElementHealth(b) * 2.55, 0, 255), txtSize, dxgui_FontA, "center", "top", false, false, false, false)
				dxDrawText(getPlayerName(b), x, y, x, y, tocolor(200, 200, 200, getPedArmor(b) * 2.55), txtSize, dxgui_FontA, "center", "top", false, false, false, false)
				
				local alvl = getElementData(b, "Adminlevel")
				
				if alvl and alvl > 0 then
					dxDrawImage(x - dxGetTextWidth(getPlayerName(b), txtSize, dxgui_FontA) * 0.5 - 0.05 * screenY, y, 0.05 * screenY, 0.05 * screenY, "images/else/admin" .. aimg .. ".png", 0, 0, 0, tocolor(255, 255, 255, 200))
				end
			end
		end
	end
	
	
	timer = timer + delta
	
	if timer >= 0.13 then
		aimg = aimg + 1
		
		if aimg > 8 then
			aimg = 1
		end
		
		timer = 0
	end
end
addEventHandler("onClientRender", root, render)