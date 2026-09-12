@abstract
class_name Obstacle
extends Area2D

@export var BASE_SPEED: float = 1;
@export var MAX_DISTANCE: float = 100;

@export var distance: float;

@export var is_damaging: bool;
@export var _damage: int;

@export var is_gold: bool;
@export var _gold: int;

@onready var mask: Sprite2D = $Graphics/Mask;
@onready var manager: GameStateManager = %GameState;

var speed: float;

func _process(delta: float) -> void:
	speed = (BASE_SPEED + (manager.player._gold / 100));
	var n: float = position.y - SpawnPoints.obstacle_altitude;
	n -= MAX_DISTANCE / (MAX_DISTANCE - distance);
	
	if position.y > SpawnPoints.obstacle_altitude + 4:
		mask.visible = false;
	
	if position.y > SpawnPoints.obstacle_altitude + 8:
		scale.x = 1;
		scale.y = 1;
	
	position.y += speed * (n / 2) * delta;

func damage() -> int:
	if is_damaging: return _damage;
	
	return 0;

func gold() -> int:
	if is_gold: return _gold;
	
	return 0;
