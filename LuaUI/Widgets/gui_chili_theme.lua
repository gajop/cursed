--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Chili Theme",
    desc      = "v0.01 Set the Chili theme.",
    author    = "CarRepairer",
    date      = "2010-06-06",
    license   = "GNU GPL, v2 or later",
    layer     = -1000001,
    enabled   = true,
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local echo = Spring.Echo

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local Chili

local themes = {
	cursed = 'cursed',
	imperials = 'imperial',
}
local cursors = {
	cursed = 'cursed',
	imperials = 'imperial',
}
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function SetTheme()
	local myTeamID = Spring.GetMyTeamID()
	local side = WG.faction or Spring.GetTeamRulesParam(myTeamID, "side") or select(5, Spring.GetTeamInfo(myTeamID)) or "cursed"

	if not Chili then
		Chili = WG.Chili
	end
	
	if Chili then
		if (themes[side] ~= nil) then
			Chili.theme.skin.general.skinName = themes[side]
		else
			Chili.theme.skin.general.skinName = 'cursed'
		end
	end
	
	if WG.crude and WG.crude.SetCursor then
		if (cursors[side] ~= nil) then
			WG.crude.SetCursor( cursors[side] )
		else
			WG.crude.SetCursor( 'cursed' )
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--[[ chili skin won't change unless windows or luaui gets reloaded
function widget:Update()
	cycle = cycle % 300 +1
	if cycle == 1 then
		SetTheme()
	end
end]]--

function widget:GameFrame(n)
    if n==0 then
		SetTheme()
	elseif n>0 then
		Spring.SendCommands("luaui disablewidget Chili Integral Menu")
		Spring.SendCommands("luaui disablewidget Chili Resource Bars Classic")
--		Spring.SendCommands("luaui disablewidget Chili Pro Console2")
		Spring.SendCommands("luaui disablewidget Chili Selections & CursorTip v2")
		Spring.SendCommands("luaui disablewidget Chili Minimap")		
		Spring.SendCommands("luaui disablewidget Context Menu")		
		
		Spring.SendCommands("luaui enablewidget Chili Integral Menu")
		Spring.SendCommands("luaui enablewidget Chili Resource Bars Classic")
--		Spring.SendCommands("luaui enablewidget Chili Pro Console2")
		Spring.SendCommands("luaui enablewidget Chili Selections & CursorTip v2")
		Spring.SendCommands("luaui enablewidget Chili Minimap")		
		Spring.SendCommands("luaui enablewidget Context Menu")		
        widgetHandler:RemoveWidget(self)
    end
end

function widget:Initialize()
	SetTheme()
end


