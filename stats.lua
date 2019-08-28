

local increase_stat = function(player, name, value)
	if player == nil or player.get_attribute == nil then
		-- fake player
		return
	end

	local count = player:get_attribute(name)
	if not count then
		count = 0
	end

	player:set_attribute(name, count + value)
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer > 5 then
		for _,player in ipairs(minetest.get_connected_players()) do
			increase_stat(player, "played_time", timer)
		end
		timer = 0
	end
end)


minetest.register_on_dignode(function(pos, oldnode, player)
	if player and player:is_player() then
		increase_stat(player, "digged_nodes", 1)
	end
end)

minetest.register_on_placenode(function(pos, newnode, player, oldnode, itemstack)
	if player and player:is_player() then
		increase_stat(player, "placed_nodes", 1)
	end
end)

minetest.register_on_dieplayer(function(player)
	increase_stat(player, "died", 1)
end)

minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	increase_stat(player, "crafted", itemstack:get_count())
end)

