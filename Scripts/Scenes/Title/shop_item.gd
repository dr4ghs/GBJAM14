class_name ShopItem
extends Control

enum Stat {
	HEALTH,
	SPEED,
	COOLDOWN,
}

@export var stat: Stat

@export var selector: TextureRect
@export var level: TextureRect
@export var cost_lbl: Label

var cost: int

var _selected: bool
var selected: bool:
	get: return _selected
	set(value):
		_selected = value
		selector.visible = _selected
		if _selected:
			if PlayerStats.get_level(stat) == 4:
				(selector.texture as AtlasTexture).region.position.x = 64
			else:
				(selector.texture as AtlasTexture).region.position.x = 48

func _ready() -> void:
	update()

func update() -> void:
	var lvl: int = PlayerStats.get_level(stat)
	
	(level.texture as AtlasTexture).region.position.y = (lvl - 1) * 16
	cost = int(lvl * 2.5 * 100)
	if lvl == 4: cost_lbl.text = "-"
	else: cost_lbl.text = str(cost)
	selected = selected
