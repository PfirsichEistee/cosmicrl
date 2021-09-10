
factionName = {
	[0] = "Zivilist",
	[1] = "SFPD",
	[2] = "FBI",
	[3] = "Army",
	[4] = "Grove",
	[5] = "Ballas",
	[6] = "Yakuza",
	[7] = "Cosa Nostra",
}

factionColor = {
	[0] = { r = 255, g = 255, b = 255 },
	[1] = { r = 75, g = 75, b = 255 },
	[2] = { r = 25, g = 25, b = 255 },
	[3] = { r = 75, g = 255, b = 75 },
	[4] = { r = 0, g = 255, b = 0 },
	[5] = { r = 255, g = 0, b = 255 },
	[6] = { r = 255, g = 75, b = 75 },
	[7] = { r = 255, g = 255, b = 0 },
}

local gangs = { 4, 5, 6, 7 }


function isFactionGang(id)
	for a, b in ipairs(gangs) do
		if b == id then
			return true
		end
	end
	
	return false
end