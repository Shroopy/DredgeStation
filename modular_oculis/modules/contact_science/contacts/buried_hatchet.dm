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
	if(successful_echo == "i will take you") //second dialogue
		last_response = "i will take you"
