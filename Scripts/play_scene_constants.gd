extends Node

const BASE_SPEED: float = 1.0;
const DISTANCE_UNIT: int = 10.0;
const MAX_DISTANCE: float = 100.0;

func calculate_distance(dist: int) -> float:
	return MAX_DISTANCE + DISTANCE_UNIT * dist;
