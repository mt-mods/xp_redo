local has_protector_mod = minetest.get_modpath("protector")

local update_formspec = function(meta)
	local threshold = meta:get_int("xpthreshold")

	meta:set_string("infotext", "XP Gate, threshold: " .. threshold)
	meta:set_string("formspec", "size[6,2;]" ..
		"button_exit[4,0.5;2,1;save;Save]" ..
		"field[0,1;4,1;xpthreshold;XP Threshold;" .. threshold .. "]")
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
		update_formspec(meta)
	end,

	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.get_meta(pos)
		local name = sender:get_player_name()

		if name == meta:get_string("owner") then
			-- ownder
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
			minetest.log("action", "x-gate @ " .. pos.x .. "/" .. pos.y .. "/" .. pos.z)
			local ppos = clicker:get_pos()

			minetest.log("action", "x-gate clicked by player @ " .. ppos.x .. "/" .. ppos.y .. "/" .. ppos.z)

			local gate = minetest.find_node_near(pos, 2, {"xp_redo:xpgate"})
			if gate ~= nil then
				-- xp limited door
				local meta = minetest.get_meta(gate)
				local xpthreshold = meta:get_int("xpthreshold")

				local xp = xp_redo.get_xp(clicker:get_player_name())

				if xp >= xpthreshold then
					local dir = vector.direction(ppos, pos)
					local newPos = vector.add(pos, dir)

					-- use y from door
					newPos.y = pos.y + yoffset

					clicker:moveto(newPos)
					minetest.log("action", "x-gate moving player to " .. newPos.x .. "/" .. newPos.y .. "/" .. newPos.z)
				else
					minetest.chat_send_player(clicker:get_player_name(), "Not enough xp, needed: " .. xpthreshold)
				end

			else
				-- normal door
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

