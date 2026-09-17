class_name ChatBox
extends Control

@export var text: Label
@export var arrow: Label

@export var speed: float = 20

var cursor: float

func _process(delta: float) -> void:
	if int(cursor) + 1 == len(text.text): return
	
	cursor += speed * delta
	text.visible_characters = int(cursor)
	
	if int(cursor) + 1 == len(text.text):
		arrow.visible = true
	elif text.text[int(cursor)] == " " or text.text[int(cursor)] == "\n":
		cursor += 1
