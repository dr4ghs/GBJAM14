class_name Entity
extends Area2D

signal hit(entity: Entity);

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

func populate(resource: EntityResource, dist: int) -> void:
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
	(collisions.shape as RectangleShape2D).size = Vector2(16 * resource.width, 16);
	
	distance = PlaySceneConstants.MAX_DISTANCE + (float(dist) / 10);
	position.y = START_ALTITUDE;
	
func damage() -> void:
	if not health.enabled: return;
	
	health.value -= 1;
	hit.emit(self);

func update(delta: float) -> void:
	if health.enabled and health.value <= 0: return;
	
	distance -= PlaySceneConstants.BASE_SPEED * PlayerStats.speed * delta;
	
	if distance > PlaySceneConstants.MAX_DISTANCE: return;
	
	var delta_d: float = snapped(-4 * pow(distance, 2) + 4 * distance, 0.01);
	
	if distance <= 0.5 and delta_d == 1: 
		self.z_index = 0;
		mask.visible = false;
	
	position.y = get_viewport_rect().size.y - (delta_d * (get_viewport_rect().size.y - 48));

func _on_area_entered(area: Area2D) -> void:
	if health.enabled and health.value <= 0: return;
	if z_index < area.z_index: return;
	if attack.enabled: return;
	if area is CannonBall and not health.enabled: return;
	if health.enabled and not gold.enabled:
		Audio.get_controller().play_sfx("quack")
	
	self.queue_free()

func on_damaged_anim_end() -> void:
	if health.enabled and health.value <= 0:
		queue_free();


func _on_hit(_entity: Entity) -> void:
	if not gold.enabled: 
		Audio.get_controller().play_sfx("quack")
		return
	
	Audio.get_controller().play_sfx("hit")
