
local itemTex = {
	[1] = "images/items/sprunk.png",
	[2] = "images/items/burger.png",
	[3] = "images/items/cigarettes.png",
	[4] = "images/items/chocolate.png",
	[5] = "images/items/weed.png",
	[6] = "images/items/weedseeds.png",
	[7] = "images/items/lsd.png",
	[8] = "images/items/card_car.png", -- car license
	[9] = "images/items/card_bike.png", -- bike license
	[10] = "images/items/card_truck.png", -- truck license
	[11] = "images/items/card_plane.png", -- plane license
	[12] = "images/items/card_heli.png", -- helicopter license
	[13] = "images/items/card.png",
	[14] = "images/items/card_gunA.png",
	[15] = "images/items/card_gunB.png",
}


function getItemImage(id)
	return itemTex[id]
end