
local function round(num)
	if (num - math.floor(num)) < 0.5 then
		return math.floor(num)
	else
		return math.ceil(num)
	end
end


local function clamp(num, mini, maxi)
	if (num < mini) then
		return mini
	elseif (num > maxi) then
		return maxi
	end
	return num
end


local function move_towards(num, target, delta)
	delta = clamp(delta, 0, math.abs(target - num))
	
	if (target < num) then
		delta = -delta
	end
	
	return (num + delta)
end


local function isPointInRect(x, y, rectX, rectY, rectW, rectH)
	if (x >= rectX and x <= (rectX + rectW) and y >= rectY and y <= (rectY + rectH)) then
		return true
	end
	
	return false
end


local function dist2D(x1, y1, x2, y2)
	local dx = x2 - x1
	local dy = y2 - y1
	
	return math.sqrt(dx * dx + dy * dy)
end


local function dist3D(x1, y1, z1, x2, y2, z2)
	local c = math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
	
	return math.sqrt(c * c + (z2 - z1) * (z2 - z1))
end


local function move_towards3D(x1, y1, z1, x2, y2, z2, delta)
	local dis = dist3D(x1, y1, z1, x2, y2, z2)
	if dis < delta then
		delta = dis
	end
	
	local dx, dy, dz = x2 - x1, y2 - y1, z2 - z1
	
	return x1 + ((dx / dis) * delta), y1 + ((dy / dis) * delta), z1 + ((dz / dis) * delta)
end


local function distElements(e1, e2)
	local x1, y1, z1 = getElementPosition(e1)
	local x2, y2, z2 = getElementPosition(e2)
	
	return dist3D(x1, y1, z1, x2, y2, z2)
	
	
	-- dist3D(getElementPosition(e1), getElementPosition(e2)) DOESNT WORK!
	-- Thats because it passes these values:
	-- -> x1, x2, y2, z2, nil, nil
	-- Why?
	-- After the first comma you basically say SET VALUE NR 2 TO getElementPosition(e2)
	-- ... which replaces the values previously set by getElementPosition(e1)
	
	-- This will work though:
	-- dist3D(x1, y1, z1, getElementPosition(e2))
end


local function lerp(from, to, mult)
	mult = clamp(mult, 0, 1)
	return from + ((to - from) * mult)
end


local function lerp2D(x1, y1, x2, y2, mult)
	mult = clamp(mult, 0, 1)
	return x1 + ((x2 - x1) * mult), y1 + ((y2 - y1) * mult)
end


local function lerp3D(x1, y1, z1, x2, y2, z2, mult)
	mult = clamp(mult, 0, 1)
	return x1 + ((x2 - x1) * mult), y1 + ((y2 - y1) * mult), z1 + ((z2 - z1) * mult)
end


local function smooth(from, to, mult, minSpeed)
	-- basically lerp but with minimum speed
	mult = clamp(mult, 0, 1)
	if math.abs(to - from) > 0 then
		local delta = (to - from) * mult
		
		if math.abs(delta) < minSpeed then
			return move_towards(from, to, delta)
		else
			return from + delta
		end
	end
	
	return to
end


local function dirToAngle(x, y)
	local rtd = (180 / math.pi)
	
	local angle = 0
	
	if y > 0 then
		if x > 0 then
			angle = math.asin(x)
		else
			angle = 2 * math.pi + math.asin(x)
		end
	else
		if x > 0 then
			angle = math.pi - math.asin(x)
		else
			angle = math.pi - math.asin(x)
		end
	end
	
	return 360 - (angle * rtd)
end


local function List(...)
	return {...}
end


local function getElementSpeed(element)
	-- getElementVelocity: The returned values are expressed in GTA units per 1/50th of a second. A GTA Unit is equal to one metre
	
	-- return: Speed in m/s
	
	return dist3D(0, 0, 0, getElementVelocity(element)) / (1 / 50)
end


local function getAngle3D(x1, y1, z1, x2, y2, z2)
	-- cos(q) = ( a * b ) / ( |a|*|b| )
	local ph1 = math.sqrt(x1 * x1 + y1 * y1 + z1 * z1)
	local ph2 = math.sqrt(x2 * x2 + y2 * y2 + z2 * z2)
	
	local ab = x1 * x2 + y1 * y2 + z1 * z2
	
	return math.acos(ab / (ph1 * ph2))
end


local function round(value)
	if (value - math.floor(value)) < 0.5 then
		return math.floor(value)
	end
	return math.ceil(value)
end


local function getStringMaxRows(str)
	local ph, rows = string.gsub(str, "\n", "\n")
	
	return rows + 1
end


local function getStringRowStartAndEnd(str, row)
	local startChar = 1
	local endChar = string.find(str, "\n", startChar)
	
	for i = 1, (row - 1), 1 do
		startChar = string.find(str, "\n", startChar) + 1
		endChar = string.find(str, "\n", startChar)
	end
	
	if endChar then
		return startChar, endChar - 1
	else
		return startChar
	end
end


local function getStringRow(str, row)
	local s, e = getStringRowStartAndEnd(str, row)
	return string.sub(str, getStringRowStartAndEnd(str, row))
end


local function isPedLookingAt(ped, eleX, eleY, eleZ)
	local x, y, z = getElementPosition(ped)
	
	local dx, dy, dz = eleX - x, eleY - y, eleZ - z
	
	local pedForward = Matrix(Vector3(getElementPosition(ped)), Vector3(getElementRotation(ped))):getForward()
	
	local angle = getAngle3D(pedForward.x, pedForward.y, pedForward.z, dx, dy, dz)
	
	if angle < (math.pi / 3) then
		return true
	end
	return false
end


cmath = {
	round = round,
	move_towards = move_towards,
	clamp = clamp,
	isPointInRect = isPointInRect,
	dist2D = dist2D,
	dist3D = dist3D,
	move_towards3D = move_towards3D,
	distElements = distElements,
	lerp = lerp,
	lerp2D = lerp2D,
	lerp3D = lerp3D,
	smooth = smooth,
	List = List,
	dirToAngle = dirToAngle,
	getElementSpeed = getElementSpeed,
	getAngle3D = getAngle3D,
	getStringMaxRows = getStringMaxRows,
	getStringRowStartAndEnd = getStringRowStartAndEnd,
	getStringRow = getStringRow,
	isPedLookingAt = isPedLookingAt,
}