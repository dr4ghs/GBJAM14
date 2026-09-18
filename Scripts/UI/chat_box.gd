class_name ChatBox
extends Control

@export var anim_player: AnimationPlayer
@export var audio: AudioStreamPlayer
@export var text: Label
@export var arrow: Label
@export var mugshot: TextureRect

var _captain: CaptainResource
var captain: CaptainResource:
	get: return _captain
	set(value):
		_captain = value
		mugshot.texture = _captain.mugshot
		dialogue = _captain.dialogues

var _dialogue: DialogueResource
var dialogue: DialogueResource:
	get: return _dialogue
	set(value):
		_dialogue = value
		speed = _dialogue.speed
		audio.stream = _dialogue.speak_sfx

var _state: DialogueResource.States
var state: DialogueResource.States:
	get: return _state
	set(value):
		_state = value
		cursor = 0
		text.text = DialogueResource.get_line(dialogue, _state)
		anim_player.play(&"show")

var cursor: float
var cursor_buff: int
var speed: float

func _ready() -> void:
	state = DialogueResource.States.ENTRY

func _process(delta: float) -> void:
	if arrow.visible and (Input.is_action_just_pressed("action") or Input.is_action_just_pressed("cancel")):
		anim_player.play(&"hide")
	
	if int(cursor) == len(text.text): return
	
	if Input.is_action_just_pressed("action") or Input.is_action_just_pressed("cancel"):
		arrow.visible = true
	
	if arrow.visible: cursor = len(text.text)
	else: cursor += speed * delta
	if int(cursor) > cursor_buff:
		audio.stop()
		cursor_buff = int(cursor)
		audio.play(0)
		
	text.visible_characters = cursor_buff
	
	if int(cursor) == len(text.text):
		arrow.visible = true
	elif text.text[int(cursor)] == " " or text.text[int(cursor)] == "\n":
		cursor += 1

func _on_hide_anim_end() -> void:
	if state == DialogueResource.States.ENTRY: return
	
	queue_free()
