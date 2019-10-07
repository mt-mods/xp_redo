
local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 3 then
		local players = minetest.get_connected_players()
		for _,player in pairs(players) do
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

			if not xp_redo.disable_hover_entity then
				xp_redo.update_rank_entity(player, rank)
			end
		end

		timer = 0
	end
end)
