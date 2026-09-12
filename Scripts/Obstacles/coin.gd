class_name CoinObstacle extends Obstacle

func _on_area_entered(area: Area2D) -> void:
	if area is Ship: self.queue_free();
