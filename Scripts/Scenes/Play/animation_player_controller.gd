class_name AnimationPlayerController
extends AnimationPlayer

func _on_start() -> void:
	play("start");

func _on_game_over() -> void:
	play("game_over")
