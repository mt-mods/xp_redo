
local has_woodcutting_mod = minetest.get_modpath("woodcutting")

local function create_limiter(seconds)

	local player_time_map = {}

	return function(playername)

		local last_call = player_time_map[playername]
		local now = minetest.get_us_time()

		if not last_call or now - last_call > (seconds * 1000000) then
			-- either no last call or last call was longer than limit

			-- register new time
			player_time_map[playername] = minetest.get_us_time()

			return false -- not limited
		end

		return true -- limited
	end
end

-- bonus on placing
minetest.register_on_placenode(function(_, newnode, player)
	if player and player:is_player() and not player.is_fake_player then
		if newnode and newnode.name and string.match(newnode.name, "^digtron") then
			-- digtron uncrating
			return
		end

		local wield_item = player:get_wielded_item()
		if wield_item then
			local name = wield_item:get_name()
			-- check for technic replacer
			-- since placing single node takes same effort as placing without
			-- replacer, it seems fair to give XP in single mode
			if name == "replacer:replacer_technic" and "single" ~= wield_item:get_meta():get_string("mode") then
				return
			end
		end

		xp_redo.add_xp(player:get_player_name(), 1)
	end
end)

local death_limiter = create_limiter(60)

-- malus on death
if xp_redo.enable_death_malus then
	minetest.register_on_dieplayer(function(player)
		if player and player:is_player() then
			if not death_limiter(player:get_player_name()) then
				-- one death in 60 seconds
				xp_redo.add_xp(player:get_player_name(), -1000)
			end
		end
	end);
end

local node_reward_table = {}

local function register_node_reward(name, reward)
	table.insert(node_reward_table, { name=name, reward=reward })
end

if xp_redo.enable_dignode_rewards then
	register_node_reward("default:stone_with_coal", 2)
	register_node_reward("default:stone_with_copper", 3)
	register_node_reward("default:stone_with_diamond", 10)
	register_node_reward("default:stone_with_gold", 5)
	register_node_reward("default:stone_with_iron", 2)
	register_node_reward("default:stone_with_mese", 10)
	register_node_reward("default:stone_with_tin", 2)
end

-- bonus on digging
local dig_limiter = (xp_redo.limit_dig_rate and xp_redo.limit_dig_rate > 0) and
	create_limiter(1 / xp_redo.limit_dig_rate)
minetest.register_on_dignode(function(_, oldnode, digger)
	if digger ~= nil and digger:is_player() and not digger.is_fake_player then
		if not oldnode.name then
			return
		end

		if has_woodcutting_mod and woodcutting.process_runtime[digger:get_player_name()] then
			-- woodcutting active, skip reward
			return
		end

		-- digging rate limiter
		if dig_limiter and dig_limiter(digger:get_player_name()) then
			return
		end

		-- no reward for nodes that are fast to dig and add no tool wear
		local dig_immediate = minetest.get_item_group(oldnode.name, "dig_immediate")
		if dig_immediate == 2 or dig_immediate == 3 then
			return
		end

		local reward = 1

		local wield_item = digger:get_wielded_item()
		if wield_item then
			local name = wield_item:get_name()
			-- check for mining laser/drill
			if string.find(name, "technic%:laser") or string.find(name, "technic%:mining") then
				-- no reward
				return
			end
			-- check for basic replacer
			if "replacer:replacer" == name then
				return
			end
			-- check for technic replacer
			if name == "replacer:replacer_technic" then
				return
			end
		end

		if string.find(oldnode.name, "^digtron") then
			-- digtron crating
			return
		end


		for _,entry in pairs(node_reward_table) do
			if oldnode.name == entry.name then
				reward = entry.reward
			end
		end

		xp_redo.add_xp(digger:get_player_name(), reward)
	end
end)

-- reward on eating
-- minetest.register_on_item_eat(function(hp_change, replace_with_item, itemstack, user, pointed_thing)
--	print(hp_change .. " - " .. user:get_hp())
-- end);

local craft_limiter = create_limiter(0.5)

-- external accessible
xp_redo.on_craft = function(itemstack, player)
	 if player and player:is_player() then
		-- limit invoke count
		if not craft_limiter(player:get_player_name()) then
			-- limit craft reward to mitigate back-and-forth crafting for xp
			xp_redo.add_xp(player:get_player_name(), math.min(itemstack:get_count(), 10))
		end
	end
end

-- reward on crafting
minetest.register_on_craft(function(itemstack, player)
	xp_redo.on_craft(itemstack, player)
end)
