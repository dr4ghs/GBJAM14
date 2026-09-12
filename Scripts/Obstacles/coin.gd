class_name CoinObstacle extends Obstacle

func _on_area_entered(area: Area2D) -> void:
	self.queue_free();
