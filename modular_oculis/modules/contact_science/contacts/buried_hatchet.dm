/mob/living/simple_animal/formic/buried_hatchet
	name = "Buried Hatchet"
	desc = "Will you unbury the hatchet?"
	icon = 'modular_oculis/modules/contact_science/icons/buried_hatchet.dmi'
	icon_state = "buried_hatchet"

	nanotrasen_id = "NT-ARDB-013"
	primary_hazard_labels = "N/A"
	secondary_hazard_labels = "Hostile manifestation"
	initial_line = "Oh, would you please take me with you?"
	hidden_description = "A crude hatchet buried into a thick basalt formation. The blade of the hatchet is comprised of a metal alloy which is able to reform and shape itself to a limited extent. It vocalizes by vibrating this metal composition."
	dialogue_lines = list(
		"Come on, pretty please? Take me with you?",
		"I have so much to do! So much to see!",
		"The world has so much to see! I want to see it all!",
		"Come on! Take me!",
		"Don't you want a friend, too?",
		"While you can still hear me! Please?",
		"I'm a cold memory.",
		"Pretty please?"
	)
	echoes = list(
		"what is your name"
	)
	talksound = 'sound/mobs/non-humanoids/roro/roro_warble.ogg'

	var/unburied_icon = "unburied"

/mob/living/simple_animal/formic/buried_hatchet/echo_success()
	var/successful_echo = awaiting_response
	if(successful_echo == "what is your name") //starting dialogue
		last_response = "what is your name"
		langsay("My name? I... don't need one! Come on, take me with you!")
		echoes -= "what is your name"
		echoes += "why should i"
		echoes += "what can you do"
		balloon_alert(last_speaker, "new echoes detected!")
	if(successful_echo == "why should i") //second dialogue
		last_response = "why should i"
		langsay("Well, I can do lots of things for you! Come on, I can't show you while I'm stuck in this rock!")
		echoes -= "why should i"
		echoes -= "what can you do"
		echoes += "i will take you"
		balloon_alert(last_speaker, "new echoes detected!")
	if(successful_echo == "what can you do") //second dialogue
		last_response = "what can you do"
		langsay("I can be lots of things! Like a crowbar, or a screwdriver! Doesn't that sound useful?")
		echoes -= "why should i"
		echoes -= "what can you do"
		echoes += "i will take you"
		balloon_alert(last_speaker, "new echoes detected!")
	if(successful_echo == "i will take you") //taking dialogue
		last_response = "i will take you"
		var/obj/item/fireaxe/boardingaxe/buried_hatchet/made_hatchet = new /obj/item/fireaxe/boardingaxe/buried_hatchet(get_turf(last_speaker))
		made_hatchet.get_owner(last_speaker)
		echoes -= "i will take you"
		echoes += "what are you still doing here"
		icon_state = "unburied"
		dialogue_lines = list("...")
		talksound = null
		spoken_lang = /datum/language/terrum
		balloon_alert(last_speaker, "new echoes detected!")
	if(successful_echo == "what are you still doing here") //post-dialogue
		if(last_response == "what are you still doing here")
			langsay("You pester me.")
			return
		last_response = "what are you still doing here"
		langsay("Just biding my time.")

/obj/item/fireaxe/boardingaxe/buried_hatchet
	name = "Buried Hatchet"
	desc = "A hulking, shapeshifting cleaver. You can hear it speaking, or at least, vibrating its edge to resemble speech."
	icon = 'modular_oculis/modules/contact_science/icons/buried_hatchet_tool.dmi'
	icon_state = "hatchet0"
	inhand_icon_state = "hatchet0"
	base_icon_state = "hatchet"
	force_unwielded = 4
	force_wielded = 16
	demolition_mod = 1
	sharpness = SHARP_EDGED
	tool_behaviour = TOOL_SAW
	obj_flags = INDESTRUCTIBLE

	var/mob/living/carbon/human/owner //who will speak to the hatchet
	var/list/echoes = list( //potential commands
		"hatchet",
		"screwdriver",
		"wrench",
		"crowbar"
	)
	var/living_state = "happy"
	var/current_form = "hatchet"
	var/talksound = 'sound/mobs/non-humanoids/roro/roro_warble.ogg'
	var/hearing_range = 8

	var/loneliness_threshold = 9 //distance required for lonely state
	var/lonely_ticks = 0
	var/lonely_limit = 250 //how long does it have to be left alone for the tax collectors to come

	var/dialogue_timer_max = 60
	var/dialogue_timer = 60

	var/list/active_lines
	var/list/happy_lines = list(
		"We make a great team, friend!",
		"I love you, friend!",
		"Let's keep working together!",
		"This is so fun!",
		"I'm having so much fun!",
		"Please don't ever leave my side...",
		"Let's keep sticking together!",
		"Look at us go!"
	)
	var/list/lonely_lines = list(
		"Where are you..?",
		"Are you gone for good..?",
		"I miss you.",
		"Don't let them take me..."
	)
	var/list/change_lines = list(
		"hatchet" = "Okay! Hatchet it is!",
		"screwdriver" = "Screwdriver!",
		"wrench" = "On it! Wrench!",
		"crowbar" = "Need to pry a door?"
	)
	var/breaching = FALSE

/obj/item/fireaxe/boardingaxe/buried_hatchet/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	soundsay("Okay! Just say what you need! Hatchet, screwdriver, wrench, or crowbar!")
	active_lines = happy_lines

/obj/item/fireaxe/boardingaxe/buried_hatchet/proc/soundsay(var/message)
	say(message)
	playsound(src, talksound, 40, TRUE)

/obj/item/fireaxe/boardingaxe/buried_hatchet/proc/get_owner(mob/living/carbon/human/to_own)
	owner = to_own
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(respond_to_speech))

/obj/item/fireaxe/boardingaxe/buried_hatchet/proc/respond_to_speech(mob/living/carbon/human/source, list/hearing_args)
	SIGNAL_HANDLER
	var/haystack = hearing_args[SPEECH_MESSAGE]
	if(get_dist(src, source) <= hearing_range)
		for(var/needle in echoes)
			if(findtext(haystack, needle)) //success
				change_form(needle)
				current_form = needle
				addtimer(CALLBACK(src, PROC_REF(say_form)), 3, TIMER_UNIQUE | TIMER_DELETE_ME) //small dialogue delay
				return

/obj/item/fireaxe/boardingaxe/buried_hatchet/proc/say_form()
	soundsay(change_lines[current_form])

/obj/item/fireaxe/boardingaxe/buried_hatchet/proc/change_form(suggested_form)
	if(suggested_form == "hatchet")
		force_unwielded = 4
		force_wielded = 16
		demolition_mod = 1
		icon_state = "hatchet0"
		base_icon_state = "hatchet"
		sharpness = SHARP_EDGED
		tool_behaviour = TOOL_SAW
	if(suggested_form == "screwdriver")
		force_unwielded = 5
		force_wielded = 12
		demolition_mod = 1
		icon_state = "screwdriver0"
		base_icon_state = "screwdriver"
		sharpness = SHARP_POINTY
		tool_behaviour = TOOL_SCREWDRIVER
	if(suggested_form == "wrench")
		force_unwielded = 3
		force_wielded = 10
		demolition_mod = 1
		icon_state = "wrench0"
		base_icon_state = "wrench"
		sharpness = SHARP_EDGED
		tool_behaviour = TOOL_WRENCH
	if(suggested_form == "crowbar")
		force_unwielded = 3
		force_wielded = 14
		demolition_mod = 1
		icon_state = "crowbar0"
		base_icon_state = "crowbar"
		sharpness = SHARP_EDGED
		tool_behaviour = TOOL_CROWBAR

/obj/item/fireaxe/boardingaxe/buried_hatchet/process(seconds_per_tick = SSOBJ_DT)
	if(dialogue_timer > 0)
		dialogue_timer -= seconds_per_tick
	else
		soundsay(pick(active_lines))
		dialogue_timer = dialogue_timer_max
	if(get_dist(src, owner) > loneliness_threshold)
		living_state = "lonely"
		active_lines = lonely_lines
		lonely_ticks += 1
		if(lonely_ticks >= lonely_limit && !breaching) //if it's been lonely long enough, breach
			breaching = TRUE
			sound_to_playing_players('sound/effects/magic/lightning_chargeup.ogg')
			addtimer(CALLBACK(src, PROC_REF(breach)), 80, TIMER_UNIQUE | TIMER_DELETE_ME)
	else
		living_state = "happy"
		active_lines = happy_lines

/obj/item/fireaxe/boardingaxe/buried_hatchet/proc/breach()
	priority_announce("An anomalous ideaform has breached containment within [station_name()]. Please route to subdue the hostile form.")
	var/area/spawning_area = get_area(src)
	for(var/i in 1 to 5)
		new /mob/living/basic/tax_collector(pick(spawning_area.contents))
	qdel(src)

/mob/living/basic/tax_collector
	name = "Tax Collector"
	desc = "To leave someone alone in a world like this is to condemn them."
	health = 200
	maxHealth = 200
	speed = 5
	icon = 'modular_oculis/modules/contact_science/icons/tax_collector.dmi'
	icon_state = "tax_collector"
	environment_smash = ENVIRONMENT_SMASH_WALLS
	melee_damage_lower = 8
	melee_damage_upper = 12
	melee_damage_type = BURN
	obj_damage = 10
	attack_vis_effect = ATTACK_EFFECT_SLASH
	attack_verb_continuous = "slashes at"
	attack_verb_simple = "slash at"
	incorporeal_move = INCORPOREAL_MOVE_JAUNT
	death_sound = 'sound/effects/portal/portal_travel.ogg'
	death_message = "vanishes, just as quickly as it came."
	ai_controller = /datum/ai_controller/basic_controller/tax_collector
	status_flags = CANPUSH | CANSTUN
	unsuitable_atmos_damage = 0
	unsuitable_cold_damage = 0
	faction = list(FACTION_HOSTILE)

/datum/ai_controller/basic_controller/tax_collector
	behavior_tree_json = "code/modules/mob/living/basic/ruin_defender/zombie.bt.json" //theyre effectively strong zombies
	blackboard = list(
		BB_TARGET_MINIMUM_STAT = HARD_CRIT,
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
		BB_BASIC_MOB_SPEAK_LINES = list(
			BB_EMOTE_HEAR = list("groans.", "chirps.", "whistles."),
			BB_EMOTE_SEE = list("shimmers.", "twitches."),
			BB_SPEAK_CHANCE = 3,
		),
	)

	ai_movement = /datum/ai_movement/basic_avoidance
