class_name AudioController
extends Node

@export var bgm: AudioStreamPlayer
@export var side_bgm: AudioStreamPlayer
@export var sfx: AudioStreamPlayer
@export var side_sfx: AudioStreamPlayer

@export var background_music: Dictionary[String, AudioStream];
@export var sound_effects: Dictionary[String, AudioStream];

func get_controller() -> AudioController:
	return $"." as AudioController

func play_bgm(bgm_name: String) -> void:
	if not background_music.has(bgm_name): return
	
	bgm.stream = background_music[bgm_name]
	bgm.play()

func pause_bgm() -> void:
	bgm.stream_paused = true

func resume_bgm() -> void:
	bgm.stream_paused = false

func stop_bgm() -> void:
	bgm.stop()

func play_side_bgm(bgm_name: String) -> void:
	if not background_music.has(bgm_name): return
	
	side_bgm.stream = background_music[bgm_name]
	side_bgm.play()

func pause_side_bgm() -> void:
	side_bgm.stream_paused = true

func resume_side_bgm() -> void:
	side_bgm.stream_paused = false

func stop_side_bgm() -> void:
	side_bgm.stop()

func play_sfx(sfx_name: String, volume: float = 1.0) -> void:
	if not sound_effects.has(sfx_name): return
	
	sfx.volume_db = volume
	sfx.stream = sound_effects[sfx_name]
	sfx.play()

func play_side_sfx(sfx_name: String, volume: float = 0.0) -> void:
	if not sound_effects.has(sfx_name): return
	
	side_sfx.volume_db = volume
	side_sfx.stream = sound_effects[sfx_name]
	side_sfx.play()
