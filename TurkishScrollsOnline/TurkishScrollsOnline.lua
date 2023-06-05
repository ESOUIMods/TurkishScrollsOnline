local LMP = LibMediaProvider
TurkishScrollsOnline = {}
TurkishScrollsOnline.name  = "Turkish Scrolls Online"
TurkishScrollsOnline.version = "1.02"
TurkishScrollsOnline.settings = TurkishScrollsOnline.defaults
TurkishScrollsOnline.langString = nil
TurkishScrollsOnline.positionning = false
TurkishScrollsOnline.Flags = { "en", "tr"}

TurkishScrollsOnline.defaults = {
	Enable	= true,
	anchor	= {BOTTOMRIGHT, BOTTOMRIGHT, 0, 7},
	Flags = {
		["en"]	= true,
		["tr"]	= true,
	}
}

local confirmDialog = {
    title = { text = zo_iconFormat("TurkishScrollsOnline/images/".."tr.dds", 24, 24).." Turkish Scrolls Online "..zo_iconFormat("TurkishScrollsOnline/images/".."tr.dds", 24, 24)},
    mainText = { text = "Bu mod herhangi bir kar amacı güdülerek oluşturulmamıştır. Hata ve önerileri bildirmek için Discord yoluyla ulaşabilirsiniz. Balgamov#5865 \"." },
    buttons = {
        { text = SI_DIALOG_ACCEPT, callback = functionToCall},
    }
}
ZO_Dialogs_RegisterCustomDialog("ADDON_DIALOG", confirmDialog )

if GetCVar("IgnorePatcherLanguageSetting") == "0" then
	ZO_Dialogs_ShowDialog("ADDON_DIALOG")
end

function TurkishScrollsOnline_ChangeLanguage(lang)
	if lang ~= GetCVar("language.2") then
    if lang == "en" then
      SetCVar("IgnorePatcherLanguageSetting", 0)
    else
      SetCVar("IgnorePatcherLanguageSetting", 1)
    end
    SetCVar("language.2", lang)
    d(msg)
  end
end

function TurkishScrollsOnline:RefreshUI()
	local flagControl
	local count = 0
	local flagTexture
	for _, flagCode in pairs(TurkishScrollsOnline.Flags) do
		flagTexture = "TurkishScrollsOnline/images/"..flagCode..".dds"
		flagControl = GetControl("TurkishScrollsOnline_FlagControl_"..tostring(flagCode))
		if flagControl == nil then
			flagControl = CreateControlFromVirtual("TurkishScrollsOnline_FlagControl_", TurkishScrollsOnlineUI, "TurkishScrollsOnline_FlagControl", tostring(flagCode))
			if flagControl:GetHandler("OnMouseDown") == nil then flagControl:SetHandler("OnMouseDown", function() TurkishScrollsOnline_ChangeLanguage(flagCode) end) end
			GetControl("TurkishScrollsOnline_FlagControl_"..flagCode.."Texture"):SetTexture(flagTexture)
		end
		if TurkishScrollsOnline.settings.Flags[flagCode] then
			flagControl:ClearAnchors()
			flagControl:SetAnchor(LEFT, TurkishScrollsOnlineUI, LEFT, 14 +count*34, 0)
			count = count +1
		end
		flagControl:SetMouseEnabled(true)
		flagControl:SetHidden(not TurkishScrollsOnline.settings.Flags[flagCode])
	end
	TurkishScrollsOnlineUI:SetDimensions(25 +count*34, 50)
	TurkishScrollsOnlineUI:SetMouseEnabled(true)

end

function TurkishScrollsOnline_Selected()
	local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY = TurkishScrollsOnlineUI:GetSelected()
	if isValidAnchor then
		TurkishScrollsOnline.settings.anchor = { point, relativePoint, offsetX, offsetY }
	end
end

function TurkishScrollsOnline:getFontPath()
  if GetCVar("language.2") == "tr" then
    return "TurkishScrollsOnline/fonts/"
  end
  return "EsoUI/Common/Fonts/"
end

function TurkishScrollsOnline:fontChangeWhenInit()
  local path = TurkishScrollsOnline:getFontPath()
  local pair = { "ZO_TOOLTIP_STYLES", "ZO_CRAFTING_TOOLTIP_STYLES", "ZO_GAMEPAD_DYEING_TOOLTIP_STYLES" }
  local function f(x) return path .. x end
  local fontFaces = TurkishScrollsOnline.fontFaces

  for _, v in pairs(pair) do for k, fnt in pairs(fontFaces[v]) do _G[v][k]["fontFace"] = f(fnt) end end

  SetSCTKeyboardFont(f(fontFaces.UNI67) .. "|29|soft-shadow-thick")
  SetSCTGamepadFont(f(fontFaces.UNI67) .. "|35|soft-shadow-thick")
  SetNameplateKeyboardFont(f(fontFaces.UNI67), 4)
  SetNameplateGamepadFont(f(fontFaces.UNI67), 4)

  -- this is set up by TurkishScrollsOnline in fontFaces.lua
  -- ["Univers 55"] = UNI55,
  -- ["Univers 57"] = UNI57,
  -- ["Univers 67"] = UNI67,
  -- ["Skyrim Handwritten"] = HAND,
  -- ["ProseAntique"] = ANTIQUE,
  -- ["Trajan Pro"] = TRAJAN,
  -- ["Futura Condensed"] = FTN57,
  -- ["Futura Condensed Bold"] = FTN87,
  -- ["Futura Condensed Light"] = FTN47,
  for k, v in pairs(fontFaces.fonts) do
    LMP.MediaTable.font[k] = nil
    LMP:Register("font", k, f(v))
  end
  LMP:SetDefault("font", "Univers 57")

  -- Loop through list and make sure it is using TurkishScrollsOnline Font
  local uni57 = f(fontFaces.UNI57)
  local uni47 = f(fontFaces.FTN47)
  local fontList = {
    "Arial Narrow",
    "Consolas",
    "ESO Cartographer",
    "Fontin Bold",
    "Fontin Italic",
    "Fontin Regular",
    "Fontin SmallCaps",
    "Futura Condensed",
  }
  for i = 1, #fontList do
    LMP.MediaTable.font[fontList[i]] = nil
    LMP:Register("font", fontList[i], uni57)
  end

  -- do single because it is different
  if LMP:Fetch("font", "Futura Light") ~= uni47 then
    LMP.MediaTable.font["Futura Light"] = nil
    LMP:Register("font", "Futura Light", uni47)
  end

  function ZO_TooltipStyledObject:GetFontString(...)
    local fontFace = self:GetProperty("fontFace", ...)
    local fontSize = self:GetProperty("fontSize", ...)

    if fontFace == "$(GAMEPAD_LIGHT_FONT)" then fontFace = f(fontFaces.FTN47) end
    if fontFace == "$(GAMEPAD_MEDIUM_FONT)" then fontFace = f(fontFaces.FTN57) end
    if fontFace == "$(GAMEPAD_BOLD_FONT)" then fontFace = f(fontFaces.FTN87) end

    if (fontFace and fontSize) then
      if type(fontSize) == "number" then
        fontSize = tostring(fontSize)
      end

      local fontStyle = self:GetProperty("fontStyle", ...)
      if (fontStyle) then
        return string.format("%s|%s|%s", fontFace, fontSize, fontStyle)
      else
        return string.format("%s|%s", fontFace, fontSize)
      end
    else
      return "ZoFontGame"
    end
  end
end

function TurkishScrollsOnline:OnInit(eventCode, addOnName)
	TurkishScrollsOnline.langString = GetCVar("language.2")
	TurkishScrollsOnline.settings = ZO_SavedVars:New(TurkishScrollsOnline.name .. "_settings", 1, nil, TurkishScrollsOnline.defaults)

	for _, flagCode in pairs(TurkishScrollsOnline.Flags) do
		ZO_CreateStringId("SI_BINDING_NAME_"..string.upper(flagCode), string.upper(flagCode))
	end

  TurkishScrollsOnline:fontChangeWhenInit()
	TurkishScrollsOnline:RefreshUI()
	TurkishScrollsOnlineUI:ClearAnchors()
	TurkishScrollsOnlineUI:SetAnchor(TurkishScrollsOnline.settings.anchor[1], GuiRoot, TurkishScrollsOnline.settings.anchor[2], TurkishScrollsOnline.settings.anchor[3], TurkishScrollsOnline.settings.anchor[4])
	TurkishScrollsOnline:registerEvents(true)

	EVENT_MANAGER:UnregisterForEvent(TurkishScrollsOnline.name, EVENT_ADD_ON_LOADED)
end

function TurkishScrollsOnline:registerEvents(state)
	if state then
		EVENT_MANAGER:RegisterForEvent(TurkishScrollsOnline.name, EVENT_RETICLE_HIDDEN_UPDATE, function(eventCode, hidden) if TurkishScrollsOnline.settings.Enable then TurkishScrollsOnlineUI:SetHidden(not hidden) end end)
	else
		EVENT_MANAGER:UnregisterForEvent(TurkishScrollsOnline.name, EVENT_RETICLE_HIDDEN_UPDATE)
	end
end

EVENT_MANAGER:RegisterForEvent(TurkishScrollsOnline.name, EVENT_ADD_ON_LOADED , function(_event, _name) TurkishScrollsOnline:OnInit(_event, _name) end)