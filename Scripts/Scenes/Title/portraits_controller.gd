extends Control

@export var capt_fish: TextureRect
@export var capt_rat: TextureRect
@export var capt_cat: TextureRect
@export var capt_king: TextureRect

func refresh() -> void:
	capt_fish.visible = PlayerStats.progress[Captains.Values.FISH]
	capt_rat.visible = PlayerStats.progress[Captains.Values.RAT]
	capt_cat.visible = PlayerStats.progress[Captains.Values.CAT]
	capt_king.visible = PlayerStats.progress[Captains.Values.BOSS]
