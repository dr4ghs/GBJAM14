class_name Ship extends Area2D

signal damage_taken(damage: int);
signal gold_taken(damate: int);
signal death();

@onready var collision_box: CollisionShape2D = $CollisionBox;
@onready var graphics: Sprite2D = $Graphics;
@onready var animation_player: AnimationPlayer = $AnimationPlayer;
@onready var coin: AnimationPlayer = $Coin/AnimationPlayer

@export var _health: int;

var _gold: int;
var _curr_lane: int = 2;
var damaged: bool;

func gold() -> int:
	return _gold;

func on_damaged_anim_end() -> void:
	animation_player.play("ship_idle");
	damaged = false;

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("steer_left"):
		if _curr_lane > 0: _curr_lane -= 1;
	elif Input.is_action_just_pressed("steer_right"):
		if _curr_lane < len(SpawnPoints.lanes) - 1: _curr_lane += 1;
	
	position.x = lerp(position.x, SpawnPoints.lanes[_curr_lane], 0.2);
	animation_player.speed_scale = PlayerStats.speed;

func _on_area_entered(obstacle: Entity) -> void:
	if z_index > obstacle.z_index: return;
	
	if obstacle.is_damaging and not damaged:
		_health -= obstacle.damage()
		if (_health <= 0): death.emit();
		else:
			damaged = true;
			animation_player.play("damaged"); 
			damage_taken.emit(_health);
	if obstacle.is_gold:
		_gold += obstacle.gold()
		coin.stop();
		coin.play("defualt");
		gold_taken.emit(_gold);
