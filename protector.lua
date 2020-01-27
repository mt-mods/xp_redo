local has_protector_mod = minetest.get_modpath("protector")
local has_mesecons_mvps_mod = minetest.get_modpath("mesecons_mvps")


local update_formspec = function(meta)
	local threshold = meta:get_int("xpthreshold")
	local owner = meta:get_string("owner")

	meta:set_string("infotext", "XP Protector, threshold: " .. threshold .. ", owner: " .. owner)
	meta:set_string("formspec", "size[6,3;]" ..
		"field[0,1;6,1;xpthreshold;XP Threshold;" .. threshold .. "]" ..
		"button_exit[0,2;6,1;save;Save]"
	)
end

local last_player_xp_map = {}

local function get_last_player_user_xp(name)
	return last_player_xp_map[name] or 1000
end

local function set_last_player_user_xp(name, xp)
	last_player_xp_map[name] = xp
end


minetest.register_node("xp_redo:protector", {
	description = "XP Protector",
	tiles = {
		"default_bronze_block.png^xp_protector_overlay.png",
		"default_bronze_block.png^xp_protector_overlay.png",
		"default_bronze_block.png^xp_protector_overlay.png^xp_protector_logo.png"
	},

	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_int("xpthreshold", get_last_player_user_xp(placer:get_player_name()))
		update_formspec(meta)
	end,

	on_receive_fields = function(pos, _, fields, sender)
		local meta = minetest.get_meta(pos)
		local name = sender:get_player_name()

		if name == meta:get_string("owner") then
			-- ownder
			if fields.xpthreshold then
				local xpthreshold = tonumber(fields.xpthreshold)
				if xpthreshold ~= nil then
					meta:set_int("xpthreshold", fields.xpthreshold)
					set_last_player_user_xp(name, fields.xpthreshold)
				end
			end

			update_formspec(meta)
		end
	end,

	on_punch = function(pos, _, puncher)
		if minetest.is_protected(pos, puncher:get_player_name()) then
			return
		end

		if has_protector_mod then
			minetest.add_entity(pos, "protector:display")
		end
	end,

	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos)
		local name = player:get_player_name()

		return name == meta:get_string("owner") or minetest.check_player_privs(name, {protection_bypass=true})
	end
})



local old_is_protected = minetest.is_protected

-- check for protected area, return true if protected and digger isn't on list
function minetest.is_protected(pos, digger)

	local radius = 5
	digger = digger or "" -- nil check

	if minetest.check_player_privs(digger, {protection_bypass = true}) then
		return false
	end

	local xp = xp_redo.get_xp(digger)
	local nodes = minetest.find_nodes_in_area(
		{x = pos.x - radius, y = pos.y - radius, z = pos.z - radius},
		{x = pos.x + radius, y = pos.y + radius, z = pos.z + radius},
		{"xp_redo:protector"})

	for n = 1, #nodes do

		local meta = minetest.get_meta(nodes[n])
		local xpthreshold = meta:get_int("xpthreshold") or 0

		if xpthreshold > xp then
			minetest.chat_send_player(digger, "This area is protected with a minimum-xp of " .. xpthreshold .. "!")
			return true
		end

	end




	-- otherwise can dig or place
	return old_is_protected(pos, digger)
end

if has_protector_mod and protector.tool.register_protector then
	protector.tool:register_protector('xp_redo:protector', {
		nodes = nil, -- Compatible nodes for protector tool, uses same on_place, radius, etc.
		param2 = nil, -- Default param2 for protector
		on_place = nil, -- on_place callback, protector is about to be placed
		after_place = function(user, meta, src_meta)
			-- copy members across if holding sneak when using tool
			if user:get_player_control().sneak then
				-- get priv on source protector / set target protector metadata
				local xpthreshold = src_meta:get_int("xpthreshold") or 1000
				meta:set_int("xpthreshold", xpthreshold)
			else
				local name = user:get_player_name()
				meta:set_int("xpthreshold", get_last_player_user_xp(name))
			end
			update_formspec(meta)
		end,
	})
end

minetest.register_craft({
    output = 'xp_redo:protector',
    type = 'shapeless',
    recipe = {"default:bronzeblock", "default:steel_ingot"}
})

if has_mesecons_mvps_mod then
	mesecon.register_mvps_stopper("xp_redo:protector")
end
