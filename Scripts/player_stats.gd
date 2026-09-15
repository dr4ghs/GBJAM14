extends Node

var speed: float = 1.0;
var health: int = 1;

var curr_speed: float;
var curr_health: int;

func reset() -> void:
	curr_speed = speed;
	curr_health = health;
