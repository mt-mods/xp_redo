
xp_redo.ranks = {}

xp_redo.register_rank = function(def)
	table.insert(xp_redo.ranks, def)
end

-- https://github.com/minetest/minetest/blob/ba91624d8c354bac49c35a449029b6712022d0cb/doc/lua_api.txt#L4053

xp_redo.register_rank({
	name="Recruit",
	icon="xp_rank_00_recruit.png",
	color={r=255, g=255, b=255},
	xp=0
})

xp_redo.register_rank({
	name="Private Second Class",
	icon="xp_rank_01_private_second.png",
	color={r=255, g=245, b=245},
	xp=10
})

xp_redo.register_rank({
	name="Private First Class",
	icon="xp_rank_02_private_first.png",
	color={r=255, g=235, b=235},
	xp=50
})

xp_redo.register_rank({
	name="Corporal",
	icon="xp_rank_03_corporal.png",
	color={r=255, g=225, b=225},
	xp=100
})

xp_redo.register_rank({
	name="Seargant",
	icon="xp_rank_04_seargant.png",
	color={r=255, g=215, b=215},
	xp=500
})

xp_redo.register_rank({
	name="Staff Seargant",
	icon="xp_rank_05_staff_seargant.png",
	color={r=255, g=205, b=205},
	xp=1000
})

xp_redo.register_rank({
	name="Seargant First Class",
	icon="xp_rank_06_seargant_first_class.png",
	color={r=255, g=195, b=195},
	xp=5000
})

xp_redo.register_rank({
	name="Master Seargant",
	icon="xp_rank_07_seargant_master.png",
	color={r=255, g=185, b=185},
	xp=10000
})

xp_redo.register_rank({
	name="First Seargant",
	icon="xp_rank_08_seargant_first.png",
	color={r=255, g=175, b=175},
	xp=50000
})

xp_redo.register_rank({
	name="Seargant Major",
	icon="xp_rank_09_seargant_major.png",
	color={r=255, g=165, b=165},
	xp=100000
})

xp_redo.register_rank({
	name="Command Seargant Major",
	icon="xp_rank_10_command_seargant_major.png",
	color={r=255, g=155, b=155},
	xp=200000
})


xp_redo.register_rank({
	name="First Seargant Major",
	icon="xp_rank_11_seargant_major_army.png",
	color={r=255, g=145, b=145},
	xp=300000
})

xp_redo.register_rank({
	name="Second Lieutenant",
	icon="xp_rank_12_second_lieutenant.png",
	color={r=255, g=135, b=135},
	xp=400000
})

xp_redo.register_rank({
	name="First Lieutenant",
	icon="xp_rank_13_first_lieutenant.png",
	color={r=255, g=125, b=125},
	xp=500000
})

xp_redo.register_rank({
	name="Captain",
	icon="xp_rank_14_captain.png",
	color={r=255, g=115, b=115},
	xp=600000
})

xp_redo.register_rank({
	name="Major",
	icon="xp_rank_15_major.png",
	color={r=255, g=105, b=105},
	xp=700000
})

xp_redo.register_rank({
	name="Colonel",
	icon="xp_rank_16_colonel.png",
	color={r=255, g=95, b=95},
	xp=800000
})

xp_redo.register_rank({
	name="Brigadier General",
	icon="xp_rank_17_brigadier_general.png",
	color={r=255, g=85, b=85},
	xp=900000
})

xp_redo.register_rank({
	name="Major General",
	icon="xp_rank_18_major_general.png",
	color={r=255, g=75, b=75},
	xp=1000000
})

xp_redo.register_rank({
	name="Lieutenant General",
	icon="xp_rank_19_lieutenant_general.png",
	color={r=255, g=65, b=65},
	xp=1100000
})

xp_redo.register_rank({
	name="General",
	icon="xp_rank_20_general.png",
	color={r=255, g=55, b=55},
	xp=1200000
})

xp_redo.register_rank({
	name="General Minetest",
	icon="xp_rank_21_general_minetest.png",
	color={r=255, g=45, b=45},
	xp=1500000
})

-- diamond ranks

xp_redo.register_rank({
        name="Diamond lord",
        icon="default_diamond.png",
        color={r=66, g=189, b=196}, -- dark blue
        xp=2000000
})

xp_redo.register_rank({
        name="Diamond god",
        icon="default_diamond_block.png",
        color={r=0, g=242, b=255}, -- blue
        xp=2500000
})


-- mese ranks

xp_redo.register_rank({
        name="Mese lord",
        icon="default_mese_crystal.png",
        color={r=188, g=184, b=62}, -- dark yellow
        xp=3000000
})      

xp_redo.register_rank({
        name="Mese god",
        icon="default_mese_block.png",
        color={r=255, g=246, b=0}, -- yellow
        xp=3500000
})

-- final rank (for sure, not hoing any further...)

xp_redo.register_rank({
        name="God of pandora",
        icon="default_lava.png",
        color={r=25, g=255, b=0}, -- should be green
        xp=5000000
})

