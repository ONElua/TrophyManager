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
"title","details",						Title and description of the trophies (Globlal)
"group"									if there is a group of trophies:-1 or 2,3,etc...
"progress"								Progress (%)
"unlockT"								Total of unlocked trophies
"unlockP"								Total of unlocked trophies: Platinum
"unlockG"								Total of unlocked trophies: Gold
"unlockS"								Total of unlocked trophies: Silver
"unlockB"								Total of unlocked trophies: Bronze
]]

local trophyT = {}

function get_trophies()

	trophyT = trophy.info(__TITLE)
	if trophyT then
		for i=#trophyT,1,-1 do

			if trophyT[i].title == nil then	table.remove(trophyT,i)
			else
				trophyT[i].total = tonumber(trophyT[i].total)
				trophyT[i].group = tonumber(trophyT[i].group)
				trophyT[i].progress = tonumber(trophyT[i].progress)
				trophyT[i].unlockT = tonumber(trophyT[i].unlockT)

				trophyT[i].exist = false
				trophyT[i].del = false

				game.umount()
					buttons.homepopup(0)
						game.mount(DATA_TROPHY..trophyT[i].npcommid.."/")

						local app = nil

						--Open TRPTITLE.DAT
						local fp = io.open(DATA_TROPHY..trophyT[i].npcommid.."/TRPTITLE.DAT","r")
						if fp then
							fp:seek("set",0x290)
							app = fp:read(0x9)
							if app == "TROPHAXSE" then
								fp:seek("set",0x2D0)
								app = fp:read(0x9)
							end
							fp:close()
							if app then trophyT[i].ID = app end
						end

						--Open TRPTRANS.DAT
						trophyT[i].commsign = nil
						local fp = io.open(DATA_TROPHY..trophyT[i].npcommid.."/TRPTRANS.DAT","r")
						if fp then
							fp:seek("set",0x190)
							trophyT[i].commsign = fp:read(0xA0)
							fp:close()
						end

						if app and game.exists(app) then trophyT[i].exist = true end

					buttons.homepopup(1)
				game.umount()

			end

		end
	end

end

function trophies_title()

	get_trophies()

	if trophyT and #trophyT > 0 then
		table.sort(trophyT, function (a,b) return string.lower(a.title)<string.lower(b.title) end)
	end

	local maxim,inter,d_scroll,t_scroll,delete,sort_T = 5,55,25,25,0,1
	local scroll = newScroll(trophyT,maxim)

	buttons.interval(12,5)
	while true do
		buttons.read()
		
		if flag_delete_db then buttons.homepopup(0) else buttons.homepopup(1) end
		
		if back then back:blit(0,0) end
		if img_trophies then
			img_trophies:blitsprite(560,0,0)
			img_trophies:blitsprite(630,0,1)
			img_trophies:blitsprite(700,0,2)
			img_trophies:blitsprite(770,0,3)
		end

		------------------------------------------------------------------------------------------
		screen.print(25,35,"Trophy Manager",1,color.white,color.black)
		screen.print(955,10,"("..scroll.maxim..")",1,color.red,color.black, __ARIGHT)

		if scroll.maxim > 0 and trophyT then

			local y=95
			for i=scroll.ini, scroll.lim do

				if i == scroll.sel then
					if scroll.maxim >= maxim then
						draw.offsetgradrect(20,y-3,810,60,color.shine:a(75),color.shine:a(135),0x0,0x0,21)
					else
						draw.offsetgradrect(5,y-3,825,60,color.shine:a(75),color.shine:a(135),0x0,0x0,21)
					end

					screen.print(560 + 30, 65, trophyT[scroll.sel].platinum,1,color.white,color.black, __ACENTER)
					screen.print(630 + 30, 65, trophyT[scroll.sel].gold,1,color.white,color.black, __ACENTER)
					screen.print(700 + 30, 65, trophyT[scroll.sel].silver,1,color.white,color.black, __ACENTER)
					screen.print(770 + 30, 65, trophyT[scroll.sel].bronze,1,color.white,color.black, __ACENTER)
					screen.print(955, 65, trophyT[scroll.sel].total,1,color.white,color.black, __ARIGHT)

					if not trophyT[scroll.sel].exist then
						screen.print(950,460,trophyT[scroll.sel].ID.." "..STRINGS_GAME_NOT_INSTALLED,1.5,color.red:a(150),color.black, __ARIGHT)
					end

					if screen.textwidth(trophyT[scroll.sel].details,1) > 945 then
						d_scroll = screen.print(d_scroll,520,trophyT[scroll.sel].details,1,color.white,color.black, __SLEFT,920)
					else 
						screen.print(480,520,trophyT[scroll.sel].details,1,color.white,color.black, __ACENTER)
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
				if screen.textwidth(trophyT[i].title,1) > 530 then
					t_scroll = screen.print(t_scroll,y,trophyT[i].title,1,color.white,color.black,__SLEFT,520)
				else
					screen.print(25,y,trophyT[i].title,1,color.white,color.black)
				end

				--Progress
				draw.fillrect(25, y + (inter/2), 200, 20, color.shine:a(80))
				draw.fillrect(25, y + (inter/2) , math.map(trophyT[i].progress, 0, 100, 0, 200 ), 20, color.green:a(80))
				draw.rect(25, y + (inter/2), 200, 20, color.white:a(200))
				screen.print(235, y + (inter/2), trophyT[i].progress.."%",1,color.white,color.black)

				--Sub-Trophies
				if trophyT[i].group > 0 then
					screen.print(320, y + (inter/2), STRINGS_SUB_TROPHIES.." "..trophyT[i].group,1,color.white,color.black)
				end

				--Unlocked Trophies
				if trophyT[i].del then cgrad = color.red else cgrad = color.white:a(125) end
				draw.rect(560, y + (inter/2)-30, 270, 60, cgrad)
				screen.print(560 + 30, y + (inter/2)-5, trophyT[i].unlockP,1,color.white,color.black, __ACENTER)
				screen.print(630 + 30, y + (inter/2)-5, trophyT[i].unlockG,1,color.white,color.black, __ACENTER)
				screen.print(700 + 30, y + (inter/2)-5, trophyT[i].unlockS,1,color.white,color.black, __ACENTER)
				screen.print(770 + 30, y + (inter/2)-5, trophyT[i].unlockB,1,color.white,color.black, __ACENTER)

				if trophyT[i].del then draw.offsetgradrect(5,y-3,825,60,color.red:a(60),color.red:a(75),0x0,0x0,10) end

				--Blit icon0
				if not trophyT[i].icon0 then
					trophyT[i].icon0 = image.load(CONF_TROPHY..trophyT[i].npcommid.."/ICON0.PNG")
					if trophyT[i].icon0 then
						trophyT[i].icon0:resize(120,62)
						trophyT[i].icon0:center()
					end
				else
					trophyT[i].icon0:blit(955 - (trophyT[i].icon0:getw()/2), y + (inter/2))
				end

				if buttonskey then buttonskey:blitsprite(10,437,2) end                     		--[]
				screen.print(40,440,STRINGS_MARK_TROPHIES,1,color.white,color.black,__ALEFT)

				if buttonskey2 then buttonskey2:blitsprite(5,460,1) end                   		--Start
				screen.print(40,462,STRINGS_DEL_TROPHIES,1,color.white,color.black, __ALEFT)

				if buttonskey2 then buttonskey2:blitsprite(5,483,0) end                     	--select
				screen.print(40,485,STRINGS_SORT.._SORT_T[sort_T],1,color.white,color.black,__ALEFT)

				y+=inter + 15

			end --for

		else
			screen.print(480,202,STRINGS_EMPTY,1.5,color.yellow,color.black,__ACENTER)

			screen.print(480,252,STRINGS_RELOAD_TROPHIES,1,color.white,color.black,__ACENTER)
			
			if wlan.isconnected() then
				screen.print(480,352,STRINGS_TROPHY_WIFI_ON,1.5,color.yellow,color.black,__ACENTER)
			end

		end

		if buttonskey then buttonskey:blitsprite(940,483,1) end                     		--Triangle
		screen.print(935,485,STRINGS_TROPHY_OPENAPP,1,color.white,color.black,__ARIGHT)

		screen.flip()

		----------------------------------Controls-------------------------------
		if scroll.maxim > 0 and trophyT then

			if (buttons.up or buttons.held.l or buttons.analogly<-60) then
				if scroll:up() then d_scroll,t_scroll = 25,25 end
			end

			if (buttons.down or buttons.held.r or buttons.analogly>60) then 
				if scroll:down() then d_scroll,t_scroll = 25,25 end
			end

			--Mark/Unmark
			if buttons.square then
				trophyT[scroll.sel].del = not trophyT[scroll.sel].del
				if trophyT[scroll.sel].del then delete+=1 else delete-=1 end
			end

			--Delete trophies
			if buttons.start then
				if os.message(STRINGS_DELETE_QUESTION, 1) == 1 then
					if delete <= 1 then
						--ux0
						files.delete(ICONS_TROPHY..trophyT[scroll.sel].npcommid)
						--ur0
						files.delete(CONF_TROPHY..trophyT[scroll.sel].npcommid)
						files.delete(DATA_TROPHY..trophyT[scroll.sel].npcommid)
						trophyT[scroll.sel].icon0, delete = nil,0
						scroll:delete(trophyT)
						
					else
						--Batch
						for i=scroll.maxim,1,-1 do
							if trophyT[i].del then
								--ux0
								files.delete(ICONS_TROPHY..trophyT[i].npcommid)
								--ur0
								files.delete(CONF_TROPHY..trophyT[i].npcommid)
								files.delete(DATA_TROPHY..trophyT[i].npcommid)
								trophyT[i].icon0 = nil
								table.remove(trophyT,i)
							end
						end
						scroll:set(trophyT,maxim)
						delete = 0

					end
					files.delete(TROP_TROPHY)
					flag_delete_db = true
				end
			end

			if buttons.select then
				if sort_T == 2 then
					sort_T = 1
					table.sort(trophyT, function (a,b) return string.lower(a.title)<string.lower(b.title) end)
				elseif sort_T == 1 then
					sort_T = 2
					table.sort(trophyT, function (a,b) return (a.progress)>(b.progress) end)
				end
			end

			if buttons[accept] then
				if trophyT[scroll.sel].group > 0 then
					trophies_group(trophyT[scroll.sel])
				else
					trophies_list(trophyT[scroll.sel])
				end
			end

		end

		--Open Trophy APP
		if buttons.triangle then
			if wlan.isconnected() then os.message(STRINGS_TROPHY_WIFI_ON)
			else
				if flag_delete_db then files.delete(DB_TROPHY) end
				os.delay(500)
				if flag_delete_db then buttons.homepopup(0) else buttons.homepopup(1) end

				os.uri("pstc:")
			end
		end

		if buttons[cancel] then
			if flag_delete_db then files.delete(DB_TROPHY) end
			buttons.homepopup(1)
			os.exit()
		end

	end
end
