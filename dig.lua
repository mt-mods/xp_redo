

minetest.register_on_dignode(function(pos, oldnode, digger)

	if digger:is_player() then
		xp_redo.add_xp(digger:get_player_name(), 1)
	end
end)
