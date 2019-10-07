local has_protector_mod = minetest.get_modpath("protector")

local update_formspec = function(meta)
	local threshold = meta:get_int("xpthreshold")
	local mode = meta:get_int("mode")

	local mode_str = "Mode: <Min XP required>"
	if mode == 1 then
		mode_str = "Mode: <Max XP allowed>"
	end

	meta:set_string("infotext", "XP Gate, threshold: " .. threshold .. " " .. mode_str)
	meta:set_string("formspec", "size[6,4;]" ..
		"field[0,1;6,1;xpthreshold;XP Threshold;" .. threshold .. "]" ..
		"button[0,2;6,1;toggle_mode;" .. mode_str .. "]" ..
		"button_exit[0,3.2;6,1;save;Save]"
	)
end

minetest.register_node("xp_redo:xpgate", {
	description = "XP Gateway",
	tiles = {"xp_gate.png"},
	groups = {cracky=3,oddly_breakable_by_hand=3},
	drop = "xp_redo:xpgate",
	sounds = default.node_sound_glass_defaults(),

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
	end,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_int("xpthreshold", 10)
		meta:set_int("mode", 0)-- 0=min xp required, 1=max xp allowed
		update_formspec(meta)
	end,

	on_receive_fields = function(pos, _, fields, sender)
		local meta = minetest.get_meta(pos)
		local name = sender:get_player_name()

		if name == meta:get_string("owner") then


			if fields.toggle_mode then
				local mode = meta:get_int("mode")
				if mode == 1 then
					meta:set_int("mode", 0)
				else
					meta:set_int("mode", 1)
				end
			end

			-- owner
			if fields.xpthreshold then
				local xpthreshold = tonumber(fields.xpthreshold)
				if xpthreshold ~= nil then
					meta:set_int("xpthreshold", xpthreshold)
				end
			end

			update_formspec(meta)
		end
	end,

	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos)
		local name = player:get_player_name()

		return name == meta:get_string("owner")
	end
})

local override_door = function(name, yoffset)

	local doorDef = minetest.registered_nodes[name]

	if doorDef ~= nil then
		-- override door def
		local doorRightClick = doorDef.on_rightclick

		doorDef.on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			local ppos = clicker:get_pos()

			local gate = minetest.find_node_near(pos, 2, {"xp_redo:xpgate"})
			if gate ~= nil then
				minetest.log("action", "[xp-gate] clicked by player " ..
					clicker:get_player_name() .. " @ " ..
					ppos.x .. "/" .. ppos.y .. "/" .. ppos.z)

				-- xp limited door
				local meta = minetest.get_meta(gate)

				local mode = meta:get_int("mode")
				local xpthreshold = meta:get_int("xpthreshold")

				local playername = clicker:get_player_name()
				local xp = xp_redo.get_xp(playername)

				local err_msg
				local allowed

				if mode == 1 then
					-- max xp allowed
					allowed = xp <= xpthreshold
					err_msg = "Too much xp, maximum allowed: " .. xpthreshold
				else
					-- min xp required
					allowed = xp >= xpthreshold
					err_msg = "Not enough xp, minimum required: " .. xpthreshold
				end

				if allowed then
					local dir = vector.direction(ppos, pos)
					local newPos = vector.add(pos, dir)

					-- use y from door
					newPos.y = pos.y + yoffset

					minetest.log("action", "[xp-gate] moving player to " .. newPos.x .. "/" .. newPos.y .. "/" .. newPos.z)
					clicker:moveto(newPos)
				else
					-- not allowed
					minetest.log("action", "[xp-gate] player '" .. playername .. "' disallowed: " .. err_msg)
					minetest.chat_send_player(playername, err_msg)
				end

			else
				-- normal door, delegate
				doorRightClick(pos, node, clicker, itemstack, pointed_thing)
			end
		end

	end


end

if has_protector_mod then
	override_door("protector:door_steel_b_1", -0.5)
	override_door("protector:door_steel_b_2", -0.5)
	override_door("protector:door_steel_t_1", -1.5)
	override_door("protector:door_steel_t_2", -1.5)
end

override_door("doors:door_wood_b", -0.5)

minetest.register_craft({
	output = 'xp_redo:xpgate',
	recipe = {
		{'doors:door_wood', '', 'doors:door_steel'},
		{'group:wood', 'group:wood', 'group:wood'},
		{'doors:door_steel', '', 'doors:door_wood'}
	}
})
