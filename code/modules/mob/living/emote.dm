
/* EMOTE DATUMS */
/datum/emote/living
	mob_type_allowed_typecache = /mob/living
	mob_type_blacklist_typecache = list(/mob/living/simple_animal/slime, /mob/living/brain)

/datum/emote/living/blush
	key = "blush"
	key_third_person = "blushes"
	message = "se sonroja."


/datum/emote/living/pray
	key = "pray"
	key_third_person = "prays"
	message = "reza algo."
	restraint_check = FALSE
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_pray()
	set name = "Pray"
	set category = "Emotes"

	emote("pray", intentional = TRUE)

/datum/emote/living/pray/run_emote(mob/user, params, type_override, intentional)
	if(isliving(user))
		var/mob/living/L = user
		var/area/C = get_area(user)
		var/msg = input("Susurra tu plegaria:", "Prayer") as text|null
		if(msg)
			L.whisper(msg)
			L.roguepray(msg)
			if(istype(C, /area/rogue/underworld))
				L.check_prayer_underworld(L,msg)
				return
			L.check_prayer(L,msg)
			for(var/mob/living/LICKMYBALLS in hearers(2,src))
				LICKMYBALLS.succumb_timer = world.time

/mob/living/proc/check_prayer(mob/living/L,message)
	if(!L || !message || !ishuman(L))
		return FALSE
	var/mob/living/carbon/human/M = L
	if(length(message) > 15)
		if(L.has_flaw(/datum/charflaw/addiction/godfearing))
			L.sate_addiction()
		if(L.mob_timers[MT_PSYPRAY])
			if(world.time < L.mob_timers[MT_PSYPRAY] + 1 MINUTES)
				L.mob_timers[MT_PSYPRAY] = world.time
				return FALSE
		else
			L.mob_timers[MT_PSYPRAY] = world.time

		var/patron_name = M?.patron?.name
		if(!patron_name)
			CRASH("check_prayer called with null patron")

		if(!findtext(message, "[patron_name]"))
			return FALSE
		else
			L.playsound_local(L, 'sound/misc/notice (2).ogg', 100, FALSE)
			L.add_stress(/datum/stressevent/psyprayer)
			return TRUE
	else
		to_chat(L, span_danger("Mi plegaria fue algo corta..."))

/mob/living/proc/check_prayer_underworld(mob/living/L,message)
	if(!L || !message)
		return FALSE
	var/list/bannedwords = list("cock","dick","fuck","shit","pussy","ass","cuck","fucker","fucked","cunt","asshole")
	var/mob/living/carbon/spirit/M = L
	for(var/T in bannedwords)
		var/list/turfs = list()
		if(findtext(message, T))
			for(var/turf/U in /area/rogue/underworld)
				if(U.density)
					continue
				turfs.Add(U)

			var/turf/pickedturf = safepick(turfs)
			if(!pickedturf)
				return
			to_chat(L, "<font color='yellow'>INSOLENTE, TU PROBLEMA ES MERECIDO.</font>")
			L.forceMove(pickedturf)
			return FALSE
	if(length(message) > 15)
		if(findtext(message, "[M.patron.name]"))
			L.playsound_local(L, 'sound/misc/notice (2).ogg', 100, FALSE)
			to_chat(L, "<font color='yellow'>I, [M.patron.name], ha escuchado tu plegaria, sin embargo no puede ayudarte.</font>")
			/*var/obj/item/underworld/coin/C = new
			L.put_in_active_hand(C)*/
			return TRUE
		else
			return TRUE
	else
		to_chat(L, span_danger("Mi plegaria fue algo corta..."))

/datum/emote/living/meditate
	key = "meditate"
	key_third_person = "meditate"
	message = "medita."
	restraint_check = FALSE
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_meditate()
	set name = "Meditate"
	set category = "Emotes"

	emote("meditate", intentional = TRUE)

/datum/emote/living/meditate/run_emote(mob/user, params, type_override, intentional)
	if(isliving(user))
		if(!COOLDOWN_FINISHED(user, schizohelp_cooldown))
			to_chat(user, span_warning("Tengo que esperar antes de poder meditar otra vez."))
			return
		var/msg = input("Di tu meditacion:", "Voices in your head") as text|null
		if(msg)
			user.schizohelp(msg)

/datum/emote/living/bow
	key = "bow"
	key_third_person = "bows"
	message = "hace una reverencia."
	message_param = "se inclina ante %t haciendo una reverencia.."
	restraint_check = TRUE
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_bow()
	set name = "Bow"
	set category = "Emotes"

	emote("bow", intentional = TRUE)

/datum/emote/living/burp
	key = "burp"
	key_third_person = "burps"
	message = "eructa."
	message_muffled = "hace un sonido apagado."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_burp()
	set name = "Burp"
	set category = "Noises"

	emote("burp", intentional = TRUE)

/datum/emote/living/choke
	key = "choke"
	key_third_person = "chokes"
	message = "se atraganta!"
	emote_type = EMOTE_AUDIBLE
	ignore_silent = TRUE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_choke()
	set name = "Choke"
	set category = "Noises"

	emote("choke", intentional = TRUE)

/datum/emote/living/cross
	key = "crossarms"
	key_third_person = "crossesarms"
	message = "cruza sus brazos."
	restraint_check = TRUE
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_crossarms()
	set name = "Cross Arms"
	set category = "Emotes"

	emote("crossarms", intentional = TRUE)

/datum/emote/living/collapse
	key = "collapse"
	key_third_person = "collapses"
	message = "colapsa." //como yo si sigo haciendome esto a mi mismo
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/collapse/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && isliving(user))
		var/mob/living/L = user
		L.Unconscious(40)

/datum/emote/living/whisper
	key = "whisper"
	key_third_person = "whispers"
	message = "susurra."
	message_mime = "parece susurrar algo."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/aggro
	key = "aggro"
	key_third_person = "aggro"
	message = ""
	nomsg = TRUE
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/cough
	key = "cough"
	key_third_person = "coughs"
	message = "tose."
	message_muffled = "hace un sonido apagado."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_cough()
	set name = "Cough"
	set category = "Noises"

	emote("cough", intentional = TRUE)

/datum/emote/living/clearthroat
	key = "clearthroat"
	key_third_person = "clearsthroat"
	message = "se aclara la garganta."
	message_muffled = "hace un sonido apagado."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_clearthroat()
	set name = "Clear Throat"
	set category = "Noises"

	emote("clearthroat", intentional = TRUE)

/datum/emote/living/dance
	key = "dance"
	key_third_person = "dances"
	message = "baila."
	restraint_check = TRUE
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_dance()
	set name = "Dance"
	set category = "Emotes"

	emote("dance", intentional = TRUE)

/datum/emote/living/deathgasp
	key = ""
	key_third_person = ""
	message = "suspira su ultimo aliento."
	message_robot = "se agita violentamente antes de quedarse tieso, sus ojos poco a poco se vuelven negros."
	message_AI = "screeches, its screen flickering as its systems slowly halt."
	message_alien = "tiene unos cuantos espasmos antes de llegar a su destino final..."
	message_larva = "suelta un grito para caer rendido en el suelo..."
	message_monkey = "suelta un leve lloriqueo antes de ahogarse en la miseria..."
	message_simple =  "cae al suelo como un muñeco de trapo."
	stat_allowed = UNCONSCIOUS

/datum/emote/living/deathgasp/run_emote(mob/user, params, type_override, intentional)
	var/mob/living/simple_animal/S = user
	if(istype(S) && S.deathmessage)
		message_simple = S.deathmessage
	. = ..()
	message_simple = initial(message_simple)
	if(. && user.deathsound)
		if(isliving(user))
			var/mob/living/L = user
			if(!L.can_speak_vocal() || L.oxyloss >= 50)
				return //stop the sound if oxyloss too high/cant speak
		playsound(user, user.deathsound, 200, TRUE, TRUE)

/datum/emote/living/drool
	key = "drool"
	key_third_person = "drools"
	message = "babea."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_drool()
	set name = "Drool"
	set category = "Emotes"

	emote("drool", intentional = TRUE)

/datum/emote/living/faint
	key = "faint"
	key_third_person = "faints"
	message = "se desmaya."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_faint()
	set name = "Faint"
	set category = "Emotes"

	emote("faint", intentional = TRUE)

/datum/emote/living/faint/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/L = user
		if(L.get_complex_pain() > (L.STAEND * 9))
			L.setDir(2)
			L.SetUnconscious(200)
		else
			L.Knockdown(10)

/datum/emote/living/flap
	key = "flap"
	key_third_person = "flaps"
	message = "agita sus alas."
	restraint_check = TRUE
	var/wing_time = 20

/datum/emote/living/carbon/human/flap/can_run_emote(mob/user, status_check = TRUE , intentional)
	return FALSE

/datum/emote/living/flap/aflap
	key = "aflap"
	key_third_person = "aflaps"
	message = "agita sus alas AGRESIVAMENTE!"
	restraint_check = TRUE
	wing_time = 10

/datum/emote/living/carbon/human/aflap/can_run_emote(mob/user, status_check = TRUE , intentional)
	return FALSE

/datum/emote/living/frown
	key = "frown"
	key_third_person = "frowns"
	message = "frunce el ceño."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_frown()
	set name = "Frown"
	set category = "Emotes"

	emote("frown", intentional = TRUE)

/datum/emote/living/gag
	key = "gag"
	key_third_person = "gags"
	message = "suelta una arcada."
	emote_type = EMOTE_AUDIBLE
	ignore_silent = TRUE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_gag()
	set name = "Gag"
	set category = "Noises"

	emote("gag", intentional = TRUE)

/datum/emote/living/gasp
	key = "gasp"
	key_third_person = "gasps"
	message = "jadea!"
	message_muffled = "hace un sonido apagado."
	emote_type = EMOTE_AUDIBLE
	stat_allowed = UNCONSCIOUS
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_gasp()
	set name = "Gasp"
	set category = "Noises"

	emote("gasp", intentional = TRUE)

/datum/emote/living/breathgasp
	key = "breathgasp"
	key_third_person = "breathgasps"
	message = "jadea en busca de aire!"
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/giggle
	key = "giggle"
	key_third_person = "giggles"
	message = "se rie levemente."
	message_mime = "se rie levemente, y silenciosamente!"
	message_muffled = "hace un sonido apagado."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_giggle()
	set name = "Giggle"
	set category = "Noises"

	emote("giggle", intentional = TRUE)

/datum/emote/living/chuckle
	key = "chuckle"
	key_third_person = "chuckles"
	message = "se rie brevemente."
	message_muffled = "hace un sonido apagado."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_chuckle()
	set name = "Chuckle"
	set category = "Noises"

	emote("chuckle", intentional = TRUE)

/datum/emote/living/glare
	key = "glare"
	key_third_person = "glares"
	message = "mira despiadadamente."
	message_param = "mira de forma despiadada a %t."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_glare()
	set name = "Glare"
	set category = "Emotes"

	emote("glare", intentional = TRUE)

/datum/emote/living/grin
	key = "grin"
	key_third_person = "grins"
	message = "guiña el ojo."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_grin()
	set name = "Grin"
	set category = "Emotes"

	emote("grin", intentional = TRUE)

/datum/emote/living/groan
	key = "groan"
	key_third_person = "groans"
	message = "gime."
	message_muffled = "hace un sonido apagado."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_groan()
	set name = "Groan"
	set category = "Noises"

	emote("groan", intentional = TRUE)

/datum/emote/living/grimace
	key = "grimace"
	key_third_person = "grimaces"
	message = "hace una mueca."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_grimace()
	set name = "Grimace"
	set category = "Emotes"

	emote("grimace", intentional = TRUE)

/datum/emote/living/jump
	key = "jump"
	key_third_person = "jumps"
	message = "jumps!"
	restraint_check = TRUE

/datum/emote/living/leap
	key = "leap"
	key_third_person = "leaps"
	message = "leaps!"
	restraint_check = TRUE
	only_forced_audio = TRUE

/datum/emote/living/kiss
	key = "kiss"
	key_third_person = "kisses"
	message = "lanza un beso."
	message_param = "besa a %t."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_kiss()
	set name = "Kiss"
	set category = "Emotes"

	emote("kiss", intentional = TRUE, targetted = TRUE)

/datum/emote/living/kiss/adjacentaction(mob/user, mob/target)
	. = ..()
	message_param = initial(message_param) // re
	if(!user || !target)
		return
	if(ishuman(user) && ishuman(target))
		var/mob/living/carbon/human/H = user
		var/do_change
		if(target.loc == user.loc)
			do_change = TRUE
		if(!do_change)
			if(H.pulling == target)
				do_change = TRUE
		if(do_change)
			if(H.zone_selected == BODY_ZONE_PRECISE_MOUTH)
				message_param = "besa a %t profundamente."
			else if(H.zone_selected == BODY_ZONE_PRECISE_EARS)
				message_param = "besa a %t en la oreja."
				var/mob/living/carbon/human/E = target
				if(iself(E) || ishalfelf(E))
					if(!E.cmode)
						to_chat(target, span_love("Hace cosquillas..."))
			else if(H.zone_selected == BODY_ZONE_PRECISE_R_EYE || H.zone_selected == BODY_ZONE_PRECISE_L_EYE)
				message_param = "besa a %t en la ceja."
			else
				message_param = "besa a %t en [parse_zone(H.zone_selected)]."
	playsound(target.loc, pick('sound/vo/kiss (1).ogg','sound/vo/kiss (2).ogg'), 100, FALSE, -1)


/datum/emote/living/spit
	key = "spit"
	key_third_person = "spits"
	message = "escupe en el suelo."
	message_param = "le escupe a %t."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_spit()
	set name = "Spit"
	set category = "Emotes"

	emote("spit", intentional = TRUE, targetted = TRUE)


/datum/emote/living/spit/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param) // reset
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mouth)
			if(H.mouth.spitoutmouth)
				H.visible_message(span_warning("[H] spits out [H.mouth]."))
				H.dropItemToGround(H.mouth, silent = FALSE)
			return
	..()

/datum/emote/living/spit/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return
	if(user.gender == MALE)
		playsound(target.loc, pick('sound/vo/male/gen/spit.ogg'), 100, FALSE, -1)
	else
		playsound(target.loc, pick('sound/vo/female/gen/spit.ogg'), 100, FALSE, -1)


/datum/emote/living/hug
	key = "hug"
	key_third_person = "hugs"
	message = ""
	message_param = "da un abrazo a %t."
	emote_type = EMOTE_VISIBLE
	restraint_check = TRUE

/mob/living/carbon/human/verb/emote_hug()
	set name = "Hug"
	set category = "Emotes"

	emote("hug", intentional = TRUE, targetted = TRUE)

/datum/emote/living/holdbreath
	key = "hold"
	key_third_person = "holds"
	message = "empieza aguantar la respiracion."
	stat_allowed = SOFT_CRIT

/mob/living/carbon/human/verb/emote_hold()
	set name = "Hold Breath"
	set category = "Emotes"

	emote("hold", intentional = TRUE)

/datum/emote/living/holdbreath/can_run_emote(mob/living/user, status_check = TRUE, intentional)
	. = ..()
	if(. && intentional && !HAS_TRAIT(user, TRAIT_HOLDBREATH) && !HAS_TRAIT(user, TRAIT_PARALYSIS))
		to_chat(user, span_warning("No estoy tan desesperado como hacer eso."))
		return FALSE

/datum/emote/living/holdbreath/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(.)
		if(HAS_TRAIT(user, TRAIT_HOLDBREATH))
			REMOVE_TRAIT(user, TRAIT_HOLDBREATH, "[type]")
		else
			ADD_TRAIT(user, TRAIT_HOLDBREATH, "[type]")

/datum/emote/living/holdbreath/select_message_type(mob/user, intentional)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_HOLDBREATH))
		. = "deja de aguantar la respiracion."

/datum/emote/living/slap
	key = "slap"
	key_third_person = "slaps"
	message = ""
	message_param = "le da un guantazo a %t en la cara."
	emote_type = EMOTE_VISIBLE
	restraint_check = TRUE


/datum/emote/living/slap/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param) // reset
	// RATWOOD MODULAR START
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.zone_selected == BODY_ZONE_PRECISE_GROIN)
			message_param = "le da un cachetazo %t en el culo!"
	// RATWOOD MODULAR END
	..()

/mob/living/carbon/human/verb/emote_slap()
	set name = "Slap"
	set category = "Emotes"

	emote("slap", intentional = TRUE, targetted = TRUE)

/datum/emote/living/slap/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.flash_fullscreen("redflash3")
		H.AdjustSleeping(-50)
		playsound(target.loc, 'sound/foley/slap.ogg', 100, TRUE, -1)

/datum/emote/living/pinch
	key = "pinch"
	key_third_person = "pinches"
	message = ""
	message_param = "le mete un pellizco a %t."
	emote_type = EMOTE_VISIBLE
	restraint_check = TRUE

/datum/emote/living/pinch/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.flash_fullscreen("redflash1")

/mob/living/carbon/human/verb/emote_pinch()
	set name = "Pinch"
	set category = "Emotes"

	emote("pinch", intentional = TRUE, targetted = TRUE)



/datum/emote/living/laugh
	key = "laugh"
	key_third_person = "laughs"
	message = "se rie."
	message_mime = "se rie silenciosamente!"
	message_muffled = "hace una risa enlatada."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/laugh/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		return !C.silent

/mob/living/carbon/human/verb/emote_laugh()
	set name = "Laugh"
	set category = "Noises"

	emote("laugh", intentional = TRUE)

/datum/emote/living/look
	key = "look"
	key_third_person = "looks"
	message = "mira de forma vacia."
	message_param = "mira hacia %t."

/datum/emote/living/nod
	key = "nod"
	key_third_person = "nods"
	message = "asiente."
	message_param = "le asiente a %t."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_nod()
	set name = "Nod"
	set category = "Emotes"

	emote("nod", intentional = TRUE)

/datum/emote/living/point
	key = "point"
	key_third_person = "points"
	message = "señala."
	message_param = "señala a %t."
	restraint_check = TRUE

/datum/emote/living/point/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param) // reset
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.get_num_arms() == 0)
			if(H.get_num_legs() != 0)
				message_param = "tries to point at %t with a leg, <span class='danger'>falling down</span> in the process!"
				H.Paralyze(20)
			else
				message_param = "<span class='danger'>bumps [user.p_their()] head on the ground</span> trying to motion towards %t."
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5)
	..()

/datum/emote/living/pout
	key = "pout"
	key_third_person = "pouts"
	message = "hace pucheros."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/scream
	key = "scream"
	key_third_person = "screams"
	message = "grita!"
	message_mime = "finge un grito"
	message_muffled = "hace un sonido apagado, intentando soltar un grito!"
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_scream()
	set name = "Scream"
	set category = "Noises"

	emote("scream", intentional = TRUE)

/datum/emote/living/scream/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(intentional)
			if(!C.rogfat_add(10))
				to_chat(C, span_warning("Intento gritar pero la voz me falla."))
				. = FALSE

/datum/emote/living/scream/painscream
	key = "painscream"
	message = "grita de dolor!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/scream/painscream/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(.)
		for(var/mob/living/carbon/human/L in viewers(7,user))
			if(L == user)
				continue
			if(L.has_flaw(/datum/charflaw/addiction/sadist))
				L.sate_addiction()

/datum/emote/living/scream/agony
	key = "agony"
	message = "grita en agonia!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/scream/agony/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(.)
		for(var/mob/living/carbon/human/L in viewers(7,user))
			if(L == user)
				continue
			if(L.has_flaw(/datum/charflaw/addiction/sadist))
				L.sate_addiction()

/datum/emote/living/scream/firescream
	key = "firescream"
	nomsg = TRUE
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/scream/firescream/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(.)
		for(var/mob/living/carbon/human/L in viewers(7,user))
			if(L == user)
				continue
			if(L.has_flaw(/datum/charflaw/addiction/sadist))
				L.sate_addiction()

/datum/emote/living/aggro
	key = "aggro"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/idle
	key = "idle"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/death
	key = "death"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	stat_allowed = UNCONSCIOUS
	mob_type_ignore_stat_typecache = list(/mob/living)
	show_runechat = FALSE

/datum/emote/living/pain
	key = "pain"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/drown
	key = "drown"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	ignore_silent = TRUE
	show_runechat = FALSE

/datum/emote/living/paincrit
	key = "paincrit"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/embed
	key = "embed"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/painmoan
	key = "painmoan"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/groin
	key = "groin"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/fatigue
	key = "fatigue"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/jump
	key = "jump"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/haltyell
	key = "haltyell"
	message = "ordena que te pares!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/rage
	key = "rage"
	message = "grita de furia!"
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_rage()
	set name = "Rage"
	set category = "Noises"

	emote("rage", intentional = TRUE)

/datum/emote/living/attnwhistle
	key = "attnwhistle"
	message = "silba buscando atencion!"
	message_muffled = "hace un sonido apagado."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_attnwhistle()
	set name = "Attnwhistle"
	set category = "Noises"

	emote("attnwhistle", intentional = TRUE)

/datum/emote/living/choke
	key = "choke"
	key_third_person = "chokes"
	message = "se atraganta!"
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/scowl
	key = "scowl"
	key_third_person = "scowls"
	message = "frunce el ceño."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/shakehead
	key = "shakehead"
	key_third_person = "shakeshead"
	message = "agita la cabeza."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_shakehead()
	set name = "Shake Head"
	set category = "Emotes"

	emote("shakehead", intentional = TRUE)


/datum/emote/living/shiver
	key = "shiver"
	key_third_person = "shiver"
	message = "tiembla."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_shiver()
	set name = "Shiver"
	set category = "Emotes"

	emote("shiver", intentional = TRUE)


/datum/emote/living/sigh
	key = "sigh"
	key_third_person = "sighs"
	message = "suspira."
	message_muffled = "hace un suspiro apagado."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_sigh()
	set name = "Sigh"
	set category = "Noises"

	emote("sigh", intentional = TRUE)

/datum/emote/living/whistle
	key = "whistle"
	key_third_person = "whistles"
	message = "silba."
	message_muffled = "hace un sonido apagado."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_whistle()
	set name = "Whistle"
	set category = "Noises"

	emote("whistle", intentional = TRUE)

/datum/emote/living/hmm
	key = "hmm"
	key_third_person = "hmms"
	message = "hace 'hmm...'"
	message_muffled = "hace 'hmm...' de forma apagada."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_hmm()
	set name = "Hmm"
	set category = "Noises"

	emote("hmm", intentional = TRUE)

/datum/emote/living/huh
	key = "huh"
	key_third_person = "huhs"
	message_muffled = "hace un sonido apagado."
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_huh()
	set name = "Huh"
	set category = "Noises"

	emote("huh", intentional = TRUE)

/datum/emote/living/hum
	key = "hum"
	key_third_person = "hums"
	message = "tararea."
	emote_type = EMOTE_AUDIBLE
	message_muffled = "tararea de forma apagada."
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_hum()
	set name = "Hum"
	set category = "Noises"

	emote("hum", intentional = TRUE)

/datum/emote/living/smile
	key = "smile"
	key_third_person = "smiles"
	message = "sonrie."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_smile()
	set name = "Smile"
	set category = "Emotes"

	emote("smile", intentional = TRUE)

/datum/emote/living/sneeze
	key = "sneeze"
	key_third_person = "sneezes"
	message = "estornuda."
	message_muffled = "hace un estornudo apagado."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/shh
	key = "shh"
	key_third_person = "shhs"
	message = "manda a callar."
	message_muffled = "hace un 'shh' apagado."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_shh()
	set name = "Shh"
	set category = "Noises"

	emote("shh", intentional = TRUE)

/datum/emote/living/smug
	key = "smug"
	key_third_person = "smugs"
	message = "hace una mueca sonriente."

/datum/emote/living/sniff
	key = "sniff"
	key_third_person = "sniffs"
	message = "olfatea."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/snore
	key = "snore"
	key_third_person = "snores"
	message = "ronca."
	message_mime = "ronca silenciosamente."
	emote_type = EMOTE_AUDIBLE
	stat_allowed = UNCONSCIOUS
	snd_range = -4
	show_runechat = FALSE

/datum/emote/living/stare
	key = "stare"
	key_third_person = "stares"
	message = "fija la mirada."
	message_param = "mira fijamente a %t."

/datum/emote/living/strech
	key = "stretch"
	key_third_person = "stretches"
	message = "estira sus brazos."

/datum/emote/living/sulk
	key = "sulk"
	key_third_person = "sulks"
	message = "se enfurruña."

/datum/emote/living/sway
	key = "sway"
	key_third_person = "sways"
	message = "se balancea vertiginosamente."

/datum/emote/living/tremble
	key = "tremble"
	key_third_person = "trembles"
	message = "tiembla de miedo!"

/datum/emote/living/twitch
	key = "twitch"
	key_third_person = "twitches"
	message = "se agita violentamente!"

/datum/emote/living/twitch_s
	key = "twitch_s"
	message = "se agita!"
	stat_allowed = UNCONSCIOUS
	mob_type_ignore_stat_typecache = list(/mob/living/carbon/human)

/datum/emote/living/wave
	key = "wave"
	key_third_person = "waves"
	message = "saluda con la mano."

/datum/emote/living/whimper
	key = "whimper"
	key_third_person = "whimpers"
	message = "lloriquea."
	message_mime = "parece estar herido."
	message_muffled = "lloriquea de forma apagada."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_whimper()
	set name = "Whimper"
	set category = "Noises"

	emote("whimper", intentional = TRUE)

/datum/emote/living/wsmile
	key = "wsmile"
	key_third_person = "wsmiles"
	message = "sonrie debilmente."

/datum/emote/living/yawn
	key = "yawn"
	key_third_person = "yawns"
	message = "bosteza."
	message_muffled = "hace un bostezo apagado."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_yawn()
	set name = "Yawn"
	set category = "Noises"

	emote("yawn", intentional = TRUE)

/datum/emote/living/custom
	key = "me"
	key_third_person = "custom"
	show_runechat = TRUE
#ifdef MATURESERVER
	message_param = "%t"
#endif
	//mute_time = 1 - RATWOOD CHANGE, I don't want spammers.
/datum/emote/living/custom/can_run_emote(mob/user, status_check, intentional)
	. = ..() && intentional

/datum/emote/living/custom/proc/check_invalid(mob/user, input)
	. = TRUE
	if(copytext(input,1,5) == "dice")
		to_chat(user, span_danger("Invalid emote."))
	else if(copytext(input,1,9) == "exclama")
		to_chat(user, span_danger("Invalid emote."))
	else if(copytext(input,1,6) == "grita")
		to_chat(user, span_danger("Invalid emote."))
	else if(copytext(input,1,5) == "pregunta")
		to_chat(user, span_danger("Invalid emote."))
	else
		. = FALSE

/datum/emote/living/custom/run_emote(mob/user, params, type_override = null, intentional = FALSE)
	if(!can_run_emote(user, TRUE, intentional))
		return FALSE
	if(is_banned_from(user.ckey, "Emote"))
		to_chat(user, span_boldwarning("I cannot send custom emotes (banned)."))
		return FALSE
	else if(QDELETED(user))
		return FALSE
	else if(user.client && user.client.prefs.muted & MUTE_IC)
		to_chat(user, span_boldwarning("I cannot send IC messages (muted)."))
		return FALSE
	else if(!params)
		var/custom_emote = copytext(sanitize(input("What does your character do?") as text|null), 1, MAX_MESSAGE_LEN)
		if(custom_emote && !check_invalid(user, custom_emote))
/*			var/type = input("Is this a visible or hearable emote?") as null|anything in list("Visible", "Hearable")
			switch(type)
				if("Visible")
					emote_type = EMOTE_VISIBLE
				if("Hearable")
					emote_type = EMOTE_AUDIBLE
				else
					alert("Unable to use this emote, must be either hearable or visible.")
					return*/
			message = custom_emote
			emote_type = EMOTE_VISIBLE
	else
		message = params
		if(type_override)
			emote_type = type_override
	. = ..()
	message = null
	emote_type = EMOTE_VISIBLE

/datum/emote/living/custom/replace_pronoun(mob/user, message)
	return message

/datum/emote/living/help
	key = "help"

/datum/emote/living/help/run_emote(mob/user, params, type_override, intentional)
/*	var/list/keys = list()
	var/list/message = list("Available emotes, you can use them with say \"*emote\": ")

	for(var/key in GLOB.emote_list)
		for(var/datum/emote/P in GLOB.emote_list[key])
			if(P.key in keys)
				continue
			if(P.can_run_emote(user, status_check = FALSE , intentional = TRUE))
				keys += P.key

	keys = sortList(keys)

	for(var/emote in keys)
		if(LAZYLEN(message) > 1)
			message += ", [emote]"
		else
			message += "[emote]"

	message += "."

	message = jointext(message, "")

	to_chat(user, message)*/

/datum/emote/beep
	key = "beep"
	key_third_person = "beeps"
	message = "beeps."
	message_param = "beeps at %t."
	sound = 'sound/blank.ogg'
	mob_type_allowed_typecache = list(/mob/living/brain, /mob/living/silicon)
/*
/datum/emote/living/circle
	key = "circle"
	key_third_person = "circles"
	restraint_check = TRUE

/datum/emote/living/circle/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	var/obj/item/circlegame/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, span_notice("I make a circle with your hand."))
	else
		qdel(N)
		to_chat(user, span_warning("I don't have any free hands to make a circle with."))

/datum/emote/living/slap
	key = "slap"
	key_third_person = "slaps"
	restraint_check = TRUE

/datum/emote/living/slap/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/obj/item/slapper/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, span_notice("I ready your slapping hand."))
	else
		to_chat(user, span_warning("You're incapable of slapping in your current state."))
*/

/datum/emote/living/shake
	key = "shake"
	key_third_person = "shakes"
	message = "agita su cabeza."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_shake()
	set name = "Shake Head"
	set category = "Emotes"

	emote("shake", intentional = TRUE)

/datum/emote/living/squint
	key = "squint"
	key_third_person = "squints"
	message = "entrecierra sus ojos."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_squint()
	set name = "Squint"
	set category = "Emotes"

	emote("squint", intentional = TRUE)