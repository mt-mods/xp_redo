
xp_redo.ranks = {}

xp_redo.register_rank = function(def)
	table.insert(xp_redo.ranks, def)
	if not xp_redo.disable_hover_entity then
		-- register entity only if not disabled
		xp_redo.register_rank_entity(def)
	end
end
