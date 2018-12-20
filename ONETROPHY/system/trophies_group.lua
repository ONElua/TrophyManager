--[[ 
	----------Trophy Manager------------
	Create and organize your direct adrenaline bubbles.
	
	Licensed by GNU General Public License v3.0
	
	Designed By:
	- Gdljjrod (https://twitter.com/gdljjrod).
]]

--[[
"npcommid"								ID special for Trophy
"total"									Total of trophies
"platinum","gold","silver","bronze",	Total of trophies for each type
"title","details",						Title and description of the trophies (Sub-Trophies)
"group"									if there is a group of trophies
"progress"								Progress (%)
"unlockT"								Total of unlocked trophies
"unlockP"								Total of unlocked trophies: Platinum
"unlockG"								Total of unlocked trophies: Gold
"unlockS"								Total of unlocked trophies: Silver
"unlockB"								Total of unlocked trophies: Bronze
]]

local trophyG = {}

function get_trophiesG(obj)

	local tmp = trophy.info(__GROUP)

	if tmp then
		for i=1, #tmp do

			if tmp[i].npcommid == obj.npcommid then
				tmp[i].total = tonumber(tmp[i].total)
				tmp[i].group = tonumber(tmp[i].group)
				tmp[i].progress = tonumber(tmp[i].progress)
				tmp[i].unlockT = tonumber(tmp[i].unlockT)
				table.insert(trophyG,tmp[i])
			end
		end
	end
end

function trophies_group(obj)

	trophyG = {}
	get_trophiesG(obj)

	if trophyG and #trophyG > 0 then
		table.sort(trophyG, function (a,b) return string.lower(a.group)<string.lower(b.group) end)
	end

	local maxim,inter,d_scroll,t_scroll,init_scroll,sort_G = 5,55,25,25,25,1
	local scroll = newScroll(trophyG,maxim)

	buttons.interval(12,5)
	while true do
		buttons.read()
		if back then back:blit(0,0) end

		if img_trophies then
			img_trophies:blitsprite(560,0,0)
			img_trophies:blitsprite(630,0,1)
			img_trophies:blitsprite(700,0,2)
			img_trophies:blitsprite(770,0,3)
		end

		------------------------------------------------------------------------------------------
		if screen.textwidth(obj.title,1) > 530 then
			init_scroll = screen.print(init_scroll,35,obj.title,1,color.white,color.black,__SLEFT,520)
		else
			screen.print(25,35,obj.title,1,color.white,color.black)
		end
		screen.print(955,10,"("..scroll.maxim..")",1,color.red,color.black, __ARIGHT)

		if scroll.maxim > 0 and trophyG then

			local y=95
			for i=scroll.ini, scroll.lim do

				if i == scroll.sel then
					if scroll.maxim >= maxim then
						draw.offsetgradrect(20,y-3,810,60,color.shine:a(75),color.shine:a(135),0x0,0x0,21)
					else
						draw.offsetgradrect(5,y-3,825,60,color.shine:a(75),color.shine:a(135),0x0,0x0,21)
					end

					screen.print(560 + 30, 65, trophyG[scroll.sel].platinum,1,color.white,color.black, __ACENTER)
					screen.print(630 + 30, 65, trophyG[scroll.sel].gold,1,color.white,color.black, __ACENTER)
					screen.print(700 + 30, 65, trophyG[scroll.sel].silver,1,color.white,color.black, __ACENTER)
					screen.print(770 + 30, 65, trophyG[scroll.sel].bronze,1,color.white,color.black, __ACENTER)
					screen.print(955, 65, trophyG[scroll.sel].total.."/"..obj.total,1,color.white,color.black, __ARIGHT)

					if not obj.exist then
						screen.print(480,460,STRINGS_GAME_NOT_INSTALLED,1.5,color.red:a(150),color.black, __ACENTER)
					end

					if screen.textwidth( trophyG[scroll.sel].details,1) > 945 then
						d_scroll = screen.print(d_scroll,510,trophyG[scroll.sel].details,1,color.white,color.black, __SLEFT,920)
					else 
						screen.print(480,510,trophyG[scroll.sel].details,1,color.white,color.black, __ACENTER)
					end

				end

				--Bar Scroll
				if scroll.maxim >= maxim then -- Draw Scroll Bar
					local ybar,h=93, (maxim*(inter + 15))-7
					draw.fillrect(5, ybar-2, 8, h, color.shine:a(50))
					--if scroll.maxim >= maxim then -- Draw Scroll Bar
						local pos_height = math.max(h/scroll.maxim, maxim)
						draw.fillrect(5, ybar-2 + ((h-pos_height)/(scroll.maxim-1))*(scroll.sel-1), 8, pos_height, color.new(0,255,0))
					--end
				end

				--Title
				if screen.textwidth(trophyG[i].title,1) > 530 then
					t_scroll = screen.print(t_scroll,y,trophyG[i].title,1,color.white,color.black,__SLEFT,520)
				else
					screen.print(25,y,trophyG[i].title,1,color.white,color.black)
				end

				--Progress
				draw.fillrect(25, y + (inter/2), 200, 20, color.shine:a(80))
				draw.fillrect(25, y + (inter/2) , math.map(trophyG[i].progress, 0, 100, 0, 200 ), 20, color.green:a(80))
				draw.rect(25, y + (inter/2), 200, 20, color.white:a(200))
				screen.print(235, y + (inter/2), trophyG[i].progress.."%",1,color.white,color.black)

				--Unlocked Trophies
				draw.rect(560, y + (inter/2)-30, 270, 60, color.white:a(125))
				screen.print(560 + 30, y + (inter/2)-5, trophyG[i].unlockP,1,color.white,color.black, __ACENTER)
				screen.print(630 + 30, y + (inter/2)-5, trophyG[i].unlockG,1,color.white,color.black, __ACENTER)
				screen.print(700 + 30, y + (inter/2)-5, trophyG[i].unlockS,1,color.white,color.black, __ACENTER)
				screen.print(770 + 30, y + (inter/2)-5, trophyG[i].unlockB,1,color.white,color.black, __ACENTER)

				--Blit icon0
				if not trophyG[i].icon0 then
					if trophyG[i].group == -1 then
						trophyG[i].icon0 = image.load(CONF_TROPHY..trophyG[i].npcommid.."/ICON0.PNG")
					else
						trophyG[i].icon0 = image.load(CONF_TROPHY..trophyG[i].npcommid.."/GR"..string.rep("0", 3 - string.len(trophyG[i].group))..trophyG[i].group..".PNG")
					end

					if trophyG[i].icon0 then
						trophyG[i].icon0:resize(120,62)
						trophyG[i].icon0:center()
					end
				else
					trophyG[i].icon0:blit(955 - (trophyG[i].icon0:getw()/2), y + (inter/2))
				end

				y+=inter + 15

			end --for

		else
			screen.print(480,272,STRINGS_EMPTY,1.5,color.yellow,color.black,__ACENTER)
		end

		screen.flip()

		----------------------------------Controls-------------------------------
		if scroll.maxim > 0 and trophyG then

			if (buttons.up or buttons.held.l or buttons.analogly<-60) then
				if scroll:up() then d_scroll,t_scroll,init_scroll = 25,25,25 end
			end

			if (buttons.down or buttons.held.r or buttons.analogly>60) then 
				if scroll:down() then d_scroll,t_scroll,init_scroll = 25,25,25 end
			end

			if buttons[accept] then
				trophies_list(trophyG[scroll.sel])
			end

			if buttons.select then
				if sort_G == 2 then
					sort_G = 1
					table.sort(trophyG, function (a,b) return string.lower(a.group)<string.lower(b.group) end)
				elseif sort_G == 1 then
					sort_G = 2
					table.sort(trophyG, function (a,b) return (a.progress)>(b.progress) end)
				end
			end

		end
		
		if buttons[cancel] then
			trophyG = {}

			collectgarbage("collect")
			os.delay(250)

			return true
		end

	end
end
