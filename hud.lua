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

local HUD_DISPLAY_STATE_NAME = "hud_state"

local hud_color = {}

local setup_hud = function(player)
	local playername = player:get_player_name()
	if hud[playername] then
		return
	end

	local data = {}
	local color = hud_color[playername] or tonumber(player:get_meta():get_string("xp_redo_hud_color")) or tonumber("0x0000FF")
	local img_color = hud_color[playername] or player:get_meta():get_string("xp_redo_hud_color") or "0x0000FF"

	local img_color = string.match(img_color,"%x%x%x%x%x%x$")

	if img_color then
		img_color = "#"..img_color
	else
		img_color = "#0000FF"
	end

	player:set_attribute(HUD_DISPLAY_STATE_NAME, "on")
	
	data.info = player:hud_add({
		hud_elem_type = "text",
		position = HUD_POSITION,
		offset = {x = 0,   y = 0},
		text = "",
		alignment = HUD_ALIGNMENT,
		scale = {x = 100, y = 100},
		number = color
	})
	

	data.rank = player:hud_add({
		hud_elem_type = "text",
		position = HUD_POSITION,
		offset = {x = 0,   y = 20},
		text = "",
		alignment = HUD_ALIGNMENT,
		scale = {x = 100, y = 100},
		number = color
	})

	-- rank img

	if not xp_redo.disable_hud_icon then

		local RANK_IMG_OFFSET = {x = 0,   y = 90}

		data.rankimg = player:hud_add({
			hud_elem_type = "image",
			position = HUD_POSITION,
			offset = RANK_IMG_OFFSET,
			text = "xp_empty.png",
			alignment = HUD_ALIGNMENT,
			scale = {x = -9/3, y = -16/3}
		})
	end

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
			text = "xp_progress_fg.png^[colorize:"..img_color..":255",
			alignment = HUD_ALIGNMENT,
			scale = {x = 0, y = 1}
		})
	end

	hud[playername] = data

end

local remove_hud = function(player)
	local playername = player:get_player_name()
	local data = hud[playername]

	player:set_attribute(HUD_DISPLAY_STATE_NAME, "off")


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
		else
			return true, "Usage: /xp_hud on|off"
		end
	end
})

local get_color = function(r,g,b)
	return b + (g * 256) + (r * 256 * 256)
end

local function get_hex_color(colorSpec)
	return string.format("#%x%x%x", colorSpec.r, colorSpec.g, colorSpec.b)
end

xp_redo.update_hud = function(player, xp, rank, next_rank)

	local playername = player:get_player_name()
	local data = hud[playername]

	if not data or not rank then
		return
	end

	--local infoTxt = "XP: " .. xp_redo.format_thousand(xp)
	local infoTxt = "XP: " .. xp_redo.format_thousand(xp - rank.xp)
	local progress = 100

	if next_rank ~= nil then
		--infoTxt = infoTxt .. "/" .. xp_redo.format_thousand(next_rank.xp)
		infoTxt = infoTxt .. "/" .. xp_redo.format_thousand(next_rank.xp - rank.xp) .. " [" .. xp_redo.format_thousand(xp) .. "]"
		if next_rank.xp > xp then
			-- progress from 0 to 100
			--progress = tonumber(xp / next_rank.xp * 100)
			progress = tonumber((xp - rank.xp) / (next_rank.xp - rank.xp) * 100)
		end
	end

	player:hud_change(data.info, "text", infoTxt)

	local color = get_color(rank.color.r, rank.color.g, rank.color.b)

	player:hud_change(data.rank, "number", color)
	player:hud_change(data.rank, "text", "[" .. rank.name .. "]")

	if not xp_redo.disable_hud_icon then
		player:hud_change(data.rankimg, "text", rank.icon)
	end

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
	local state = player:get_attribute(HUD_DISPLAY_STATE_NAME)
	if not state or state == "on" then
		setup_hud(player)
	end
end)

minetest.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	hud[playername] = nil
end)

minetest.register_chatcommand("xp_hud_color", {
	params = "<hex color code>",
	description = "Changes the color of your xp HUD to the one specified, eg 0xFFFF00 for yellow",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)

		-- detect legit color code. If unsure, keep the default.
		-- we accept 0x00FF00 or 00FF00
		local color = string.match(param:trim(),"%x%x%x%x%x%x$")

		if color then
			hud_color[name] = "0x"..color
			player:get_meta():set_string("xp_redo_hud_color","0x"..color)
			remove_hud(player)
			setup_hud(player)
		else
			return true, "Usage: /xp_hud_color 0x00FF00 or 00FF00"
		end
	end
})