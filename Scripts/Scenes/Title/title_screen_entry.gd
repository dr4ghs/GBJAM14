@abstract
class_name TitleScreenEntry
extends NinePatchRect

@export var manager: TitleScreenManager

var _enabled: bool

func _process(_delta: float) -> void:
	if not _enabled: return
	
	handle_input()

@abstract func handle_input() -> void
