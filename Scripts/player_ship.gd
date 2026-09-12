class_name PlayerShip extends Ship

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("steer_left"):
		if _curr_lane > 0: _curr_lane -= 1;
	elif Input.is_action_just_pressed("steer_right"):
		if _curr_lane < len(SpawnPoints.lanes) - 1: _curr_lane += 1;
	
	super(delta);

func _on_damage_taken(damage: int) -> void:
	_health -= 1;
	if _health <= 0: death.emit();

func _on_gold_taken(damate: int) -> void:
	_gold += 1;
