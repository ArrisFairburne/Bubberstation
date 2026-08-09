/datum/round_event_control/stray_cargo/ape_escape
	typepath = /datum/round_event/stray_cargo/ape_escape
	weight = 2
	min_players = 30
	max_occurrences = 1
	earliest_start = 45 MINUTES
	description = "Sends one violent gorilla to the station."
	min_wizard_trigger_potency = 3
	max_wizard_trigger_potency = 6
	tags = list(TAG_COMMUNAL, TAG_COMBAT, TAG_NPC_ANTAG)

/datum/round_event/stray_cargo/ape_escape
	announce_when = 0
	announce_chance = 100
	possible_pack_types = list()

	///What mob will be spawned
	var/mob/spawned_mob = /mob/living/basic/gorilla/dangerous

/datum/round_event/stray_cargo/ape_escape/announce(fake)
	priority_announce("The ape has escaped. Beware.", "CentCom Dangerous Wildlife Division", sound = ANNOUNCER_SPOOKY, color_override = "yellow")

///Apply the syndicate pod skin
/datum/round_event/stray_cargo/ape_escape/make_pod()
	var/obj/structure/closet/supplypod/S = new
	S.set_style(/datum/pod_style/centcom)
	var/mob/gori = new spawned_mob(S)
	return S

/mob/living/basic/gorilla/dangerous
	faction = list(FACTION_HOSTILE)
