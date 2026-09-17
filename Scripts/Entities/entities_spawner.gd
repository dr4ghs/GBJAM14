class_name EntitiesSpawner
extends Node

@export var pattern: SpawnPattern;
@export var audio_ctrl: AudioController;

var entity_scene: PackedScene = preload("res://Scenes/Prefabs/entity.tscn");

var wait_time: float;

var working: bool;

func _on_play() -> void:
	working = true;

func _on_start() -> void:
	working = false;
	for child in get_children():
		child.queue_free();
	
	spawn();

func _on_pause() -> void:
	working = false;

func _on_game_over() -> void:
	working = false;

func spawn() -> void:
	var lane: float = 0;
	if pattern.random_lane:
		lane = SpawnPoints.lanes[randi() % 5];
	for res in pattern.entities:
		var entity: Entity = entity_scene.instantiate();
		add_child(entity);
		entity.populate(res.entity, int(res.distance));
		entity.hurted.connect(enemy_hurted);
		if pattern.random_lane:
			entity.position.x = lane;
		else:
			entity.position.x = SpawnPoints.lanes[res.lane + pattern.lane_shift];
		
	wait_time = pattern.wait_time;

func _process(delta: float) -> void:
	if not working: return;
	
	if wait_time > 0:
		wait_time -= delta * PlayerStats.speed;
	if wait_time <= 0: spawn();
	
	for c in get_children():
		if c is Entity: (c as Entity).update(delta)

func enemy_hurted() -> void:
	audio_ctrl.play_side_sfx("damage");
