
local export_ranks = function()
	local fname = minetest.get_worldpath().."/ranks.json"
	print("[XP-Redo] Exporting ranks as json to: " .. fname)

	local f = io.open(fname, "w")
	local data_string = minetest.write_json(xp_redo.ranks)
	f:write(data_string)
	io.close(f)
end

if minetest.write_json then
	minetest.after(5, export_ranks)
end
