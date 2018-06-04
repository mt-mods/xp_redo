

local update_formspec = function(meta)
	local orientation = meta:get_string("orientation")

	meta:set_string("formspec", "size[6,2;]" ..
		"button_exit[4,0.5;2,1;save;Save]" ..
		"field[0,1;4,1;orientation;Orientation (x+,x-,z+,z-);" .. orientation .. "]")
end

local build_board = function(pos)
	local start = os.clock()

	local meta = minetest.get_meta(pos)
	local orientation = meta:get_string("orientation")

	local fromX = pos.x
	local toX = pos.x

	local fromZ = pos.z
	local toZ = pos.z

	local fromY = pos.y + 13
	local toY = pos.y + 1

	local mulX = 0
	local mulZ = 0

	local width = 20

	if orientation == "x+" then
		toX = toX + width
		mulX = 1
	elseif orientation == "x-" then
		fromX = fromX - width
		mulX = -1
	elseif orientation == "z+" then
		toZ = toZ + width
		mulZ = 1
	elseif orientation == "z-" then
		fromZ = fromZ - width
		mulZ = -1
	else
		-- bad orientation
		return
	end

	local id_stone = minetest.get_content_id("default:stone")
	local id_blank = minetest.get_content_id("ehlphabet:block")
	local id_air = minetest.get_content_id("air")

	-- Get the vmanip object and the area and nodes
	local manip = minetest.get_voxel_manip()
	local e1, e2 = manip:read_from_map({ x=fromX, y=fromY, z=fromZ }, { x=toX, y=toY, z=toZ })
	local area = VoxelArea:new({MinEdge=e1, MaxEdge=e2})
	local data = manip:get_data()

	local set_coord = function(row, col, id)
		local x = fromX + (col * mulX)
		local y = fromY - row
		local z = fromZ + (col * mulZ)

		-- print(x .. "/" .. y .. "/" .. z)

		data[area:index(x,y,z)] = id
	end

	local entries = {} -- list of strings

	for _,entry in pairs(xp_redo.highscore) do
		local line = string.sub(entry.name, 1, 8)

		while string.len(line) < 10 do
			line = line .. " "
		end

	end

	local rows = 12
	local cols = 20

	for row=1,rows do
		for col=1,cols do
			if row == 1 or row == rows then
				-- h-border
				set_coord(row, col, id_stone)
			elseif col == 1 or col == cols then
				-- v-border
				set_coord(row, col, id_stone)
			else
				-- content (2...rows) (2...cols)
				local entry = xp_redo.highscore[row-1]
				if entry then
					local char = string.byte(entry.name, col-1)
					if char then
						if char >= 97 and char <= 122 then
							-- lower case letter, convert to upper case
							char = char - 32 -- string.byte("a", 1) - string.byte("A", 1)
						end
						
						local id = minetest.get_content_id("ehlphabet:" .. char)
						if id then
							set_coord(row, col, id)
						else
							set_coord(row, col, id_blank)
						end
					else
						-- no char...
						set_coord(row, col, id_blank)

					end
				else
					set_coord(row, col, id_blank)
				end
				-- TODO
			end
		end
	end
 
	-- Doc: http://dev.minetest.net/vmanip

	manip:set_data(data)
	manip:write_to_map()

	local diff = os.clock() - start
	print("Board painting took " .. diff .. " seconds")
end


minetest.register_node("xp_redo:highscore_board", {
	description = "XP Highscore board",
	tiles = {"xp_highscore_board.png"},
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
	end,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("orientation", "")
		update_formspec(meta)

		local timer = minetest.get_node_timer(pos)
		timer:start(10)
	end,

	on_timer = function(pos)
		build_board(pos)
		return true
	end,

	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.get_meta(pos)
		local name = sender:get_player_name()

		if name == meta:get_string("owner") then
			-- owner
			if fields.orientation then
				meta:set_string("orientation", fields.orientation)
			end

			update_formspec(meta)
		end
	end,

	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos)
		local name = player:get_player_name()

		return name == meta:get_string("owner")
	end
})
