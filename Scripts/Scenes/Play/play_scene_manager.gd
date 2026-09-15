class_name PlaySceneManager
extends Node2D

enum State {
	START,
	PLAY,
	GAME_OVER,
};

signal on_starting();
signal on_play();
signal on_game_over();

var player_ps: PackedScene = preload("res://Scenes/Prefabs/player.tscn");

var player: Player;

var state: State:
	set(value):
		state = value;
		if state == State.START:
			on_starting.emit()
		elif  state == State.PLAY:
			on_play.emit()
		elif state == State.GAME_OVER:
			on_game_over.emit()

func start() -> void:
	#player = player_ps.instantiate();
	#add_child(player);
	pass;

func play() -> void:
	pass;

func game_over() -> void:
	pass;
