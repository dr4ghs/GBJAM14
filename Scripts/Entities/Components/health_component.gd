class_name HealthComponent
extends Node

@export var anim_player: AnimationPlayer

var enabled: bool
var _value: int

var value: int:
	get:
		return _value
	set(health):
		if not enabled: return;
		
		_value = health
		if _value <= 0:
			anim_player.play("damaged")
