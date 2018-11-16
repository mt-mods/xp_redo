
xp_redo.ranks = {}

xp_redo.register_rank = function(def)
	table.insert(xp_redo.ranks, def)
	xp_redo.register_rank_entity(def)
end

