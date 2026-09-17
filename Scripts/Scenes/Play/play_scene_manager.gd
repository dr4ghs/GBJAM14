class_name PlaySceneManager
extends Node2D

enum State {
	START,
	PLAY,
	PAUSE,
	GAME_OVER,
};

signal start();
signal play();
signal pause();
signal game_over();

@export var camera: PlaySceneCamera
@export var health_bar: HealthBar
@export var gold_ctrl: GoldController
@export var audio_ctrl: AudioController
@export var anim: AnimationPlayer
@export var player_spawn: PlayerSpawner
@export var entity_spawn: EntitiesSpawner

@export var boss: Captains.Values

@export var state: State:
	set(value):
		state = value;
		if state == State.START:
			anim.play("start");
			start.emit()
		elif  state == State.PLAY:
			play.emit()
		elif state == State.PAUSE:
			pause.emit();
		elif state == State.GAME_OVER:
			game_over.emit()

var golds: int
var health: int
var cooldown: float

func _ready() -> void:
	state = State.START;

func _process(delta: float) -> void:
	if cooldown > 0: cooldown -= delta;
	
	if state == State.GAME_OVER and Input.is_action_just_pressed("action"):
		state = State.START;
	
	elif state == State.PAUSE: 
		if Input.is_action_just_pressed("menu"):
			audio_ctrl.resume_bgm()
			state = State.PLAY
		
		if Input.is_action_just_pressed("cancel"):
			# TODO return to main screen
			pass;
	
	elif state == State.PLAY:
		if Input.is_action_just_pressed("menu"):
			audio_ctrl.pause_bgm()
			state = State.PAUSE

func _on_death() -> void:
	state = State.GAME_OVER;

func _on_damage_taken(dmg: int) -> void:
	health -= dmg
	camera.screen_shake()
	health_bar.update(health)
	if health <= 0: player_spawn.death.emit()

func _on_gold_gained(amount: int) -> void:
	golds += amount
	gold_ctrl.gold_lbl.text = str(golds)

func _on_start() -> void:
	health = PlayerStats.health
	cooldown = PlayerStats.cooldown

func _on_game_over() -> void:
	PlayerStats.golds += golds;
