extends Node

enum {
	HEALTH,
	SPEED,
	COOLDOWN,
}

var golds: int

const BASE_SPEED: float = 0.2
var _speed_lvl: int = 1
var speed_lvl: int:
	get: return _speed_lvl
	set(value): 
		_speed_lvl = value
		if _speed_lvl > 4: _speed_lvl = 4
	
var speed: float:
	get: return BASE_SPEED * speed_lvl

const BASE_COOLDOWN: float = 4.0
var _cooldown_lvl: int = 4
var cooldown_lvl: int:
	get: return _cooldown_lvl
	set(value): 
		_cooldown_lvl = value
		if _cooldown_lvl > 4: _cooldown_lvl = 4

var cooldown: float:
	get: return 1 + BASE_COOLDOWN - cooldown_lvl

var _health: int = 4
var health: int:
	get: return _health
	set(value): 
		_health = value
		if _health > 5: _health = 4

var progress: Dictionary[Captains.Values, bool] = {
	Captains.Values.FISH: false,
	Captains.Values.RAT: false,
	Captains.Values.CAT: false,
	Captains.Values.BOSS: false,
}

func get_level(stat: int) -> int:
	if stat == HEALTH: return health
	if stat == SPEED: return speed_lvl
	if stat == COOLDOWN: return cooldown_lvl
	
	return 0

func level_up(stat: int) -> void:
	if stat == HEALTH: health += 1
	if stat == SPEED: speed_lvl += 1
	if stat == COOLDOWN: cooldown_lvl += 1
