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

var speed: float;

@export var res: EntityResource;

func _ready() -> void:
	populate(res, 1)

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
	
	anim_player.current_animation = resource.anim_name;
	
	distance = PlaySceneConstants.calculate_distance(dist);
	
	mask.visible = true;

func damage() -> int:
	if is_damaging: return _damage;
	
	return 0;

func gold() -> int:
	if is_gold: return _gold;
	
	return 0;

func _process(delta: float) -> void:
	speed = (PlaySceneConstants.BASE_SPEED + (game_state.player._gold / 100));
	var n: float = position.y - SpawnPoints.obstacle_altitude;
	n -= PlaySceneConstants.MAX_DISTANCE / (PlaySceneConstants.MAX_DISTANCE - distance);
	
	if position.y > SpawnPoints.obstacle_altitude + 4:
		mask.visible = false;
	
	position.y += speed * (n / 2) * delta;

func _on_area_entered(area: Area2D) -> void:
	if is_gold: self.queue_free();
