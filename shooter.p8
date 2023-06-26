pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
function _init()
 p={x=60,y=90,speed=2}
 bullets={}
 enemies={}
 explosions={}
 create_stars()
 boss={}
 boss_bombs={}
 score=0
 state=0
end

function _update60()
	if (state==0) update_game()
	if (state==1) update_gameover()
end

function _draw()
	if (state==0) draw_game()
	if (state==1) draw_gameover()
end

function update_game()
	update_player()
	update_bordure()
	update_life()
 update_bullets()
 update_stars()
 update_life()
 if #enemies==0 then
 	spawn_enemies(2+ceil(rnd(3))) 		
	end
 update_enemies()
 update_explosions()
 update_boss()
 if score==300 then
		spawn_boss(1)	
	end
	delete_enemies()
	update_bombs()
end

function draw_game()
	cls()
 --stars
 for s in all(stars) do
 	pset(s.x,s.y,s.col)
 end
	--affichage vaisseau
	spr(146,p.x,p.y,2,2)
	--life
	spr(life_full_sprite,life_full_x,life_full_y)
	spr(life_demi_sprite,life_demi_x,life_demi_y)
	spr(life_empty_sprite,life_empty_x,life_empty_y)
	--enemis
	for e in all (enemies) do
		spr(128,e.x,e.y,1,1,true,true)
	end
	--explosions
	draw_explosions()
	--affichage bullets
	for i in all(bullets) do
		spr(129,i.x,i.y)
 end
 for b in all (boss) do
		spr(68,b.x,b.y,4,4,false,true)
	end
	for b in all(boss_bombs) do
		spr(73,b.x,b.y)
 end
 --score
 print("score:\n"..score,2,2,11)
end
-->8
--bullets

function shoot()
	new_bullet={
	x=p.x,
	y=p.y,
	speed=4
	}
	add(bullets,new_bullet)
	sfx(0)
end

function update_bullets()
	for b in all(bullets) do
		b.y-=b.speed
		if b.y<-8 then 
			del(bullets,b)
		end	
	end
end
-->8
--stars

function create_stars()
	stars={}
	for i=1,14 do
		new_star={
			x=rnd(128),
			y=rnd(128),
			col=1,
			speed=0.5+rnd(0.5)
		}
		add(stars,new_star)
	end
		
	for i=1,9 do
		new_star={
			x=rnd(128),
			y=rnd(128),
			col=rnd({10,14,15}),
			speed=2+rnd(2)
		}
		add(stars,new_star)
		end
end

function update_stars()
	for s in all(stars) do
		s.y+=s.speed
		if s.y > 128 then
			s.y=0
			s.x=rnd(128)
		end	
	end	
end
-->8
--enemies

function spawn_enemies(nombre)
	gap=(128-8*nombre)/(nombre+1)
	for i=1,nombre do
		new_enemy={
			x=gap*i+8*(i-1),
			y=-20,
			life=2
		}
		add(enemies,new_enemy)
	end
end

function update_enemies()
	for e in all(enemies) do	
		e.y+=0.5
		if e.y > 130 then 
			del(enemies,e)
		end
		--collision
		for b in all (bullets) do
			if collision(e,b) then
				create_explosion(b.x,b.y)
				del(bullets,b)
				e.life-=1
				if e.life==0 then 
				del(enemies,e)
				score+=100
				end
			end
		end
	end
end

function delete_enemies()
	for e in all(enemies) do	
		if score==300 then
			del(enemies,e)
		end
	end
end		
-->8
--collisions
function collision(a,b)
	if a.x>b.x+8 
	or a.y>b.y+8
	or a.x+8<b.x
	or a.y+8<b.y then 
		return false
	else
		return true
	end
end

-->8
--explosions	
function create_explosion(x,y)
	sfx(1)
	add(explosions,{x=x,y=y,timer=0})
end

function update_explosions()
	for e in all(explosions) do
		e.timer+=1
		if e.timer==13 then
			del(explosions,e)
		end
	end
end

function draw_explosions()
	--circ(x,y,rayon,couleur)
	
	for e in all(explosions) do
		circ(e.x,e.y,e.timer/3,
							8+e.timer%3)
	end
end

-->8
--player

function update_player()
 if (btn(➡️)) p.x+=p.speed
 if (btn(⬅️)) p.x-=p.speed
 if (btn(⬆️)) p.y-=p.speed
 if (btn(⬇️)) p.y+=p.speed
 if (btnp(❎)) shoot()
end 
 
function update_bordure()
	if p.x < 0 then 
		p.x=1
	end
	if p.x > 127 then
		p.x=110
	end
 
 for e in all(enemies) do
 	if collision(e,p) then
 		state=1
 		end
 	end
end


-->8
--game over
function update_gameover()
	if (btn(🅾️)) _init()
	
end

function draw_gameover()
	cls(0)
	--rectfill(x,y,x2,y2,couleur)
	rectfill(15,40,105,90,7)
	print("score:\n"..score,50,50,3)
	print("press c to continue",20,70,3)
end
-->8
--life
life_full_sprite=182
life_full_x=120
life_full_y=1

life_demi_sprite=181
life_demi_x=112
life_demi_y=1

life_empty_sprite=180
life_empty_x=104
life_empty_y=1


function update_life()
end

function draw_life()
		spr(life_full_sprite,life_full_x,life_full_y)
		spr(life_demi_sprite,life_demi_x,life_demi_y)
		spr(life_empty_sprite,life_empty_x,life_empty_y)

end
-->8
--boss

function spawn_boss(nombre)
	gap=(104-32*nombre)/(nombre+1)
	for i=1,nombre do
		new_boss={
			x=gap*i+32*(i-1),
			y=-1,
			life=2,
		shoot_timer=0
		}
		add(boss,new_boss)
	end	
end

function update_boss()
	for b in all(boss) do
		if b.y<15 then
			b.y+=0.5
		end		
		new_boss.shoot_timer+=1
		if new_boss.shoot_timer==120 then
			shoot_boss(new_boss)
			new_boss.shoot_timer=0
		end
	end	
end

--shoot_boss
function angle_to(x1,y1,x2,y2)
	return atan2(y2-y1,x2-x1)+0.25
end	

function shoot_boss(boss)
	local angle=angle_to(boss.x,boss.y,p.x,p.y)
	local new_bomb={
		x=boss.x+2, y=boss.y+5,
		w=4, h=5,
		speed=2,
		dx=cos(angle),
		dy=-sin(angle)
	}
	add(boss_bombs,new_bomb)
end

function update_bombs()
	for b in all (boss_bombs) do
		b.x+=b.dx*b.speed
		b.y+=b.dy*b.speed
		if (b.y>128) del(boss_bombs,b)
	end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000ccc100000000000000000000000000cccccc111000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000cc1111000000000000000000000000cc11111111000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000c1661110000000000000000000000ccc11111111100000000000000000000000000000000000000000000000000000000000000000000000000
000000002000c1666611000200000000000000000cc1111777711111000002200000000000000000000000000000000000000000000000000000000000000000
00000000020666662666d0200000000022000000cc11111722711111000002200000000000000000000000000000000000000000000000000000000000000000
00000000002666622266d2000000000022000000cc11777722777777d00220000000000000000000000000000000000000000000000000000000000000000000
0000000000d666222226dd00000000000022000ccc11772522527777d00220000000000000000000000000000000000000000000000000000000000000000000
0000000000d666622266dd0000000000002200777777772255227777d22000000000000000000000000000000000000000000000000000000000000000000000
0000000000d666622266dd0000000000000022577772222222222227d22000000000000000000000000000000000000000000000000000000000000000000000
0000000000d666662666dd0000000000000022577772222222222227ddd000000000000000000000000000000000000000000000000000000000000000000000
000000000055525555525500000000000000ddd77777722222222777ddd000000000000000000000000000000000000000000000000000000000000000000000
000000000dd66666666dddd0000000000000ddd77777728222282777ddd000000000000000000000000000000000000000000000000000000000000000000000
00000000ddd6666666666ddd000000000000ddd77777722522522777ddd000000000000000000000000000000000000000000000000000000000000000000000
000000008899888899888998000000000000ddd77777725222252777ddd000000000000000000000000000000000000000000000000000000000000000000000
000000000899800899808998000000000000ddd77777722222222777ddd000000000000000000000000000000000000000000000000000000000000000000000
000000000088000088000880000000000000ddd77777722222222777ddd000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000ddd77777777722777777ddd000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000ddd77777777722777777ddd000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000055555225555555555522555000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000055555225555555555522555000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000ddd777777777777777ddddd000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000ddd777777777777777ddddddd0000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000ddddd777777777777777777dddd0000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000ddddd777777777777777777dddd0000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000ddddddd777777777777777777dddddd00000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000ddddddd777777777777777777dddddd00000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000888899998888888999988888899998800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000888899998888888999988888899998800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000008899998800088999988008899998800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000008899998800088999988008899998800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000088880000000888800000088880000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000088880000000888800000088880000000000000000000000000000000000000000000000000000000000000000000
001001000aa00aa00000000070666000070000700333333000000000000000000888888000888800088898884444444400444400111111110000000000000000
001001000aa00aa00000000070000000708ee80733333333000aa0000007c00008888880008889800889998899999999044545401a1111110000000000000000
01d28d10099009900001110070606000770ee0773833833300aaaa00007ccc000777777008888998088999984545454545454545111111710000000000000000
01d22d10000000001001c100d5d6d50070000007333333330dddddd007cc1cc00777777000899980088999884545454545454dd5111111110000000000000000
d11dd11d0990099001051500606660d007d00d70337070736a6a6a6a0cccc7c00778777000099900008999804545454545454dd5111111110000000000000000
d111111d0000000010005001006660d0770dd0703000000305959590a555555a0789877005898550058985504545454545454545111111110000000000000000
050dd0500000000010101101005050007707707737070703005555002a5a5a520777777007775770077757709999999945454545117111110000000000000000
00000000000000000151511000606000770770773333333300000000022222200888888008888880088888804444444445555555111111110000000000000000
000000060000000000000006000000000000000660000000000000ccc10000000000000700000000000000000000000000000000000000000000000000000000
0000000d000000000000006760000000000000055000000000000cc1111000000000007770000000000000000000000000000000000000000000000000000000
000000ada00000000000066766000000000000670600000000000c16611100000000007c70000000000000000000000000000000000000000000000000000000
000000ddd0000000000007666700000000000060760000002000c16666110002000007ccc7000000000000000000000000000000000000000000000000000000
000000d5d000000000006771776000000000065005600000020666662666d020000087ccc7800000000000000000000000000000000000000000000000000000
000000d5d000000000076771776700000000615775160000002666622266d200000887ccc7880000000000000000000000000000000000000000000000000000
000000ddd00000000077677177677000000061577516000000d666222226dd000088878c77888000000000000000000000000000000000000000000000000000
000008ddd80000000777677177677700000661577516600000d666622266dd000888877777888800000000000000000000000000000000000000000000000000
00000666660000007787677177678770006611500511660000d666622266dd008888878777888880000000000000000000000000000000000000000000000000
00006606066000007777677177677770066117577571166000d666662666dd000888887778888800000000000000000000000000000000000000000000000000
00006006006000007777677177677770661170570507116600555255555255000080801710808000000000000000000000000000000000000000000000000000
0000500500500000767667717766767061100057050001160dd66666666dddd00000001110000000000000000000000000000000000000000000000000000000
000000000000000006666771776666006677775775777766ddd6666666666ddd0000009aa9000000000000000000000000000000000000000000000000000000
00008000008000000999677177699900066677555577666088998888998889980000a09aa0000000000000000000000000000000000000000000000000000000
0000a00000a000000898067176089800066666688666660008998008998089980000009aa9000000000000000000000000000000000000000000000000000000
00000000000000000888066666088800000000666660000000880000880008800000909090000000000000000000000000000000000000000000000000000000
05550000000000000000000005555550008808e0008808e0008808e0000000000000000000000000000000000000000000000000000000000000000000000000
05550000000000004444444405555550080080080888800808888888000000000000000000000000000000000000000000000000000000000000000000000000
00600000000000004444444405555550080000080888000808888888000000000000000000000000000000000000000000000000000000000000000000000000
06660000044444404540004405555550080000080888800808888888000000000000000000000000000000000000000000000000000000000000000000000000
44444444044444404440004406666660080000080888000808888888000000000000000000000000000000000000000000000000000000000000000000000000
44000044044444404540004406000060008000800088808000888880000000000000000000000000000000000000000000000000000000000000000000000000
44000044044444404440004406000060000808000008880000088800000000000000000000000000000000000000000000000000000000000000000000000000
44000044044444404540004406666660000080000000800000008000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002b5502e550275501d55016550115500952004520000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300002365021650316503064030620216000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
