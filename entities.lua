

local get_entity_name = function(rank)
	return "xp_redo:xp" .. rank.xp
end

for i,rank in pairs(xp_redo.ranks) do

	local name = get_entity_name(rank)
	minetest.register_entity(name, {
		initial_properties = {
			visual = "upright_sprite",
			visual_size = {x=0.5,y=0.5},
			textures = {rank.icon}
		},
		attached = nil
	});

end

local player_entities = {}

xp_redo.remove_rank_entity = function(player)
	local playername = player:get_player_name()
	local entity = player_entities[playername]

	if entity then
		entity:set_detach()
		entity:remove()
	end

	player_entities[playername] = nil
end

minetest.register_on_leaveplayer(function(player)
	xp_redo.remove_rank_entity(player)
end)

xp_redo.update_rank_entity = function(player, rank)
	if not player or not player:is_player() then
		return
	end

	local playername = player:get_player_name()
	local entity = player_entities[playername]

	-- TODO: check new rank
	if not entity then
		local pos = player:getpos()

		local name = get_entity_name(rank)
		entity = minetest.add_entity(pos, name)

		entity:set_attach(player, "", {x=0,y=15,z=0}, {x=0,y=0,z=0})

		player_entities[playername] = entity
	end

end