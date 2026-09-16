class_name AudioController
extends Node2D

@onready var bgm: AudioStreamPlayer = $BGM;
@onready var sfx: AudioStreamPlayer = $SFX;

@export var default_bgm: AudioStream;

@export var sound_effects: Dictionary[String, AudioStream];

func play_bgm(audio: AudioStream = default_bgm) -> void:
	bgm.stream = audio;
	bgm.play();

func pause_bgm() -> void:
	bgm.stream_pause = true;

func resume_bgm() -> void:
	bgm.stream_paused = false;

func stop_bgm() -> void:
	bgm.stop();

func play_sfx(sfx_name: String):
	if sound_effects.has(sfx_name):
		sfx.stream = sound_effects[sfx_name];
		sfx.play()
