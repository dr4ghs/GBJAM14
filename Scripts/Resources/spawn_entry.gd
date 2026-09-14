class_name SpawnEntry extends Resource

enum Lane {
	LEFT = 0,
	CENTER_LEFT,
	CENTER,
	CENTER_RIGHT,
	RIGHT
}

@export var entity: EntityResource;
@export var lane: Lane = Lane.CENTER;
@export var distance: float;
