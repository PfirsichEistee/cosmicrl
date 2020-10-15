
local itemTex = {
	[1] = "images/items/sprunk.png",
	[2] = "images/items/burger.png",
	[3] = "images/items/cigarettes.png",
	[4] = "images/items/chocolate.png",
	[5] = "images/items/weed.png",
	[6] = "images/items/weedseeds.png",
	[7] = "images/items/lsd.png",
}


function getItemImage(id)
	return itemTex[id]
end