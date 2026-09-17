class_name PlaySceneCamera
extends Camera2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer;

func screen_shake() -> void:
	anim_player.play("shake")
