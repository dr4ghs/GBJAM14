class_name SFXStreamPlayer
extends AudioStreamPlayer

@export var coin_sfx: AudioStream = preload("res://Assets/Audio/SFX/gold_gain.wav")
@export var dmg_sfx: AudioStream = preload("res://Assets/Audio/SFX/damage_taken.wav")
@export var ready_sfx: AudioStream = preload("res://Assets/Audio/SFX/play_scene_ready.wav");
@export var plunder_sfx: AudioStream = preload("res://Assets/Audio/SFX/play_scene_plunder.wav");

func _on_gold_taken(_gold: int) -> void:
	stop();
	stream = coin_sfx;
	play();

func _on_damage_taken(_damage: int) -> void:
	stream = dmg_sfx;
	play();
