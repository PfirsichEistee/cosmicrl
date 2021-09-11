
local gui = {}
local space = 0.005 * screenY


local function statAppend(txt, ...)
	local args = {...}
	
	txt = txt .. args[1]
	
	if #args > 1 then
		txt = txt .. "#44FF44"
		for i = 2, #args, 1 do
			txt = txt .. " " .. args[i]
		end
	end
	
	txt = txt .. "#FFFFFF\n"
	
	return txt
end


local function formatPlaytime(m)
	local h = math.floor(m / 60)
	m = m - h * 60
	
	if string.len(m) == 1 then
		m = "0" .. m
	end
	if string.len(h) == 1 then
		h = "0" .. h
	end
	
	return h .. "h " .. m .. "m"
end


local function createStatistiken()
	local w, h = dxgui_GetSize(gui["tabs"])
	
	local exp = cosmicClientGetElementData(getLocalPlayer(), "Exp")
	local lvl = getLevel(exp)
	local lvlprogress = ( (exp - getExp(lvl)) / (getExp(lvl + 1) - getExp(lvl)) ) * 100
	
	local txtA = ""
	txtA = statAppend(txtA, "Level:", getLevel(exp), "( " .. cmath.round(lvlprogress) .. "% )")
	txtA = statAppend(txtA, "Geld:", "$" .. cosmicClientGetElementData(getLocalPlayer(), "Money"))
	txtA = statAppend(txtA, "Bankgeld", "$" .. cosmicClientGetElementData(getLocalPlayer(), "Bankmoney"))
	txtA = statAppend(txtA, "Achievements:", cosmicClientGetAchievementCount() .. " / " .. "??")
	txtA = statAppend(txtA, "Spielzeit:", formatPlaytime(cosmicClientGetElementData(getLocalPlayer(), "Playtime")))
	txtA = statAppend(txtA, "Registriert am:", cosmicClientGetElementData(getLocalPlayer(), "Registerdate"))
	txtA = txtA .. "\n"
	local kills = cosmicClientGetStats("Kills")
	local deaths = cosmicClientGetStats("Deaths")
	txtA = statAppend(txtA, "Kills:", kills)
	txtA = statAppend(txtA, "Headshots:", cosmicClientGetStats("Headshots"))
	txtA = statAppend(txtA, "Deaths:", deaths)
	if deaths ~= 0 then
		txtA = statAppend(txtA, "K/D:", math.floor((kills / deaths) * 10) / 10)
	else
		txtA = statAppend(txtA, "K/D:", kills)
	end
	txtA = statAppend(txtA, "Wiederbelebungen:", cosmicClientGetStats("Revivals"))
	txtA = txtA .. "\n"
	txtA = statAppend(txtA, "Knastaufenthalte:", cosmicClientGetStats("Jail"))
	txtA = statAppend(txtA, "Gangwars:", cosmicClientGetStats("Gangwars"))
	
	local txtB = ""
	txtB = statAppend(txtB, "Fahrzeuge:", "??")
	txtB = statAppend(txtB, "Haeuser:", "??")
	txtB = statAppend(txtB, "Fraktion:", factionName[cosmicClientGetElementData(getLocalPlayer(), "FactionID")])
	txtB = statAppend(txtB, "Gruppe:", "??")
	txtB = txtB .. "\n"
	txtB = statAppend(txtB, "Bans:", cosmicClientGetStats("Bans"))
	txtB = statAppend(txtB, "Letzter Ban:", cosmicClientGetStats("LastBan"))
	txtB = statAppend(txtB, "Warns:", cosmicClientGetStats("Warns"))
	
	
	dxgui_CreateText(space, tabsHeight + space, w - space * 2, h - tabsHeight - space * 2, txtA, dxgui_FontA, nil, "left", "top", true, false, true, 255, 255, 255, 255, false, gui["tabs"])
	
	dxgui_CreateText(w / 2, tabsHeight + space, w / 2 - space, h - tabsHeight - space * 2, txtB, dxgui_FontA, nil, "left", "top", true, false, true, 255, 255, 255, 255, false, gui["tabs"])
end

local function createBesitztuemer()

end

local function createGruppe()

end

local function createFreunde()

end

local function createEinstellungen()

end

local function openSelf()
	if gui["window"] ~= nil then
		dxgui_ClearKill(gui["window"])
		gui = {}
		showCursor(false)
		return
	end
	showCursor(true)
	
	local winW = 0.4 * screenX
	local winH = titleHeight + 0.6 * screenY
	
	gui["window"] = dxgui_CreateWindow((screenX - winW) / 2, (screenY - winH) / 2, winW, winH, "Selbstmenue", false)
	
	gui["tabs"] = dxgui_CreateTabs(0, titleHeight, winW, winH - titleHeight, "Statistiken", false, gui["window"])
	dxgui_TabsAddTab(gui["tabs"], "Besitztuemer")
	dxgui_TabsAddTab(gui["tabs"], "Gruppe")
	dxgui_TabsAddTab(gui["tabs"], "Freunde")
	dxgui_TabsAddTab(gui["tabs"], "Einstellungen")
	
	createStatistiken()
end
cosmicBindKey("u", "down", openSelf) -- 'u' stands for user alright
addCommandHandler("self", openSelf)
