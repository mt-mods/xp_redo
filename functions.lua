

local get_rank = function(xp)
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

			local rank = get_rank(xp)

			player:set_nametag_attributes({
				color=rank.color,
				text="[" .. rank.name .. "|" .. xp .. "] " .. playername
			})

		end

		timer = 0
	end
end)
