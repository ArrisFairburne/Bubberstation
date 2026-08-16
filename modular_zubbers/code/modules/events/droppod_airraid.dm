/datum/round_event_control/portal_storm_narsie
	name = "Drop Troopers: Syndicate"
	typepath = /datum/round_event/portal_storm/portal_storm_narsie
	weight = 0
	max_occurrences = 0
	category = EVENT_CATEGORY_ENTITIES
	description = "The Syndicate sends large numbers of drop pod soldiers to fight the station."
	min_wizard_trigger_potency = 5
	max_wizard_trigger_potency = 7

/datum/round_event/portal_storm/portal_storm_narsie
	boss_types = list(/mob/living/basic/construct/artificer/hostile = 6)
	hostile_types = list(
		/mob/living/basic/construct/juggernaut/hostile = 8,
		/mob/living/basic/construct/wraith/hostile = 6,
	)

/datum/round_event/droppod_airraid
	start_when = 180
	end_when = 999
	announce_when = 1

	/// Number of turfs needed in an area to spawn one droppod
	var/turf_droppods_ratio = 50
	/// Lower and upper bounds of how many spawn waves to send in
	var/spawn_wave_total_lower = 0
	var/spawn_wave_total_upper = 0
	/// The actual number of waves to send
	var/spawn_waves = 0
	/// What wave are we currently on?
	var/current_wave = 0
	/// Where do we spawn the pods?
	var/area/current_spawn_area
	/// Complete list of valid droppod areas
	var/static/list/valid_spawn_areas
	/// Number of spawns in a drop pod
	var/droppod_density = 0
	/// Enemy types; spawn during normal waves
	var/list/enemy_types = list()
	/// Boss types; spawns during the final wave, if this has contents
	var/list/boss_types = list()
	/// Maximum number of boss pods to send in the final wave
	var/max_boss_pods = 1
	/// Helps calculate the time between droppod waves, multiplied against the current number of droppods
	var/time_to_next_wave_droppod_factor = 50
	/// When the next incident should happen
	var/next_incidence_time = 0

	/// Style of droppod to send
	var/droppod_style
	/// min and max time for droppods to send (for how long they take to reach destination)
	var/max_droppod_dropdelay = 10
	var/min_droppod_dropdelay = 30

/datum/round_event/droppod_airraid/setup()
	spawn_waves = rand(spawn_wave_total_lower, spawn_wave_total_upper)
	generate_valid_areas()

/datum/round_event/droppod_airraid/proc/generate_valid_areas()
	if(isnull(valid_spawn_areas))
		//areas that are always OK to be attacked
		var/static/list/whitelisted_areas = typecacheof(list(/area/station/engineering/break_room))

		//areas that will never be attacked (unless they are exactly part of the whitelist)
		var/static/list/blacklisted_areas = typecacheof(list(
			/area/station/ai/satellite/chamber,
			/area/station/ai/upload/chamber,
			/area/station/engineering,
			/area/shuttle,
		))
		blacklisted_areas += GLOB.expected_erp_areas
		blacklisted_areas += /area/station/maintenance

		valid_spawn_areas = make_associative(GLOB.the_station_areas) - blacklisted_areas + whitelisted_areas

/datum/round_event/droppod_airraid/tick()
	if(activeFor == next_incidence_time)
		if(current_wave < spawn_waves)
			send_droppod_wave()
		else
			end_event()

/datum/round_event/droppod_airraid/proc/send_droppod_wave()
	var/list/droppod_list
	var/number_bosspods_sent = 0

	current_spawn_area = select_droppod_area()
	droppod_list = generate_droppods()
	for(var/pod in droppod_list)
		if(i == spawn_waves && number_bosspods_sent < max_boss_pods)
			fill_bosspod(pod)
		else
			fill_droppod(pod)
	send_droppods(droppod_list)
	after_wave(length(droppod_list))

/datum/round_event/droppod_airraid/proc/select_droppod_area()
	return pick(valid_spawn_areas)

/datum/round_event/droppod_airraid/proc/generate_droppods()
	. = list()
	number_droppods = get_droppod_count()
	while(var/i = 0; i < number_droppods; i ++)
		. += generate_one_droppod()

/datum/round_event/droppod_airraid/proc/get_droppod_count()
	return ceil(current_spawn_area.areasize / turf_droppods_ratio)

/datum/round_event/droppod_airraid/proc/generate_one_droppod()
	var/obj/structure/closet/supplypod/pod = new /obj/structure/closet/supplypod
	pod.set_style(droppod_style)
	pod.delays[POD_TRANSIT] = rand(min_droppod_dropdelay, max_droppod_dropdelay)
	pod.explosionSize = list(0,0,0,1)
	return pod

/datum/round_event/droppod_airraid/proc/fill_droppod(obj/structure/pod)
	var/mob/enemy
	for(var/i = 0; i < droppod_density; i ++)
		enemy = new pick(enemy_types)
		enemy.forceMove(pod)

/datum/round_event/droppod_airraid/proc/fill_bosspod(obj/structure/pod)
	var/mob/enemy
	for(var/i = 0; i < droppod_density; i ++)
		if(i == 0 && boss_types.len > 0)
			enemy = new pick(boss_types)`
		else
			enemy = new pick(enemy_types)
		enemy.forceMove(pod)

/datum/round_event/droppod_airraid/proc/after_wave(droppod_count)
	current_wave++
	next_incidence_time = activeFor + calculate_time_to_next_wave(droppod_count)

/datum/round_event/droppod_airraid/proc/calculate_time_to_next_wave(current_droppod_count)
	return current_droppod_count * time_to_next_wave_droppod_factor + 60

/datum/round_event/droppod_airraid/proc/end_event()
	announce_end()
	end_when = activeFor

/datum/round_event/droppod_airraid/proc/announce_end()
	priority_announce("Alert! The Syndicate is sending orbital drop shock troopers to [GLOB.station_name]. Please brace for impact.", "Incoming Enemy Signatures", 'sound/announcer/alarm/airraid.ogg',color_override = "red")

//////////////////////////////////////
/////////////// SYNDIE ///////////////
//////////////////////////////////////

/datum/round_event_control/portal_storm_narsie
	name = "Drop Troopers: Syndicate"
	typepath = /datum/round_event/droppod_airraid/syndicate
	weight = 4
	max_occurrences = 2
	min_players = 30
	category = EVENT_CATEGORY_ENTITIES
	description = "The Syndicate sends large numbers of drop pod soldiers to fight the station."`

/datum/round_event/portal_storm/tick()
	spawn_effects(get_random_station_turf())

	if(spawn_hostile() && length(hostile_types))
		var/type = pick(hostile_types)
		hostile_types[type] = hostile_types[type] - 1
		spawn_mob(type, hostiles_spawn)
		if(!hostile_types[type])
			hostile_types -= type

	if(spawn_boss() && length(boss_types))
		var/type = pick(boss_types)
		boss_types[type] = boss_types[type] - 1
		spawn_mob(type, boss_spawn)
		if(!boss_types[type])
			boss_types -= type

	time_to_end()
/datum/round_event/droppod_airraid/syndicate/announce(fake)
	priority_announce("Alert! The Syndicate is sending orbital drop shock troopers to [GLOB.station_name]. Please brace for impact.", "Incoming Enemy Signatures", 'sound/announcer/alarm/airraid.ogg',color_override = "red")

