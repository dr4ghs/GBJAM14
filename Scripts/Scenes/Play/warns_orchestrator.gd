class_name WarnsOrchestrator
extends Node2D

@export var warns: Dictionary[Lanes.Values, WarningSign]

func notify(lane: Lanes.Values) -> void:
	if lane > Lanes.Values.RIGHT: return
	
	warns[lane].warn()

func _on_area_exited(area: Area2D) -> void:
	if area is not Entity: return
	if area.z_index >= 0: return
	
	var entity: Entity = area as Entity
	if entity.attack.enabled:
		warns[entity.lane].warn()
