
local increment_punch_count = function(player)
	if player == nil or player.get_attribute == nil then
		-- fake player
		return
	end

	local count = player:get_attribute("punch_count")
	if not count then
		count = 0
	end

	player:set_attribute("punch_count", count + 1)
end

local increase_inflicted_damage = function(player, value)
	if player == nil or player.get_attribute == nil then
		-- fake player
		return
	end

	local count = player:get_attribute("inflicted_damage")
	if not count then
		count = 0
	end

	player:set_attribute("inflicted_damage", count + value)
end


for _,entity in pairs(minetest.registered_entities) do
	if entity.on_punch ~= nil and entity.hp_min ~= nil and entity.hp_min > 0 then

		local originalPunch = entity.on_punch

		entity.on_punch = function(self, hitter,time_from_last_punch, tool_capabilities, direction)

			if tool_capabilities.damage_groups ~= nil and
			   tool_capabilities.damage_groups.fleshy ~= nil and
			   self.health ~= nil then
				local rest = tool_capabilities.damage_groups.fleshy

				if hitter:is_player() then
					-- xp_redo.add_xp(hitter:get_player_name(), rest * 2)
					xp_redo.add_xp(hitter:get_player_name(), 1)
					increase_inflicted_damage(hitter, rest * 2)
					increment_punch_count(hitter)
				end
			end

			-- print(tool_capabilities.damage_groups.fleshy)
			-- print(self.health)

			return originalPunch(self, hitter, time_from_last_punch, tool_capabilities, direction)
		end
	end
end
