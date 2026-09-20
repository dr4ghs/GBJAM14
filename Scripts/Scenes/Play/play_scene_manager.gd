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

@onready var title_screen: PackedScene = preload("res://Scenes/title_screen.tscn")
@onready var dialogue_box: PackedScene = preload("res://Scenes/Prefabs/chat_box.tscn")

@export var hud: Control

@export var camera: PlaySceneCamera
@export var health_bar: HealthBar
@export var gold_ctrl: GoldController
@export var overlay: PromptsController
@export var anim: AnimationPlayer
@export var player_spawn: PlayerSpawner
@export var entity_spawn: EntitiesSpawner

@export var boss: Captains.Values

@export var state: State:
	set(value):
		state = value;
		if state == State.START:
			Audio.get_controller().play_bgm("main_theme")
			anim.play("start");
			start.emit()
		elif  state == State.PLAY:
			play.emit()
		elif state == State.PAUSE:
			pause.emit();
		elif state == State.GAME_OVER:
			game_over.emit()

var chat_box: ChatBox

var golds: int
var health: int
var cooldown: float

func _init() -> void:
	ScreenStateMachine.captain_defeated.connect(_on_captain_defeated)

func _ready() -> void:
	ScreenStateMachine.connect_signal(ScreenStateMachine.States.TITLE, _on_title_screen_state)
	ScreenStateMachine.connect_signal(ScreenStateMachine.States.PLAY, _on_play_screen_state)
	
	Audio.get_controller().play_side_bgm("waves")
	
	ScreenStateMachine.state = ScreenStateMachine.States.TITLE

func _process(delta: float) -> void:
	if ScreenStateMachine.state != ScreenStateMachine.States.PLAY: return
	
	if cooldown > 0: cooldown -= delta;
	
	if state == State.GAME_OVER and Input.is_action_just_pressed("action"):
		state = State.START;
	
	elif state == State.PAUSE: 
		if Input.is_action_just_pressed("menu"):
			Audio.get_controller().resume_bgm()
			state = State.PLAY
		
		if Input.is_action_just_pressed("cancel"):
			ScreenStateMachine.state = ScreenStateMachine.States.TITLE
	
	elif state == State.PLAY:
		if Input.is_action_just_pressed("menu"):
			Audio.get_controller().pause_bgm()
			state = State.PAUSE

func _on_death() -> void:
	if ScreenStateMachine.capt_stage == Captains.Stages.FIGHT:
		ScreenStateMachine.capt_stage = Captains.Stages.LOSE
	else:
		state = State.GAME_OVER;

func _on_damage_taken(dmg: int) -> void:
	if dmg > 0:
		health -= dmg
		camera.screen_shake()
		health_bar.update(health)
		if health <= 0: player_spawn.death.emit()
	elif health < PlayerStats.health:
		health -= dmg
		health_bar.update(health)

func _on_gold_gained(amount: int) -> void:
	golds += amount
	gold_ctrl.gold_lbl.text = str(golds)

func _on_start() -> void:
	health = PlayerStats.health
	cooldown = PlayerStats.cooldown

func _on_game_over() -> void:
	Audio.get_controller().stop_bgm()
	PlayerStats.golds += golds;
	golds = 0

func play_sfx(sfx_name: String, volume: float) -> void:
	Audio.get_controller().play_sfx(sfx_name, volume)

func _on_play_screen_state() -> void:
	state = State.START
	health_bar.visible = true
	gold_ctrl.visible = true
	overlay.visible = true

func _on_title_screen_state() -> void:
	hud.add_child(title_screen.instantiate())
	player_spawn.remove_player()
	health_bar.visible = false
	gold_ctrl.visible = false
	overlay.visible = false

func _on_captain_defeated(_capt: Captains.Values) -> void:
	chat_box.queue_free()

func _on_speak(capt: CaptainResource, dialogue_state: DialogueResource.States) -> void:
	chat_box = dialogue_box.instantiate()
	hud.add_child(chat_box)
	chat_box.captain = capt
	chat_box.state = dialogue_state
