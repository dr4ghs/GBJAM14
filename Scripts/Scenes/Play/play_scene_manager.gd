class_name PlaySceneManager
extends Node2D

enum {
	START,
	PLAY,
	GAME_OVER,
};

signal start();
signal play();
signal game_over();

var player_ps: PackedScene = preload("res://Scenes/Prefabs/player.tscn");

@onready var player_spawn: Node2D = $PlayerSpawner;
@onready var health_bar: HealthBar = $HUD/HealthBar;
@onready var golds_label: GoldLabel = $HUD/Golds/Label;

var player: Player;

var state: int:
	set(value):
		state = value;
		if state == START:
			start.emit()
		elif  state == PLAY:
			play.emit()
		elif state == GAME_OVER:
			game_over.emit()

func _ready() -> void:
	state = START;
	pass;

func _on_start() -> void:
	player = player_ps.instantiate();
	player.position = player_spawn.position;
	player.damage_taken.connect(health_bar.on_damage_taken);
	player.gold_taken.connect(golds_label.on_gold_taken);
	player.setup();
	
	add_child(player);
	health_bar.populate(PlayerStats.curr_health);
	
	pass;

func _on_play() -> void:
	pass;

func _on_game_over() -> void:
	pass;
