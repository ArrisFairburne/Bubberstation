/datum/round_event_control/ape_escape
	typepath = /datum/round_event/ape_escape
	weight = 2
	min_players = 30
	max_occurrences = 1
	earliest_start = 45 MINUTES
	description = "Sends one violent gorilla to the station."
	min_wizard_trigger_potency = 3
	max_wizard_trigger_potency = 6
	tags = list(TAG_COMMUNAL, TAG_COMBAT)

/datum/round_event_control/vent_clog/can_spawn_event(players_amt, allow_magic = FALSE)
	. = ..()
	if(!.)
		return
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/vent as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/atmospherics/components/unary/vent_pump))
		var/turf/vent_turf = get_turf(vent)
		var/area/vent_area = get_area(vent)
		if(vent_turf && is_station_level(vent_turf.z) && !vent.welded && istype(vent_area, /area/station))
			return TRUE //make sure we have a valid vent to spawn from.
	return FALSE

/datum/round_event/ape_escape
	announce_when = 0
	announce_chance = 100
	end_when = 600

	///Area selected for the event.
	var/area/event_area
	///What mob will be spawned
	var/mob/spawned_mob = /mob/living/basic/gorilla/dangerous

/datum/round_event/ape_escape/announce(fake)
	priority_announce("The ape has escaped. Beware.", "CentCom Dangerous Wildlife Division", color_override = "yellow")

/mob/living/basic/gorilla/dangerous
	faction = list(FACTION_HOSTILE)
