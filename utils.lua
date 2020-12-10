
-- converts an {r,g,b} colorspec to an int value
xp_redo.rgb_to_int = function(r,g,b)
	return b + (g * 256) + (r * 256 * 256)
end
