

-- bonus on placing
minetest.register_on_placenode(function(pos, newnode, player, oldnode, itemstack)
	if player and player:is_player() then
		xp_redo.add_xp(player:get_player_name(), 1)
	end
end)

-- malus on death
minetest.register_on_dieplayer(function(player)
	if player and player:is_player() then
		xp_redo.add_xp(player:get_player_name(), -100)
	end
end);

local node_reward_table = {}

local function register_node_reward(name, reward)
	table.insert(node_reward_table, { name=name, reward=reward })
end

register_node_reward("default:stone_with_coal", 2)
register_node_reward("default:stone_with_copper", 3)
register_node_reward("default:stone_with_diamond", 10)
register_node_reward("default:stone_with_gold", 5)
register_node_reward("default:stone_with_iron", 2)
register_node_reward("default:stone_with_mese", 10)
register_node_reward("default:stone_with_tin", 2)

-- bonus on digging
minetest.register_on_dignode(function(pos, oldnode, digger)
	if digger ~= nil and digger:is_player() then
		local reward = 1

		if oldnode.name then
			for _,entry in pairs(node_reward_table) do
				if oldnode.name == entry.name then
					reward = entry.reward
				end
			end
		end

		xp_redo.add_xp(digger:get_player_name(), reward)
	end
end)


minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	if player and player:is_player() then
		-- limit craft reward to mitigate back-and-forth crafting for xp
		xp_redo.add_xp(player:get_player_name(), math.min(itemstack:get_count(), 50))
	end
end)

