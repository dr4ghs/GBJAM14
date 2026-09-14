class_name EntitiesSpawner
extends Node

@export var pattern: Array[SpawnPattern];

var entity_scene = preload("res://Scenes/Prefabs/entity.tscn");

var wait_time: float;
var curr_pattern: int;

func spawn() -> void:
	if curr_pattern >= len(pattern): return;
	
	for res in pattern[curr_pattern].entities:
		var entity: Entity = entity_scene.instantiate();
		add_child(entity);
		entity.populate(res.entity, res.distance);
		entity.position.x = SpawnPoints.lanes[res.lane + pattern[curr_pattern].lane_shift];
	wait_time = pattern[curr_pattern].wait_time;
	curr_pattern += 1;

func _ready() -> void:
	spawn();

func _process(delta: float) -> void:
	if wait_time > 0:
		wait_time -= delta * PlayerStats.speed;
	if wait_time <= 0: spawn();
