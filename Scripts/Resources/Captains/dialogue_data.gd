class_name DialogueResource
extends Resource

enum States {
	ENTRY = 0,
	WIN,
	LOSE
}

@export var speak_sfx: AudioStream
@export var speed: float

@export_multiline var entry: String
@export_multiline var win: String
@export_multiline var lose: String

static func get_line(data: DialogueResource, state: States) -> String:
	if state == States.ENTRY: return data.entry
	if state == States.WIN: return data.win
	if state == States.LOSE: return data.lose
	
	return ""
