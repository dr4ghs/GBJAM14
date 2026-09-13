class_name Entity
extends Area2D

@onready var game_state: GameStateManager = %GameState;
@onready var gfx: Sprite2D = $Graphics;
@onready var mask: Sprite2D = $Graphics/Mask;
@onready var collisions: CollisionShape2D = $CollisionBox;
@onready var anim_player: AnimationPlayer = $AnimationPlayer;

@export var distance: float;

var is_damaging: bool;
var _damage: int;

var is_gold: bool;
var _gold: int;

@export var res: EntityResource;

func _ready() -> void:
	populate(res, distance)

func populate(resource: EntityResource, dist: int) -> void:
	is_damaging = resource.damage > 0;
	_damage = resource.damage;
	
	is_gold = resource.gold > 0;
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

func damage() -> int:
	if is_damaging: return _damage;
	
	return 0;

func gold() -> int:
	if is_gold: return _gold;
	
	return 0;

func _process(delta: float) -> void:
	distance -= PlaySceneConstants.BASE_SPEED * game_state.player.speed * delta;
	
	var delta_d: float = snapped(-4 * pow(distance, 2) + 4 * distance, 0.01);
	
	if distance <= 0.5 and delta_d == 1: 
		self.z_index = 0;
		mask.visible = false;
	if distance < 0.4: scale = Vector2(1, 1);
	
	position.y = get_viewport_rect().size.y - (delta_d * (get_viewport_rect().size.y - 48));

func _on_area_entered(_area: Area2D) -> void:
	if z_index < _area.z_index: return;
	
	self.queue_free()
