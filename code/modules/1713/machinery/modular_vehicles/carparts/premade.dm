//////////////////////////////////////////////////////////////////////////////////////////
//Yamasaki Industries > Japanese manufacturer of sports cars and motorcycles

//Yamasaki M125 - A 125cc motorcycle
//Yamasaki Shinobu 7000 - A fast sports car

//////////////////////////////////////////////////////////////////////////////////////////
//Stallion Motors Company > American manufacturer of Trucks and full-size cars

//SMC Wyoming - A medium-sized jeep
//SMC HP800 - A pickup truck
//SMC Falcon - A full-size sedan
//SMC Falcon Interceptor - The police version of the SMC Falcon

//////////////////////////////////////////////////////////////////////////////////////////
//Ubermacht Motorwerke > German manufacturer of luxury cars and vans

//UM Erstenklasse - Large luxury sedan
//UM Volle - A transport van
//UM Volle KW - A large ambulance version of the Volle

//////////////////////////////////////////////////////////////////////////////////////////
//ASINO > Cheap, small italian cars

//ASINO Piccolino - Small 2 seat italian car
//ASINO Quattroporte - Simple 4 seater

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
/obj/effects/premadevehicles
	name = "premade vehicle"
	icon = 'icons/obj/vehicleeffects.dmi'
	icon_state = "3x3"
	var/custom_color = ""
	var/axis = /obj/structure/vehicleparts/axis/car
	var/doorcode = 0
	var/list/tocreate = list(

	"1,1" = list(),
	"1,2" = list(),
	"1,3" = list(),
	"1,4" = list(),
	"1,5" = list(),

	"2,1" = list(),
	"2,2" = list(),
	"2,3" = list(),
	"2,4" = list(),
	"2,5" = list(),

	"3,1" = list(),
	"3,2" = list(),
	"3,3" = list(),
	"3,4" = list(),
	"3,5" = list(),

	"4,1" = list(),
	"4,2" = list(),
	"4,3" = list(),
	"4,4" = list(),
	"4,5" = list(),

	"5,1" = list(),
	"5,2" = list(),
	"5,3" = list(),
	"5,4" = list(),
	"5,5" = list(),
	)

/obj/effects/premadevehicles/New()
	invisibility = 101
	..()
	var/vmaxx = 1
	var/vmaxy = 1
	spawn(10)
		for (var/ix=1,ix<=5,ix++)
			for(var/iy=1, iy<=5, iy++)
				if (tocreate["[ix],[iy]"] && islist(tocreate["[ix],[iy]"]) && tocreate["[ix],[iy]"].len)
					var/turf/T = get_turf(locate(src.x+ix,src.y+iy,src.z))
					if (T)
						for(var/pt in tocreate["[ix],[iy]"])
							new pt(T)
							if (iy > vmaxy)
								vmaxy = iy
							if (ix > vmaxx)
								vmaxx = ix
		var/obj/structure/vehicleparts/axis/tpt = new axis(get_turf(locate(x+vmaxx,y+1,z)))
		if (custom_color != "")
			tpt.color = custom_color
		if (doorcode != 0)
			tpt.doorcode = doorcode
		tpt.dir = 2
		new/obj/effect/autoassembler(get_turf(locate(tpt.x-2,tpt.y+2,tpt.z)))


//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//ASNO
/obj/effects/premadevehicles/asno/piccolino
	name = "ASNO Piccolino"
	icon_state = "2x2"
	custom_color = "#494949"
	axis = /obj/structure/vehicleparts/axis/car/piccolino
	tocreate = list(
	"1,1" = list(/obj/item/weapon/reagent_containers/glass/barrel/fueltank/smalltank/fueledgasoline,/obj/structure/vehicleparts/movement,/obj/structure/vehicleparts/frame/car/piccolino/rf),
	"2,1" = list(/obj/structure/vehicleparts/frame/car/piccolino/lf,/obj/structure/engine/internal/gasoline/premade/piccolino,/obj/structure/vehicleparts/movement,/obj/structure/vehicleparts/license_plate/eu/centered/front),

	"1,2" = list(/obj/structure/bed/chair/carseat/right,/obj/structure/vehicleparts/frame/car/piccolino/rb,/obj/structure/vehicleparts/movement/reversed),
	"2,2" = list(/obj/structure/bed/chair/drivers/car,/obj/structure/vehicleparts/frame/car/piccolino/lb,/obj/structure/vehicleparts/movement/reversed,/obj/structure/vehicleparts/license_plate/eu/centered),

	)

/obj/effects/premadevehicles/asno/quattroporte
	name = "ASNO Quattroporte"
	icon_state = "3x3"
	custom_color = "#076007"
	axis = /obj/structure/vehicleparts/axis/car/quattroporte
	tocreate = list(
	"1,1" = list(/obj/item/weapon/reagent_containers/glass/barrel/fueltank/smalltank/fueledgasoline,/obj/structure/vehicleparts/movement,/obj/structure/vehicleparts/frame/car/quattroporte/rf),
	"2,1" = list(/obj/structure/vehicleparts/frame/car/quattroporte/lf,/obj/structure/engine/internal/gasoline/premade/quattroporte,/obj/structure/vehicleparts/movement,/obj/structure/vehicleparts/license_plate/eu/centered/front),

	"1,3" = list(/obj/structure/bed/chair/carseat/right,/obj/structure/vehicleparts/frame/car/quattroporte/rb,/obj/structure/vehicleparts/movement/reversed),
	"2,3" = list(/obj/structure/bed/chair/carseat/left,/obj/structure/vehicleparts/frame/car/quattroporte/lb,/obj/structure/vehicleparts/license_plate/eu/centered,/obj/structure/vehicleparts/movement/reversed),

	"1,2" = list(/obj/structure/bed/chair/carseat/right,/obj/structure/vehicleparts/frame/car/quattroporte/rc),
	"2,2" = list(/obj/structure/bed/chair/drivers/car,/obj/structure/vehicleparts/frame/car/quattroporte/lc),
	)

/obj/effects/premadevehicles/ubermacht/erstenklasse
	name = "Ubermacht Erstenklasse"
	icon_state = "4x4"
	custom_color = "#1b1f1b"
	axis = /obj/structure/vehicleparts/axis/car/erstenklasse
	tocreate = list(
	"1,1" = list(/obj/item/weapon/reagent_containers/glass/barrel/fueltank/tank/fueledgasoline,/obj/structure/vehicleparts/movement,/obj/structure/vehicleparts/frame/car/umek/rf),
	"2,1" = list(/obj/structure/vehicleparts/frame/car/umek/lf,/obj/structure/engine/internal/gasoline/premade/erstenklasse,/obj/structure/vehicleparts/movement,/obj/structure/vehicleparts/license_plate/eu/centered/front),
	
	"1,2" = list(/obj/structure/vehicleparts/frame/car/umek/rfc,/obj/structure/bed/chair/carseat/right/lion),
	"2,2" = list(/obj/structure/vehicleparts/frame/car/umek/lfc,/obj/structure/bed/chair/drivers/car/lion),

	"1,3" = list(/obj/structure/vehicleparts/frame/car/umek/rbc,/obj/structure/bed/chair/carseat/right/lion),
	"2,3" = list(/obj/structure/vehicleparts/frame/car/umek/lbc,/obj/structure/bed/chair/carseat/left/lion),

	"1,4" = list(/obj/structure/vehicleparts/frame/car/umek/rb,/obj/structure/table/carboot,/obj/structure/vehicleparts/movement/reversed),
	"2,4" = list(/obj/structure/vehicleparts/frame/car/umek/lb,/obj/structure/table/carboot,/obj/structure/vehicleparts/movement/reversed),

	)