# Minetest XP mod (xp_redo)

[![luacheck](https://github.com/mt-mods/xp_redo/actions/workflows/luacheck.yml/badge.svg)](https://github.com/mt-mods/xp_redo/actions/)

Minetest mod for player experience management (xp)
It adds an xp counter per player and ranks according to your xp level.
The xp level, your rank and a progress bar to the next rank will show up in your hud.
On every rank level up you get a award-like notification.
There is also a xpgate block which, when placed under a wooden door will only allow players with a certain xp level to go through.

* Forum-Topic: <https://forum.minetest.net/viewtopic.php?f=9&t=20124>
* With some ideas from: <https://forum.minetest.net/viewtopic.php?id=3291>

## Installation

- Unzip the archive, rename the folder to `xp_redo` and
place it in `.. minetest/mods/`

- GNU/Linux: If you use a system-wide installation place
    it in `~/.minetest/mods/`.

- If you only want this to be used in a single world, place
    the folder in `.. worldmods/` in your world directory.

For further information or help, see:  
https://wiki.minetest.net/Installing_Mods

## Privileges

- **givexp**: Manage XP of your users.

## Commands

Add or remove (amount with negative sign) XP from a user:

```plaintext
/givexp (username) (amount)
```

Examples:\
Give player somedude 200 XP points.

```plaintext
/givexp somedude 200
```

Remove 100 XP points from player somedude.

```plaintext
/givexp somedude -100
```

## Dependencies

- `default` (included in [Minetest Game](https://github.com/minetest/minetest_game))

### Optional dependencies

- [`areas`](https://github.com/minetest-mods/areas)
- [`qos`](https://github.com/S-S-X/qos)
- [`protector`](https://notabug.org/TenPlus1/protector)
- `doors` (included in [Minetest Game](https://github.com/minetest/minetest_game))
- [`mobs_redo`](https://notabug.org/TenPlus1/mobs_redo)
- [`mobs_animal`](https://notabug.org/TenPlus1/mobs_animal)
- [`mobs_monster`](https://notabug.org/TenPlus1/mobs_monster)
- [`mesecons_mvps`](https://github.com/minetest-mods/mesecons/tree/HEAD/mesecons_mvps)
- [`hudbars`](https://codeberg.org/Wuzzy/minetest_hudbars)
- `screwdriver` (included in [Minetest Game](https://github.com/minetest/minetest_game))
- [`woodcutting`](https://github.com/minetest-mods/woodcutting)

# Areas integration

There are additional commands available if the `areas` mod is available:

* `/area_xp_set_min <id> <xp>` assign a min-value that a aplayer needs to interact with the area
* `/area_xp_get_min <id>` returns the min-value, if any for that area

For this to work the area has to be opened with `/area_open <id>`

# Builtin XP events

## Digging

Every node dig gives you 1 xp point

## Punching

Every mob punch gives you the amount of damage on the mob in xp

## Ranks

See:

- <https://github.com/mt-mods/xp_redo_ranks_ores>

## Settings

* **xp_redo.discord.webhook_url** Discord webhook URL (optional)
* **xp_redo.discord.texture_baseurl** Base URL for the webhook avatar image (optional)

For the webhook, the mod has to be in the `secure.http_mods` setting (in `minetest.conf`):

```conf
secure.http_mods = xp_redo
```

## Lua api

## Ranks

### `xp_redo.register_rank(rankDef)`

```lua
rankDef = {
	name = "Rank name",
	icon = "myicon.png" -- Should fit withing the background icon (16x32px)
	color = {r=255, g=255, b=255}, -- Player name tag color
	xp = 100 -- xp threshold
}
```

Ranks are held in `xp_redo.ranks` as a table.

### `xp_redo.get_rank(xpAmount)`

Returns the rankDef for given xp amount

### Hooks

```lua
xp_redo.register_hook({
  xp_change = function(playername, xp)
    -- new xp value
  end,

  rank_change = function(playername, xp, rank)
    -- new rank
  end,

  stat_change = function(playername, name, value)
    -- see stats.lua
  end
})
```

## XP

### `xp_redo.get_xp(playername)`

Returns the XP level for given playername (always a number).

### `xp_redo.add_xp(playername, xp)`

Adds the amount of xp to given playername (can be negative for xp removal).

# License

See LICENSE.txt

- Trophy model/texture source: <https://gitlab.com/VanessaE/homedecor_modpack/>
- [`xp_mese_crystal.png`](https://github.com/minetest/minetest_game/blob/HEAD/mods/default/textures/default_mese_crystal.png)

# Pull requests / bugs

I'm happy for any bug reports or pull requests (code and textures).

# TODO / Ideas

* Scoreboard (block)
* More doors
* Door-teleport alternative
* XP Regions
* XP entities/items
