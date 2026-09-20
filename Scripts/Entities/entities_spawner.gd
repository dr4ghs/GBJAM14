class_name EntitiesSpawner
extends Node2D

signal pattern_spawned(count: int)

@export var scene: PlaySceneManager
@export var pattern: SpawnPattern
@export var warns_orchestrator: WarnsOrchestrator
@export var player_spawner: PlayerSpawner

var health_entity: EntityResource = preload("res://Resources/Entities/health_entity.tres")

var entity_scene: PackedScene = preload("res://Scenes/Prefabs/entity.tscn")
var capt_scene: PackedScene = preload("res://Scenes/Prefabs/captain.tscn")

var wait_time: float
var working: bool
var ducks_count: int

var pattern_count: int

var curr_capt: CaptainBehaviour

func _on_play() -> void:
	working = true
	pattern_count = 0
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
		
		var heals: float = PlayerStats.health - scene.health
		if heals > 0 and randf() < (heals * 0.8) / 100:
			var heart: Entity = entity_scene.instantiate()
			heart.populate(health_entity, int(res.distance), 0)
			heart.lane = ((len(Lanes.Values) + res.lane - 2) % len(Lanes.Values)) as Lanes.Values
			add_child(heart)
	
	wait_time = pattern.wait_time
	pattern_count += 1
	pattern_spawned.emit(pattern_count)

func _init() -> void:
	pattern_spawned.connect(ScreenStateMachine._on_pattern_spawned)
	ScreenStateMachine.spawn_captain.connect(_on_spawn_captain)
	ScreenStateMachine.captain_defeated.connect(_on_captain_defeated)

func _process(delta: float) -> void:
	if working:
		if wait_time > 0: wait_time -= delta
		if wait_time <= 0: spawn()
	
	#if working or working and ScreenStateMachine.capt_stage == Captains.Stages.FIGHT:
	for c in get_children():
		if c is Entity: (c as Entity).update(delta)

func _on_hit(entity: Entity) -> void:
	if entity.health.enabled and entity.gold.enabled:
		player_spawner.player.coin.stop();
		player_spawner.player.coin.play("defualt");
		player_spawner.player.gold_taken.emit(entity.gold.value);
	
	if entity.health.enabled and not entity.attack.enabled and not entity.gold.enabled:
		ducks_count += 1

func _on_spawn_captain(capt_res: CaptainResource) -> void:
	for child in get_children():
		child.queue_free()
	
	curr_capt = capt_scene.instantiate()
	curr_capt.res = capt_res
	curr_capt.fire_projectile.connect(_on_captain_fire_projectile)
	curr_capt.speak.connect(scene._on_speak)
	curr_capt.position.x = Lanes.coordinates(Lanes.Values.CENTER)
	curr_capt.position.y = 57
	curr_capt.health = capt_res.health
	add_child(curr_capt)
	working = false

func _on_captain_defeated(_capt: Captains.Stages) -> void:
	working = true
	spawn()

func _on_captain_fire_projectile(res: EntityResource, dist: float, lane: Lanes.Values) -> void:
	var entity: Entity = entity_scene.instantiate()
	entity.populate(res, dist, float(ducks_count) / 10, true)
	entity.hit.connect(_on_hit)
	entity.lane = lane
	add_child(entity)
