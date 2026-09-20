class_name CaptainBehaviour
extends Area2D

signal fire_projectile(res: EntityResource, dist: float, lane: Lanes.Values)
signal speak(capt: CaptainResource, state: DialogueResource.States)

var duck_proj: EntityResource = preload("res://Resources/Entities/duck_entity.tres")
var shark_proj: EntityResource = preload("res://Resources/Entities/shark_entity.tres")
var keg_proj: EntityResource = preload("res://Resources/Entities/keg_entity.tres")

@export var capt_fish_max_cooldown: float = 3.5

@export var res: CaptainResource

@export var anim_player: AnimationPlayer
@export var damaged: bool

var health: int
var lane: Lanes.Values = Lanes.Values.CENTER
var cooldown: float
var acting: bool = true

func _init() -> void:
	ScreenStateMachine.captain_defeated.connect(_on_captain_defeated)
	ScreenStateMachine.captain_won.connect(_on_captain_won)

func _process(delta: float) -> void:
	if ScreenStateMachine.capt_stage != Captains.Stages.FIGHT: return
	if health <= 0: return
	
	if not damaged:
		cooldown -= delta
	
	if not acting:
		if cooldown <= 0:
			var choice: float = randf()
			if res.captain == Captains.Values.FISH:
				capt_fish_behaviour(choice)
			if res.captain == Captains.Values.CAT:
				pass
			if res.captain == Captains.Values.CAT:
				pass
			if res.captain == Captains.Values.BOSS:
				pass
	else:
		acting = false
	
	position.x = lerp(position.x, Lanes.coordinates(lane), 0.4);

func damage() -> void:
	health -= 1
	anim_player.play("damaged")
	Audio.get_controller().play_sfx("hit")
	
	if health <= 0: 
		Audio.get_controller().stop_bgm()
		ScreenStateMachine.halt_input = true
		speak.emit(res, DialogueResource.States.WIN)

func capt_fish_behaviour(choice: float) -> void:
	var proj: EntityResource = duck_proj
	if choice <= 0.3: proj = shark_proj
	
	fire_projectile.emit(proj, 0.5, lane)
	
	anim_player.play(&"capt_fish/submerge")
	
	cooldown = capt_fish_max_cooldown
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
	ScreenStateMachine.halt_input = true
	speak.emit(res, state as DialogueResource.States)

func _on_enter_anim_start() -> void:
	Audio.get_controller().pause_bgm()

func _on_death_anim_end() -> void:
	Audio.get_controller().play_bgm("main_theme")
	queue_free()

func play_damage_sfx() -> void:
	Audio.get_controller().play_sfx("damage")

func _on_captain_defeated(_capt: Captains.Values) -> void:
	anim_player.play("death")

func _on_captain_won() -> void:
	ScreenStateMachine.halt_input = true
	speak.emit(res, DialogueResource.States.LOSE)
	damaged = true
