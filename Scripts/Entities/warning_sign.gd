class_name WarningSign
extends AnimatedSprite2D

const DURATION: float = 1.0
const ALTITUDE: float = 32.0

@export var lane: Lanes.Values

var duration: float
var warning: bool

func warn() -> void:
	visible = true;
	warning = true
	duration = DURATION
	
	if not is_playing(): play("default")

func _ready() -> void:
	position.x = Lanes.coordinates(lane)
	position.y = ALTITUDE

func _process(delta: float) -> void:
	if not warning: return
	
	duration -= delta
	if duration <= 0:
		visible = false
		warning = false
