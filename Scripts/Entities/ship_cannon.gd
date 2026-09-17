class_name ShipCannon
extends Node2D

var prefab: PackedScene = preload("res://Scenes/Prefabs/cannon_ball.tscn")

func spawn(parent: Node2D) -> void:
	var cannon_ball: Node2D = prefab.instantiate();
	parent.add_child(cannon_ball);
	cannon_ball.position = $"..".position + position;
