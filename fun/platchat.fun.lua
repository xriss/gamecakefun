
local chatdown=require("wetgenes.gamecake.fun.chatdown")

hardware,main=system.configurator({
	mode="fun64", -- select the standard 320x240 screen using the swanky32 palette.
	update=function() update() end, -- called repeatedly to update+draw
})

-- debug text dump
local ls=function(t) print(require("wetgenes.string").dump(t)) end


-- define all graphics in this global, we will convert and upload to tiles at setup
-- although you can change tiles during a game, we try and only upload graphics
-- during initial setup so we have a nice looking sprite sheet to be edited by artists

graphics={
{0x0100,"char_empty",[[
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
]]},
{0x0101,"char_black",[[
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
]]},
{0x0102,"char_wall",[[
O O R R R R O O 
O O R R R R O O 
r r r r o o o o 
r r r r o o o o 
R R O O O O R R 
R R O O O O R R 
o o o o r r r r 
o o o o r r r r 
]]},
{0x0103,"char_floor",[[
R R R R R R R R 
r r r r r r r r 
r r r r r r r r 
. r r r r r r . 
. . r . r r . . 
. . . . r r . . 
. . . . . r . . 
. . . . . . . . 
]]},

{0x0200,"player_f1",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . 4 4 4 4 . . . . . . . . . . 
. . . . . . . . . 4 2 7 7 1 4 . . . . . . . . . 
. . . . . . . . . 4 7 2 1 7 4 . . . . . . . . . 
. . . . . . . . 4 7 7 1 2 7 7 4 . . . . . . . . 
. . . . . . . 4 7 7 1 7 7 2 7 7 4 . . . . . . . 
. . . . . . . 4 4 4 4 4 4 4 4 4 4 . . . . . . . 
. . . . . . . . . . 7 7 0 7 . . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . . . 7 7 . . . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . 7 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . 7 7 7 7 . 7 7 7 . . . . . . . . 
. . . . . . . . 7 7 7 7 7 . 7 7 . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . 7 7 7 . 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 . 7 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 7 . 7 7 7 . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
]]},
{0x0203,"player_f2",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . 4 4 4 4 . . . . . . . . . . 
. . . . . . . . . 4 2 7 7 1 4 . . . . . . . . . 
. . . . . . . . . 4 7 2 1 7 4 . . . . . . . . . 
. . . . . . . . 4 7 7 1 2 7 7 4 . . . . . . . . 
. . . . . . . 4 7 7 1 7 7 2 7 7 4 . . . . . . . 
. . . . . . . 4 4 4 4 4 4 4 4 4 4 . . . . . . . 
. . . . . . . . . . 7 7 0 7 . . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . . . 7 7 . . . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . 7 7 . 7 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 . 7 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 . 7 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 7 . 7 7 . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . . . 7 7 . . . . . . . . . . . 
. . . . . . . . . . . 7 7 . . . . . . . . . . . 
. . . . . . . . . . . 7 7 7 . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
]]},
{0x0206,"player_f3",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . 4 4 4 4 . . . . . . . . . . 
. . . . . . . . . 4 2 7 7 1 4 . . . . . . . . . 
. . . . . . . . . 4 7 2 1 7 4 . . . . . . . . . 
. . . . . . . . 4 7 7 1 2 7 7 4 . . . . . . . . 
. . . . . . . 4 7 7 1 7 7 2 7 7 4 . . . . . . . 
. . . . . . . 4 4 4 4 4 4 4 4 4 4 . . . . . . . 
. . . . . . . . . . 7 7 0 7 . . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . . . 7 7 . . . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . 7 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . 7 7 7 7 7 7 7 7 . . . . . . . . 
. . . . . . . 7 7 7 7 7 7 7 7 7 7 . . . . . . . 
. . . . . . . 7 7 . 7 7 7 7 . 7 7 . . . . . . . 
. . . . . . . . . . 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 7 . 7 7 . 7 . . . . . . . 
. . . . . . . . 7 7 . . . . 7 7 7 . . . . . . . 
. . . . . . . . 7 7 7 . . . 7 7 . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
]]},
{0x0209,"cannon_ball",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . O O O O . . . . . . . . . . 
. . . . . . . R O O O O O O O O R . . . . . . . 
. . . . . . R R R O O O O O O R R R . . . . . . 
. . . . . R R R R O O O O O O R R R R . . . . . 
. . . . . 5 R R R R O O O O R R R R c . . . . . 
. . . . . 5 5 5 R R O O O O R R c c c . . . . . 
. . . . 5 5 5 5 5 5 R 0 0 R c c c c c c . . . . 
. . . . 5 5 5 5 5 5 0 0 0 0 c c c c c c . . . . 
. . . . 5 5 5 5 5 5 0 0 0 0 c c c c c c . . . . 
. . . . 5 5 5 5 5 5 R 0 0 R c c c c c c . . . . 
. . . . . 5 5 5 R R o o o o R R c c c . . . . . 
. . . . . 5 R R R R o o o o R R R R c . . . . . 
. . . . . R R R R o o o o o o R R R R . . . . . 
. . . . . . R R R o o o o o o R R R . . . . . . 
. . . . . . . R o o o o o o o o R . . . . . . . 
. . . . . . . . . . o o o o . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
]]},
{0x0500,"coin",[[
. . . . . . . . 
. . Y Y Y Y . . 
. Y Y 0 0 Y Y . 
Y Y 0 Y Y 0 Y Y 
Y Y Y 0 0 Y Y Y 
Y Y 0 Y Y 0 Y Y 
. Y Y 0 0 Y Y . 
. . Y Y Y Y . . 
]]},


}


local chat_text=[[

#example Conversation NPC

	A rare bread of NPC who will fulfil all your conversational desires for 
	a very good price.

	=sir sir/madam

	>convo

		Is this the right room for a conversation?
		
	>welcome
	
		...ERROR...EOF...PLEASE...RESTART...

<welcome

	Good Morning {sir},
	
	>morning

		Good morning to you too.

	>afternoon

		I think you will find it is now afternoon.

	>sir

		How dare you call me {sir}!

<sir

	My apologies, I am afraid that I am but an NPC with very little 
	brain, how might I address you?
	
	>welcome.1?sir!=madam

		You may address me as Madam.

		=sir madam

	>welcome.2?sir!=God

		You may address me as God.

		=sir God

	>welcome.3?sir!=sir

		You may address me as Sir.

		=sir sir

<afternoon
	
	Then good afternoon {sir},
	
	>convo

<morning
	
	and how may I help {sir} today?
	
	>convo


<convo

	Indeed it is, would you like the full conversation or just the quick natter?

	>convo_full
	
		How long is the full conversation?

	>convo_quick

		A quick natter sounds just perfect.

<convo_full

	The full conversation is very full and long so much so that you 
	will have to page through many pages before you get to make a 
	decision
	
	>
		Like this?
	<
	
	Yes just like this. In fact I think you can see that we are already 
	doing it.
			
	
	>welcome

<convo_quick

	...
	
	>welcome

]]

local combine_legends=function(...)
	local legend={}
	for _,t in ipairs{...} do -- merge all
		for n,v in pairs(t) do -- shallow copy, right side values overwrite left
			legend[n]=v
		end
	end
	return legend
end

local default_legend={
	[0]={ name="char_empty",	},

	[". "]={ name="char_empty",				},
	["00"]={ name="char_black",				solid=1, dense=1, },		-- black border
	["0 "]={ name="char_empty",				solid=1, dense=1, },		-- empty border

	["||"]={ name="char_wall",				solid=1},				-- wall
	["=="]={ name="char_floor",				solid=1},				-- floor

-- items not tiles, so display tile 0 and we will add a sprite for display
	["S "]={ name="char_empty",	start=1,	},
	["N "]={ name="char_empty",	npc=1,		},

}
	
levels={}

levels[1]={
legend=combine_legends(default_legend,{
	["?0"]={ name="char_empty" },
}),
title="This is a test.",
map=[[
||0000000000000000000000000000000000000000000000000000000000000000000000000000||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||================================================. . . . ====================||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||======. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||==========. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . ||||||||||||. . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . ||||||||||||. . . . . . . . . ||
||==============. . . . ======================================================||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . S . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . N . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ==============||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . ====================================================. . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||============================================================================||
||0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ||
]],
}




-----------------------------------------------------------------------------
--[[#setup_menu

	menu = setup_menu()

Create a displayable and controllable menu system that can be fed chat 
data for user display.

After setup, provide it with menu items to display using 
menu.show(items) then call update and draw each frame.


]]
-----------------------------------------------------------------------------
function setup_menu(items)

	local wstr=require("wetgenes.string")

	local menu={}

	menu.stack={}

	menu.width=80-4
	menu.cursor=0
	menu.cx=math.floor((80-menu.width)/2)
	menu.cy=0
	
	function menu.show(items)

		if items.call then items.call(items,menu) end -- refresh
		
		menu.items=items
		menu.cursor=items.cursor or 1
		
		menu.lines={}
		for idx=1,#items do
			local item=items[idx]
			local text=item.text
			if text then
				local ls=wstr.smart_wrap(text,menu.width-8)
				if #ls==0 then ls={""} end -- blank line
				for i=1,#ls do
					local prefix=""--(i>1 and " " or "")
					if item.cursor then prefix=" " end -- indent decisions
					menu.lines[#menu.lines+1]={s=prefix..ls[i],idx=idx,item=item,cursor=item.cursor,color=item.color}
				end
			end
		end

	end


	
	menu.update=function()
	
		if not menu.items then return end

		local bfire,bup,bdown,bleft,bright
		
		for i=0,5 do -- any player, press a button, to control menu
			local up=ups(i)
			if up then
				bfire =bfire  or up.button("fire_clr")
				bup   =bup    or up.button("up_set")
				bdown =bdown  or up.button("down_set")
				bleft =bleft  or up.button("left_set")
				bright=bright or up.button("right_set")
			end
		end
		

		if bfire then

			for i,item in ipairs(menu.items) do
			
				if item.cursor==menu.cursor then
			
					if item.call then -- do this
					
						item.call( item , menu )
											
					end
					
					break
				end
			end
		end
		
		if bleft or bup then
		
			menu.cursor=menu.cursor-1
			if menu.cursor<1 then menu.cursor=menu.items.cursor_max end

		end
		
		if bright or bdown then
			
			menu.cursor=menu.cursor+1
			if menu.cursor>menu.items.cursor_max then menu.cursor=1 end
		
		end
	
	end
	
	menu.draw=function()

		local tprint=system.components.text.text_print
		local tgrd=system.components.text.tilemap_grd

		if not menu.lines then return end
		
		menu.cy=math.floor((30-(#menu.lines+4))/2)
		
		tgrd:clip(menu.cx,menu.cy,0,menu.width,#menu.lines+4,1):clear(0x02000000)
		tgrd:clip(menu.cx+2,menu.cy+1,0,menu.width-4,#menu.lines+4-2,1):clear(0x01000000)
		
		if menu.items.title then
			local title=" "..(menu.items.title).." "
			local wo2=math.floor(#title/2)
			tprint(title,menu.cx+(menu.width/2)-wo2,menu.cy+0,31,2)
		end
		
		for i,v in ipairs(menu.lines) do
			tprint(v.s,menu.cx+4,menu.cy+i+1,v.color or 31,1)
		end
		
		local it=nil
		for i=1,#menu.lines do
			if it~=menu.lines[i].item then -- first line only
				it=menu.lines[i].item
				if it.cursor == menu.cursor then
					tprint(">",menu.cx+4,menu.cy+i+1,31,1)
				end
			end
		end

		system.components.text.dirty(true)

	end
	

	if items then menu.show(items) end	
	return menu
end


-----------------------------------------------------------------------------
--[[#update

	update()

Update and draw loop, called every frame.

]]
-----------------------------------------------------------------------------
update=function()

	if not setup_done then
		chats=chatdown.setup(chat_text)
		menu=setup_menu( chats.get_menu_items("example") )
		setup_done=true
	end
	
	menu.update()
	menu.draw()
	
end
