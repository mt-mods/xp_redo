


minetest.register_on_placenode(function(pos, newnode, player, oldnode, itemstack)
	if player and player:is_player() then
		xp_redo.add_xp(player:get_player_name(), 1)
	end
end)



minetest.register_on_dignode(function(pos, oldnode, digger)
	if digger ~= nil and digger:is_player() then
		xp_redo.add_xp(digger:get_player_name(), 1)
	end
end)




minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	if player and player:is_player() then
		xp_redo.add_xp(player:get_player_name(), 1) -- money back and forth hack
	end
end)

