class_name Ship extends Area2D

signal damage_taken(damage: int);
signal gold_taken(damate: int);
signal death();

@onready var collision_box: CollisionShape2D = $CollisionBox;
@onready var graphics: Sprite2D = $Graphics;
@onready var animation_player: AnimationPlayer = $AnimationPlayer;

@export var _health: int;

var _gold: int;
var _curr_lane: int = 2;

func gold() -> int:
	return _gold;

func _process(delta: float) -> void:
	position.x = lerp(position.x, SpawnPoints.lanes[_curr_lane], 0.2);
	animation_player.speed_scale = 1 + (_gold / 500)

func _on_area_entered(obstacle: Entity) -> void:
	if z_index > obstacle.z_index: return;
	
	if obstacle.is_damaging: 
		_health -= obstacle.damage()
		damage_taken.emit(_health);
	if obstacle.is_gold:
		_gold += obstacle.gold()
		gold_taken.emit(_gold);
