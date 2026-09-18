class_name PlayerSpawner
extends VisibleOnScreenNotifier2D

signal fire(parent: Node2D)
signal death()

var prefab: PackedScene = preload("res://Scenes/Prefabs/player.tscn")

@export var scene: PlaySceneManager
@export var health_ctrl: HealthBar
@export var gold_ctrl: GoldController

var player: Player

var enable_input: bool

func _ready() -> void:
	death.connect(scene._on_death)

func _process(delta: float) -> void:
	if scene.health <= 0: return;
	
	if scene.state != scene.State.PLAY: return
	
	process_input()
	player.process(delta)

func process_input() -> void:
	if not enable_input: return
	
	if scene.cooldown <= 0 and Input.is_action_just_pressed("action"):
		fire.emit(scene)
		Audio.get_controller().play_side_sfx("shoot")
		scene.cooldown = PlayerStats.cooldown
	
	if Input.is_action_just_pressed("left") and player.lane > 0:
		player.lane -= 1
	
	if Input.is_action_just_pressed("right") and player.lane + 1 < len(Lanes.Values):
		player.lane += 1

func _on_start() -> void:
	player = prefab.instantiate()
	player.position = position
	player.damage_taken.connect(scene._on_damage_taken)
	player.damage_taken.connect(_on_damage_taken)
	player.gold_taken.connect(scene._on_gold_gained)
	player.gold_taken.connect(_on_gold_gained)
	player.setup()
	
	scene.add_child(player)
	
	fire.connect(player._on_fire)
	death.connect(player._on_death)

func _on_play() -> void:
	enable_input = true

func _on_pause() -> void:
	enable_input = false

func _on_damage_taken(_damage: int) -> void:
	Audio.get_controller().play_sfx("damage")

func _on_gold_gained(_gold: int) -> void:
	Audio.get_controller().play_sfx("gold")
