
_servername = "Cosmic"
_forum = "www.cosmic-rl.xobor.de"



function formatDate(day, month, year)
	if string.len(day) == 1 then day = "0" .. day end
	if string.len(month) == 1 then month = "0" .. month end
	
	return (day .. "." .. month .. "." .. year)
end


function getCurrentDate()
	local t = getRealTime()
	
	return formatDate(t.monthday, t.month + 1, t.year + 1900)
end


function getTimestamp(plusHours)
	if not plusHours then
		plusHours = 0
	end
	
	return getRealTime().timestamp + plusHours * 60 * 60
end


function getElementStringTransform(e)
	local px, py, pz = getElementPosition(e)
	local rx, ry, rz = getElementRotation(e)
	
	return px .. "|" .. py .. "|" .. pz .. "|" .. rx .. "|" .. ry .. "|" .. rz
end
function getPositionFromString(str)
	return tonumber(gettok(str, 1, "|")), tonumber(gettok(str, 2, "|")), tonumber(gettok(str, 3, "|"))
end
function getRotationFromString(str)
	return tonumber(gettok(str, 4, "|")), tonumber(gettok(str, 5, "|")), tonumber(gettok(str, 6, "|"))
end


function getTokenList(str)
	local list = {}
	
	for i = 1, 999, 1 do
		local item = gettok(str, i, "|")
		
		if item then
			if tonumber(item) then
				item = tonumber(item)
			end
			
			table.insert(list, item)
		else
			break
		end
	end
	
	return list
end

function getTokenString(...)
	local args = {...}
	local str = ""
	
	for a, b in ipairs(args) do
		if a ~= 1 then
			str = str .. "|"
		end
		str = str .. b
	end
	
	return str
end