extends Node2D

@export var sprite: AnimatedSprite2D

var play_scene: PackedScene = preload("res://Scenes/play_scene.tscn")

var played: bool

func _process(_delta: float) -> void:
	if not played and sprite.frame == 26:
		Audio.get_controller().play_sfx("gold")
		played = true

func _on_anim_end() -> void:
	get_tree().root.add_child(play_scene.instantiate())
	queue_free()
