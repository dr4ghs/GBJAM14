class_name CaptainBehaviour
extends Area2D

signal speak(dialogue: DialogueResource, state: DialogueResource.States)

@export var res: CaptainResource

@export var anim_player: AnimationPlayer
