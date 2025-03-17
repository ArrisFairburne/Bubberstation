/obj/item/organ/cyberimp/empshield_skin
	name = "Faraday Inner Lining"
	desc = "A layer of synthetic material implanted subdermally. Blocks the effects of EMPs to all internal organs."
	icon_state = "empshield_skin"
	slot = ORGAN_SLOT_SUBDERMAL
	var/emp_damage_multiplier = 0.66667

/datum/design/empshield_skin
	name = "Faraday Inner Lining"
	desc = "An inner skin that protects body organs from EMPs."
	id = "empshield_skin"
	build_type = MECHFAB
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 10 SECONDS
	build_path = /obj/item/organ/cyberimp/empshield_skin
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_TOOLS,
	)
