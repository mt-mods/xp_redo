
local hud = {} -- playername -> data

local HUD_POSITION = {x = 0.6, y = 0.7}
local HUD_ALIGNMENT = {x = 1, y = 0}


xp_redo.update_hud = function(player, xp, rank, next_rank)

	local playername = player:get_player_name()
	local data = hud[playername]

	local infoTxt = "XP: " .. xp
	local progress = 100

	if next_rank ~= nil then
		infoTxt = infoTxt .. "/" .. next_rank.xp
		if next_rank.xp > xp then
			-- something to achieve
			progress = tonumber(xp / next_rank.xp * 100)
		end
	end

	player:hud_change(data.info, "text", infoTxt)

	local color = rank.color.b + (rank.color.g * 256) + (rank.color.r * 256 * 256)
	player:hud_change(data.rank, "number", color)
	player:hud_change(data.rank, "text", "[" .. rank.name .. "]")

	player:hud_change(data.rankimg, "text", rank.icon)

	player:hud_change(data.progressimg, "scale", { x=progress, y=1 })

	player:set_nametag_attributes({
		color=rank.color,
		text="[" .. rank.name .. "|" .. xp .. "] " .. playername
	})

end

minetest.register_on_joinplayer(function(player)
	local playername = player:get_player_name()

	local data = {}

	data.info = player:hud_add({
		hud_elem_type = "text",
		position = HUD_POSITION,
		offset = {x = 0,   y = 0},
		text = "",
		alignment = HUD_ALIGNMENT,
		scale = {x = 100, y = 100},
		number = 0x0000FF
	})

	data.rank = player:hud_add({
		hud_elem_type = "text",
		position = HUD_POSITION,
		offset = {x = 0,   y = 20},
		text = "",
		alignment = HUD_ALIGNMENT,
		scale = {x = 100, y = 100},
		number = 0x0000FF
	})

	-- rank img

	local RANK_IMG_OFFSET = {x = -50,   y = 15}

	data.rankimg = player:hud_add({
		hud_elem_type = "image",
		position = HUD_POSITION,
		offset = RANK_IMG_OFFSET,
		text = "xp_empty.png",
		alignment = HUD_ALIGNMENT,
		scale = {x = 2, y = 2}
	})

	-- xp progress

	local XP_PROGRESS_OFFSET = {x = 0, y = 40}

	player:hud_add({
		hud_elem_type = "image",
		position = HUD_POSITION,
		offset = XP_PROGRESS_OFFSET,
		text = "xp_progress_bg.png",
		alignment = HUD_ALIGNMENT,
		scale = {x = 1, y = 1}
	})

	data.progressimg = player:hud_add({
		hud_elem_type = "image",
		position = HUD_POSITION,
		offset = XP_PROGRESS_OFFSET,
		text = "xp_progress_fg.png",
		alignment = HUD_ALIGNMENT,
		scale = {x = 0, y = 1}
	})

	hud[playername] = data
end)

minetest.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	hud[playername] = nil
end)
