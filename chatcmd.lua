
minetest.register_privilege("givexp", {"Can give or take xp with /givexp", give_to_singleplayer = false})


minetest.register_chatcommand("givexp", {
    params = "<username> <xp>",
    description = "Give or take experience points",
    privs = {givexp=true},
    func = function(caller, param)
	local ign,ign,name,xp = string.find(param, "^([^%s]+)%s+([^%s]+)%s*$")
	if name == nil or xp == nil then
		minetest.chat_send_player(caller, "syntax: /givexp <username> <xp>")
		return
	end

	local newXp = xp_redo.add_xp(name, xp)
	if newXp == nil then
		return
	end

	minetest.chat_send_player(caller, "XP of player " .. name .. " = " .. newXp)
    end,
})