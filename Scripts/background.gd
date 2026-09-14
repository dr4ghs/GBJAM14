class_name Background
extends Node2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer;

func _process(delta: float) -> void:
	anim_player.speed_scale = PlayerStats.speed
