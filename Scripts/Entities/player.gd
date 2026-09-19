class_name Player extends Area2D

signal damage_taken(damage: int);
signal gold_taken(damate: int);

var cannon_ball: PackedScene = preload("res://Scenes/Prefabs/cannon_ball.tscn");

@export var collision_box: CollisionShape2D
@export var animation_player: AnimationPlayer
@export var ship_gfx: Sprite2D
@export var coin: AnimationPlayer
@export var cannon: ShipCannon

@export var damaged: bool

var lane: Lanes.Values

func setup() -> void:
	lane = Lanes.Values.CENTER;

func _on_death() -> void:
	animation_player.play("death");

func _ready() -> void:
	setup();

func process(_delta: float) -> void:
	position.x = lerp(position.x, Lanes.coordinates(lane), 0.2 * (PlayerStats.speed));

func _on_area_entered(entity: Entity) -> void:
	if z_index > entity.z_index: return;
	
	if entity.attack.enabled and not damaged:
		animation_player.play("damaged");
		damage_taken.emit(entity.attack.value);
	
	if entity.gold.enabled:
		if entity.health.enabled:
			animation_player.play("damaged")
			damage_taken.emit(1)
		else:
			coin.stop();
			coin.play("defualt");
			gold_taken.emit(entity.gold.value);

func _on_fire(parent: Node2D) -> void:
	cannon.spawn(parent)
