GLOBAL_LIST_INIT(dyelist, list("Red"="#a32121",
"Purple"="#8747b1",
"Black"="#414143",
"Brown"="#685542",
"Green"="#428138",
"Dark Green"="#264d26",
"Blue"="#537bc6",
"Yellow"="#b5b004",
"Teal"="#249589",
"White"="#ffffff",
"Orange"="#bd6606",
"Majenta"="#962e5c",
"Grey"="#999999"))

/obj/item/reagent_containers/glass/dyekit
	name = "dye kit"
	icon_state = "dye_kit"
	desc = "Bottles and a bowl for measuring out dyes to create colors accurately."
	icon = 'icons/roguetown/items/misc.dmi'
	force = 5
	throwforce = 10
	obj_flags = CAN_BE_HIT
	w_class = WEIGHT_CLASS_NORMAL

	volume = 12
	fillsounds = list('sound/items/fillcup.ogg')

	var/cur_color = "#ffffff"

/obj/item/reagent_containers/glass/dyekit/attack_self(mob/user)
	var/choice = input(user, "Choose a color", "Dye Kit") as anything in GLOB.dyelist
	if(choice)
		if(GLOB.dyelist[choice])
			cur_color = GLOB.dyelist[choice]
			if(reagents.has_reagent(/datum/reagent/rogue_dye))
				reagents.recolor_reagent(/datum/reagent/rogue_dye, cur_color)
			
	
/obj/item/reagent_containers/glass/dyekit/attack_obj(obj/O, mob/living/user)
	if(isitem(O))
		var/obj/item/I = O
		if(I.dyeneeded)
			if(reagents.has_reagent(/datum/reagent/rogue_dye, I.dyeneeded))
				var/sewtime = 70
				if(user.mind)
					sewtime = (70 - ((user.mind.get_skill_level(/datum/skill/misc/sewing)) * 10))
				var/datum/component/storage/target_storage = I.GetComponent(/datum/component/storage)
				if(do_after(user, sewtime, target = I))
					reagents.remove_reagent(/datum/reagent/rogue_dye, I.dyeneeded)
					I.color = cur_color
					I.strongdyed = TRUE
					if(target_storage)
						target_storage.being_repaired = FALSE
				else
					if(target_storage)
						target_storage.being_repaired = FALSE
				return
			else
				to_chat(user, span_warning("I don't have enough dye!"))
			return
	return ..()

/datum/reagent/rogue_dye
	name = "Dye"

/obj/item/reagent_containers/glass/bottle/rogue/dye
	list_reagents = list(/datum/reagent/rogue_dye = 12)

/obj/item/reagent_containers/glass/dyekit/loaded
	list_reagents = list(/datum/reagent/rogue_dye = 12)
