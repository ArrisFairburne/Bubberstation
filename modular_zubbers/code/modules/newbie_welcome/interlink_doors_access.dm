
///Interlink-specific airlocks that gate you if you're still a newbie (to prevent getting lost and confused as a first impressioon)
/obj/machinery/door/airlock/interlink_access
	resistance_flags = INDESTRUCTIBLE

///Item pass to get early access (given via admin request)
/obj/item/interlink_pass
	name = "Interlink access pass"
	desc = "A pass giving early access to Nanotrasen's private lounge planet. New employees may request this pass to their employers."

/obj/machinery/door/airlock/interlink_access/bumpopen(mob/user)
	if (user_has_interlink_access(user))
		return ..()

/obj/machinery/door/airlock/interlink_access/try_to_activate_door(mob/living/user, access_bypass = FALSE)
	if (user_has_interlink_access(user))
		return ..()

/obj/machinery/door/airlock/interlink_access/user_has_interlink_access(mob/user)
	if (!isnull(user) && !isnull(user.client))
		if (user.client.get_exp_living(pure_numeric = TRUE) > NEWBIE_HOURS || (!isnull(user.contents) && is_type_in_list(user.contents, /obj/item/interlink_pass)) || unrestricted_side(user))
			return TRUE
		else
			to_chat(human, span_notice("You may only access the company's private lounge planet after working for a life total of " + NEWBIE_HOURS + " hours! You have currently worked for " + user.client.get_exp_living(pure_numeric = TRUE) + " hours. You may also file a request to CentCom for early access."))
			return FALSE
	else
		return FALSE
		//run_animation(DOOR_DENY_ANIMATION)

/obj/machinery/door/airlock/interlink_access/public
	name = "public airlock"
	icon = 'icons/obj/doors/airlocks/public/glass.dmi'
	overlays_file = 'icons/obj/doors/airlocks/public/overlays.dmi'

/obj/machinery/door/airlock/interlink_access/public/glass
	name = "public glass airlock"
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/interlink_access/security
	name = "security airlock"
	icon = 'icons/obj/doors/airlocks/station/security.dmi'

/obj/machinery/door/airlock/interlink_access/security/glass
	name = "security glass airlock"
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/interlink_access/medical
	name = "medical airlock"
	icon = 'icons/obj/doors/airlocks/station/medical.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_med

/obj/machinery/door/airlock/interlink_access/medical/glass
	name = "medical glass airlock"
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/interlink_access/service
	icon = 'modular_skyrat/modules/aesthetics/airlock/icons/airlocks/station/service.dmi'

/obj/machinery/door/airlock/interlink_access/service/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/interlink_access/bathroom
	icon = 'modular_skyrat/modules/aesthetics/airlock/icons/airlocks/bathroom.dmi'

/obj/machinery/door/airlock/interlink_access/corporate
	icon = 'modular_skyrat/modules/aesthetics/airlock/icons/airlocks/station/corporate.dmi'

/obj/machinery/door/airlock/interlink_access/centcom //Use grunge as a station side version, as these have special effects related to them via phobias and such.
	icon = 'icons/obj/doors/airlocks/centcom/centcom.dmi'
	overlays_file = 'icons/obj/doors/airlocks/centcom/overlays.dmi'
	can_be_glass = FALSE

/obj/machinery/door/airlock/interlink_access/multi_tile
	icon = 'icons/obj/doors/airlocks/multi_tile/public/glass.dmi'
	overlays_file = 'icons/obj/doors/airlocks/multi_tile/public/overlays.dmi'
	assemblytype = /obj/structure/door_assembly/multi_tile/door_assembly_public
	multi_tile = TRUE
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/interlink_access/multi_tile/setDir(newdir)
	. = ..()
	set_bounds()
