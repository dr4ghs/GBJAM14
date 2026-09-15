class_name Ship extends Area2D

signal damage_taken(damage: int);
signal gold_taken(damate: int);
signal death();

@onready var collision_box: CollisionShape2D = $CollisionBox;
@onready var graphics: Sprite2D = $Graphics;
@onready var animation_player: AnimationPlayer = $AnimationPlayer;
@onready var coin: AnimationPlayer = $Coin/AnimationPlayer

var _gold: int;
var _health: int;
var _curr_lane: int = 2;
var damaged: bool;

const MAX_INVINCIBILTY_COOLDOWN: float = 5.0;
var invincible: bool;
var invincibility_cooldown: float;

func gold() -> int:
	return _gold;

func setup() -> void:
	PlayerStats.reset();
	_gold = 0;
	_health = PlayerStats.health;
	_curr_lane = Enums.Lane.CENTER;
	damaged = false;
	animation_player.play("ship_idle");

func on_damaged_anim_end() -> void:
	animation_player.play("ship_idle");
	damaged = false;

func on_death() -> void:
	animation_player.play("death");
	PlayerStats.curr_speed = 0;

func _ready() -> void:
	setup();

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn"):
		setup();
		return;
	
	if Input.is_action_just_pressed("steer_left"):
		if _curr_lane > 0: _curr_lane -= 1;
	elif Input.is_action_just_pressed("steer_right"):
		if _curr_lane < len(SpawnPoints.lanes) - 1: _curr_lane += 1;
	
	position.x = lerp(position.x, SpawnPoints.lanes[_curr_lane], 0.2);
	animation_player.speed_scale = PlayerStats.speed;
	
	if not invincible and Input.is_action_just_pressed("spawn"):
		invincible = true;
		invincibility_cooldown = MAX_INVINCIBILTY_COOLDOWN;
		animation_player.play("invincible");
	
	if invincible:
		invincibility_cooldown -= delta;
		if invincibility_cooldown <= 0:
			invincible = false;
			animation_player.play("ship_idle");
	
func _on_area_entered(obstacle: Entity) -> void:
	if z_index > obstacle.z_index: return;
	if _health <= 0: return;
	
	if obstacle.is_damaging and not damaged:
		if invincible: return;
		
		_health -= obstacle.damage()
		damaged = true;
		animation_player.play("damaged"); 
		damage_taken.emit(_health);
		if (_health <= 0): death.emit();
	if obstacle.is_gold:
		_gold += obstacle.gold()
		coin.stop();
		coin.play("defualt");
		gold_taken.emit(_gold);
