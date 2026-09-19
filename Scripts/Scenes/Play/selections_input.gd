extends TitleScreenEntry

@export var cursor: Label

var enabled: bool:
	get: return _enabled
	set(value): _enabled = value

var _idx: int

var cursors_idx: int:
	get: return _idx
	set(value):
		_idx = value
		cursor.text = ""
		for i in _idx:
			cursor.text += "\n"
		cursor.text += "~"

func handle_input() -> void:
	if Input.is_action_just_pressed("up"): 
		cursors_idx = ((cursors_idx + 2) % 3)
		Audio.get_controller().play_sfx("select")
	if Input.is_action_just_pressed("down"): 
		cursors_idx = (cursors_idx + 1) % 3
		Audio.get_controller().play_sfx("select")
	
	if Input.is_action_just_pressed("action"):
		if cursors_idx == 0: manager.close()
		if cursors_idx == 1: manager.transit(self, manager.shop)
		if cursors_idx == 2: manager.transit(self, manager.creds)
		Audio.get_controller().play_sfx("gold")
