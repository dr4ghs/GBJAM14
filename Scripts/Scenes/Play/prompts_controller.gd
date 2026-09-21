class_name PromptsController
extends Control

@export var anim_player: AnimationPlayer;

@export var main_lbl: Label;
@export var hint_lbl: Label;

func _on_start() -> void:
	visible = true
	hint_lbl.visible = false
	anim_player.play("start")

func _on_play() -> void:
	visible = false
	hint_lbl.visible = false

func _on_pause() -> void:
	main_lbl.text = "PAUSE"
	hint_lbl.text = "B - EXIT"
	visible = true
	hint_lbl.visible = true

func _on_game_over() -> void:
	if ScreenStateMachine.state == ScreenStateMachine.States.END: return
	
	main_lbl.text = "GAME OVER"
	hint_lbl.text = "A - RESTART"
	visible = true;
	hint_lbl.visible = true
