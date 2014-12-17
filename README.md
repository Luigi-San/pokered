# Pokémon Red and Blue - Enhancement Patches

This is a fork of the Pokémon Red and Blue disassembly which adds some optional
enhancement patches.

Current enhancements available:

* Increase walking speed (always, or only while holding B)
* Disable low health alarm, or make it beep only a few times and then stop
* Improvements to battle screen (more info about selected move, show "caught"
  indicator, etc)
* Debugging functions (debug menu, walk through walls, no random battles)
* Skip intro

Planned enhancements:

* Remove/reduce text delay
* Various menu improvements and bug fixes
* Who knows?

These patches can be toggled on/off by editing `hacks.asm`. With all patches
disabled, the ROM builds identical to the original.

Original readme follows...


# Pokémon Red and Blue

This is a disassembly of Pokémon Red and Blue.

It builds the following roms:

* Pokemon Red (UE) [S][!].gb  `md5: 3d45c1ee9abd5738df46d2bdda8b57dc`
* Pokemon Blue (UE) [S][!].gb `md5: 50927e843568814f7ed45ec4f944bd8b`

To set up the repository, see [**INSTALL.md**](INSTALL.md).


## See also

* Disassembly of [**Pokémon Crystal**][pokecrystal]
* irc: **irc.freenode.net** [**#pret**][irc]

[pokecrystal]: https://github.com/kanzure/pokecrystal
[irc]: https://kiwiirc.com/client/irc.freenode.net/?#pret
