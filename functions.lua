
xp_redo.get_rank = function(xp)
	if xp < 0 then
		xp = 0
	end

	local result = nil
	for _,rank in pairs(xp_redo.ranks) do
		if xp >= rank.xp then
			result = rank
		end
	end

	return result
end

-- show a level-up dialogue
local level_up = function(player, rank)
	local playername = player:get_player_name()
	minetest.sound_play({name="xp_redo_generic", gain=0.25}, {to_player=playername})

	local h1 = player:hud_add({
		hud_elem_type = "text",
		name = "award_au",
		number = xp_redo.rgb_to_int(rank.color.r, rank.color.g, rank.color.b),
		scale = {x = 100, y = 40},
		text = "Level-up to " .. rank.name,
		position = {x = 0.5, y = 0},
		offset = {x = 0, y = 40},
		alignment = {x = 0, y = -1}
	})

	local h2 = player:hud_add({
		hud_elem_type = "image",
		name = "award_icon",
		scale = {x = 4, y = 4},
		text = rank.icon,
		position = {x = 0.5, y = 0},
		offset = {x = 0, y = 150},
		alignment = {x = 0, y = -1}
	})

	minetest.after(4, function()
		player = minetest.get_player_by_name(playername)
		if player then
			player:hud_remove(h1)
			player:hud_remove(h2)
		end
	end)
end

xp_redo.get_xp = function(playername)
	local player = minetest.get_player_by_name(playername)
	if player == nil then
		return 0
	end

	local meta = player:get_meta()
	local currentXp = meta:get_int("xp")
	if currentXp == nil or currentXp < 0 then
		currentXp = 0
	end

	return currentXp
end

-- http://lua-users.org/lists/lua-l/2006-01/msg00525.html
function xp_redo.format_thousand(v)
	local s = string.format("%d", math.floor(v))
	local pos = string.len(s) % 3
	if pos == 0 then pos = 3 end
	return string.sub(s, 1, pos)
		.. string.gsub(string.sub(s, pos+1), "(...)", "'%1")
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

	player:get_meta():set_int("xp", sumXp)

	xp_redo.run_hook("xp_change", { playername, sumXp })

	local previousRank = xp_redo.get_rank(currentXp)
	local currentRank = xp_redo.get_rank(sumXp)
	if currentRank and currentRank.xp > previousRank.xp then
		-- level up
		xp_redo.run_hook("rank_change", { playername, sumXp, currentRank })

		local state = player:get_attribute(xp_redo.HUD_DISPLAY_STATE_NAME)
		if state and state == "on" then
			level_up(player, currentRank)
		end
	end

	return sumXp
end



xp_redo.get_next_rank = function(xp, current_rank)
	if xp < 0 then
		xp = 0
	end

	if current_rank == nil then
		current_rank = xp_redo.get_rank(xp)
	end

	local result = nil
	for _,rank in pairs(xp_redo.ranks) do
		if (result ~= nil and rank.xp > current_rank.xp and rank.xp < result.xp) or
		   (result == nil and rank.xp > current_rank.xp) then
			result = rank
		end
	end

	return result
end
