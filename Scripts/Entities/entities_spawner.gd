class_name EntitiesSpawner
extends Node2D

@export var pattern: SpawnPattern
@export var warns_orchestrator: WarnsOrchestrator
@export var audio_ctrl: AudioController

var entity_scene: PackedScene = preload("res://Scenes/Prefabs/entity.tscn")

var wait_time: float

var working: bool

func _on_play() -> void:
	working = true
	spawn()

func _on_start() -> void:
	working = false
	for child in get_children():
		child.queue_free()

func start() -> void:
	pass

func _on_pause() -> void:
	working = false

func _on_game_over() -> void:
	working = false

func spawn() -> void:
	var lane: float = pattern.lane_shift
	if pattern.random_lane:
		lane = randi() % len(Lanes.Values)
	for res in pattern.entities:
		var entity: Entity = entity_scene.instantiate()
		entity.populate(res.entity, int(res.distance), enemy_hurted)
		entity.lane = int(res.lane + lane) % len(Lanes.Values)
		add_child(entity)
		
	wait_time = pattern.wait_time

func _process(delta: float) -> void:
	if not working: return
	
	if wait_time > 0:
		wait_time -= delta * PlayerStats.speed
	if wait_time <= 0: spawn()
	
	for c in get_children():
		if c is Entity: (c as Entity).update(delta)

func enemy_hurted() -> void:
	audio_ctrl.play_side_sfx("damage")
