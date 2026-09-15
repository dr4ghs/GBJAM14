class_name HealthBar extends HBoxContainer

@export var hearts: Array[TextureRect];

@export var full_heart: AtlasTexture;
@export var empty_heart: AtlasTexture;

func populate(health: int) -> void:
	for i in health:
		var texture_rect: TextureRect = TextureRect.new();
		texture_rect.texture = full_heart;
		add_child(texture_rect);
		hearts.append(texture_rect);

func on_damage_taken(health: int) -> void:
	for i in len(hearts):
		if i < health: hearts[len(hearts) - 1 - i].texture = full_heart;
		else: hearts[len(hearts) - 1 - i].texture = empty_heart;
