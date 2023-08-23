-- ordered list: { name: '', xp: 0 }
local storage = minetest.get_mod_storage()

local function write_file(highscore) 
    if type(highscore) == "table" then
        storage:set_string("highscore", minetest.serialize(highscore))
    end
end
 
--Get general modstorage
local function load_file()
    local highscore_table = storage:get_string("highscore")
    if highscore_table then
        highscore_table = minetest.deserialize(highscore_table)
        --extra check needed
        if type(highscore_table) ~= "table" then
            highscore_table = {} 
        end
    else 
        highscore_table = {}
    end
    return highscore_table
end

xp_redo.highscore = load_file()

local update_highscore = function()
	local players = minetest.get_connected_players()

	for _,player in pairs(players) do
		local name = player:get_player_name()
		local xp = player:get_meta():get_int("xp")
		local found = false
		for _,entry in pairs(xp_redo.highscore) do
			if entry.name == name then
				-- connected player already exists in highscore, update value
				entry.xp = xp
				found = true
			end
		end

		if not found then
			-- create new entry
			table.insert(xp_redo.highscore, { name=name, xp=xp })
		end
	end

	-- sort
	table.sort(xp_redo.highscore, function(a,b) return a.xp > b.xp end)

	-- truncate
	while table.getn(xp_redo.highscore) > 10 do
		table.remove(xp_redo.highscore, table.getn(xp_redo.highscore))
	end
end

local timer = 0
local count = 0
minetest.register_globalstep(function(dtime)
    timer = timer + dtime;
    if timer >= 60 then
        count = count + 1
        update_highscore()
        --write_file()
        timer = 0
    end
    if count >= 5 then
        write_file(xp_redo.highscore)
    end
end)

minetest.register_on_shutdown(function()
    write_file(xp_redo.highscore)
end)


