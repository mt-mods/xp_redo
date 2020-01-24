
local MP = minetest.get_modpath("xp_redo")


xp_redo = {
	-- nametag display (player:set_nametag_attributes)
	disable_nametag = minetest.settings:get_bool("xp.display_nametag"),

	-- rank entity on top of player
	disable_hover_entity = minetest.settings:get_bool("xp.display_hover_entity"),

	-- various different xp rewards per ore
	enable_dignode_rewards = minetest.settings:get_bool("xp.enable_dignode_rewards"),

	-- xp penalty on player death
	enable_death_malus = minetest.settings:get_bool("xp.enable_death_malus", true),

	hud = {
		posx = tonumber(minetest.settings:get("xp.hud.offsetx") or 0.8),
		posy = tonumber(minetest.settings:get("xp.hud.offsety") or 0.7)
	}
}

-- optional mapserver-bridge stuff below
local http = minetest.request_http_api()

dofile(MP.."/hooks.lua")
dofile(MP.."/ranks.lua")
dofile(MP.."/json.lua") --json export

if http then
        print("Enabling discord webhook for XP-Redo")
        local webhook = dofile(MP.."/webhook.lua")
        webhook(http)
end

if not xp_redo.disable_hover_entity then
	dofile(MP.."/entities.lua")
end

dofile(MP.."/privs.lua")
dofile(MP.."/stats.lua")
dofile(MP.."/hud.lua")
dofile(MP.."/functions.lua")
dofile(MP.."/globalstep.lua")
dofile(MP.."/xpgate.lua")
dofile(MP.."/mobs.lua")
dofile(MP.."/highscore.lua")
dofile(MP.."/chatcmd.lua")
dofile(MP.."/builtin.lua")
dofile(MP.."/protector.lua")

if minetest.get_modpath("areas") then
	dofile(MP.."/areas.lua")
end

if minetest.settings:get_bool("enable_xp_redo_integration_test") then
        dofile(MP.."/integration_test.lua")
end

print("[OK] XP-Redo")
