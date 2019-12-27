
-- id -> { max=1000, min=100 }
local xp_areas = {}

-- protection check
local old_is_protected = minetest.is_protected
function minetest.is_protected(pos, name)
  local area_list = areas:getAreasAtPos(pos)
  for id in pairs(area_list) do
    local xp_area = xp_areas[id]

    if xp_area then
      local xp = xp_redo.get_xp(name)
      if xp_area.min and xp < xp_area.min then
        return true
      elseif xp_area.max and xp > xp_area.max then
        return true
      end
    end
  end

	return old_is_protected(pos, name)
end

-- File writing / reading utilities

local wpath = minetest.get_worldpath()
local filename = wpath.."/xp_areas.dat"

local function load_xp_areas()
	local f = io.open(filename, "r")
	if f == nil then return {} end
	local t = f:read("*all")
	f:close()
	if t == "" or t == nil then return {} end
	return minetest.deserialize(t)
end

local function save_xp_areas()
	local f = io.open(filename, "w")
	f:write(minetest.serialize(xp_areas))
	f:close()
end

xp_areas = load_xp_areas()

-- chat

minetest.register_chatcommand("area_xp_set_min", {
    params = "<ID> <xp_limit>",
    description = "Set or clear the min-xp value of an area",
    func = function(playername, param)
      local _, _, id_str, xp = string.find(param, "^([^%s]+)%s+([^%s]+)%s*$")
      if id_str == nil then
        return true, "Invalid syntax!"
      end

      local id = tonumber(id_str)
      if not id then
        return true, "area-id is not numeric: " .. id_str
      end

      if not areas:isAreaOwner(id, playername) and
        not minetest.check_player_privs(playername, { protection_bypas=true }) then
        return true, "you are not the owner of area: " .. id
      end

      local xp_area = xp_areas[id]
      if not xp_area then
        xp_area = {}
      end

			xp_area.min = tonumber(xp)
      xp_areas[id] = xp_area
      save_xp_areas()
			return true, "Area " .. id .. " min-xp value: " .. (xp_area.min or "<none>")
    end,
})

minetest.register_chatcommand("area_xp_get_min", {
    params = "<ID>",
    description = "Returns the min-xp value of an area",
    func = function(playername, param)
      if param == nil then
        return true, "Invalid syntax!"
      end

      local id = tonumber(param)
      if not id then
        return true, "area-id is not numeric: " .. param
      end

      if not areas:isAreaOwner(id, playername) and
        not minetest.check_player_privs(playername, { protection_bypas=true }) then
        return true, "you are not the owner of area: " .. id
      end

      local xp_area = xp_areas[id]
      if not xp_area then
        xp_area = {}
      end

			return true, "Area " .. id .. " min-xp value: " .. (xp_area.min or "<none>")
    end,
})
