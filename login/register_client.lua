
addEvent("clientStartRegister", true)


local regGui = {}



local function closeRegisterWindow()
	if regGui["window"] then
		removeEventHandler("finishRegisterLogin", getRootElement(), closeRegisterWindow)
		
		dxgui_ClearKill(regGui["window"])
		
		regGui = nil
		
		showCursor(false)
		showChat(true)
		setClientHUDVisible(true)
	end
end


local function confirmRegister()
	local pw = dxgui_GetText(regGui["pw1"])
	
	if pw == dxgui_GetText(regGui["pw2"]) then
		if string.len(pw) >= 4 and string.len(pw) <= 24 then
			if not string.find(pw, " ") then
				local d = tonumber(dxgui_GetText(regGui["day"]))
				local m = tonumber(dxgui_GetText(regGui["month"]))
				local y = tonumber(dxgui_GetText(regGui["year"]))
				
				if d and m and y then
					if d >= 1 and d <= 31 and m >= 1 and m <= 12 and y >= 1900 and y <= 2020 then
						local gender = 1 -- male
						if dxgui_CheckBoxGetState(regGui["female"]) then
							gender = 2
						end
						
						triggerServerEvent("getRegisterData", getLocalPlayer(), hash("sha256", pw), d, m, y, gender)
					else
						infobox("Ueberpruefe deine Angaben!", 3, 255, 75, 75)
					end
				else
					infobox("Du musst dein Geburtsdatum angeben!", 3, 255, 75, 75)
				end
			else
				infobox("Dein Passwort darf keine Leerzeichen enthalten!", 3, 255, 75, 75)
			end
		else
			infobox("Dein Passwort muss zwischen 4 und 24 Zeichen lang sein!", 3, 255, 75, 75)
		end
	else
		infobox("Die Passwoerter stimmen nicht ueberein!", 3, 255, 75, 75)
	end
end


local function registerGenderClick()
	if source == regGui["male"] then
		dxgui_CheckBoxSetState(regGui["female"], not dxgui_CheckBoxGetState(regGui["male"]))
	else
		dxgui_CheckBoxSetState(regGui["male"], not dxgui_CheckBoxGetState(regGui["female"]))
	end
end


local function startRegister()
	regGui["window"] = dxgui_CreateRectangle((1 - 0.3) / 2, (1 - 0.35) / 2, 0.3, 0.35, true)
	
	local winW, winH = dxgui_GetSize(regGui["window"])
	
	local space = winW * 0.05
	local rowH = (winH - 6 * space) / 5
	local rowW = winW - rowH - space
	
	
	regGui["text1"] = dxgui_CreateText(2, -(0.06 * screenY) + 2, 0.3 * screenX, 1, tostring(_servername) .. " Reallife", dxgui_FontA, 1, "center", "top", false, false, false, 0, 0, 0, 255, false, regGui["window"])
	regGui["text2"] = dxgui_CreateText(0, -(0.06 * screenY), 0.3 * screenX, 1, tostring(_servername) .. " Reallife", dxgui_FontA, 1, "center", "top", false, false, false, 255, 255, 255, 255, false, regGui["window"])
	dxgui_TextSetFontHeight(regGui["text1"], 0.06 * screenY)
	dxgui_TextSetFontHeight(regGui["text2"], 0.06 * screenY)
	
	
	regGui["imguser"] = dxgui_CreateImage(space, space, rowH, rowH, "images/login/user.png", false, regGui["window"])
	regGui["imgpwd"] = dxgui_CreateImage(space, rowH + space * 2, rowH, rowH, "images/login/lock.png", false, regGui["window"])
	regGui["imgcke"] = dxgui_CreateImage(space, rowH * 2 + space * 3, rowH, rowH, "images/login/cake.png", false, regGui["window"])
	regGui["imggen"] = dxgui_CreateImage(space, rowH * 3 + space * 4, rowH, rowH, "images/login/gender.png", false, regGui["window"])
	
	
	regGui["username"] = dxgui_CreateEdit(rowH + space * 2, space, rowW - space * 2, rowH, "Username", false, regGui["window"])
	dxgui_SetText(regGui["username"], getPlayerName(getLocalPlayer()))
	dxgui_SetEnabled(regGui["username"], false)
	
	local ph = (rowW - space * 3) / 2
	regGui["pw1"] = dxgui_CreateEdit(rowH + space * 2, rowH + space * 2, ph, rowH, "Passwort", false, regGui["window"])
	regGui["pw2"] = dxgui_CreateEdit(rowH + ph + space * 3, rowH + space * 2, ph, rowH, "Wiederholen", false, regGui["window"])
	
	ph = (rowW - space * 5) / 4
	regGui["day"] = dxgui_CreateEdit(rowH + space * 2, rowH * 2 + space * 3, ph, rowH, "Tag", false, regGui["window"])
	regGui["month"] = dxgui_CreateEdit(rowH + ph + space * 3, rowH * 2 + space * 3, ph, rowH, "Monat", false, regGui["window"])
	regGui["year"] = dxgui_CreateEdit(rowH + ph * 2 + space * 4, rowH * 2 + space * 3, ph * 2 + space, rowH, "Jahr", false, regGui["window"])
	dxgui_EditSetOnlyNumbers(regGui["day"], true)
	dxgui_EditSetOnlyNumbers(regGui["month"], true)
	dxgui_EditSetOnlyNumbers(regGui["year"], true)
	
	ph = (rowW - space * 3) / 2
	regGui["male"] = dxgui_CreateCheckBox(rowH + space * 2, rowH * 3 + space * 4, ph, rowH, "Maennlich", false, regGui["window"])
	regGui["female"] = dxgui_CreateCheckBox(rowH + ph + space * 3, rowH * 3 + space * 4, ph, rowH, "Weiblich", false, regGui["window"])
	dxgui_CheckBoxSetState(regGui["male"], true)
	
	
	regGui["button"] = dxgui_CreateButton(space, rowH * 4 + space * 5, winW - space * 2, rowH, "REGISTRIEREN", false, regGui["window"])
	
	
	addEventHandler("onDXGUIClicked", regGui["male"], registerGenderClick)
	addEventHandler("onDXGUIClicked", regGui["female"], registerGenderClick)
	addEventHandler("onDXGUIClicked", regGui["button"], confirmRegister)
	
	addEventHandler("finishRegisterLogin", getRootElement(), closeRegisterWindow)
end
addEventHandler("clientStartRegister", getRootElement(), startRegister)