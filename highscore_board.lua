

local update_formspec = function(meta)
	local orientation = meta:get_string("orientation")

	meta:set_string("formspec", "size[6,2;]" ..
		"button_exit[4,0.5;2,1;save;Save]" ..
		"field[0,1;4,1;orientation;Orientation (x+,x-,z+,z-);" .. orientation .. "]")
end

local build_board = function(pos)

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

	-- Get the vmanip object and the area and nodes
	local manip = minetest.get_voxel_manip()
	local e1, e2 = manip:read_from_map({ x=fromX, y=fromY, z=fromZ }, { x=toX, y=toY, z=toZ })
	local area = VoxelArea:new({MinEdge=e1, MaxEdge=e2})
	local data = manip:get_data()

	local set_coord = function(row, col, id)
		local x = fromX + (col * mulX)
		local y = fromY - row + 1 -- row1 == pos+0
		local z = fromZ + (col * mulZ)

		print(x .. "/" .. y .. "/" .. z) --XXX

		data[area:index(x,y,z)] = id
	end

	local row = 1
	local col = 1

	while row < 13 do
		while col <= 20 do
			if row == 1 or row == 12 then
				-- border
				set_coord(row, col, id_stone)
			else
				-- name
				-- TODO
			end

			col = col + 1
		end

		row = row + 1
	end
 
	-- Doc: http://dev.minetest.net/vmanip

	manip:set_data(data)
	manip:write_to_map()

	print("building highscore board") -- XXX
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
