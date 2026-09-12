class_name Player extends Area2D

@export var gold: int;

@onready var collision_box: CollisionShape2D = $CollisionBox;
@onready var graphics: Sprite2D = $Graphics;
@onready var animation_player: AnimationPlayer = $AnimationPlayer;

var curr_lane: int = 2;

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("steer_left"):
		if curr_lane > 0:
			curr_lane -= 1;
	elif Input.is_action_just_pressed("steer_right"):
		if curr_lane < len(SpawnPoints.lanes) - 1:
			curr_lane += 1;
	
	position.x = lerp(position.x, SpawnPoints.lanes[curr_lane], 0.2);
	animation_player.speed_scale = 1 + (gold / 500)

func _on_area_entered(obstacle: Obstacle) -> void:
	if obstacle.damage() > 0: print("%d DAMAGE" % obstacle.damage())
	if obstacle.gold() > 0: print("GOLD +%d" % obstacle.gold())
