

local get_entity_name = function(rank)
	return "xp_redo:xp" .. rank.xp
end

for i,rank in pairs(xp_redo.ranks) do

	local name = get_entity_name(rank)
	minetest.register_entity(name, {
		initial_properties = {
			visual = "upright_sprite",
			visual_size = {x=0.5,y=0.5},
			textures = {rank.icon, rank.icon},
			physical = false,
			collide_with_objects = false,
			pointable = false,
			static_save = false
		},
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
	if not player or not player:is_player() then
		return
	end

	local playername = player:get_player_name()
	local data = player_data[playername]

	-- TODO: check new rank
	if not data then
		local pos = player:getpos()

		local name = get_entity_name(rank)
		local entity = minetest.add_entity(pos, name)

		entity:set_attach(player, "", {x=0,y=15,z=0}, {x=0,y=0,z=0})

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