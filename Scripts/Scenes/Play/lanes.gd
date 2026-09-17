class_name Lanes

enum Values {
	LEFT = 0,
	CENTER_LEFT,
	CENTER,
	CENTER_RIGHT,
	RIGHT,
}

const lane_coords: Array[float] = [16.0, 48.0, 80.0, 112.0, 144.0];

static func coordinates(lane: Values) -> float:
	if lane > Values.RIGHT: return 0;
	
	return lane_coords[lane];
