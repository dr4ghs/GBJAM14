GameBoy Shader Template for Godot:

This project is released under the [Creative Commons CC0 1.0 Universal License](https://creativecommons.org/publicdomain/zero/1.0/).  
You are free to use, modify, and distribute this template for any purpose without restriction.

GameBoy-style visual template for Godot. 
It’s a simple shader overlay that gives your game a retro GameBoy feel.

It includes:
	-A 4-color palette (default or customizable through scripting and gui)
	-Optional GameBoy startup animation with scrolling text and the classic "da-ding" sound
	-Proper pixel-perfect screen resolution settings

Shader Overview:

The shader overlays your game's visuals and snaps colors to a 4-color palette. 
It’s designed for most pixel art but works best with a recommended palette to prevent 
accidental loss of detail in your sprites.

Recommended RGB palette:
Lightest: #ffffff (White)
Light: #a1a1a1 (Gray)
Dark: #575757 (Dark Gray)
Darkest:  #000000 (Black)

This ensures consistent color replacement and prevents subtle sprite details from disappearing.
The shader uses weighted brightness values to more accurately match how we perceive lightness on modern monitors.

How to Use:
It's plug-and-play, the canvas layer has both the shader adn the startup animation under it.

To configure your palette:
	GameBoy Shader (under Canvas Layer) → Material → Shader Parameters
	These values are customisable through script as well, so you can do mid-game pallette swaps

To configure your background colour: 
	Set the camera’s default clear colour in: Project Settings → Rendering → Environemnt to any of the four reccomended RGB palette colors (lightest, light, dark, darkest).

To configure the startup animation:
	toggle on/off the startup animation via the GameBoy Startup Animation node under the Canvas Layer, also edit the text in the text node.


MAKE SURE:
	You turn the canvas layer invisible when you want to do any work in the 2d environment so your not dragging the shader everywhere.
	You turn it back on for builds!!
	The Gameboy Shader is in all of your scenes!
	The Startup Animation Shader is in only your starting scene or is toggled off in all other scenes so you dont get the logo everytime you switch scenes!
	You have fun!!!

Please let me know of any bugs or feature suggestions on the GBJam server, I'm crabbethefirst
