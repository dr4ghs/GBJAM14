class_name PlayerSpawner
extends VisibleOnScreenNotifier2D

var prefab: PackedScene = preload("res://Scenes/Prefabs/player.tscn");

@export var scene: PlaySceneManager;
@export var audio_ctrl: AudioController;
@export var health_ctrl: HealthBar;
@export var gold_ctrl: GoldController;

var player: Player;

func _on_start() -> void:
	player = prefab.instantiate();
	player.position = position;
	player.cannon_ball_parent = scene;
	player.damage_taken.connect(health_ctrl._on_damage_taken);
	player.damage_taken.connect(_on_damage_taken);
	player.gold_taken.connect(gold_ctrl._on_gold_gained);
	player.gold_taken.connect(_on_gold_gained)
	player.death.connect(scene._on_death);
	player.setup();
	
	scene.add_child(player);

func _on_play() -> void:
	player.enable_input = true;

func _on_pause() -> void:
	player.enable_input = false;

func _on_damage_taken(_damage: int) -> void:
	audio_ctrl.play_sfx("damage");

func _on_gold_gained(_gold: int) -> void:
	audio_ctrl.play_sfx("gold");
