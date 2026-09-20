class_name CaptainBehaviour
extends Area2D

signal speak(capt: CaptainResource, state: DialogueResource.States)

@export var capt_fish_max_cooldown: float = 3.5

@export var res: CaptainResource

@export var anim_player: AnimationPlayer
@export var damaged: bool

var health: int
var lane: Lanes.Values = Lanes.Values.CENTER
var cooldown: float
var acting: bool = true

func _process(delta: float) -> void:
	if ScreenStateMachine.capt_stage != Captains.Stages.FIGHT: return
	
	if not damaged:
		cooldown -= delta
	
	if not acting:
		if cooldown <= 0:
			if res.captain == Captains.Values.FISH:
				capt_fish_behaviour()
			if res.captain == Captains.Values.CAT:
				pass
			if res.captain == Captains.Values.CAT:
				pass
			if res.captain == Captains.Values.BOSS:
				pass
	else:
		cooldown = capt_fish_max_cooldown
		acting = false
	
	position.x = lerp(position.x, Lanes.coordinates(lane), 0.4);

func damage() -> void:
	health -= 1
	anim_player.play("damaged")
	
	if health <= 0: speak.emit(res, DialogueResource.States.WIN)

func capt_fish_behaviour() -> void:
	anim_player.play(&"capt_fish/submerge")
	acting = true

func capt_fish_change_lane() -> void:
	lane = (lane + (randi() % len(Lanes.Values)) + 3) % len(Lanes.Values) as Lanes.Values
	anim_player.play(&"capt_fish/emerge")

func capt_rat_behaviour() -> void:
	pass

func capt_cat_behaviour() -> void:
	pass

func capt_king_behaviour() -> void:
	pass

func show_dialogue(state: int) -> void:
	speak.emit(res, state as DialogueResource.States)

func _on_enter_anim_start() -> void:
	Audio.get_controller().pause_bgm()
