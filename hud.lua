local has_hudbars = minetest.get_modpath("hudbars")

if has_hudbars then
	hb.register_hudbar("xp_progress", 0xFFFFFF, "XP", {
		icon = "xp_mese_crystal.png",
		bgicon = "hudbars_bar_background.png",
		bar = "hudbars_bar_breath.png"
		}, 0, 100, false, "@1: @2%", { order = { "label", "value" }, textdomain = "hbarmor" })
end

local hud = {} -- playername -> data

local HUD_POSITION = {x = xp_redo.hud.posx, y = xp_redo.hud.posy}
local HUD_ALIGNMENT = {x = 1, y = 0}

local setup_hud = function(player)
	local playername = player:get_player_name()
	if hud[playername] then
		return
	end

	local data = {}

	player:get_meta():set_string(xp_redo.HUD_DISPLAY_STATE_NAME, "on")

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

	local RANK_IMG_OFFSET = {x = 0,   y = 90}

	data.rankimg = player:hud_add({
		hud_elem_type = "image",
		position = HUD_POSITION,
		offset = RANK_IMG_OFFSET,
		text = "xp_empty.png",
		alignment = HUD_ALIGNMENT,
		scale = {x = 2, y = 2}
	})

	-- xp progress

	if has_hudbars then
		hb.init_hudbar(player, "xp_progress", nil, nil, false)

	else
		local XP_PROGRESS_OFFSET = {x = 0, y = 40}

		data.background = player:hud_add({
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
	end

	hud[playername] = data

end

local remove_hud = function(player)
	local playername = player:get_player_name()
	local data = hud[playername]

	player:get_meta():set_string(xp_redo.HUD_DISPLAY_STATE_NAME, "off")


	if not data then
		return
	end

	if data.info then
		player:hud_remove(data.info)
	end

	if data.rank then
		player:hud_remove(data.rank)
	end

	if data.rankimg then
		player:hud_remove(data.rankimg)
	end

	if data.progressimg then
		player:hud_remove(data.progressimg)
	end

	if data.background then
		player:hud_remove(data.background)
	end

	hud[playername] = nil
end


minetest.register_chatcommand("xp_hud", {
	params = "on|off",
	description = "Turn xp-hud on or off",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)

		if param == "on" then
			setup_hud(player)
		elseif param == "off" then
			remove_hud(player)
			xp_redo.remove_rank_entity(player)
		else
			return true, "Usage: xp_hud on|off"
		end
	end
})



local function get_hex_color(colorSpec)
	return string.format("#%x%x%x", colorSpec.r, colorSpec.g, colorSpec.b)
end

xp_redo.update_hud = function(player, xp, rank, next_rank)

	local playername = player:get_player_name()
	local data = hud[playername]

	if not data or not rank then
		return
	end

	local infoTxt = "XP: " .. xp_redo.format_thousand(xp)
	local progress = 100

	if next_rank ~= nil then
		infoTxt = infoTxt .. "/" .. xp_redo.format_thousand(next_rank.xp)
		if next_rank.xp > xp then
			-- progress from 0 to 100
			progress = tonumber((xp - rank.xp) / (next_rank.xp - rank.xp) * 100)
		end
	end

	player:hud_change(data.info, "text", infoTxt)

	local color = xp_redo.rgb_to_int(rank.color.r, rank.color.g, rank.color.b)

	player:hud_change(data.rank, "number", color)
	player:hud_change(data.rank, "text", rank.name)

	player:hud_change(data.rankimg, "text", rank.icon)

	if has_hudbars then
		hb.change_hudbar(player, "xp_progress", progress)
	else
		player:hud_change(data.progressimg, "scale", { x=progress, y=1 })
	end

	if not xp_redo.disable_nametag then
		local is_admin = minetest.check_player_privs(playername, {privs=true})
		local is_hidden = minetest.check_player_privs(playername, {hide_nametag=true})
		local text

		if is_hidden then
			-- hidden player
			text = ""

		elseif is_admin then
			-- player is an admin
			text = minetest.colorize("#ff0000", playername)

		else
			-- normal player
			text = minetest.colorize(get_hex_color(rank.color), rank.name) .. " " .. playername

		end

		player:set_nametag_attributes({ text = text })
	end
end

minetest.register_on_joinplayer(function(player)
	local state = player:get_meta():get(xp_redo.HUD_DISPLAY_STATE_NAME)
	if not state or state == "on" then
		setup_hud(player)
	end
end)

minetest.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	hud[playername] = nil
end)
