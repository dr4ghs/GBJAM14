extends AnimatedSprite2D

@export var duration: float;

func _ready() -> void:
	play("default");

func _process(delta: float) -> void:
	duration -= delta;
	if duration <= 0:
		self.queue_free();
