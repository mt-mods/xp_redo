## Minetest XP mod (xp_redo)

Minetest mod for player experience management (xp)
It adds an xp counter per player and ranks according to your xp level.
The xp level, your rank and a progress bar to the next rank will show up in your hud.
On every rank level up you get a award-like notification.
There is also a xpgate block which, when placed under a wooden door will only allow players with a certain xp level to go through.

* Forum-Topic: [https://forum.minetest.net/viewtopic.php?f=9&t=20124](https://forum.minetest.net/viewtopic.php?f=9&t=20124)
* With some ideas from: [https://forum.minetest.net/viewtopic.php?id=3291](https://forum.minetest.net/viewtopic.php?id=3291)

## Installation

- Unzip the archive, rename the folder to xp_redo and
place it in ..minetest/mods/

- GNU/Linux: If you use a system-wide installation place
    it in ~/.minetest/mods/.

- If you only want this to be used in a single world, place
    the folder in ..worldmods/ in your world directory.

For further information or help, see:  
https://wiki.minetest.net/Installing_Mods

## Privileges

* **givexp**: Manage XP of your users.

## Commands

Add or remove (amount with negative sign) XP from a user:
```
/givexp (username) (amount)
```

Example:

Give player somedude 200 XP points:
```
/givexp somedude 200
```

Remove 100 XP points from player somedude:
```
/givexp somedude -100
```

## Dependencies

- default
### Optional dependencies

- doors
- mobs_redo
- mobs_animal
- mobs_monster

## Builtin XP events

## Digging

Every node dig gives you 1 xp point

## Punching

Every mob punch gives you the amount of damage on the mob in xp

## Ranks

See:
* https://github.com/thomasrudin-mt/xp_redo_ranks_ores

## Lua api

## Ranks

### xp_redo.register_rank(rankDef)

```lua
rankDef = {
	name = "Rank name",
	icon = "myicon.png" -- Should fit withing the background icon (16x32px)
	color = {r=255, g=255, b=255}, -- Player name tag color
	xp = 100 -- xp threshold
}
```


ranks are held in **xp_redo.ranks** as a table.

### xp_redo.get_rank(xpAmount)

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

### xp_redo.get_xp(playername)

Returns the xp level for given playername (always a number).

### xp_redo.add_xp(playername, xp)

Adds the amount of xp to given playername (can be negative for xp removal).

# License

See LICENSE.txt

* Trophy model/texture source: https://gitlab.com/VanessaE/homedecor_modpack/

* xp_mese_crystal.png
* https://github.com/minetest/minetest_game mods/default/textures/default_mese_crystal.png


# Pull requests / bugs

I'm happy for any bug reports or pull requests (code and textures).

# TODO / Ideas

* Scoreboard (block)
* More doors
* Door-teleport alternative
* XP Regions
* XP entities/items
