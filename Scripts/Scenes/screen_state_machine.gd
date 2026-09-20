extends Node

enum States {
	START = 0,
	TITLE,
	PLAY,
	END,
}

signal start()
signal title()
signal play()
signal end()

var _state: States
var state: States:
	get: return _state
	set(value):
		_state = value
		
		if _state == States.START: start.emit()
		if _state == States.TITLE: title.emit()
		if _state == States.PLAY: play.emit()
		if _state == States.END: end.emit()

signal captain_defeated(capt: Captains.Values)
signal spawn_captain(res: CaptainResource)

const capt_dict: Dictionary[Captains.Values, CaptainResource] = {
	Captains.Values.FISH: preload("res://Resources/Captains/capt_fish.tres"),
	Captains.Values.RAT: preload("res://Resources/Captains/capt_rat.tres"),
	Captains.Values.CAT: preload("res://Resources/Captains/capt_cat.tres"),
	Captains.Values.BOSS: preload("res://Resources/Captains/capt_king.tres"),
}

var _capt_stage: Captains.Stages
var capt_stage: Captains.Stages:
	get: return _capt_stage
	set(value):
		_capt_stage = value
		if _capt_stage == Captains.Stages.FIGHT:
			Audio.get_controller().resume_bgm()

var next_captain: Captains.Values
var next_capt_goal: int

func _init() -> void:
	state = States.START
	
	play.connect(_on_play)
	captain_defeated.connect(_on_captain_defeated)

func connect_signal(on_state: States, callable: Callable) -> void:
	var sig: Signal
	if on_state == States.START: sig = start
	if on_state == States.TITLE: sig = title
	if on_state == States.PLAY: sig = play
	if on_state == States.END: sig = end
	
	sig.connect(callable)

func _on_play() -> void:
	next_captain = Captains.Values.FISH
	next_capt_goal = 1 # 50 + 50 * next_captain

func _on_captain_defeated(capt: Captains.Values) -> void:
	PlayerStats.progress[capt] = true
	
	if capt == Captains.Values.BOSS: state = States.END
	else: 
		next_captain = (capt + 1) as Captains.Values
		next_capt_goal = 50 + 50 * next_captain

func _on_pattern_spawned(count: int) -> void:
	if count == next_capt_goal:
		capt_stage = Captains.Stages.ENTER
		spawn_captain.emit(capt_dict[next_captain])

func _on_speak_end() -> void:
	if capt_stage == Captains.Stages.ENTER:
		capt_stage = Captains.Stages.FIGHT
