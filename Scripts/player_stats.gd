extends Node

var speed: float = 1.0;
var health: int = 1;

var curr_speed: float = speed;
var curr_health: int = health;

func reset() -> void:
	curr_speed = speed;
	curr_health = health;
