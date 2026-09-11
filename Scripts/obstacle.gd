extends Node2D

@export var base_speed: float;
@export var distance: float;

@onready var player: Player = %Ship;

var speed: float;

func _init() -> void:
	position.x = SpawnPoints.lanes[randi_range(0, 4)];

func _process(delta: float) -> void:
	speed = ((int)(player.gold / 500) + base_speed) * delta
	if distance < 100: distance += speed;
	position.y += distance * delta;
