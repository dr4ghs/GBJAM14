@abstract
class_name Obstacle
extends Area2D

@export var base_speed: float;
@export var distance: float;

@export var is_damaging: bool;
@export var _damage: int;

@export var is_gold: bool;
@export var _gold: int;

@onready var player: Player = %Ship;

var speed: float;

func _init() -> void:
	position.x = SpawnPoints.lanes[randi_range(0, 4)];

func _process(delta: float) -> void:
	speed = ((int)(player.gold / 500) + base_speed) * delta
	if distance < 100: distance += speed;
	position.y += distance * delta;

func damage() -> int:
	if is_damaging: return _damage;
	
	return 0;

func gold() -> int:
	if is_gold: return _gold;
	
	return 0;
