

local function register_trophy(name, desc,base, top)
	local tr_cbox = {
		type = "fixed",
		fixed = { -0.3125, -0.5, -0.1875, 0.3125, 0.125, 0.1875 }
	}

	minetest.register_node("xp_redo:" .. name, {
		description = desc,
		drawtype = "mesh",
		paramtype = "light",
		paramtype2 = "facedir",
		mesh = "xp_redo_trophy.obj",
		tiles = {
			base,
			top
		},
		inventory_image = "xp_trophy_inv.png",
		groups = { snappy=3 },
		walkable = false,
		selection_box = tr_cbox,
	})

	-- TODO: nice formspec

end

register_trophy("trophy_iron_stuff", "Iron trophy for xy stuff", "default_wood.png", "default_steel_block.png")
register_trophy("trophy_gold_stuff", "Gold trophy for abc stuff", "default_wood.png", "default_gold_block.png")

register_trophy("trophy_gold_stuff_plus", "Gold trophy for abc stuff and more", "default_steel_block.png", "default_gold_block.png")
register_trophy("trophy_mese", "Mese trophy for abc stuff and more", "default_steel_block.png", "default_mese_block.png")
