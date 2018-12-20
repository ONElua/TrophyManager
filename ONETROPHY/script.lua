--[[ 
	----------Trophy Manager------------
	Create and organize your direct adrenaline bubbles.
	
	Licensed by GNU General Public License v3.0
	
	Designed By:
	- Gdljjrod (https://twitter.com/gdljjrod).
]]

--Show splash
splash.zoom("resources/splash.png")

--Update
dofile("git/shared.lua")
local wstrength = wlan.strength()
if wstrength then
	if wstrength > 55 then dofile("git/updater.lua") end
end

game.close()

dofile("system/commons.lua")
dofile("system/scroll.lua")
dofile("system/trophies_title.lua")
dofile("system/trophies_group.lua")
dofile("system/trophies_list.lua")

trophies_title()