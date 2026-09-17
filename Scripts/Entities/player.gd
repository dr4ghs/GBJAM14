class_name Player extends Area2D

signal damage_taken(damage: int);
signal gold_taken(damate: int);
signal death();
signal fire(parent: Node2D);

var cannon_ball: PackedScene = preload("res://Scenes/Prefabs/cannon_ball.tscn");

@onready var collision_box: CollisionShape2D = $CollisionBox;
@onready var animation_player: AnimationPlayer = $AnimationPlayer;
@onready var ship_gfx: Sprite2D = $Graphics/Ship;
@onready var coin: AnimationPlayer = $Coin/AnimationPlayer

@export var enable_input: bool = false;

var cannon_ball_parent: Node2D;

var _gold: int;
var _health: int;
var _curr_lane: int = 2;
var damaged: bool;

const MAX_INVINCIBILTY_COOLDOWN: float = 1.0;
var invincible: bool;
var invincibility_cooldown: float;

func gold() -> int:
	return _gold;

func setup() -> void:
	PlayerStats.reset();
	_gold = 0;
	_health = PlayerStats.health;
	_curr_lane = Lanes.Values.CENTER;
	damaged = false;
	invincible = false;

func on_damaged_anim_end() -> void:
	animation_player.play("idle");
	damaged = false;

func _on_death() -> void:
	animation_player.play("death");
	PlayerStats.curr_speed = 0;

func _ready() -> void:
	setup();

func _process(delta: float) -> void:
	if _health <= 0: return;
	
	if enable_input:
		if Input.is_action_just_pressed("left"):
			if _curr_lane > 0: _curr_lane -= 1;
		elif Input.is_action_just_pressed("right"):
			if _curr_lane < len(Lanes.Values) - 1: _curr_lane += 1;
		elif Input.is_action_just_pressed("action"):
			# TODO cooldown
			fire.emit(cannon_ball_parent);
	
	position.x = lerp(position.x, Lanes.coordinates(_curr_lane), 0.2);
	animation_player.speed_scale = PlayerStats.speed;
	
	if not invincible and false:
		invincible = true;
		invincibility_cooldown = MAX_INVINCIBILTY_COOLDOWN;
		animation_player.play("invincible");
	
	if invincible:
		invincibility_cooldown -= delta;
		if invincibility_cooldown <= 0:
			invincible = false;
			ship_gfx.region_rect.position.x = 0;
			animation_player.play("idle");

func _on_area_entered(entity: Entity) -> void:
	if z_index > entity.z_index: return;
	if _health <= 0: return;
	
	if entity.attack.enabled and not damaged:
		if invincible: return;
		
		_health -= entity.attack.value
		damaged = true;
		animation_player.play("damaged"); 
		damage_taken.emit(_health);
		if (_health <= 0): death.emit();
	
	if entity.gold.enabled:
		_gold += entity.gold.value
		coin.stop();
		coin.play("defualt");
		gold_taken.emit(_gold);
