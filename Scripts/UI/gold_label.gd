class_name GoldController
extends HBoxContainer

@export var gold_lbl: Label;

func _on_start() -> void:
	gold_lbl.text = "0";
