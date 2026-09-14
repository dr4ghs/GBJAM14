class_name EntitiesSpawner
extends Node

@export var pattern: SpawnPattern;

var entity_scene: PackedScene = preload("res://Scenes/Prefabs/entity.tscn");

var wait_time: float;

func spawn() -> void:
	var lane: float = 0;
	if pattern.random_lane:
		lane = SpawnPoints.lanes[randi() % 5];
	for res in pattern.entities:
		var entity: Entity = entity_scene.instantiate();
		add_child(entity);
		entity.populate(res.entity, int(res.distance));
		if pattern.random_lane:
			entity.position.x = lane;
		else:
			entity.position.x = SpawnPoints.lanes[res.lane + pattern.lane_shift];
		
	wait_time = pattern.wait_time;

func _ready() -> void:
	spawn();

func _process(delta: float) -> void:
	if wait_time > 0:
		wait_time -= delta * PlayerStats.speed;
	if wait_time <= 0: spawn();
