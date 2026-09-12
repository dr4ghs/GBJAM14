class_name Background
extends Node2D

@onready var player: Player = %Ship;
@onready var anim_player: AnimationPlayer = $AnimationPlayer;

func _process(delta: float) -> void:
	anim_player.speed_scale = 1 + (player.gold / 500)
