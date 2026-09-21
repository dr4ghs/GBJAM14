class_name PlayerSpawner
extends VisibleOnScreenNotifier2D

signal fire(parent: Node2D)
signal reloaded()
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
	if player.malus:
		scene.cooldown = PlayerStats.cooldown + 1
		player.malus = false
	
	if ScreenStateMachine.halt_input: return
	if not enable_input: return
	
	if scene.cooldown <= 0:
		reloaded.emit()
		if Input.is_action_just_pressed("action"):
			fire.emit(scene)
			Audio.get_controller().play_side_sfx("damage")
			scene.cooldown = PlayerStats.cooldown
	
	if Input.is_action_just_pressed("left") and player.lane > 0:
		player.lane = (player.lane - 1) as Lanes.Values
	
	if Input.is_action_just_pressed("right") and player.lane + 1 < len(Lanes.Values):
		player.lane = (player.lane + 1) as Lanes.Values

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
	reloaded.connect(player._on_realoaded)
	death.connect(player._on_death)

func _on_play() -> void:
	enable_input = true

func _on_pause() -> void:
	enable_input = false

func _on_damage_taken(dmg: int) -> void:
	var sfx_name: String = "damage"
	if dmg == -1: sfx_name = "heals"
	
	Audio.get_controller().play_sfx(sfx_name)

func _on_gold_gained(_gold: int) -> void:
	Audio.get_controller().play_sfx("gold")

func remove_player() -> void:
	if player != null:
		player.queue_free()
