
-- List is NOT ipairs!!!!!
-- It would fuck up whenever an item would be removed
-- NEVER change an items ID! Itll mess with the database

-- ALL items HAVE to be OPTIONAL!
-- Inventory might get full during gameplay! May need a new inventory UI in the future! (Max items so far: 7x14 = 98 different items at MAX)


local itemList = {
	--[ID] = NAME
	[1] = "Sprunk",
	[2] = "Burger",
	[3] = "Zigaretten",
	[4] = "Schokolade",
	[5] = "Gras",
	[6] = "Gras Samen",
	[7] = "LSD",
	[8] = "PKW Schein",
	[9] = "Motorrad Schein",
	[10] = "LKW Schein",
	[11] = "Flugzeug Schein",
	[12] = "Helikopter Schein",
	[13] = "Personalausweis",
	[14] = "Waffenschein (leicht)",
	[15] = "Waffenschein (schwer)",
}


function getItemID(name)
	for a, b in pairs(itemList) do
		if b == name then
			return a
		end
	end
end

function getItemName(id)
	return itemList[id]
end