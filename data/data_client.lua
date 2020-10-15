
function getClientData(name)
	local value
	
	local path = "stored_files/" .. name .. ".data"
	if fileExists(path) then
		local file = fileOpen(path)
		value = fileRead(file, fileGetSize(file))
		fileClose(file)
	end
	
	if value and tonumber(value) then
		value = tonumber(value)
	end
	
	return value
end

function setClientData(name, data)
	local path = "stored_files/" .. name .. ".data"
	if fileExists(path) then
		fileDelete(path)
	end
	
	local file = fileCreate(path)
	fileWrite(file, data)
	fileClose(file)
end


function getClientTable(name)
	local list = {}
	
	local path = "stored_files/" .. name .. ".table"
	if fileExists(path) then
		local file = fileOpen(path)
		local raw = fileRead(file, fileGetSize(file))
		fileClose(file)
		
		while true do
			local p = string.find(raw, "\n")
			
			if p then
				local item = string.sub(raw, 1, p - 1)
				raw = string.sub(raw, p + 1)
				
				if tonumber(item) then
					item = tonumber(item)
				end
				
				table.insert(list, item)
			else
				break
			end
		end
	end
	
	return list
end

function setClientTable(name, list)
	local path = "stored_files/" .. name .. ".table"
	if fileExists(path) then
		fileDelete(path)
	end
	
	local file = fileCreate(path)
	
	for a, b in ipairs(list) do
		fileWrite(file, b .. "\n")
	end
	
	fileClose(file)
end