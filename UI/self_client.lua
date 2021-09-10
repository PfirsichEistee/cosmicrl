
local gui = {}


local function openSelf()
	if gui["window"] ~= nil then
		dxgui_ClearKill(gui["window"])
		gui = {}
		return
	end
	
	local space = 0.005 * screenY
	
	local winW = 0.4 * screenX
	local winH = titleHeight + 0.6 * screenY
	
	gui["window"] = dxgui_CreateWindow((screenX - winW) / 2, (screenY - winH) / 2, winW, winH, "Selbstmenue", false)
	
	gui["tabs"] = dxgui_CreateTabs(0, titleHeight, winW, winH - titleHeight, "Statistiken", false, gui["window"])
	dxgui_TabsAddTab(gui["tabs"], "Besitztuemer")
	dxgui_TabsAddTab(gui["tabs"], "Gruppe")
	dxgui_TabsAddTab(gui["tabs"], "Freunde")
	dxgui_TabsAddTab(gui["tabs"], "Einstellungen")
end
cosmicBindKey("u", "down", openSelf) -- 'u' stands for user alright
addCommandHandler("self", openSelf)
