

-- bonus on placing
minetest.register_on_placenode(function(pos, newnode, player, oldnode, itemstack)
	if player and player:is_player() and not player.is_fake_player then

		--[[
		if minetest.find_node_near(pos, 1, {"pipeworks:deployer_on", "pipeworks:deployer_off"}, false) then
			-- don't count deployer actions
			return
		end
		--]]

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
	if digger ~= nil and digger:is_player() and not digger.is_fake_player then
		local reward = 1

		local wield_item = digger:get_wielded_item()
		if wield_item then
			local name = wield_item:get_name()
			-- check for mining laser/drill
			if string.find(name, "technic%:laser") or string.find(name, "technic%:mining") then
				-- no reward
				return
			end
		end

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

-- reward on eating
-- minetest.register_on_item_eat(function(hp_change, replace_with_item, itemstack, user, pointed_thing)
--	print(hp_change .. " - " .. user:get_hp())
-- end);

-- external accessible
xp_redo.on_craft = function(itemstack, player)
	if player and player:is_player() then
		-- limit craft reward to mitigate back-and-forth crafting for xp
		 xp_redo.add_xp(player:get_player_name(), math.min(itemstack:get_count(), 5))
	end
end

-- reward on crafting
minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	xp_redo.on_craft(itemstack, player)
end)

