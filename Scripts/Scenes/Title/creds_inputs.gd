class_name CreditsScreen
extends TitleScreenEntry

@export var anim_player: AnimationPlayer

var enabled: bool:
	get: return _enabled
	set(value):
		_enabled = value
		if _enabled: anim_player.play(&"scroll")

func _process(delta: float) -> void:
	super(delta)
	if not visible: anim_player.play(&"RESET")

func handle_input() -> void:
	if Input.is_action_just_pressed("cancel"):
		manager.transit(self, manager.main)

func _on_scroll_anim_end() -> void:
	if not enabled: return
	
	manager.transit(self, manager.main)
