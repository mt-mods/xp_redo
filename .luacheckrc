
globals = {
	"luaentity",
	"minetest",
	"xp_redo"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"vector", "ItemStack",
	"dump",

	-- deps
	"default", "mesecon", "hb",
	"screwdriver", "areas", "protector"
}
