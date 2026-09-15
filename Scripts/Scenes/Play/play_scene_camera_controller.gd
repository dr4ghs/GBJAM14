extends Camera2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer;

func screen_shake(_damage: int) -> void:
	anim_player.play("shake")
