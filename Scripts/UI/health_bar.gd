class_name HealthBar extends HBoxContainer

@export var hearts: Array[TextureRect];

@export var full_heart: AtlasTexture;
@export var empty_heart: AtlasTexture;

func on_damage_taken(health: int) -> void:
	for i in len(hearts):
		if i < health: hearts[i].texture = full_heart;
		else: hearts[i].texture = empty_heart;
