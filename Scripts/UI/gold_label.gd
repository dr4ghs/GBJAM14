class_name GoldController
extends HBoxContainer

@export var gold_lbl: Label;

func _on_start() -> void:
	gold_lbl.text = "0";

func _on_gold_gained(gold: int) -> void:
	gold_lbl.text = str(gold);
