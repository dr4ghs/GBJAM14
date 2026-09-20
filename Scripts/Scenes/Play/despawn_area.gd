class_name DespawnArea extends Area2D

@export var entity_spawner: EntitiesSpawner

func _on_area_entered(area: Area2D) -> void:
	if area is Entity:
		var entity = area as Entity
		if entity.health.enabled and not entity.attack.enabled and not entity.gold.enabled:
			entity_spawner.ducks_count = 0
	
	if area is not CaptainBehaviour:
		area.queue_free();
