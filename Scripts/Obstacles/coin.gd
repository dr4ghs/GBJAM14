class_name CoinObstacle extends Obstacle

func damage() -> int:
	return 0;

func gold() -> int:
	return 1;


func _on_area_entered(area: Area2D) -> void:
	self.queue_free();
