Minetest XP mod (xp_redo)
======

Minetest mod for player experience management (xp)
It adds an xp counter per player and ranks according to your xp level.
The xp level, your rank and a progress bar to the next rank will show up in your hud.
On every rank level up you get a award-like notification.
There is also a xpgate block which, when placed under a wooden door will only allow players with a certain xp level to go through.

* Forum-Topic: [https://forum.minetest.net/viewtopic.php?f=9&t=20124](https://forum.minetest.net/viewtopic.php?f=9&t=20124)
* With some ideas from: [https://forum.minetest.net/viewtopic.php?id=3291](https://forum.minetest.net/viewtopic.php?id=3291)

# Install

* Unzip/Clone it to your worldmods folder

# Privileges

* **givexp**: Manage xp of your users

# Commands

Add or remove (amount with negative sign) xp from a user:
```
/givexp (username) (amount)
```

Example:

Give player somedude 200 xp points:
```
/givexp somedude 200
```

Remove 100 xp points from player somedude:
```
/givexp somedude -100
```

# Depends

* default
* doors?
* mobs_redo?
* mobs_animal?
* mobs_monster?

# Builtin xp events

## Digging

Every node dig gives you 1 xp point

## Punching

Every mob punch gives you the amount of damage on the mob in xp

# Screenshots

## Hud in action
![](screenshots/Minetest_2018-05-17-09-17-16.png?raw=true)
Note: **Android screenshot, ignore wrong spacing**

## XP Gate block (configuring)
![](screenshots/Minetest_2018-05-17-09-25-48.png?raw=true)

## XP Gate block (blocking)
![](screenshots/Minetest_2018-05-17-09-25-53.png?raw=true)
Note: **It will teleport you through if you have enough xp and try to open it**

## Player nametags (with rank-colors)
![](screenshots/Minetest_2018-05-17-09-35-30.png?raw=true)
![](screenshots/Minetest_2018-05-17-09-36-11.png?raw=true)


# Ranks

Some initial ranks are hardcoded in **ranks.lua**
(Swiss military ranks, but translated to english.... sorry :)

* Recruit (xp: 0) ![](textures/xp_rank_1_recruit.png?raw=true)
* Soldier (xp: 10) ![](textures/xp_rank_2_soldier.png?raw=true)
* Appointee (xp: 100) ![](textures/xp_rank_3_appointee.png?raw=true)
* Private (xp: 1000) ![](textures/xp_rank_4_private.png?raw=true)
* Corporal (xp: 10000) ![](textures/xp_rank_5_corporal.png?raw=true)
* Seargant (xp: 100000) ![](textures/xp_rank_6_seargant.png?raw=true)

# Lua api

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


ranks are held in **xp_redo.ranks** as a table

### xp_redo.get_rank(xpAmount)

Returns the rankDef for given xp amount

## XP

### xp_redo.get_xp(playername)

Returns the xp level for given playername (always a number)

### xp_redo.add_xp(playername, xp)

Adds the amount of xp to given playername (can be negative for xp removal)

# License

See LICENSE.txt

* Trophy model/texture source: https://gitlab.com/VanessaE/homedecor_modpack/

# Pull requests / bugs

I'm happy for any bug reports or pull requests (code and textures)

# TODO / Ideas

* Scoreboard (block)
* More doors
* Door-teleport alternative
* XP Regions
* XP entities/items

