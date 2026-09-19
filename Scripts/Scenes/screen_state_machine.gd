extends Node

enum States {
	START = 0,
	TITLE,
	PLAY,
}

signal start()
signal title()
signal play()

var _state: States
var state: States:
	get: return _state
	set(value):
		#disconnect_all()
		_state = value
		
		if _state == States.START: start.emit()
		if _state == States.TITLE: title.emit()
		if _state == States.PLAY: play.emit()

func _init() -> void:
	state = States.START

func connect_signal(callable: Callable) -> void:
	var sig: Signal
	if state == States.START: sig = start
	if state == States.TITLE: sig = title
	if state == States.PLAY: sig = play
	
	sig.connect(callable)

func disconnect_all() -> void:
	var sig: Signal
	if state == States.START: sig = start
	if state == States.TITLE: sig = title
	if state == States.PLAY: sig = play
	
	for conn in sig.get_connections():
		sig.disconnect(conn)
