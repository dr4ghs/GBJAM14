class_name GoldLabel extends Label

@onready var manager: GameStateManager = %GameState;

func on_gold_taken(gold: int):
	text = str(manager.player._gold);
