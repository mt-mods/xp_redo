
local MP = minetest.get_modpath("xp_redo")

xp_redo = {}

dofile(MP.."/ranks.lua")

-- XXX
local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime;
	if timer >= 1 then
		local players = minetest.get_connected_players()
		for i,player in pairs(players) do
			local playername = player:get_player_name()
			player:set_nametag_attributes({
				color={r=255, g=195, b=195},
				text="[Soldier] " .. playername
			})

		end

		timer = 0
	end
end)


print("[OK] XP-Redo")
