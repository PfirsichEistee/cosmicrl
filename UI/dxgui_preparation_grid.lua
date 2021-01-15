-- use this to perfectly align shit aight



local function countUntilIndex(list, index)
	local value = 0
	for i = 1, index, 1 do
		value = value + list[i]
	end
	
	return value
end


function dxgui_prep_startColumns(parent, space, titleH, ...)
	if not space then
		space = titleHeight * 0.1
	end
	if not titleH then
		titleH = titleHeight
	end
	
	parent = dxgui_GetElementTable(parent)
	local args = {...} -- total of args must equal 1 !!!
	
	local new = {
		parent = parent,
		columns = args,
		rows = nil,
		space = space,
		titleH = titleH,
	}
	
	return new
end


function dxgui_prep_setRows(pTable, ...)
	local args = {...} -- total of args must equal 1 !!!
	
	pTable.rows = args
end


function dxgui_prep_getValues(pTable, x, y, w, h)
	local newX = countUntilIndex(pTable.columns, x)
	local newY = countUntilIndex(pTable.rows, y)
	
	local newW = countUntilIndex(pTable.columns, x + w) - newX
	local newH = countUntilIndex(pTable.rows, y + h) - newY
	
	
	newX = newX * pTable.parent.w + pTable.space
	newY = newY * (pTable.parent.h - pTable.titleH) + pTable.space + pTable.titleH
	newW = newW * pTable.parent.w - pTable.space * 2
	newH = newH * (pTable.parent.h - pTable.titleH) - pTable.space * 2
	
	
	return newX, newY, newW, newH
end