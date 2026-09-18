extends TitleScreenEntry

@export var items: Array[ShopItem]

@export var golds_lbl: Label

var _selected: int
var selected: int:
	get: return _selected
	set(value):
		items[_selected].selected = false
		_selected = value
		items[_selected].selected = true

var enabled: bool:
	get: return _enabled
	set(value): _enabled = value

func _ready() -> void:
	golds_lbl.text = str(PlayerStats.golds)
	selected = 0

func handle_input() -> void:
	if Input.is_action_just_pressed("up"): selected = (selected + 2) % 3
	if Input.is_action_just_pressed("down"): selected = (selected + 1) % 3
	
	if Input.is_action_just_pressed("action"): purchase(items[selected])
	if Input.is_action_just_pressed("cancel"): manager.transit(self, manager.main)

func purchase(item: ShopItem) -> void:
	var lvl: int = PlayerStats.get_level(item.stat)
	print(lvl)
	
	if lvl == 4: return
	if PlayerStats.golds < item.cost: return
	
	PlayerStats.golds -= item.cost
	golds_lbl.text = str(PlayerStats.golds)
	
	PlayerStats.level_up(selected)
	item.update()
	
	var prev = lvl - 1
