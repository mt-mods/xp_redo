local get_entity_name = function(rank)
	return minetest.get_current_modname() .. ":xp" .. rank.xp
end

xp_redo.create_entity_properties = function(rank)
	return {
		visual = "cube",
		visual_size = {x=0.5,y=0.5},
		textures = {
			rank.icon,
			rank.icon,
			rank.icon,
			rank.icon,
			rank.icon,
			rank.icon
		},
		physical = false,
		collide_with_objects = false,
		pointable = false,
		static_save = false
	}
end

xp_redo.register_rank_entity = function(rank)
	rank.entityname = get_entity_name(rank)
	minetest.register_entity(rank.entityname, {
		initial_properties = xp_redo.create_entity_properties(rank),
		on_step = function(self)
			if self.object.get_attach and not self.object:get_attach() then
				self.object:remove()
			end
		end,
		attached = nil
	});
end

local player_data = {}

xp_redo.remove_rank_entity = function(player)
	local playername = player:get_player_name()
	local data = player_data[playername]

	if not data then
		return
	end

	local entity = data.entity

	if entity then
		entity:set_detach()
		entity:remove()
	end

	player_data[playername] = nil
end

minetest.register_on_leaveplayer(function(player)
	xp_redo.remove_rank_entity(player)
end)

xp_redo.update_rank_entity = function(player, rank)
	if not player or not player:is_player() or not rank then
		return
	end

	local state = player:get_meta():get(xp_redo.HUD_DISPLAY_STATE_NAME)
	if not (not state or state == "on") then return end

	local playername = player:get_player_name()
	local data = player_data[playername]

	-- TODO: check new rank
	if not data then
		local pos = player:get_pos()

		local entity = minetest.add_entity(pos, rank.entityname)

		entity:set_attach(player, "", {x=0,y=25,z=0}, {x=0,y=0,z=0})

		data = {
			entity = entity,
			rank = rank
		}

		player_data[playername] = data
	end

	if data.rank.xp ~= rank.xp then
		-- rank changed, remove entity
		xp_redo.remove_rank_entity(player)
	end

end
