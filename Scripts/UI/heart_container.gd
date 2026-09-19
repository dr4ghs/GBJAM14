class_name HeartContainer extends Node2D

@onready var gfx: Sprite2D = $Graphics

var full: bool:
	set(value):
		if value: gfx.region_rect.position.x = 0;
		else: gfx.region_rect.position.x = 16;
