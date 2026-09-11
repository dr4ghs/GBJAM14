extends Node2D
class_name Player

@export var gold: int;

var curr_lane: int = 2;

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("steer_left"):
		if curr_lane > 0:
			curr_lane -= 1;
	elif Input.is_action_just_pressed("steer_right"):
		if curr_lane < len(SpawnPoints.lanes) - 1:
			curr_lane += 1;
	
	position.x = lerp(position.x, SpawnPoints.lanes[curr_lane], 0.2);
