

local update_formspec = function(meta)
	local orientation = meta:get_string("orientation")

	meta:set_string("formspec", "size[6,2;]" ..
		"button_exit[4,0.5;2,1;save;Save]" ..
		"field[0,1;4,1;orientation;Orientation (x or z);" .. orientation .. "]")
end

local build_board = function(pos)

	local meta = minetest.get_meta(pos)
	local orientation = meta:get_string("orientation")

	-- TODO

	print("building highscore board") -- XXX
end


minetest.register_node("xp_redo:highscore_board", {
	description = "XP Highscore board",
	tiles = {"xp_highscore_board.png"},
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
	end,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("orientation", "")
		update_formspec(meta)

		local timer = minetest.get_node_timer(pos)
		timer:start(10)
	end,

	on_timer = function(pos)
		build_board(pos)
		return true
	end,

	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.get_meta(pos)
		local name = sender:get_player_name()

		if name == meta:get_string("owner") then
			-- owner
			if fields.orientation then
				meta:set_string("orientation", fields.orientation)
			end

			update_formspec(meta)
		end
	end,

	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos)
		local name = player:get_player_name()

		return name == meta:get_string("owner")
	end
})
