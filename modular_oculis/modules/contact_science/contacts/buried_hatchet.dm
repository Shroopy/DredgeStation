/mob/living/simple_animal/formic/buried_hatchet
	name = "Buried Hatchet"
	desc = "Will you unbury the hatchet?"
	icon = 'modular_oculis/modules/contact_science/icons/buried_hatchet.dmi'
	icon_state = "buried_hatchet"

	nanotrasen_id = "NT-ARDB-013"
	primary_hazard_labels = "Dominiohazard"
	secondary_hazard_labels = "N/A"
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
	talksound = 'sound/mobs/non-humanoids/roro_warble.ogg'

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
		echoes = list("...")
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
	icon_state = "hatchet"
	force_unwielded = 4
	force_wielded = 16
	demolition_mod = 1
	sharpness = SHARP_EDGED
	tool_behaviour = TOOL_SAW

	var/mob/living/carbon/human/owner //who will speak to the hatchet
	var/list/echoes = list( //potential commands
		"hatchet",
		"screwdriver",
		"wrench",
		"crowbar"
	)
	var/living_state = "happy"
	var/talksound = 'sound/mobs/non-humanoids/roro_warble.ogg'
	var/hearing_range = 8

	var/loneliness_threshold = 9 //distance required for lonely state

	var/hunger_timer_max = 250
	var/hunger_timer = 250 //if this hits zero, the hatchet will try to attack something nearby to refill
	var/hunger_attack_timer_max = 10
	var/hunger_attack_timer = 10

	var/dialogue_timer_max = 60
	var/dialogue_timer = 60

	var/list/active_lines
	var/list/happy_lines = list(
		"We make a great team, friend!",
		"I love you, friend!",
		"Let's keep working together!",
		"This is so fun!",
		"I'm having so much fun!"
	)
	var/list/lonely_lines = list(
		"Where are you..?",
		"Are you gone for good..?",
		"I miss you."
	)
	var/list/hungry_lines = list(
		"I feel... hungry...",
		"Sorry... I think I need something to eat...",
		"I feel a bit peckish..."
	)
	var/list/change_lines = list(
		"hatchet" = "Okay! Hatchet it is!",
		"screwdriver" = "Screwdriver!",
		"wrench" = "On it! Wrench!",
		"crowbar" = "Need to pry a door?"
	)

/obj/item/fireaxe/boardingaxe/buried_hatchet/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	soundsay("Okay! Just say what you need; hatchet, screwdriver, wrench, or crowbar!")
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
				change_form(suggested_form)
				soundsay(change_lines[needle])
				return

/obj/item/fireaxe/boardingaxe/buried_hatchet/proc/change_form(var/suggested_form)
	if(suggested_form == "hatchet")
		force_unwielded = 4
		force_wielded = 16
		demolition_mod = 1
		icon_state = "hatchet"
		sharpness = SHARP_EDGED
		tool_behaviour = TOOL_SAW
	if(suggested_form == "screwdriver")
		force_unwielded = 5
		force_wielded = 12
		demolition_mod = 1
		icon_state = "screwdriver"
		sharpness = SHARP_POINTY
		tool_behaviour = TOOL_SCREWDRIVER
	if(suggested_form == "wrench")
		force_unwielded = 3
		force_wielded = 10
		demolition_mod = 1
		icon_state = "wrench"
		sharpness = SHARP_EDGED
		tool_behaviour = TOOL_WRENCH
	if(suggested_form == "crowbar")
		force_unwielded = 3
		force_wielded = 14
		demolition_mod = 1
		icon_state = "crowbar"
		sharpness = SHARP_EDGED
		tool_behaviour = TOOL_CROWBAR

/obj/item/fireaxe/boardingaxe/buried_hatchet/process(seconds_per_tick)
	if(hunger_timer > 0)
		hunger_timer -= seconds_per_tick
	if(dialogue_timer > 0)
		dialogue_timer -= seconds_per_tick
	if(get_dist(src, owner) > loneliness_threshold)
		living_state = "lonely"
		active_lines = lonely_lines
	else
		living_state = "happy"
		active_lines = happy_lines
	if(hunger_timer <= dialogue_timer_max) //hungry lines come in before actual hunger does as a warning. warning time equals dialogue timer max to make sure they can get a line in
		active_lines = hungry_lines
	if(hunger_timer <= 0)
		living_state = "hungry"
		if(hunger_attack_timer <= 0)
			hatchet_attack()
			hunger_attack_timer = hunger_attack_timer_max
		else
			hunger_attack_timer -= seconds_per_tick
	if(dialogue_timer <= 0)
		dialogue_timer = dialogue_timer_max
		soundsay(pick(active_lines))

/obj/item/fireaxe/boardingaxe/buried_hatchet/proc/hatchet_attack()
	if(owner.get_active_held_item() == src)	//does not proc if owner isn't holding the axe
		var/list/mob/living/targets = list()
		for(var/mob/living/nearby_mobs in oview(owner, 1))
				targets += nearby_mobs
		owner.set_combat_mode(TRUE)
		if(owner.ClickOn(pick(targets)))
			to_chat(owner, span_warning("The axe acts on its own!"))
			owner.log_message(" attacked someone due to a the Buried Hatchet's hunger", LOG_ATTACK) //the attack logs itself
			hunger_timer = hunger_timer_max //then, satiate
		owner.set_combat_mode(FALSE)
