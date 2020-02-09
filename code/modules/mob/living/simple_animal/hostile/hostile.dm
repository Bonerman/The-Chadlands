/mob/living/simple_animal/hostile
	faction = "hostile"
	stop_automated_movement_when_pulled = FALSE
	a_intent = I_HARM
	behaviour = "hunt"

/mob/living/simple_animal
	var/ranged = FALSE
	var/rapid = FALSE //If fires faster
	var/casingtype = null
	var/projectiletype = null
	var/projectilesound = null
	var/fire_desc = "fires"
	var/obj/item/gun = null

/mob/living/simple_animal/proc/FindTarget()

	var/atom/T = null
	stop_automated_movement = FALSE
	var/list/the_targets = ListTargets(7)
	if (behaviour == "hostile")
		for(var/mob/living/ML in the_targets)
			if (!ishuman(ML))
				the_targets -= ML
	for (var/atom/A in the_targets)

		if (A == src)
			continue

		var/atom/F = Found(A)
		if (F)
			T = F
			break

		if (isliving(A))
			var/mob/living/L = A
			if (istype(L, /mob/living/carbon/human))
				var/mob/living/carbon/human/RH = L
				if (RH.faction_text == faction && !attack_same)
					continue
				else if (RH in friends)
					continue
				else if (RH.wolfman && istype(src,/mob/living/simple_animal/hostile/wolf))
					continue
				else if (RH.lizard && istype(src,/mob/living/simple_animal/hostile/alligator))
					continue
				else
					if (!RH.stat)
						stance = HOSTILE_STANCE_ATTACK
						T = RH
						break
			else
				if (L.faction == faction && !attack_same)
					continue
				else if (L in friends)
					continue
				else
					if (!L.stat)
						stance = HOSTILE_STANCE_ATTACK
						T = L
						break
	if (T)
		custom_emote(1,"stares alertly at [T].")
		stance = HOSTILE_STANCE_ALERT
	return T


/mob/living/simple_animal/proc/Found(var/atom/A)
	return

/mob/living/simple_animal/proc/MoveToTarget()
	if (!target_mob || !SA_attackable(target_mob))
		stance = HOSTILE_STANCE_IDLE
	if (target_mob in ListTargets(7))
		stance = HOSTILE_STANCE_ATTACKING
		if(ranged)
			if(get_dist(src, target_mob) <= 5)
				walk_to(src,0)
				OpenFire(target_mob)
			else
				walk_to(src, target_mob, TRUE, move_to_delay)
		else
			walk_to(src, target_mob, TRUE, move_to_delay)
	else if (target_mob in ListTargets(10))
		walk_to(src, target_mob, TRUE, move_to_delay)

/mob/living/simple_animal/proc/AttackTarget()
	if (!target_mob || !SA_attackable(target_mob))
		LoseTarget()
		return FALSE
	if (!(target_mob in ListTargets(7)))
		LostTarget()
		return FALSE
	if (ranged)
		if (get_dist(src, target_mob) <= 5)
			walk_to(src,0)
			OpenFire(target_mob)
		else
			MoveToTarget()
	else
		if (get_dist(src, target_mob) <= 1)	//Attacking
			AttackingTarget()
			return TRUE

/mob/living/simple_animal/proc/AttackingTarget()
	if (!Adjacent(target_mob))
		return
	if(prob(50))
		playsound(src.loc, 'sound/weapons/bite.ogg', 100, TRUE, 2)
	else
		playsound(src.loc, 'sound/weapons/bite_2.ogg', 100, TRUE, 2)
	custom_emote(1, pick( list("slashes at [target_mob]!", "bites [target_mob]!") ) )

	var/damage = pick(melee_damage_lower,melee_damage_upper)

	if (ishuman(target_mob))
		var/mob/living/carbon/human/H = target_mob
		var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
		var/obj/item/organ/external/affecting = H.get_organ(ran_zone(dam_zone))
		if (prob(95) || !can_bite_limbs_off)
			H.apply_damage(damage, BRUTE, affecting, H.run_armor_check(affecting, "melee"), sharp=1, edge=1)
		else
			affecting.droplimb(FALSE, DROPLIMB_EDGE)
			visible_message("\The [src] bites off [H]'s limb!")
			for(var/mob/living/carbon/human/NB in view(6,src))
				NB.mood -= 10
	else if (isliving(target_mob))
		var/mob/living/L = target_mob
		L.adjustBruteLoss(damage)
		if (istype(target_mob, /mob/living/simple_animal))
			var/mob/living/simple_animal/SA = target_mob
			if (SA.behaviour == "defends" || SA.behaviour == "hunt")
				if (SA.stance != HOSTILE_STANCE_ATTACK && SA.stance != HOSTILE_STANCE_ATTACKING)
					SA.stance = HOSTILE_STANCE_ATTACK
					SA.stance_step = 7
					SA.target_mob = src
		return L
/mob/living/simple_animal/proc/LoseTarget()
	stance = HOSTILE_STANCE_IDLE
	target_mob = null
	walk(src, FALSE)

/mob/living/simple_animal/proc/LostTarget()
	stance = HOSTILE_STANCE_IDLE
	walk(src, FALSE)


/mob/living/simple_animal/proc/ListTargets(var/dist = 7)
	var/list/L = hearers(dist,src)
	return L

/mob/living/simple_animal/hostile/Life()

	. = ..()
	if (!.)
		walk(src, FALSE)
		return FALSE
	if (client)
		return FALSE
	if ((prob(20) && (herbivore || carnivore || predatory_carnivore || granivore || scavenger) && simplehunger < 220) || simplehunger < 180)

		check_food() // animals will search for crops, grass, and so on

/mob/living/simple_animal/proc/DestroySurroundings()
	if (prob(break_stuff_probability))
		for (var/dir in cardinal) // North, South, East, West
			for (var/obj/structure/window/obstacle in get_step(src, dir))
				if (obstacle.dir == reverse_dir[dir]) // So that windows get smashed in the right order
					obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
					return
			var/obj/structure/obstacle = locate(/obj/structure, get_step(src, dir))
			if (istype(obstacle, /obj/structure/window) || istype(obstacle, /obj/structure/closet) || istype(obstacle, /obj/structure/table) || istype(obstacle, /obj/structure/grille))
				obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)

/////////////////////////////////////////////////////////
////////////////////RANGED///////////////////////////////

/mob/living/simple_animal/proc/OpenFire(target_mob)
	var/target = target_mob
	visible_message("<span class='danger'>\The [src] [fire_desc] at \the [target]!</span>", 1)
	switch(rapid)
		if(0) //singe-shot
			Shoot(target, src.loc, src)
			if(casingtype)
				new casingtype
		if(1) //semi-auto
			var/shots = rand(1,3)
			var/s_timer = 1
			for(var/i = 1, i<= shots, i++)
				spawn(s_timer)
					Shoot(target, src.loc, src)
					if(casingtype)
						new casingtype(get_turf(src))
				s_timer+=3
		if (2) //automatic
			var/shots = rand(3,5)
			var/s_timer = 1
			for(var/i = 1, i<= shots, i++)
				spawn(s_timer)
					Shoot(target, src.loc, src)
					if(casingtype)
						new casingtype(get_turf(src))
				s_timer+=2
	return

/mob/living/simple_animal/proc/Shoot(var/target, var/start, var/user, var/bullet = 0)
	if(target == start)
		return

	var/obj/item/projectile/A = new projectiletype(get_turf(user))
	playsound(user, projectilesound, 100, 1)
	if(!A)	return
	var/def_zone = pick("chest","head")
	if (prob(8))
		def_zone = pick("l_arm","r_arm","r_leg","l_leg")
	A.launch(target, user, src.gun, def_zone, rand(-1,1), rand(-1,1))

/////////////////////////////AI STUFF///////////////////////////////////////////////
//Special behaviour for human hostile mobs, taking cover, grenades, etc.
/mob/living/simple_animal/proc/do_human_behaviour()
	if (!target_mob)
		return "no target"
	var/tdir = 0
	if (target_mob.x >= src.x)
		tdir = EAST
	if (target_mob.x < src.x)
		tdir = WEST
	if (target_mob.y < src.y)
		tdir = SOUTH
	if (target_mob.y >= src.y)
		tdir = NORTH

	for(var/obj/structure/window/sandbag/SB in range(4,src))
		if (SB.dir == tdir && get_dist(src,SB) < get_dist(src,target_mob))
			walk_to(src, SB, TRUE, move_to_delay)
			return "take cover"
