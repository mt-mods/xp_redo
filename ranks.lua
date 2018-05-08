
xp_redo.ranks = {}

xp_redo.register_rank = function(def)
	table.insert(xp_redo.ranks, def)
end

-- https://github.com/minetest/minetest/blob/ba91624d8c354bac49c35a449029b6712022d0cb/doc/lua_api.txt#L4053

xp_redo.register_rank({
	name="Recruit",
	icon=nil,
	color={r=255, g=255, b=255},
	xp=0
})

xp_redo.register_rank({
	name="Soldier",
	icon="xp_rank_2_soldier.png",
	color={r=255, g=235, b=235},
	xp=10
})

xp_redo.register_rank({
	name="Appointee",
	icon="xp_rank_3_appointee.png",
	color={r=255, g=215, b=215},
	xp=100
})

xp_redo.register_rank({
	name="Private",
	icon="xp_rank_4_private.png",
	color={r=255, g=195, b=195},
	xp=1000
})