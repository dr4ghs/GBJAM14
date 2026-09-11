extends Node2D

@export var play_startup_sequence:bool = true
var animation_player:AnimationPlayer 

func _ready():
	animation_player = $Text/AnimationPlayer
	if play_startup_sequence:
		animation_player.play("Startup")
