class_name  GoldComponent
extends Node

var enabled: bool
var _value: int

var value: int:
	get:
		return _value
	set(gold):
		if not enabled: return;
		
		_value = gold
