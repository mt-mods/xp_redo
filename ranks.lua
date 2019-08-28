
xp_redo.ranks = {}

xp_redo.register_rank = function(def)
	-- minetest.log("action", "[xp-redo] registering rank " .. def.name .. " with xp: " .. def.xp .. " and icon " .. def.icon)
	table.insert(xp_redo.ranks, def)
	xp_redo.register_rank_entity(def)
end

