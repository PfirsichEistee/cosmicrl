
-- List is NOT ipairs!!!!!
-- It would fuck up whenever an item would be removed
-- NEVER change an items ID! Itll mess with the database

-- ALL items HAVE to be OPTIONAL!
-- Inventory might get full during gameplay!


local itemList = {
	--[ID] = NAME
	[1] = "Sprunk",
	[2] = "Burger",
	[3] = "Zigaretten",
	[4] = "Schokolade",
	[5] = "Gras",
	[6] = "Gras Samen",
	[7] = "LSD",
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