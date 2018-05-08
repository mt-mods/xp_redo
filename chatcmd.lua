
minetest.register_privilege("givexp", {"Can give or take xp with /givexp", give_to_singleplayer = false})


minetest.register_chatcommand("givexp", {
    params = "<username> <xp>",
    description = "Give or take experience points",
    privs = {givexp=true},
    func = function(caller, param)
	local ign,ign,name,xp = string.find(param, "^([^%s]+)%s+(%d+)%s*$")
	if name == nil or xp == nil then
		minetest.chat_send_player(caller, "syntax: /givexp <username> <xp>")
		return
	end

	local xpnum = tonumber(xp)
	if xpnum == nil then
		minetest.chat_send_player(caller, "not a number: " .. xp)
		return
	end

	local player = minetest.get_player_by_name(name)
	if player == nil then
		minetest.chat_send_player(caller, "not a player: " .. name)
		return
	end

	local currentXpStr = player:get_attribute("xp")
	local currentXp = 0
	if currentXpStr ~= nil then
		currentXp = tonumber(currentXpStr)
		if currentXp == nil or currentXp < 0 then
			currentXp = 0
		end
	end

	local sumXp = currentXp + xp
	if sumXp < 0 then
		sumXp = 0
	end

	player:set_attribute("xp", sumXp)
	minetest.chat_send_player(caller, "XP of player " .. name .. " = " .. sumXp)
	
    end,
})