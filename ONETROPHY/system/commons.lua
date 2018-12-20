--[[ 
	----------Trophy Manager------------
	Create and organize your direct adrenaline bubbles.
	
	Licensed by GNU General Public License v3.0
	
	Designed By:
	- Gdljjrod (https://twitter.com/gdljjrod).
]]

--Load palette
color.loadpalette()

--Load prx for mount
if files.exists("modules/kernel.skprx") then
	if os.requirek("modules/kernel.skprx")==1 then __kernel = true end
else
	if os.requirek("ux0:VitaShell/module/kernel.skprx")==1 then	__kernel = true end
end

if files.exists("modules/user.suprx") then
	if os.requireu("modules/user.suprx")==1 then __user = true end
else
	if os.requireu("ux0:VitaShell/module/user.suprx")==1 then __user = true end
end

-- Creamos carpeta de trabajo para los idiomas
__PATH_LANG = "ux0:data/ONETROPHY/"
files.mkdir(__PATH_LANG)
__LANG      = os.language()

langs = {	
	JAPANESE = 		"00",
	ENGLISH_US = 	"01",
	FRENCH = 		"02",
	SPANISH = 		"03",
	GERMAN = 		"04",
	ITALIAN = 		"05",
	DUTCH = 		"06",
	PORTUGUESE = 	"07",
	RUSSIAN = 		"08",
	KOREAN = 		"09",
	CHINESE_T = 	"10",
	CHINESE_S = 	"11",
	FINNISH = 		"12",
	SWEDISH = 		"13",
	DANISH = 		"14",
	NORWEGIAN = 	"15",
	POLISH = 		"16",
	PORTUGUESE_BR = "17",
	ENGLISH_GB = 	"18",
	TURKISH = 		"19",
}

-- Loading language file
dofile("lang/english_us.txt")
if not files.exists(__PATH_LANG.."english_us.txt") then files.copy("lang/english_us.txt",__PATH_LANG) end
if files.exists(__PATH_LANG..__LANG..".txt") then dofile(__PATH_LANG..__LANG..".txt") end

--buttons asignation
accept,cancel = "cross","circle"
if buttons.assign()==0 then
	accept,cancel = "circle","cross"
end

--Load resources
back = image.load("resources/background.png") 
img_trophies = image.load("resources/trophies.png",60,60)
buttonskey = image.load("resources/buttons.png",20,20)
buttonskey2 = image.load("resources/buttons2.png",30,20)

--Constants
ICONS_TROPHY = "ux0:user/00/trophy/conf/"
CONF_TROPHY  = "ur0:user/00/trophy/conf/"
DATA_TROPHY  = "ur0:user/00/trophy/data/"
TROP_TROPHY  = "ur0:user/00/trophy/data/sce_trop"
