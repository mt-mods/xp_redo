
xp_redo.add_xp = function(playername, xp)

	local player = minetest.get_player_by_name(playername)
	if player == nil then
		return
	end

	local currentXpStr = player:get_attribute("xp")
	local currentXp = 0
	if currentXpStr ~= nil then
		currentXp = tonumber(currentXpStr)
		if currentXp == nil or currentXp < 0 then
			currentXp = 0
		end
	end

	local sumXp = currentXp + xp
	if sumXp < 0 then
		sumXp = 0
	end

	player:set_attribute("xp", sumXp)

	return sumXp	
end

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


xp_redo.get_next_rank = function(xp, current_rank)
	if xp < 0 then
		xp = 0
	end

	if current_rank == nil then
		current_rank = get_rank(xp)
	end

	local result = nil
	for i,rank in pairs(xp_redo.ranks) do
		if result == nil or (rank.xp > current_rank.xp and result.xp > rank.xp) then
			result = rank

		end
	end

	if result.xp <= current_rank.xp then
		-- maxed out
		return nil
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
		end

		timer = 0
	end
end)
