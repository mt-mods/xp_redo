

local webhook_url = minetest.settings:get("xp_redo.discord.webhook_url")
local texture_baseurl = minetest.settings:get("xp_redo.discord.texture_baseurl")

-- discord webhook
return function(http)

  if not webhook_url then
    minetest.log("error", "xp_redo webhook_url not set!")
    return
  end

  xp_redo.register_hook({
    rank_change = function(playername, xp, rank)

      if not playername or not rank or not rank.name or not xp then
        return
      end

      local data = {
        content = "Player __" .. playername .. "__ leveled up to **" ..
          rank.name .. "** with an xp of " .. xp_redo.format_thousand(xp) .. "!"
      }

      if texture_baseurl and rank.icon then
        data.avatar_url = texture_baseurl .. rank.icon
      end

      local json = minetest.write_json(data)

      -- new rank
      http.fetch({
        url = webhook_url,
        extra_headers = { "Content-Type: application/json" },
        timeout = 5,
        post_data = json
      }, function()
        -- ignore error
      end)

    end
  })
end
