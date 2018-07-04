
xp_redo.get_rank = function(xp)
	if xp < 0 then
		xp = 0
	end

	local result = nil
	for i,rank in pairs(xp_redo.ranks) do
		if xp >= rank.xp then
			result = rank
		end
	end

	return result
end

local level_up = function(player, rank)
	minetest.sound_play({name="xp_redo_generic", gain=0.25}, {to_player=player:get_player_name()})


	local one = player:hud_add({
		hud_elem_type = "image",
		name = "award_bg",
		scale = {x = 2, y = 1},
		text = "xp_levelup_bg_default.png",
		position = {x = 0.5, y = 0},
		offset = {x = 0, y = 138},
		alignment = {x = 0, y = -1}
	})

	local two = player:hud_add({
		hud_elem_type = "text",
		name = "award_au",
		number = 0xFFFFFF,
		scale = {x = 100, y = 20},
		text = "Level-up!",
		position = {x = 0.5, y = 0},
		offset = {x = 0, y = 40},
		alignment = {x = 0, y = -1}
	})

	local three = player:hud_add({
		hud_elem_type = "text",
		name = "rank_title",
		number = 0xFFFFFF,
		scale = {x = 100, y = 20},
		text = rank.name,
		position = {x = 0.5, y = 0},
		offset = {x = 30, y = 100},
		alignment = {x = 0, y = -1}
	})

	local rank_offset = {x = -1.5, y = 126}

	local four = player:hud_add({
		hud_elem_type = "image",
		name = "award_icon",
		scale = {x = 2, y = 2},
		text = rank.icon,
		position = {x = 0.4, y = 0},
		offset = rank_offset,
		alignment = {x = 0, y = -1}
	})

	minetest.after(4, function()
		player:hud_remove(one)
		player:hud_remove(two)
		player:hud_remove(three)
		player:hud_remove(four)
	end)
end

xp_redo.get_xp = function(playername)
	local player = minetest.get_player_by_name(playername)
	if player == nil then
		return 0
	end

	local currentXpStr = player:get_attribute("xp")
	local currentXp = 0
	if currentXpStr ~= nil then
		currentXp = tonumber(currentXpStr)
		if currentXp == nil or currentXp < 0 then
			currentXp = 0
		end
	end

	return currentXp
end


xp_redo.add_xp = function(playername, xp)

	local player = minetest.get_player_by_name(playername)
	if player == nil then
		return
	end

	local currentXp = xp_redo.get_xp(playername)

	local sumXp = currentXp + xp
	if sumXp < 0 then
		sumXp = 0
	end

	player:set_attribute("xp", sumXp)

	local previousRank = xp_redo.get_rank(currentXp)
	local currentRank = xp_redo.get_rank(sumXp)
	if currentRank.xp > previousRank.xp then
		-- level up
		level_up(player, currentRank)
	end

	return sumXp	
end



xp_redo.get_next_rank = function(xp, current_rank)
	if xp < 0 then
		xp = 0
	end

	if current_rank == nil then
		current_rank = get_rank(xp)
	end

	local result = nil
	for i,rank in pairs(xp_redo.ranks) do
		if (result ~= nil and rank.xp > current_rank.xp and rank.xp < result.xp) or
		   (result == nil and rank.xp > current_rank.xp) then
			result = rank
		end
	end

	return result
end


local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 1 then
		local players = minetest.get_connected_players()
		for i,player in pairs(players) do
			local playername = player:get_player_name()
			local xp = player:get_attribute("xp")

			if xp == nil then
				xp = 0
				player:set_attribute("xp", xp)
			else
				xp = tonumber(xp)
			end

			local rank = xp_redo.get_rank(xp)
			local next_rank = xp_redo.get_next_rank(xp, rank)

			xp_redo.update_hud(player, xp, rank, next_rank)
			xp_redo.update_rank_entity(player, rank)
		end

		timer = 0
	end
end)
