
for _,entity in pairs(minetest.registered_entities) do
	if entity.on_punch ~= nil and entity.hp_min ~= nil and entity.hp_min > 0 then

		local originalPunch = entity.on_punch
		print(entity.name)

		entity.on_punch = function(self, hitter,time_from_last_punch, tool_capabilities, direction)

			if tool_capabilities.damage_groups ~= nil and
			   tool_capabilities.damage_groups.fleshy ~= nil and
			   self.health ~= nil then
				local rest = tool_capabilities.damage_groups.fleshy

				if hitter:is_player() then
					xp_redo.add_xp(hitter:get_player_name(), rest)
				end
			end

			-- print(tool_capabilities.damage_groups.fleshy)
			-- print(self.health)

			return originalPunch(self, hitter, time_from_last_punch, tool_capabilities, direction)
		end
		
	end
end