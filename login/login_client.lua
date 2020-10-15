
addEvent("clientStartLogin", true)
addEvent("finishRegisterLogin", true)


logGui = {}



local function confirmLogin()
	if string.len(dxgui_GetText(logGui["pw"])) > 0 then
		triggerServerEvent("getLoginData", getLocalPlayer(), hash("sha256", dxgui_GetText(logGui["pw"])))
	else
		infobox("Das Eingabefeld darf nicht leer sein!", 3, 255, 75, 75)
	end
end


local function closeLoginWindow()
	if logGui["window"] then
		removeEventHandler("finishRegisterLogin", getRootElement(), closeLoginWindow)
		removeEventHandler("onDXGUIClicked", logGui["button"], confirmLogin)
		removeEventHandler("onDXGUIEditEnter", logGui["pw"], confirmLogin)
		
		dxgui_ClearKill(logGui["window"])
		
		logGui = nil
		
		showCursor(false)
		showChat(true)
		setClientHUDVisible(true)
	end
end


local function startLogin()
	logGui["window"] = dxgui_CreateRectangle((1 - 0.25) / 2, (1 - 0.21) / 2, 0.25, 0.21, true)
	
	local winW, winH = dxgui_GetSize(logGui["window"])
	
	local space = winW * 0.05
	local rowH = (winH - 4 * space) / 3
	local rowW = winW - rowH - space
	
	
	logGui["text1"] = dxgui_CreateText(2, -(0.06 * screenY) + 2, 0.25 * screenX, 1, _servername .. " Reallife", dxgui_FontA, 1, "center", "top", false, false, false, 0, 0, 0, 255, false, logGui["window"])
	logGui["text2"] = dxgui_CreateText(0, -(0.06 * screenY), 0.25 * screenX, 1, _servername .. " Reallife", dxgui_FontA, 1, "center", "top", false, false, false, 255, 255, 255, 255, false, logGui["window"])
	dxgui_TextSetFontHeight(logGui["text1"], 0.06 * screenY)
	dxgui_TextSetFontHeight(logGui["text2"], 0.06 * screenY)
	
	
	logGui["imguser"] = dxgui_CreateImage(space, space, rowH, rowH, "images/login/user.png", false, logGui["window"])
	logGui["imgpwd"] = dxgui_CreateImage(space, rowH + space * 2, rowH, rowH, "images/login/lock.png", false, logGui["window"])
	
	
	logGui["username"] = dxgui_CreateEdit(rowH + space * 2, space, rowW - space * 2, rowH, "Username", false, logGui["window"])
	dxgui_SetText(logGui["username"], getPlayerName(getLocalPlayer()))
	dxgui_SetEnabled(logGui["username"], false)
	
	logGui["pw"] = dxgui_CreateEdit(rowH + space * 2, rowH + space * 2,  rowW - space * 2, rowH, "Passwort", false, logGui["window"])
	dxgui_EditSetHidden(logGui["pw"], true)
	dxgui_SetSelection(logGui["pw"])
	
	logGui["button"] = dxgui_CreateButton(space, rowH * 2 + space * 3, winW - space * 2, rowH, "EINLOGGEN", false, logGui["window"])
	
	
	addEventHandler("onDXGUIClicked", logGui["button"], confirmLogin)
	addEventHandler("onDXGUIEditEnter", logGui["pw"], confirmLogin)
	
	addEventHandler("finishRegisterLogin", getRootElement(), closeLoginWindow)
end
addEventHandler("clientStartLogin", getRootElement(), startLogin)



local function resourceStart()
	triggerServerEvent("loginCheckClient", getLocalPlayer())
	
	showCursor(true)
	showChat(false)
	setClientHUDVisible(false)
	startRegisterLoginCamera()
end
addEventHandler("onClientResourceStart", resourceRoot, resourceStart)