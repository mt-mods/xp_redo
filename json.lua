
-- rank names may contain translation escapes (e.g. from S() in xp_redo_ranks_ores),
-- export them as plain (english) text for external consumers like xp-highscore
local function plain_text(str)
	if minetest.get_translated_string then
		return minetest.get_translated_string("en", str)
	end
	return minetest.strip_escapes(str)
end

local export_ranks = function()
	local fname = minetest.get_worldpath().."/ranks.json"
	print("[XP-Redo] Exporting ranks as json to: " .. fname)

	local ranks = {}
	for i, rank in ipairs(xp_redo.ranks) do
		local copy = {}
		for k, v in pairs(rank) do
			copy[k] = v
		end
		copy.name = plain_text(rank.name)
		ranks[i] = copy
	end

	local f = io.open(fname, "w")
	local data_string = minetest.write_json(ranks)
	f:write(data_string)
	io.close(f)
end

if minetest.write_json then
	minetest.after(5, export_ranks)
end
