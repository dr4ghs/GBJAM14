class_name Background
extends Node2D

@onready var manager: GameStateManager = %GameState;
@onready var anim_player: AnimationPlayer = $AnimationPlayer;

func _process(delta: float) -> void:
	anim_player.speed_scale = 1 + (manager.player._gold / 500)
