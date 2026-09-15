class_name PlaySceneManager
extends Node2D

enum {
	START,
	PLAY,
	PAUSE,
	GAME_OVER,
};

signal start();
signal play();
signal pause();
signal game_over();

var player_ps: PackedScene = preload("res://Scenes/Prefabs/player.tscn");

@onready var player_spawn: Node2D = $PlayerSpawner;
@onready var health_bar: HealthBar = $HUD/HealthBar;
@onready var golds_label: GoldLabel = $HUD/Golds/Label;
@onready var prompts: Label = $HUD/Control/Prompts;
@onready var hint: Label = $HUD/Control/Hint;
@onready var sfx: SFXStreamPlayer = $Audio/SFX;
@onready var anim: AnimationPlayer = $AnimationPlayer;
@onready var entity_spawn: EntitiesSpawner = $EntitiesSpawner;

var player: Player;

var state: int:
	set(value):
		state = value;
		if state == START:
			start.emit()
		elif  state == PLAY:
			play.emit()
		elif state == PAUSE:
			pause.emit();
		elif state == GAME_OVER:
			game_over.emit()

func _ready() -> void:
	state = START;
	pass;

func _process(_delta: float) -> void:
	if state == GAME_OVER and Input.is_action_just_pressed("action"):
		state = START;
	
	if state == PLAY:
		if Input.is_action_just_pressed("menu"):
			state = PAUSE;
	
	if state == PAUSE: 
		if Input.is_action_just_pressed("menu"):
			state = PLAY;
			pass;
		if Input.is_action_just_pressed("cancel"):
			# TODO return to main screen
			pass;

func _on_start() -> void:
	if not player == null: player.free();
	
	player = player_ps.instantiate();
	player.position = player_spawn.position;
	player.damage_taken.connect(health_bar.on_damage_taken);
	player.damage_taken.connect(sfx._on_damage_taken);
	player.gold_taken.connect(golds_label.on_gold_taken);
	player.gold_taken.connect(sfx._on_gold_taken)
	player.death.connect(_on_death);
	player.setup();
	
	add_child(player);
	health_bar.populate(PlayerStats.curr_health);
	
	entity_spawn.reset();
	anim.play("ready");
	
	pass;

func _on_play() -> void:
	prompts.visible = false;
	hint.visible = false;
	pass;

func _on_pause() -> void:
	prompts.text = "PAUSE";
	hint.text = "PRESS START TO EXIT"
	prompts.visible = true;
	hint.visible = true;
	
	pass;

func _on_game_over() -> void:
	anim.play("game_over");
	pass;

func _on_death() -> void:
	state = GAME_OVER;
