class_name CannonBall
extends Area2D

@export var speed: float;

func _process(delta: float) -> void:
	position.y -= speed * delta;

func _on_area_entered(entity: Entity) -> void:
	if entity.z_index < z_index: return;
	
	if entity.is_damageable: entity.hurt();
	
	queue_free();
