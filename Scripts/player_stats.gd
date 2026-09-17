extends Node

var golds: int

const BASE_SPEED: float = 1.0
var _speed_lvl: int = 1
var speed_lvl: int:
	get: return _speed_lvl
	set(value): if value < 4: _speed_lvl = value
var speed: float:
	get: return BASE_SPEED + float(speed_lvl) / 4

const BASE_COOLDOWN: float = 4.0
var _cooldown_lvl: int = 1
var cooldown_lvl: int:
	get: return _cooldown_lvl
	set(value): if value < 4: _cooldown_lvl = value

var cooldown: float:
	get: return 1 + BASE_COOLDOWN - cooldown_lvl

var _health: int = 1
var health: int:
	get: return _health
	set(value): if value < 4: _health = value

var progress: Dictionary[Captains.Values, bool] = {
	Captains.Values.FISH: false,
	Captains.Values.RAT: false,
	Captains.Values.CAT: false,
	Captains.Values.BOSS: false,
}
