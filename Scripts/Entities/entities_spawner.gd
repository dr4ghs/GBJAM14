class_name EntitiesSpawner
extends Node2D

@export var pattern: SpawnPattern
@export var warns_orchestrator: WarnsOrchestrator
@export var player_spawner: PlayerSpawner

var entity_scene: PackedScene = preload("res://Scenes/Prefabs/entity.tscn")

var wait_time: float
var working: bool
var ducks_count: int

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
		entity.populate(res.entity, int(res.distance), float(ducks_count) / 10)
		entity.hit.connect(_on_hit)
		entity.lane = int(res.lane + lane) % len(Lanes.Values) as Lanes.Values
		add_child(entity)
		
	wait_time = pattern.wait_time

func _process(delta: float) -> void:
	if not working: return
	
	if wait_time > 0: wait_time -= delta
	if wait_time <= 0: spawn()
	
	for c in get_children():
		if c is Entity: (c as Entity).update(delta)

func _on_hit(entity: Entity) -> void:
	if entity.health.enabled and entity.gold.enabled:
		player_spawner.player.coin.stop();
		player_spawner.player.coin.play("defualt");
		player_spawner.player.gold_taken.emit(entity.gold.value);
	
	if entity.health.enabled and not entity.attack.enabled and not entity.gold.enabled:
		ducks_count += 1
		print("DUCKS COUNT: %" % ducks_count)
