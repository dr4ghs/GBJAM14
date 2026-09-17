class_name AttackComponent
extends Node

var enabled: bool
var _value: int

var value: int:
	get:
		return _value
	set(attack):
		if not enabled: return;
		
		_value = attack
