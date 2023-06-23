pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
--the alop's adventure--
--by alop's team--

function _init()
	create_player()
	init_msg()
	init_camera()
	create_msg("alop:",
	"me voila sur place\nbon ou est grogu?")
end

function _update()
	if not messages[1] then
		player_movement()
	end
	update_camera()
	update_msg()
end

function _draw()
	cls()
	draw_map()
	draw_player()
	draw_ui()
	draw_msg()
end
-->8
--player--

function create_player()
	p={
		x=8,y=11,
		ox=0,oy=0,
		start_ox=0,start_oy=0,
		anim_t=0,
		sprite=80,
		keys=0
	}
end

function player_movement()
	newx=p.x
	newy=p.y
	if p.anim_t==0 then
		if btn(➡️) then 
			newx+=1
			newox=-8
			newoy=0
			p.flip=false
		elseif btn(⬅️) then
			newx-=1
			newox=8
			newoy=0
			p.flip=true
		elseif btn(⬇️) then
			newy+=1
			newoy=-8
			newox=0
		elseif btn(⬆️) then
			newy-=1
			newoy=8
			newox=0
		end
	end
	
	interact(newx,newy)	
	
	if not check_flag(0,newx,newy)
	and (p.x!=newx or p.y!=newy) then
		p.x=newx
		p.y=newy
		p.start_ox=newox
		p.start_oy=newoy
		p.anim_t=1
	end
	
	--animation
	p.anim_t=max(p.anim_t-0.125,0)
	p.ox=p.start_ox*p.anim_t
	p.oy=p.start_oy*p.anim_t
	
		if p.anim_t>=0.5 then
			p.sprite=80
		else
			p.sprite=81
		end
		--operateur ternaire
		--p.sprite=condition and 1 or 2
		--p.sprite=p.anim>=0.5 and 80 or 81
end

function interact(x,y)
	if check_flag(1,x,y) then
		pick_up_key(x,y)
	elseif check_flag(2,x,y)
	and p.keys>0 then
		open_door1(x,y) 
	end
	if x==20 and y==5 then
		create_msg("grogu",
		"sauve moi !\nj'ai peur au secours")		
	end
	if x==23 and y==10 then
		create_msg("greedo",
		"ahah grogu est la\na moi la prime")
	end
end

function draw_player()
	spr(p.sprite,p.x*8+p.ox,p.y*8+p.oy,
	1,1,p.flip)
end
	
-->8
--map--

function draw_map()
	map(0,0,0,0,128,64)
end


function init_camera()
	camx,camy=0,0
end

function update_camera()
	sectionx=flr(p.x/16)*16
	sectiony=flr(p.y/16)*16
	
	destx=sectionx*8
	desty=sectiony*8
	
	diffx=destx-camx
	diffy=desty-camy
	
	diffx/=8
	diffy/=8
	
	camx+=diffx
	camy+=diffy
	
	camera(camx,camy)
end

function check_flag(flag,x,y)
	local sprite=mget(x,y)
	return fget(sprite,flag)
end

function next_tile(x,y)
	sprite=mget(x,y)
	mset(x,y,sprite+1)
end

function pick_up_key(x,y)
	next_tile(x,y)
	p.keys+=1
end

function open_door1(x,y)
	next_tile(x,y)
	p.keys-=1
end
-->8
--textes--
function grogu(x,y)
	if x==20 and y==5 then
		create_msg("grogu",
		"sauve moi !\nj'ai peur au secours")		
	end
end

function greedo(x,y)
	if x==23 and y==13 then
		create_msg("greedo",
		"ahah grogu est la\na moi la prime")
	end
end

-->8
--ui--

function draw_ui()
	camera(0,0)
	palt(0,false)
	palt(12,true)
	spr(8,2,2)
	print_outline("X"..p.keys,10,2,7)
	palt()
end

function print_outline(text,x,y)
	print(text,x-1,y,0)
	print(text,x+1,y,0)
	print(text,x,y-1,0)
	print(text,x,y+1,0)
	print(text,x,y,7)	
end
-->8
--message--

function init_msg()
	messages={}
end

function create_msg(name,...)
	msg_title=name
	messages={...}
end

function update_msg()
	if (btnp(❎)) then
		deli(messages,1)
	end
end

function draw_msg()
	if messages[1] then
		local y=100
		if p.y%16>9 then
			y=20
		end 
		rectfill(1,y+8,126,y+22,10)
		rectfill(2,y+9,125,y+21,4)
		print(messages[1],4,y+10,7)
		rectfill(1,y+1,
		4+#msg_title*4,y+8,10)
		rectfill(2,y+2,
		3+#msg_title*4,y+8,4)
		print(msg_title,4,y+3,7)
	end	
end
__gfx__
0000000077777777575757577777777777777777777775555555555577777777cccccccc565115655551155556565656111111115555555577777777cccccccc
000000007777777657575757aaaa777677777776777765655eeee5e57777777600000ccc55511555565115655556565611111111588885857777777600000ccc
007007007777777657575757a7eaaaaa77777776777765555e55e5e577777776aaaa0000565115655551155556565656111711115855858577777776aaaa0000
000770007777777657575757aeea4a4a44444444777765655e55e5e577777776a7eaaaaa555115555651156555565656111111115855858577777776a78aaaaa
000770007777777655555555aaaa444444444444777765555eeee5e577777776aeea0a0a565115655551155556555555111111115888858577777776a88a0a0a
0070070077777776777777774444444444444444777765655eeee5e577777776aaaa0000555115555651156555566666555115555888858577777776aaaa0000
0000000077777776777777766eeee2256eeee225777765555eeee5e57777777600000cc056511565555115555656656656511565588885857777777600000ccc
0000000076666666766666666666555566665555777765655555555576666666cccccccc555115555651156555566666555115555555555576666666cccccccc
00000000000000001111111111111111111111111111155511111555111115555651111156511111565111115555555511111111111111115551111111111555
0000000000000000171111111111171111111111111115651117156511111565555111a155511111555111117575757511111111111111115651111111111565
00000000000000001111111111111111111111111a11155511111555111115555651111156511111565111115555555511171111111711115557111111171555
0000000000000000111111a111111111111111111111156511111565111115655551111155511711555111117575757511111111111111115651111111111565
00000000000000001111111111111111111111111111155511111555111115555651111156511111565111117575757511111111111111115651111111111565
00000000000000005555555555555555555555551111156511111565111115655551711155511111555111117575757511111555555111115651111111111565
00000000000000006565656565656565656565651111155517111555111115555651111156511111565111117575757511111565565111115651111111111565
00000000000000005555555555555555555555551111156511111565111115655551111155511111555111115555555511111555555111115551111111111555
000000005555555577777777cccccccc7888888700888800088898880000000000000000000600001111111d215555550000000d200000000000000000000000
00000000522225257555557600000ccc7888888600888980088999880000000760000000000d0000111111177156565600000007700000000000000000000000
000000005255252575777576aaaa00007667777608888998088999980000007776000000000d0000111111d772565656000000d7720000000000000000000000
000000005255252575777576a72aaaaa766777760089998008899988000000777600000000bd80001111117d275656560000007d270000000000000000000000
000000005222252575777576a22a0a0a766877760009990000899980000000777600000000d1d00011117d7cc725565600007d7cc72600000000000700000000
000000005222252575555576aaaa00007689877605898550058985500000077cc760000000d1d00011177dc7c127565600077dc7c12760000000007760000000
00000000522225257777777600000ccc7667777607775770077757700000a7c7c168000000dcd00011777dccc127755600777dccc12776000000007c60000000
000000005555555576666666cccccccc788888860888888008888880000a97ccc169800000ddd00017787dccc127875507787dccc1278760000007c716000000
0000000075555577755555777772222277777777555555557777777700a997ccc169980000d5d00077777d7c1727777677777d7c172777760000b7cc16300000
0000000075b585767585b57677eeeee27777777656565657777777760a99977c1769998000d6d00077777d7d2727777677777d7d27277776000b37cc16330000
00000000755555767555557677e4e4e2777771115656565777777111a99997777769999800ddd00077d7dd7d2722727677d7dd7d2722727600bb377176333000
0000000046666644466666447beeeee99999ccc1565656577555ddd1a99997777769999808ddd80077dddd7d2722227677dddd7d272222760bb3377776333300
000000004666664446666644bbbbb3aaaaa9c5c1565656576665d5d10aaaa777776888800666660011666d7d2726651100666d7d27266500bbb3377766333330
000000004444444444444444b5b5b3a4a4a9ccc1565656576465ddd10000007666000000660606601160517777160511089a98777789a9800bbb337663333300
000000007775566677755666b5b5b3a4a4a9c5c1565656576465d5d100000ddddd10000060060060116551d772155511089a98d77289a98000b0b01610303000
000000007555555675555556bbbbb6aaaaa6ccc6555555556666ddd600000dd11110000050050050111111dd22111111008980dd220898000000001110000000
7777777777777777777b77b777b77b7700e1110000e111000665000006650000005566000055660006667000066670005533bb005533bb000600050606000506
777733377777777777bbbb7777bbbb7700eeb00000eeb0006e5250006e5250000525e6e00535b6b06677770066777700358888b0358888b00666660606666606
773333337777333777b8b87777b8b87700ee2200e0ee22006b53505a695855a09999aaaa9999aaaa6655557066555575381111b0381111b0061ff106061ff106
777730307733333377bbbb7777bbbb770eeeeb000eeeeb00ee222050ee22250005556660055566606677577566775775338818b0338818b006ffff0606ffff06
7777f333777730307711b173b711b177e02ee222002ee20066555050665555000005660000056600667757756677577533b818b033b818b00033330600333306
7777ffff7777f3337b1111377b11113700eeeb2000eeeb206a5955506a59550000505060005050600067770500677775005666dd055666d90f3333450f333345
77777f4f7777ff4fb7448477774484730eeee22000eee2000650000006050000050050060500560006556575065565000544a4600044a4600fbbbb05f0bbbb05
7666ff4f766fff4f76166167766116670bbbbb3000bbbb00665500006605500000500600500500000060070000067000005006000005600000f00406000f4006
05555000055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555500555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5f3ff3505f3ff3500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55ffff5055ffff500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55888850558888500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08444400084444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08556500805565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08400400800440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999900044444000444440004444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99ffff0044ffff0004ffff0004ffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
994ff490443ff340041ff10004cffc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99ffff9044ffff400444440004444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99777790442222400011110000777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9f7777f00f2222f00f1111f00f7777f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90111100002222000044440000444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010010000d00d000040040000400400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111a11111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111117111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11a11111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
111111711111111111111a1100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000051101010101010101010101010101010
10101010101010101010101010101091000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000061101010101010101010101010101010
10101010101010101010101010101091000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000051101010101010101010101010101010
101010101010101010101010101010a1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000071101010101010101010101010101010
10101010101010101010101010101091000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000061101010101010101010101010101010
10101010101010101010101010101081000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000051101010101010101010101010101010
10101010101010101010101010101091000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000071101010101010101010101010101010
101010101010101010101010101010a1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000061101010101010101010101010101010
10101010101010101010101010101081000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000051101010101010101010101010101010
10101010101010101010101010101091000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000061101010101010101010101010101010
101010101010101010101010101010a1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000071101010101010101010101010101010
10101010101010101010101010101091000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000051101010101010101010101010101010
10101010101010101010101010101081000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000071101010101010101010101010101010
101010101010101010101010101010a1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000051101010101010101010101010101010
10101010101010101010101010101091000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000061101010101010101010101010101010
10101010101010101010101010101081000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1
b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000301010500000101000109000000000101010101010101010101010101001100000100000000000001000000000001010101000100000000000000000001010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1c12131412131414131214131412130c0c13121412141213141214131214121214131214121412131414121413141214121412131214121413141312141214131412141314131213141314131214131412121413121413131214131214121313141214131213131412131413121414131314121314121412131414131214131d
1702020202020202020202020202020909020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020219
1536360136010101010136360101010a0901010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101011a
1601363334010301010101333436010a0901010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101011a
1533340101010101010101363334010a09010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010118
1736010101010101010101013601010a09010101400101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010119
173334240101010101010133340101090901010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101011a
1601012424010101010101222222220622222222222222222222222201010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010119
1701010101010101010101220101010a0901010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101011a
161b1b1b1b1b1b1b010101220101010a09010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010119
7171717171717116310101220101010a09010101010101420101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010118
71717072712a2b35222222220133340a0901010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101011a
71727171713a3b16010101010124360a09010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010118
7171717171717115333401240136360a09010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010118
7071727171727116013601013334010a09010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010119
72717171707171171b1b1b1b1b1b1b0a0a1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b0101010101010101010101010101010101010101010101010101010101011b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b01010101010101010101010101011b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1e
0000000000000000000000000000000017010101010101010101010101010118000000000000000000000000000000001501010101010101010101010101010101010101010101010101010101010119000000000000000000000000000000001701010101010101010101010101011a00000000000000000000000000000000
000000000000000000000000000000001601010101010101010101010101011a000000000000000000000000000000001701010101010101010101010101010101010101010101010101010101010118000000000000000000000000000000001501010101010101010101010101011900000000000000000000000000000000
000000000000000000000000000000001601010101010101010101010101011800000000000000000000000000000000160101010101010101010101010101010101010101010101010101010101011a000000000000000000000000000000001601010101010101010101010101011800000000000000000000000000000000
0000000000000000000000000000000017010101010101010101010101010119000000000000000000000000000000001501010101010101010101010101010101010101010101010101010101010119000000000000000000000000000000001501010101010101010101010101011a00000000000000000000000000000000
000000000000000000000000000000001501010101010101010101010101011a000000000000000000000000000000001501010101010101010101010101010101010101010101010101010101010119000000000000000000000000000000001601010101010101010101010101011800000000000000000000000000000000
0000000000000000000000000000000016010101010101010101010101010118000000000000000000000000000000001701010101010101010101010101010101010101010101010101010101010118000000000000000000000000000000001701010101010101010101010101011900000000000000000000000000000000
000000000000000000000000000000001601010101010101010101010101011a00000000000000000000000000000000160101010101010101010101010101010101010101010101010101010101011a000000000000000000000000000000001501010101010101010101010101011a00000000000000000000000000000000
0000000000000000000000000000000017010101010101010101010101010119000000000000000000000000000000001501010101010101010101010101010101010101010101010101010101010119000000000000000000000000000000001601010101010101010101010101011800000000000000000000000000000000
000000000000000000000000000000001501010101010101010101010101011800000000000000000000000000000000170101010101010101010101010101010101010101010101010101010101011a000000000000000000000000000000001701010101010101010101010101011900000000000000000000000000000000
000000000000000000000000000000001601010101010101010101010101011a000000000000000000000000000000001501010101010101010101010101010101010101010101010101010101010118000000000000000000000000000000001501010101010101010101010101011800000000000000000000000000000000
0000000000000000000000000000000017010101010101010101010101010119000000000000000000000000000000001601010101010101010101010101010101010101010101010101010101010119000000000000000000000000000000001601010101010101010101010101011a00000000000000000000000000000000
0000000000000000000000000000000016010101010101010101010101010118000000000000000000000000000000001501010101010101010101010101010101010101010101010101010101010118000000000000000000000000000000001701010101010101010101010101011800000000000000000000000000000000
000000000000000000000000000000001501010101010101010101010101011a00000000000000000000000000000000170101010101010101010101010101010101010101010101010101010101011a000000000000000000000000000000001601010101010101010101010101011900000000000000000000000000000000
0000000000000000000000000000000016010101010101010101010101010118000000000000000000000000000000001601010101010101010101010101010101010101010101010101010101010119000000000000000000000000000000001501010101010101010101010101011900000000000000000000000000000000
000000000000000000000000000000001701010101010101010101010101011a00000000000000000000000000000000150101010101010101010101010101010101010101010101010101010101011a000000000000000000000000000000001701010101010101010101010101011800000000000000000000000000000000
000000000000000000000000000000001f1b1b1b1b1b1b1b1b1b1b1b1b1b1b1e000000000000000000000000000000001701010101010101010101010101010101010101010101010101010101010118000000000000000000000000000000001f1b1b1b1b1b1b1b1b1b1b1b1b1b1b1e00000000000000000000000000000000
__sfx__
0009000033650326502f6402d6402a6302863025620216201e6201a6101761014610116100d6100a6100761005610026100060000600000000000000000000000000000000000000000000000000000000000000
000300003a06035060310602d0502a0402504025030290302c020310403504039050390503604033030320202e0402c0502803000000000000000000000000000000000000000000000000000000000000000000
000900001355017550195501b5001f5001e5001c5001b50019500175001650014500115000e5000b5000150000000000000000000000000000000000000000000000000000000000000000000000000000000000
000f00001905018050150500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300002965025650216501c6401a6401464013630116300f6300c62009620076200661000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c0011240142601428034290442b0542d0642f06424074260642806425064270642a0542c0342e0242401426014000000000000000000000000000000000000000000000000000000000000000000000000000
001000003005330053300533005330053300533005330053000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300000f3110f321103411235114361173711a3711e36122361263512a3512e3312f33100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000800001467014670146601464014630146201461014610146001460000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a00002d0552d055000001800018000000000000000000180551805500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
