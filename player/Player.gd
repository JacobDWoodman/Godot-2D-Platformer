extends "res://moving_entity.gd"
#this script overrides its parent's _flip() and _do_gravity() funcs

const Tiger = preload("res://player/secret_tiger.tscn")
const Briefcase = preload("res://player/BriefCase.tscn")

onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")
onready var pivot = $Position2D
onready var tiger_spawnp = $Position2D/tiger_spawnpoint
onready var hurtbox = $Position2D/hurtbox

var stats = PlayerStats

enum{
	MOVE,
	ATTACK,
	ATTACK2,
	ATTACKRANGED,
	ATTACKRANGED2,
	HEAVYATTACK,
	HEAVYATTACK2,
	CATCHING,
	OUCH
}

var state = MOVE

func _ready():
	._ready()
	stats.connect("no_health", self, "queue_free")

func _physics_process(delta):
	move_dir = 0
	
	match state:
		MOVE: _do_move(delta)
		ATTACK: _do_attack("attack")
		ATTACK2: _do_attack("altattack")
		ATTACKRANGED: _do_attack("summon_tiger")
		ATTACKRANGED2: _do_locked_attack("throwCase")
		HEAVYATTACK: _do_locked_attack("heavyattack")
		HEAVYATTACK2: _do_locked_attack("heavyaltattack")
		CATCHING: anim_state.travel("catchCase")
		OUCH: _get_hit(delta)
	
	grounded = is_on_floor()
	_do_gravity()

func _do_gravity():
	y_velo += gravity
	if grounded and Input.is_action_just_pressed("jump"):
		y_velo = -jump_force
	if grounded and y_velo >= 5 or is_on_ceiling():
		y_velo = 5
	if y_velo > max_fall_speed:
		y_velo = max_fall_speed

func _anim_handler():
	if grounded:
		if move_dir == 0:
			anim_state.travel("idle")
		else:
			anim_state.travel("walk")
	else: 
		if y_velo < 0:
			anim_state.travel("JumpStart")
		else:
			anim_state.travel("JumpFall")

func _do_move(_delta):
	if Input.is_action_pressed("move_left"):
		move_dir -= 1
	if Input.is_action_pressed("move_right"):
		move_dir += 1
	# warning-ignore:return_value_discarded
	move_and_slide(Vector2(move_dir * move_speed, y_velo), Vector2(0, -1))
	_anim_handler()
	_check_attacks()
	_do_rotation()

func _do_rotation():
	if facing_right and move_dir > 0:
		_flip()
	if !facing_right and move_dir < 0:
		_flip()

func _check_attacks():
	if grounded:
		_check_attack_type("punch", HEAVYATTACK, ATTACK)
		_check_attack_type("kick", HEAVYATTACK2, ATTACK2)
		_check_attack_type("ranged", ATTACKRANGED, ATTACKRANGED2)

func _check_attack_type(type, a, b):
	if Input.is_action_just_pressed(type):
		if Input.is_action_pressed("down"):
			state = a
		else: state = b

func _do_attack(attackname):
	anim_state.travel(attackname)
	_check_attacks()

func _do_locked_attack(attackname):
	anim_state.travel(attackname)

func spawn_briefcase():
	var effect = Briefcase.instance()
	get_parent().add_child(effect)
	#cant use tiger_spawnp for some reason
	effect.position = position + Vector2(0, -50)
	effect.facing_right = facing_right
	effect.sprite.flip_h = sprite.flip_h

func _summon_tiger():
	var effect = Tiger.instance()
	get_parent().add_child(effect)
	#cant use tiger_spawnp for some reason
	effect.position = position
	effect.facing_right = facing_right
	effect.sprite.flip_h = sprite.flip_h

func _flip():
	print("called player flip")
	._flip()
	if facing_right: pivot.set_scale(Vector2(-1, 1))
	else: pivot.set_scale(Vector2(1, 1))

func _reset_state():
	state = MOVE

func _get_hit(delta):
	anim_state.travel("Hit")
	if facing_right:
		move_dir += 1
	else: move_dir -= 1
	move_and_slide(Vector2(move_dir * move_speed, y_velo), Vector2(0, -1))

func _on_catchBriefCase_area_entered(area):
	var briefcase = area.get_parent()
	if !briefcase.has_bounced: return
	state = CATCHING
	briefcase.queue_free()

func _on_hurtbox_area_entered(area):
	hurtbox.create_hitEffect()
	stats.health -= area.damage
	state = OUCH
	y_velo = -jump_force/2

func _on_LoseBriefCase_area_entered(area):
	_reset_state()
	area.get_parent().queue_free()
