class_name TitleScreenManager
extends AnimationPlayer

@export var play_scene: PlaySceneManager
@export var root: Control

@export var portraits: PortraitsController
@export var main: TitleScreenEntry
@export var shop: TitleScreenEntry
@export var creds: TitleScreenEntry

var from_screen: TitleScreenEntry
var to_screen: TitleScreenEntry

func _ready() -> void:
	to_screen = main
	to_screen.enabled = false
	
	play(&"enter")

func transit(from: TitleScreenEntry, to: TitleScreenEntry) -> void:
	from_screen = from
	to_screen = to
	
	play(&"back")

func close() -> void:
	play(&"exit")

func _on_enter_anim_start() -> void:
	portraits.refresh()
	to_screen.visible = true

func _on_enter_anim_end() -> void:
	to_screen.enabled = true

func _on_back_anim_start() -> void:
	from_screen.enabled = false

func _on_back_anim_end() -> void:
	from_screen.visible = false
	play(&"enter")

func _on_exit_anim_start() -> void:
	to_screen.enabled = false

func _on_exit_anim_end() -> void:
	ScreenStateMachine.state = ScreenStateMachine.States.PLAY
	queue_free()
