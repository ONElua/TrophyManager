--[[ 
	----------Trophy Manager------------
	Create and organize your direct adrenaline bubbles.
	
	Licensed by GNU General Public License v3.0
	
	Designed By:
	- Gdljjrod (https://twitter.com/gdljjrod).
]]

--Load palette
color.loadpalette()

flag_delete_db = false

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
__PATH_LANG = "ux0:data/ONETROPHY/lang/"
__PATH_FONT = "ux0:data/ONETROPHY/font/"
files.mkdir(__PATH_LANG)
files.mkdir(__PATH_FONT)
__LANG      = os.language()

-- Loading language file
dofile("lang/english_us.txt")
if not files.exists(__PATH_LANG.."english_us.txt") then files.copy("lang/english_us.txt",__PATH_LANG) end
if files.exists(__PATH_LANG..__LANG..".txt") then dofile(__PATH_LANG..__LANG..".txt") end

-- Loading custom font
fnt = font.load(__PATH_FONT.."font.ttf") or font.load(__PATH_FONT.."font.pgf") or font.load(__PATH_FONT.."font.pvf")
if fnt then	font.setdefault(fnt) end

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
DB_TROPHY = "ur0:user/00/trophy/db"

function draw.offsetgradrect(x,y,sx,sy,c1,c2,c3,c4,offset)
	local sizey = sy/2
		draw.gradrect(x,y,sx,sizey + offset,c1,c2,c3,c4)
			draw.gradrect(x,y + sizey - offset,sx,sizey + offset,c3,c4,c1,c2)
end