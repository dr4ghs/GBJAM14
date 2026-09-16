class_name PromptsController
extends Control

@export var anim_player: AnimationPlayer;

@export var main_lbl: Label;
@export var hint_lbl: Label;

func _on_start() -> void:
	main_lbl.visible = true;
	hint_lbl.visible = false;
	anim_player.play("start")

func _on_play() -> void:
	main_lbl.visible = false;
	hint_lbl.visible = false;

func _on_pause() -> void:
	main_lbl.text = "PAUSE"
	hint_lbl.text = "B TO EXIT"
	main_lbl.visible = true;
	hint_lbl.visible = true;

func _on_game_over() -> void:
	main_lbl.text = "GAME OVER"
	hint_lbl.text = "A TO RESTART"
	main_lbl.visible = true;
	hint_lbl.visible = true;
