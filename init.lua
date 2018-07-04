
local MP = minetest.get_modpath("xp_redo")

xp_redo = {}

dofile(MP.."/ranks.lua")
dofile(MP.."/entities.lua")
dofile(MP.."/hud.lua")
dofile(MP.."/functions.lua")
dofile(MP.."/xpgate.lua")
dofile(MP.."/mobs.lua")
dofile(MP.."/highscore.lua")
dofile(MP.."/chatcmd.lua")
dofile(MP.."/builtin.lua")

local has_ehlphabet_mod = minetest.get_modpath("ehlphabet")

if has_ehlphabet_mod then
	-- load highscore board
	dofile(MP.."/highscore_board.lua")
end


print("[OK] XP-Redo")
