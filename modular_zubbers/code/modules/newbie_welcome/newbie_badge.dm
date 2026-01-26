/obj/item/clothing/accessory/newbie_badge
	name = "\improper New Hire Badge"
	desc = "A badge typically attached onto the uniform of new employees at the Bubber sector of Nanotrasen."

/obj/item/clothing/accessory/newbie_badge/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/human_equipper = user
		human_equipper.newbie_hud_set()

/obj/item/clothing/accessory/newbie_badge/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/human_equipper = user
		human_equipper.newbie_hud_set()

/mob/living/carbon/human/proc/newbie_hud_set_badge()
	var/obj/item/clothing/under/undershirt = w_uniform
	if(!istype(undershirt))
		set_hud_image_inactive(NEWBIE_HUD)
		return

	set_hud_image_active(NEWBIE_HUD)
	if(is_type_in_list(undershirt.attached_accessories, /obj/item/clothing/accessory/newbie_badge))
		set_hud_image_state(NEWBIE_HUD, "clown_enjoyer_pin")
	else
		set_hud_image_state(NEWBIE_HUD, "hudfan_no")

/datum/atom_hud/data/human/newbie_hud
	hud_icons = list(NEWBIE_HUD)
