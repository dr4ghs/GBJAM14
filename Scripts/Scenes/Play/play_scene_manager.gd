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

@export var player_spawn: Node2D;
@export var health_bar: HealthBar;
@export var audio_ctrl: AudioController;
@export var anim: AnimationPlayer;
@export var entity_spawn: EntitiesSpawner;

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

func _ready() -> void:
	state = State.START;
	pass;

func _process(_delta: float) -> void:
	if state == State.GAME_OVER and Input.is_action_just_pressed("action"):
		state = State.START;
	
	if state == State.PLAY:
		if Input.is_action_just_pressed("menu"):
			state = State.PAUSE;
	
	if state == State.PAUSE: 
		if Input.is_action_just_pressed("menu"):
			state = State.PLAY;
			pass;
		if Input.is_action_just_pressed("cancel"):
			# TODO return to main screen
			pass;

func _on_death() -> void:
	state = State.GAME_OVER;
