Minetest XP mod (xp_redo)
======

Minetest mod for player experience management (xp)
It adds an xp counter per player and ranks according to your xp level.
The xp level, your rank and a progress bar to the next rank will show up in your hud.
There is also a xpgate block which, when placed under a wooden door will only allow players with a certain xp level to go through.

# Install

* Unzip/Clone it to your worldmods folder

# Privileges

* givexp: Manage xp of your users

# Commands

Add or remove (amount with negative sign) xp from a user:
* /givexp (username) (amount)

Example:

Give player somedude 200 xp points:
* /givexp somedude 200

Remove 100 xp points from player somedude:
* /givexp somedude -100

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

# Screenshot

# Ranks

Some initial ranks are hardcoded in ranks.lua

# Lua api

## Ranks

### xp_redo.register_rank(rankDef)

rankDef = {
	name = "Rank name",
	icon = "myicon.png" -- Should fit withing the background icon (16x32px)
	color = {r=255, g=255, b=255}, -- Player name tag color
	xp = 100 -- xp threshold
}


ranks are held in xp_redo.ranks as a table

### xp_redo.get_rank(xpAmount)

Returns the rankDef for given xp amount

## XP

### xp_redo.get_xp(playername)

Returns the xp level for given playername (always a number)

### xp_redo.add_xp(playername, xp)

Adds the amount of xp to given playername (can be negative for xp removal)

# Pull requests / bugs

I'm happy for any bug reports or pull requests (code and textures)

