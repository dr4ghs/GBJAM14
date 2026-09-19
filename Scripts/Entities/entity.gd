class_name Entity
extends Area2D

signal hit(entity: Entity);

@export var duck_spawn_rate: float = 1
@export var chest_spawn_rate: float = 5
@export var kraken_spawn_rate: float = 3

var duck: EntityResource = preload("res://Resources/Entities/duck_entity.tres")
var common_chest: EntityResource = preload("res://Resources/Entities/common_chest_resource.tres")
var rare_chest: EntityResource = preload("res://Resources/Entities/rare_chest.tres")
var kraken: EntityResource = preload("res://Resources/Entities/kraken_entity.tres")

const START_ALTITUDE = 72.0;

@export var gfx: AnimatedSprite2D;
@export var mask: Sprite2D;
@export var collisions: CollisionShape2D;
@export var anim_player: AnimationPlayer;

@export var health: HealthComponent
@export var attack: AttackComponent
@export var gold: GoldComponent

var lane: Lanes.Values:
	set(value):
		lane = value
		position.x = Lanes.coordinates(value)

var distance: float

func populate(resource: EntityResource, dist: int, ducks_count: float) -> void:
	resource = entity_mods(resource, ducks_count)
	
	health.enabled = resource.health > 0
	if health.enabled: 
		health.value = resource.health
		set_collision_mask_value(4, true)
	
	attack.enabled = resource.attack > 0
	if attack.enabled: 
		attack.value = resource.attack
		set_collision_layer_value(3, true)
	
	gold.enabled = resource.gold > 0
	if gold.enabled:
		gold.value = resource.gold
		set_collision_layer_value(2, true)
	
	if health.enabled and not attack.enabled:
		if not gold.enabled: set_collision_layer_value(8, true)
		else: set_collision_layer_value(7, true)
	
	gfx.play(resource.entity_name)
	
	collisions.shape = RectangleShape2D.new();
	(collisions.shape as RectangleShape2D).size = Vector2(20 * resource.width, 16);
	
	distance = PlaySceneConstants.MAX_DISTANCE + (float(dist) / 10);
	position.y = START_ALTITUDE;
	
func damage() -> void:
	if not health.enabled: return;
	
	health.value -= 1;
	hit.emit(self);

func update(delta: float) -> void:
	if health.enabled and health.value <= 0: return;
	
	distance -= PlayerStats.speed * delta;
	
	if distance > PlaySceneConstants.MAX_DISTANCE: return;
	
	var delta_d: float = snapped(-4 * pow(distance, 2) + 4 * distance, 0.01);
	
	if distance <= 0.5 and delta_d == 1: 
		self.z_index = 0;
		mask.visible = false;
	
	position.y = get_viewport_rect().size.y - (delta_d * (get_viewport_rect().size.y - 48));

func entity_mods(resource: EntityResource, ducks_count: float) -> EntityResource:
	var prob: float = randf() * 100
	if prob < duck_spawn_rate:
		resource = duck
	elif resource.attack > 0 and prob < kraken_spawn_rate + ducks_count:
		resource = kraken
	elif resource.gold > 0 and prob < chest_spawn_rate:
		if randf() * 100 < chest_spawn_rate:
			resource = rare_chest
		else: resource = common_chest
	
	return resource

func _on_area_entered(area: Area2D) -> void:
	if health.enabled and health.value <= 0: return;
	if z_index < area.z_index: return;
	if attack.enabled: return;
	if area is CannonBall and not health.enabled: return;
	if health.enabled and health.value > 0 and not gold.enabled:
		if area is Player:
			(area as Player).malus = true
			Audio.get_controller().play_sfx("quack")
	
	self.queue_free()

func on_damaged_anim_end() -> void:
	if health.enabled and health.value <= 0:
		queue_free();

func _on_hit(_entity: Entity) -> void:
	if health.enabled and not attack.enabled and not gold.enabled: 
		Audio.get_controller().play_sfx("quack")
		return
	
	Audio.get_controller().play_sfx("hit")
