extends AudioStreamPlayer

@export var coin_sfx: AudioStream = preload("res://Assets/Audio/SFX/gold_gain.wav")
@export var dmg_sfx: AudioStream = preload("res://Assets/Audio/SFX/damage_taken.wav")

func on_gold_gained(_gold: int) -> void:
	stop();
	stream = coin_sfx;
	play();

func on_damage_taken(_damage: int) -> void:
	stream = dmg_sfx;
	play();
