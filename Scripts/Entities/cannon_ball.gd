class_name CannonBall
extends Area2D

@export var speed: float;

func _process(delta: float) -> void:
	position.y -= speed * delta;

func _on_area_entered(entity: Area2D) -> void:
	if entity.z_index < z_index: return;
	
	if entity is Entity:
		if entity.health.enabled and entity.health.value > 0: 
			entity.damage();
			queue_free();
