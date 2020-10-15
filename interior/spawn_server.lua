
-- [spawnID] = { x, y, z, r, interior, dimension, }
local spawnPoint = {
	[0] = cmath.List(1743.1688, -1860.3788, 13.5788, 0, 0, 0 ), -- Noobspawn (Bahnhof LS)
}


function cosmicSpawnPlayer(player, id)
	if not id then
		id = cosmicGetElementData(player, "Spawn")
	end
	
	spawnPlayer(player, spawnPoint[id][1], spawnPoint[id][2], spawnPoint[id][3], spawnPoint[id][4], 16, spawnPoint[id][5], spawnPoint[id][6])
	--setElementInterior(player, spawnPoint[id][5])
	--setElementDimension(player, spawnPoint[id][6])
	--setElementPosition(player, spawnPoint[id][1], spawnPoint[id][2], spawnPoint[id][3])
	
	setElementAlpha(player, 255)
	
	setCameraTarget(player, player)
	
	setGhostMode(player, 5000, true)
	
	toggleAllControls(player, true)
end