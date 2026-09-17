class_name Entity
extends Area2D

const WARN_SIGN_Y: int = 32;

signal hurted();

var warn_sign: PackedScene = preload("res://Scenes/Prefabs/warning_sign.tscn");

@onready var gfx: Sprite2D = $Graphics;
@onready var mask: Sprite2D = $Graphics/Mask;
@onready var collisions: CollisionShape2D = $CollisionBox;
@onready var anim_player: AnimationPlayer = $AnimationPlayer;

var is_damageable: bool;
var _health: int;

var is_damaging: bool;
var _damage: int;

var is_gold: bool;
var _gold: int;

var distance: float;
var warned: bool;

#@export var res: EntityResource;

func populate(resource: EntityResource, dist: int) -> void:
	is_damageable = resource.health > 0;
	set_collision_layer_value(3, is_damageable);
	set_collision_mask_value(4, is_damageable)
	_health = resource.health;
	
	is_damaging = resource.damage > 0;
	set_collision_layer_value(3, is_damaging);
	set_collision_mask_value(4, is_damageable)
	_damage = resource.damage;
	
	is_gold = resource.gold > 0;
	set_collision_layer_value(2, is_gold);
	_gold = resource.gold;
	
	if resource.texture is AtlasTexture:
		var atlas: AtlasTexture = resource.texture as AtlasTexture;
		gfx.texture = atlas.atlas
		gfx.region_enabled = true;
		gfx.region_rect = atlas.region;
	else:
		gfx.texture = resource.texture;
	
	collisions.shape = RectangleShape2D.new();
	(collisions.shape as RectangleShape2D).size = Vector2(16 * resource.width, 16);
	
	anim_player.current_animation = resource.anim_name;
	
	distance = PlaySceneConstants.MAX_DISTANCE + (float(dist) / 10);
	position.y = SpawnPoints.obstacle_altitude;
	
	mask.visible = true;

func health() -> int:
	if is_damageable: return _health;
	
	return 0;

func damage() -> int:
	if is_damaging: return _damage;
	
	return 0;

func gold() -> int:
	if is_gold: return _gold;
	
	return 0;

func hurt() -> void:
	hurted.emit();
	_health -= 1;
	if _health <= 0:
		anim_player.play("entity_anims/damaged");

func update(delta: float) -> void:
	if is_damageable and _health <= 0: return;
	
	distance -= PlaySceneConstants.BASE_SPEED * PlayerStats.curr_speed * delta;
	
	if is_damaging and not warned and distance <= PlaySceneConstants.MAX_DISTANCE * 0.75:
		var warn: Node = warn_sign.instantiate();
		$"..".add_child(warn);
		warn.position.y = WARN_SIGN_Y;
		warn.position.x = position.x;
		warned = true;
	
	if distance > PlaySceneConstants.MAX_DISTANCE: return;
	
	var delta_d: float = snapped(-4 * pow(distance, 2) + 4 * distance, 0.01);
	
	if distance <= 0.5 and delta_d == 1: 
		self.z_index = 0;
		mask.visible = false;
	
	position.y = get_viewport_rect().size.y - (delta_d * (get_viewport_rect().size.y - 48));

func _on_area_entered(area: Area2D) -> void:
	if is_damageable and _health <= 0: return;
	if z_index < area.z_index: return;
	if is_damaging: return;
	#if area is CannonBall and not is_damaging: return;
	
	self.queue_free()

func on_damaged_anim_end() -> void:
	if is_damageable and _health <= 0:
		queue_free();
