SUBSYSTEM_DEF(trade)
	name = "Trade"
	priority = SS_PRIORITY_TRADE
	init_order = INIT_ORDER_TRADE
	flags = SS_NO_INIT|SS_BACKGROUND
	wait = 1 MINUTE

/datum/controller/subsystem/trade/fire()
	for(var/a in GLOB.traders)
		var/datum/trader/T = a
		if(!T.tick())
			GLOB.traders -= T
			qdel(T)
	if(prob(100-GLOB.traders.len*10))
		generateTrader()

/datum/controller/subsystem/trade/proc/generateTrader(var/stations = 0)
	var/list/possible = list()
	if(stations)
		possible += subtypesof(/datum/trader) - typesof(/datum/trader/ship)
	else
		if(prob(5))
			possible += subtypesof(/datum/trader/ship/unique)
		else
			possible += subtypesof(/datum/trader/ship) - typesof(/datum/trader/ship/unique)

	for(var/i in 1 to 10)
		var/type = pick(possible)
		var/bad = 0
		for(var/trader in GLOB.traders)
			if(istype(trader,type))
				bad = 1
				break
		if(bad)
			continue
		GLOB.traders += new type
		return